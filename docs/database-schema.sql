-- Velo Database Schema for Supabase PostgreSQL
-- Run this in Supabase SQL Editor to set up all tables and Row Level Security policies

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- USER PROFILES TABLE
-- ============================================================================
-- Extends Supabase Auth users with app-specific data

CREATE TABLE IF NOT EXISTS public.user_profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    role_type TEXT NOT NULL CHECK (role_type IN ('parent', 'salon', 'realtor', 'business', 'explorer')),
    subscription_tier TEXT NOT NULL DEFAULT 'free' CHECK (subscription_tier IN ('free', 'pro', 'business')),
    edits_this_month INTEGER NOT NULL DEFAULT 0,
    edits_month_start DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add indexes for performance
CREATE INDEX IF NOT EXISTS idx_user_profiles_role_type ON public.user_profiles(role_type);
CREATE INDEX IF NOT EXISTS idx_user_profiles_subscription_tier ON public.user_profiles(subscription_tier);

-- Enable Row Level Security
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- RLS Policies for user_profiles
CREATE POLICY "Users can view own profile"
    ON public.user_profiles
    FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
    ON public.user_profiles
    FOR UPDATE
    USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
    ON public.user_profiles
    FOR INSERT
    WITH CHECK (auth.uid() = id);

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE ON public.user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- EDITS TABLE
-- ============================================================================
-- Stores edit history for all users

CREATE TABLE IF NOT EXISTS public.edits (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    command_text TEXT NOT NULL,
    original_image_url TEXT,
    edited_image_url TEXT,
    model_used TEXT NOT NULL CHECK (model_used IN ('base', 'pro')),
    processing_time_ms INTEGER,
    cost_usd NUMERIC(10, 4)
);

-- Add indexes for performance
CREATE INDEX IF NOT EXISTS idx_edits_user_id ON public.edits(user_id);
CREATE INDEX IF NOT EXISTS idx_edits_created_at ON public.edits(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_edits_model_used ON public.edits(model_used);

-- Enable Row Level Security
ALTER TABLE public.edits ENABLE ROW LEVEL SECURITY;

-- RLS Policies for edits
CREATE POLICY "Users can view own edits"
    ON public.edits
    FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own edits"
    ON public.edits
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- TEMPLATES TABLE
-- ============================================================================
-- Pre-defined editing templates

CREATE TABLE IF NOT EXISTS public.templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    prompt_text TEXT NOT NULL,
    role_tags TEXT[] DEFAULT '{}', -- Empty array means available to all roles
    category TEXT NOT NULL CHECK (category IN ('quick_fixes', 'backgrounds', 'business', 'seasonal')),
    preview_url TEXT,
    usage_count INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add indexes for performance
CREATE INDEX IF NOT EXISTS idx_templates_category ON public.templates(category);
CREATE INDEX IF NOT EXISTS idx_templates_is_active ON public.templates(is_active);
CREATE INDEX IF NOT EXISTS idx_templates_role_tags ON public.templates USING GIN(role_tags);

-- Enable Row Level Security
ALTER TABLE public.templates ENABLE ROW LEVEL SECURITY;

-- RLS Policies for templates (public read, admin write)
CREATE POLICY "Templates are publicly readable"
    ON public.templates
    FOR SELECT
    USING (is_active = TRUE);

-- Only service role can insert/update templates (via admin panel)
CREATE POLICY "Service role can manage templates"
    ON public.templates
    FOR ALL
    USING (auth.jwt() ->> 'role' = 'service_role');

-- Auto-update updated_at timestamp
CREATE TRIGGER update_templates_updated_at
    BEFORE UPDATE ON public.templates
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- BRAND KITS TABLE
-- ============================================================================
-- Logo uploads for business users

CREATE TABLE IF NOT EXISTS public.brand_kits (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    name TEXT NOT NULL,
    logo_url TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add indexes for performance
CREATE INDEX IF NOT EXISTS idx_brand_kits_user_id ON public.brand_kits(user_id);

-- Enable Row Level Security
ALTER TABLE public.brand_kits ENABLE ROW LEVEL SECURITY;

-- RLS Policies for brand_kits
CREATE POLICY "Users can view own brand kits"
    ON public.brand_kits
    FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own brand kits"
    ON public.brand_kits
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own brand kits"
    ON public.brand_kits
    FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own brand kits"
    ON public.brand_kits
    FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Function to increment edit count (called from Edge Function)
CREATE OR REPLACE FUNCTION increment_edit_count(user_uuid UUID)
RETURNS VOID AS $$
DECLARE
    current_month_start DATE;
    user_month_start DATE;
BEGIN
    -- Get current month start
    current_month_start := DATE_TRUNC('month', CURRENT_DATE);

    -- Get user's edit month start
    SELECT edits_month_start INTO user_month_start
    FROM public.user_profiles
    WHERE id = user_uuid;

    -- If in new month, reset counter
    IF user_month_start < current_month_start THEN
        UPDATE public.user_profiles
        SET edits_this_month = 1,
            edits_month_start = current_month_start
        WHERE id = user_uuid;
    ELSE
        -- Increment counter
        UPDATE public.user_profiles
        SET edits_this_month = edits_this_month + 1
        WHERE id = user_uuid;
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if user has edits remaining
CREATE OR REPLACE FUNCTION has_edits_remaining(user_uuid UUID)
RETURNS BOOLEAN AS $$
DECLARE
    tier TEXT;
    edits_used INTEGER;
    free_limit INTEGER := 5;
BEGIN
    SELECT subscription_tier, edits_this_month
    INTO tier, edits_used
    FROM public.user_profiles
    WHERE id = user_uuid;

    -- Pro and business tiers have unlimited edits
    IF tier IN ('pro', 'business') THEN
        RETURN TRUE;
    END IF;

    -- Free tier has limit
    RETURN edits_used < free_limit;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- SEED DATA - Sample Templates
-- ============================================================================

INSERT INTO public.templates (name, description, prompt_text, role_tags, category) VALUES
    -- Quick Fixes
    ('Fix Closed Eyes', 'Open eyes in photos where someone blinked', 'Open the closed eyes in this photo naturally', ARRAY['parent', 'salon', 'explorer'], 'quick_fixes'),
    ('Remove Red Eyes', 'Fix red eye from camera flash', 'Remove red eye effect from this photo', ARRAY['parent', 'explorer'], 'quick_fixes'),
    ('Brighten Photo', 'Enhance overall brightness naturally', 'Brighten this photo naturally without overexposing', ARRAY[]::TEXT[], 'quick_fixes'),
    ('Professional Lighting', 'Enhance lighting for professional look', 'Enhance the lighting to look professional and natural', ARRAY['salon', 'realtor', 'business'], 'quick_fixes'),

    -- Backgrounds
    ('Beach Sunset', 'Change background to beach at sunset', 'Change the background to a beautiful beach sunset scene, keeping the subject natural', ARRAY['parent', 'explorer'], 'backgrounds'),
    ('Studio White', 'Clean white studio background', 'Replace background with clean white studio background', ARRAY['salon', 'business'], 'backgrounds'),
    ('Blur Background', 'Blur background for portrait effect', 'Blur the background while keeping the subject sharp, creating a professional portrait effect', ARRAY[]::TEXT[], 'backgrounds'),
    ('Remove Background', 'Remove background completely', 'Remove the background completely, leaving only the subject with transparent background', ARRAY['salon', 'business'], 'backgrounds'),

    -- Business Templates
    ('Salon Before/After', 'Create side-by-side transformation', 'Create a professional before/after side-by-side comparison suitable for salon social media', ARRAY['salon'], 'business'),
    ('Real Estate Ready', 'Perfect for property listings', 'Enhance this property photo: brighten interior, improve lighting, make it look professional for real estate listing', ARRAY['realtor'], 'business'),
    ('Fix Overhead Lighting', 'Correct harsh overhead lights', 'Fix harsh overhead fluorescent lighting, make the lighting look natural and flattering', ARRAY['salon', 'business'], 'business'),
    ('Instagram-Ready', 'Optimize for social media', 'Make this photo Instagram-ready: enhance colors, improve composition, make it eye-catching while keeping it natural', ARRAY['salon', 'business'], 'business')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- STORAGE BUCKETS (Run separately or via Supabase UI)
-- ============================================================================
-- Note: Storage buckets are typically created via Supabase dashboard
-- If using SQL, you can create them like this:

-- INSERT INTO storage.buckets (id, name, public)
-- VALUES ('edited-images', 'edited-images', FALSE);

-- Storage policies for edited-images bucket
-- CREATE POLICY "Users can upload own images"
--     ON storage.objects FOR INSERT
--     WITH CHECK (bucket_id = 'edited-images' AND auth.uid()::text = (storage.foldername(name))[1]);

-- CREATE POLICY "Users can view own images"
--     ON storage.objects FOR SELECT
--     USING (bucket_id = 'edited-images' AND auth.uid()::text = (storage.foldername(name))[1]);

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================
-- Run these to verify your setup:

-- SELECT * FROM public.user_profiles;
-- SELECT * FROM public.edits;
-- SELECT * FROM public.templates WHERE is_active = TRUE;
-- SELECT * FROM public.brand_kits;

-- Check RLS is enabled:
-- SELECT tablename, rowsecurity FROM pg_tables WHERE schemaname = 'public';

-- ============================================================================
-- CLEANUP (USE WITH CAUTION - ONLY FOR DEVELOPMENT)
-- ============================================================================
-- Uncomment and run to reset database (WARNING: DELETES ALL DATA)

-- DROP TABLE IF EXISTS public.brand_kits CASCADE;
-- DROP TABLE IF EXISTS public.edits CASCADE;
-- DROP TABLE IF EXISTS public.templates CASCADE;
-- DROP TABLE IF EXISTS public.user_profiles CASCADE;
-- DROP FUNCTION IF EXISTS increment_edit_count(UUID);
-- DROP FUNCTION IF EXISTS has_edits_remaining(UUID);
-- DROP FUNCTION IF EXISTS update_updated_at_column();
