// Supabase Edge Function: process-edit
// Handles AI image editing requests via Nano Banana API

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface EditRequest {
  user_id: string
  command_text: string
  image_base64: string
  user_tier: string
}

interface EditResponse {
  success: boolean
  edited_image_url?: string
  edits_remaining: number
  model_used: string
  processing_time_ms: number
  error?: string
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  const startTime = Date.now()

  try {
    // Initialize Supabase client
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      {
        global: {
          headers: { Authorization: req.headers.get('Authorization')! },
        },
      }
    )

    // Get the current user from the JWT
    const {
      data: { user },
    } = await supabaseClient.auth.getUser()

    if (!user) {
      throw new Error('Unauthorized')
    }

    // Parse request body
    const requestBody: EditRequest = await req.json()
    const { command_text, image_base64, user_tier } = requestBody

    console.log(`Processing edit for user: ${user.id}`)
    console.log(`Command: ${command_text}`)
    console.log(`User tier: ${user_tier}`)

    // Step 1: Check user's edit quota
    const { data: quotaCheck, error: quotaError } = await supabaseClient
      .rpc('has_edits_remaining', { user_uuid: user.id })

    if (quotaError) {
      throw new Error(`Quota check failed: ${quotaError.message}`)
    }

    if (!quotaCheck) {
      return new Response(
        JSON.stringify({
          success: false,
          error: 'Edit quota exceeded. Upgrade to Pro for unlimited edits.',
          edits_remaining: 0,
          model_used: 'none',
          processing_time_ms: Date.now() - startTime,
        } as EditResponse),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 403,
        }
      )
    }

    // Step 2: Determine which model to use based on subscription tier
    const modelName = user_tier === 'pro' || user_tier === 'business'
      ? 'gemini-3-pro-image'
      : 'gemini-2.5-flash-image'

    const outputQuality = user_tier === 'business' ? '4k' : '2k'

    console.log(`Using model: ${modelName} with quality: ${outputQuality}`)

    // Step 3: Call Nano Banana API
    const nanoBananaApiKey = Deno.env.get('NANO_BANANA_API_KEY')
    if (!nanoBananaApiKey) {
      throw new Error('Nano Banana API key not configured')
    }

    const nanoBananaResponse = await fetch('https://api.nanobanana.ai/v1/edit', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${nanoBananaApiKey}`,
      },
      body: JSON.stringify({
        model: modelName,
        prompt: command_text,
        image: image_base64,
        output_quality: outputQuality,
      }),
    })

    if (!nanoBananaResponse.ok) {
      const errorText = await nanoBananaResponse.text()
      throw new Error(`Nano Banana API error: ${errorText}`)
    }

    const nanoBananaResult = await nanoBananaResponse.json()
    console.log('Nano Banana API response received')

    // Step 4: Upload edited image to Supabase Storage
    const editedImageBase64 = nanoBananaResult.image || nanoBananaResult.output_image
    if (!editedImageBase64) {
      throw new Error('No image returned from Nano Banana API')
    }

    // Decode base64 to binary
    const imageData = Uint8Array.from(atob(editedImageBase64), c => c.charCodeAt(0))
    const fileName = `${user.id}/${Date.now()}.jpg`

    const { data: uploadData, error: uploadError } = await supabaseClient.storage
      .from('edited-images')
      .upload(fileName, imageData, {
        contentType: 'image/jpeg',
        upsert: false,
      })

    if (uploadError) {
      throw new Error(`Failed to upload image: ${uploadError.message}`)
    }

    // Get public URL for the uploaded image
    const { data: publicUrlData } = supabaseClient.storage
      .from('edited-images')
      .getPublicUrl(fileName)

    const editedImageUrl = publicUrlData.publicUrl

    console.log(`Image uploaded: ${editedImageUrl}`)

    // Step 5: Save edit to database
    const processingTimeMs = Date.now() - startTime
    const costUsd = user_tier === 'business' ? 0.24 : (user_tier === 'pro' ? 0.12 : 0.039)

    const { error: insertError } = await supabaseClient
      .from('edits')
      .insert({
        user_id: user.id,
        command_text: command_text,
        edited_image_url: editedImageUrl,
        model_used: modelName,
        processing_time_ms: processingTimeMs,
        cost_usd: costUsd,
      })

    if (insertError) {
      console.error(`Failed to save edit to database: ${insertError.message}`)
      // Don't throw - the edit succeeded, just logging failed
    }

    // Step 6: Increment user's edit count
    const { error: incrementError } = await supabaseClient
      .rpc('increment_edit_count', { user_uuid: user.id })

    if (incrementError) {
      console.error(`Failed to increment edit count: ${incrementError.message}`)
    }

    // Step 7: Get updated user profile to return edits remaining
    const { data: profileData, error: profileError } = await supabaseClient
      .from('user_profiles')
      .select('edits_this_month, subscription_tier')
      .eq('id', user.id)
      .single()

    let editsRemaining = 0
    if (!profileError && profileData) {
      const freeLimit = 5
      if (profileData.subscription_tier === 'free') {
        editsRemaining = Math.max(0, freeLimit - profileData.edits_this_month)
      } else {
        editsRemaining = 999 // Unlimited for paid tiers
      }
    }

    // Step 8: Add watermark for free tier
    const needsWatermark = user_tier === 'free'

    console.log(`Edit completed in ${processingTimeMs}ms`)

    // Return success response
    const response: EditResponse = {
      success: true,
      edited_image_url: editedImageUrl,
      edits_remaining: editsRemaining,
      model_used: modelName,
      processing_time_ms: processingTimeMs,
    }

    if (needsWatermark) {
      response.edited_image_url = `${editedImageUrl}?watermark=true`
    }

    return new Response(
      JSON.stringify(response),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    )

  } catch (error) {
    console.error('Error processing edit:', error)

    return new Response(
      JSON.stringify({
        success: false,
        error: error.message || 'Internal server error',
        edits_remaining: 0,
        model_used: 'none',
        processing_time_ms: Date.now() - startTime,
      } as EditResponse),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 500,
      }
    )
  }
})
