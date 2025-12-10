# Complete Database Setup - Fix Authentication Issues

## Problem

Getting "You must be signed in to perform this action" even with anonymous auth enabled.

**Root causes:**
1. Table might not exist or have wrong column types
2. RLS policies might not match table structure
3. Anonymous auth session not being used correctly

---

## STEP 1: Verify Anonymous Auth is Enabled

1. Go to: https://supabase.com/dashboard/project/ycuxojvbqodicewurpxp/auth/settings
2. Find "Anonymous sign-ins"
3. Make sure toggle is **GREEN/ON**
4. Click **Save**

---

## STEP 2: Recreate Tables with Correct Schema

Go to [SQL Editor](https://supabase.com/dashboard/project/ycuxojvbqodicewurpxp/sql/new) and run:

```sql
-- ============================================================================
-- CLEAN SLATE: Drop existing tables and policies
-- ============================================================================

-- Drop policies first
DROP POLICY IF EXISTS "Users can create own profile" ON public.user_profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON public.user_profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.user_profiles;
DROP POLICY IF EXISTS "Users can view own edits" ON public.edits;
DROP POLICY IF EXISTS "Users can create own edits" ON public.edits;
DROP POLICY IF EXISTS "Templates are publicly readable" ON public.templates;

-- Drop tables (CASCADE removes dependencies)
DROP TABLE IF EXISTS public.user_profiles CASCADE;
DROP TABLE IF EXISTS public.edits CASCADE;
DROP TABLE IF EXISTS public.templates CASCADE;

-- ============================================================================
-- CREATE TABLES WITH CORRECT TYPES
-- ============================================================================

-- User Profiles Table
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    role_type TEXT NOT NULL DEFAULT 'explorer',
    subscription_tier TEXT NOT NULL DEFAULT 'free',
    edits_this_month INTEGER NOT NULL DEFAULT 0,
    edits_month_start DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Templates Table
CREATE TABLE public.templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    prompt_text TEXT NOT NULL,
    role_tags TEXT[] DEFAULT '{}',
    preview_url TEXT,
    usage_count INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Edits Table
CREATE TABLE public.edits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    command_text TEXT NOT NULL,
    edited_image_url TEXT,
    model_used TEXT,
    processing_time_ms INTEGER,
    cost_usd DECIMAL(10,4)
);

-- ============================================================================
-- ENABLE ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.edits ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- CREATE RLS POLICIES (FIXED FOR ANONYMOUS AUTH)
-- ============================================================================

-- User Profiles: Allow authenticated users to manage their own profile
CREATE POLICY "Users can create own profile"
ON public.user_profiles
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can view own profile"
ON public.user_profiles
FOR SELECT
TO authenticated
USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
ON public.user_profiles
FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Templates: Public read for all authenticated users
CREATE POLICY "Templates are publicly readable"
ON public.templates
FOR SELECT
TO authenticated
USING (is_active = true);

-- Edits: Allow users to view and create their own edits
CREATE POLICY "Users can view own edits"
ON public.edits
FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

CREATE POLICY "Users can create own edits"
ON public.edits
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- CREATE FUNCTION FOR INCREMENTING EDIT COUNT
-- ============================================================================

CREATE OR REPLACE FUNCTION public.increment_edit_count(user_uuid UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    current_month_start DATE;
BEGIN
    current_month_start := DATE_TRUNC('month', CURRENT_DATE)::DATE;

    -- Update or reset edit count
    UPDATE public.user_profiles
    SET
        edits_this_month = CASE
            WHEN edits_month_start < current_month_start THEN 1
            ELSE edits_this_month + 1
        END,
        edits_month_start = current_month_start
    WHERE id = user_uuid;
END;
$$;

-- ============================================================================
-- INSERT SAMPLE TEMPLATES
-- ============================================================================

INSERT INTO public.templates (name, description, prompt_text, role_tags, is_active) VALUES
    ('Fix Closed Eyes', 'Open closed eyes in photos', 'Open any closed eyes in this photo and make them look natural', ARRAY['parent', 'explorer'], true),
    ('Brighten Photo', 'Enhance brightness and lighting', 'Make this photo brighter with better lighting, keep it natural', ARRAY['parent', 'salon', 'realtor', 'business', 'explorer'], true),
    ('Remove Background', 'Remove the background completely', 'Remove the background and make it transparent', ARRAY['business', 'explorer'], true),
    ('Professional Lighting', 'Add professional studio lighting', 'Add professional studio lighting to this photo', ARRAY['salon', 'business'], true),
    ('Real Estate Ready', 'Optimize for real estate listing', 'Enhance this property photo: improve lighting, straighten vertical lines, make it look professional and inviting', ARRAY['realtor'], true);

-- ============================================================================
-- VERIFY SETUP
-- ============================================================================

-- Check tables exist
SELECT
    table_name,
    table_type
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_name IN ('user_profiles', 'templates', 'edits')
ORDER BY table_name;

-- Check RLS is enabled
SELECT
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
AND tablename IN ('user_profiles', 'templates', 'edits')
ORDER BY tablename;

-- Check policies exist
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd
FROM pg_policies
WHERE schemaname = 'public'
AND tablename IN ('user_profiles', 'templates', 'edits')
ORDER BY tablename, policyname;
```

---

## STEP 3: Verify the Setup Worked

After running the SQL above, you should see:

**Tables:**
- `user_profiles` (table)
- `templates` (table)
- `edits` (table)

**RLS Enabled:**
- All 3 tables should have `rowsecurity = true`

**Policies (6 total):**
1. user_profiles - "Users can create own profile" (INSERT, authenticated)
2. user_profiles - "Users can view own profile" (SELECT, authenticated)
3. user_profiles - "Users can update own profile" (UPDATE, authenticated)
4. templates - "Templates are publicly readable" (SELECT, authenticated)
5. edits - "Users can view own edits" (SELECT, authenticated)
6. edits - "Users can create own edits" (INSERT, authenticated)

---

## STEP 4: Test the App

1. **Delete the app** from simulator (important - clears cache)
2. **Clean build**: ⌘+Shift+K
3. **Build**: ⌘+B
4. **Run**: ⌘+R
5. **Complete onboarding** and select a role

### Watch Console Logs

You should see:
```
🔄 Attempting to sign in anonymously...
✅ Anonymous session created successfully! User ID: [UUID]
✅ User is anonymous: true
Creating user profile in database: [UUID]
User profile created successfully
✅ Auth session exists. User ID: [UUID]
✅ Session is anonymous: true
User profile updated successfully
```

---

## STEP 5: Verify in Supabase Dashboard

1. **Check Auth Users**: https://supabase.com/dashboard/project/ycuxojvbqodicewurpxp/auth/users
   - Should see anonymous user: `anonymous-XXXXX@supabase.com`

2. **Check User Profiles**: https://supabase.com/dashboard/project/ycuxojvbqodicewurpxp/editor/user_profiles
   - Should see 1 row with the user's ID and selected role

3. **Check Templates**: https://supabase.com/dashboard/project/ycuxojvbqodicewurpxp/editor/templates
   - Should see 5 template rows

---

## Common Issues

### Error: "relation does not exist"
- Run the CREATE TABLE commands again
- Make sure you're in the correct database (check project ref)

### Error: "must be owner of table"
- You're logged in with wrong credentials
- Use the Supabase SQL Editor (it uses service role automatically)

### Still getting "You must be signed in"
1. Verify anonymous auth is **actually enabled** (refresh the settings page)
2. Delete the app and rebuild from scratch
3. Check console logs - if you don't see "✅ Anonymous session created", the issue is with auth, not database

---

**Last Updated:** December 10, 2025
**Status:** Complete database recreation with UUID types
