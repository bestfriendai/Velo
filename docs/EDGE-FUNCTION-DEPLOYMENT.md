# Edge Function Deployment Guide

This guide covers deploying the `process-edit` Supabase Edge Function for AI image processing.

---

## Prerequisites

### 1. Install Supabase CLI

```bash
# macOS
brew install supabase/tap/supabase

# Or via npm (any platform)
npm install -g supabase

# Verify installation
supabase --version
```

### 2. Get Nano Banana API Key

1. Go to [https://nanobanana.ai](https://nanobanana.ai)
2. Sign up for an account
3. Navigate to API Keys section
4. Create a new API key
5. Copy the key - you'll need it for deployment

---

## Deployment Steps

### Step 1: Link to Your Supabase Project

```bash
cd /path/to/Velo

# Link to your project
supabase link --project-ref ycuxojvbqodicewurpxp

# You'll be prompted to log in via browser
```

### Step 2: Set Secret Environment Variables

```bash
# Set the Nano Banana API key as a secret
supabase secrets set NANO_BANANA_API_KEY=your_actual_api_key_here

# Verify the secret was set
supabase secrets list
```

**Output should show:**
```
NANO_BANANA_API_KEY
```

### Step 3: Deploy the Edge Function

```bash
# Deploy the process-edit function
supabase functions deploy process-edit

# This will:
# 1. Bundle the TypeScript code
# 2. Upload to Supabase
# 3. Make it available at: https://ycuxojvbqodicewurpxp.supabase.co/functions/v1/process-edit
```

**Expected output:**
```
Deploying function process-edit...
Function deployed successfully!
URL: https://ycuxojvbqodicewurpxp.supabase.co/functions/v1/process-edit
```

### Step 4: Verify Deployment

Test the function with curl:

```bash
# Get your Supabase anon key
SUPABASE_ANON_KEY="your_anon_key_here"

# Test the function
curl -i --location --request POST \
  'https://ycuxojvbqodicewurpxp.supabase.co/functions/v1/process-edit' \
  --header "Authorization: Bearer $SUPABASE_ANON_KEY" \
  --header 'Content-Type: application/json' \
  --data '{
    "userId": "test-user-id",
    "commandText": "Brighten the photo",
    "imageBase64": "base64_encoded_image_data_here",
    "userTier": "free"
  }'
```

---

## Edge Function Architecture

### What the Function Does

1. **Authentication**: Verifies JWT token from client
2. **Quota Check**: Calls `has_edits_remaining()` RPC function
3. **Model Selection**:
   - Free tier → `gemini-2.5-flash-image` (2k quality)
   - Pro tier → `gemini-3-pro-image` (2k quality)
   - Business tier → `gemini-3-pro-image` (4k quality)
4. **AI Processing**: Calls Nano Banana API with image and prompt
5. **Storage**: Uploads edited image to `edited-images` bucket
6. **Database**: Saves edit record to `edits` table
7. **Quota Update**: Increments user's edit count
8. **Response**: Returns edited image URL and remaining quota

### Request Format

```typescript
{
  userId: string       // User's UUID
  commandText: string  // Natural language edit command
  imageBase64: string  // Base64-encoded JPEG/PNG
  userTier: string     // 'free', 'pro', or 'business'
}
```

### Response Format

```typescript
{
  success: boolean
  editedImageUrl?: string        // URL to edited image
  editsRemaining: number         // Remaining quota for user
  modelUsed: string              // AI model used
  processingTimeMs: number       // Time taken
  error?: string                 // Error message if failed
}
```

---

## Storage Bucket Setup

### Create the `edited-images` Bucket

1. Go to Supabase Dashboard → Storage
2. Click "Create bucket"
3. Name: `edited-images`
4. Public: **No** (private bucket with RLS)
5. File size limit: 50 MB
6. Allowed MIME types: `image/jpeg`, `image/png`
7. Click "Create"

### Set Up Storage Policies

Run this SQL in Supabase SQL Editor:

```sql
-- Allow authenticated users to upload images to their own folder
CREATE POLICY "Users can upload own images"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'edited-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Allow authenticated users to view their own images
CREATE POLICY "Users can view own images"
ON storage.objects
FOR SELECT
TO authenticated
USING (
  bucket_id = 'edited-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Allow authenticated users to delete their own images
CREATE POLICY "Users can delete own images"
ON storage.objects
FOR DELETE
TO authenticated
USING (
  bucket_id = 'edited-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);
```

---

## Testing the Integration

### Test 1: Anonymous User Edit (Free Tier)

```bash
# 1. Create anonymous user via iOS app
# 2. Note the user ID from logs
# 3. Get a test image and convert to base64:

base64 -i test-image.jpg -o test-image.txt

# 4. Test the function
curl -X POST \
  'https://ycuxojvbqodicewurpxp.supabase.co/functions/v1/process-edit' \
  --header "Authorization: Bearer YOUR_JWT_TOKEN" \
  --header 'Content-Type: application/json' \
  --data '{
    "userId": "user-uuid-from-app",
    "commandText": "Make it brighter",
    "imageBase64": "'"$(cat test-image.txt)"'",
    "userTier": "free"
  }'
```

### Test 2: Check Supabase Logs

1. Go to Supabase Dashboard → Edge Functions
2. Click on `process-edit`
3. Click "Logs" tab
4. You should see:
   ```
   Processing edit for user: <uuid>
   Command: Make it brighter
   User tier: free
   Using model: gemini-2.5-flash-image with quality: 2k
   Nano Banana API response received
   Image uploaded: https://...
   Edit completed in 3542ms
   ```

### Test 3: Verify Database Records

```sql
-- Check edit was saved
SELECT * FROM edits ORDER BY created_at DESC LIMIT 1;

-- Check user's quota was incremented
SELECT id, edits_this_month, subscription_tier
FROM user_profiles
WHERE id = 'user-uuid-here';

-- Check storage bucket
SELECT * FROM storage.objects
WHERE bucket_id = 'edited-images'
ORDER BY created_at DESC
LIMIT 5;
```

---

## iOS App Integration

Update `SupabaseService.swift` to call the edge function:

```swift
/// Process edit request via Supabase Edge Function
func processEdit(command: String, image: UIImage) async throws -> EditResponse {
    guard let profile = currentUserProfile else {
        throw SupabaseError.notAuthenticated
    }

    // Check quota first
    guard profile.hasEditsRemaining else {
        throw SupabaseError.quotaExceeded
    }

    // Compress image
    guard let imageData = image.jpegData(compressionQuality: 0.8),
          let base64Image = imageData.base64EncodedString() else {
        throw SupabaseError.imageProcessingFailed
    }

    Logger.info("Calling process-edit function", category: .api)

    // Prepare request
    let requestBody: [String: Any] = [
        "userId": profile.id,
        "commandText": command,
        "imageBase64": base64Image,
        "userTier": profile.subscriptionTier.rawValue
    ]

    do {
        let response = try await supabase.functions
            .invoke(
                "process-edit",
                options: FunctionInvokeOptions(
                    body: requestBody
                )
            )

        let decoder = JSONDecoder()
        let editResponse = try decoder.decode(EditResponse.self, from: response.data)

        Logger.info("Edit completed: \(editResponse.editsRemaining) edits remaining", category: .api)

        return editResponse
    } catch {
        Logger.error("Failed to process edit: \(error.localizedDescription)", category: .api)
        throw SupabaseError.imageProcessingFailed
    }
}
```

---

## Cost Estimation

### Nano Banana Pricing

| Tier      | Model                    | Quality | Cost per Edit |
|-----------|--------------------------|---------|---------------|
| Free      | gemini-2.5-flash-image  | 2K      | $0.039        |
| Pro       | gemini-3-pro-image      | 2K      | $0.12         |
| Business  | gemini-3-pro-image      | 4K      | $0.24         |

### Monthly Cost Examples

**Free Tier Users (5 edits/month):**
- 1,000 users × 5 edits × $0.039 = **$195/month**

**Pro Users ($6.99/month, ~20 edits/month):**
- 100 users × 20 edits × $0.12 = **$240/month**
- Revenue: 100 × $6.99 = **$699/month**
- Profit margin: **65%**

**Business Users ($14.99/month, ~50 edits/month):**
- 50 users × 50 edits × $0.24 = **$600/month**
- Revenue: 50 × $14.99 = **$749.50/month**
- Profit margin: **20%**

---

## Troubleshooting

### "Nano Banana API key not configured"

**Issue:** Secret not set in Supabase

**Fix:**
```bash
supabase secrets set NANO_BANANA_API_KEY=your_key_here
supabase functions deploy process-edit
```

### "Unauthorized" Error

**Issue:** Invalid JWT token

**Fix:**
- Ensure client is authenticated
- Check Authorization header is set correctly
- Verify token hasn't expired

### "Failed to upload image" Error

**Issue:** Storage bucket or RLS policy issue

**Fix:**
1. Verify `edited-images` bucket exists
2. Check RLS policies are correctly set
3. Ensure user ID matches folder structure

### "Quota check failed"

**Issue:** RPC function not found or database error

**Fix:**
1. Verify database schema is deployed
2. Check `has_edits_remaining()` function exists:
   ```sql
   SELECT * FROM pg_proc WHERE proname = 'has_edits_remaining';
   ```

### Function Logs Not Showing

**Issue:** Logging not enabled or delayed

**Fix:**
1. Wait 1-2 minutes for logs to appear
2. Check Supabase Dashboard → Edge Functions → Logs
3. Use `console.log()` liberally in function code

---

## Monitoring & Maintenance

### Key Metrics to Track

1. **Function Invocations**: Supabase Dashboard → Edge Functions
2. **Error Rate**: Check logs for failures
3. **Processing Time**: Average `processingTimeMs` in responses
4. **Storage Usage**: Dashboard → Storage → edited-images
5. **API Costs**: Track Nano Banana usage

### Recommended Monitoring

```sql
-- Daily edit volume by tier
SELECT
  DATE(created_at) as date,
  COUNT(*) as total_edits,
  SUM(cost_usd) as total_cost
FROM edits
WHERE created_at > NOW() - INTERVAL '30 days'
GROUP BY DATE(created_at)
ORDER BY date DESC;

-- Average processing time
SELECT
  model_used,
  AVG(processing_time_ms) as avg_ms,
  COUNT(*) as count
FROM edits
WHERE created_at > NOW() - INTERVAL '7 days'
GROUP BY model_used;
```

---

## Next Steps

1. ✅ Deploy edge function
2. ✅ Set up storage bucket and policies
3. ✅ Test with real images
4. Update iOS app to call the function
5. Add watermarking for free tier images
6. Implement batch processing for business tier
7. Set up monitoring and alerts

---

**Function URL:** `https://ycuxojvbqodicewurpxp.supabase.co/functions/v1/process-edit`

**Status:** Ready to deploy
**Last Updated:** December 10, 2025
