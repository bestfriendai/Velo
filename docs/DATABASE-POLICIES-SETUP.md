# Database Row Level Security (RLS) Policies Setup

## Issue: "You must be signed in to perform this action"

This error occurs when trying to update user profiles because **anonymous authentication is not enabled** or the database doesn't have the correct RLS policies.

---

## ⚠️ CRITICAL FIRST STEP: Enable Anonymous Authentication

**You MUST do this first before anything else will work!**

1. Go to [Authentication Settings](https://supabase.com/dashboard/project/ycuxojvbqodicewurpxp/auth/settings)
2. Scroll down to **"Anonymous sign-ins"**
3. Click the **toggle to turn it ON** (it should be green/enabled)
4. Click **"Save"** at the bottom of the page
5. **Verify it's enabled**: Refresh the page and confirm the toggle is still ON

**If you skip this step, the app will NOT work!**

---

## Step 2: Run These SQL Commands

Go to [Supabase SQL Editor](https://supabase.com/dashboard/project/ycuxojvbqodicewurpxp/sql/new) and run:

```sql
-- ============================================================================
-- USER PROFILES TABLE POLICIES
-- ============================================================================

-- 1. Allow anonymous users to INSERT their own profile (during signup)
CREATE POLICY "Users can create own profile"
ON public.user_profiles
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id::uuid);

-- 2. Allow users to VIEW their own profile
CREATE POLICY "Users can view own profile"
ON public.user_profiles
FOR SELECT
TO authenticated
USING (auth.uid() = id::uuid);

-- 3. Allow users to UPDATE their own profile
CREATE POLICY "Users can update own profile"
ON public.user_profiles
FOR UPDATE
TO authenticated
USING (auth.uid() = id::uuid)
WITH CHECK (auth.uid() = id::uuid);

-- ============================================================================
-- TEMPLATES TABLE POLICIES (Public Read)
-- ============================================================================

-- Allow anyone (even anonymous) to read templates
CREATE POLICY "Templates are publicly readable"
ON public.templates
FOR SELECT
TO authenticated
USING (is_active = true);

-- ============================================================================
-- EDITS TABLE POLICIES
-- ============================================================================

-- Allow users to view their own edit history
CREATE POLICY "Users can view own edits"
ON public.edits
FOR SELECT
TO authenticated
USING (auth.uid() = user_id::uuid);

-- Allow users to create their own edit records
CREATE POLICY "Users can create own edits"
ON public.edits
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id::uuid);
```

---

## Verify Policies Are Applied

Run this query to check:

```sql
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies
WHERE schemaname = 'public'
AND tablename IN ('user_profiles', 'templates', 'edits')
ORDER BY tablename, policyname;
```

**Expected output:** You should see 6 policies:
1. `user_profiles` - "Users can create own profile" (INSERT)
2. `user_profiles` - "Users can view own profile" (SELECT)
3. `user_profiles` - "Users can update own profile" (UPDATE)
4. `templates` - "Templates are publicly readable" (SELECT)
5. `edits` - "Users can view own edits" (SELECT)
6. `edits` - "Users can create own edits" (INSERT)

---

## If Policies Already Exist (Error: "already exists")

If you get an error like `policy "Users can view own profile" already exists`, first **drop the old policies**:

```sql
-- Drop existing policies on user_profiles
DROP POLICY IF EXISTS "Users can view own profile" ON public.user_profiles;
DROP POLICY IF EXISTS "Users can create own profile" ON public.user_profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.user_profiles;

-- Drop existing policies on templates
DROP POLICY IF EXISTS "Templates are public" ON public.templates;
DROP POLICY IF EXISTS "Templates are publicly readable" ON public.templates;

-- Drop existing policies on edits
DROP POLICY IF EXISTS "Users can view own edits" ON public.edits;
DROP POLICY IF EXISTS "Users can create own edits" ON public.edits;
```

Then re-run the CREATE POLICY commands above.

---

## Step 3: Verify Anonymous Auth is Working

After enabling anonymous sign-ins, verify it's working:

1. Open the app in Xcode and look at the **console logs**
2. You should see these messages:
   ```
   🔄 Attempting to sign in anonymously...
   ✅ Anonymous session created successfully! User ID: [UUID]
   ✅ User is anonymous: true
   ```

3. If you see `❌ NO AUTH SESSION FOUND!` then anonymous auth is **NOT** enabled in Supabase. Go back to Step 1.

4. Check the Supabase dashboard:
   - Go to [Authentication > Users](https://supabase.com/dashboard/project/ycuxojvbqodicewurpxp/auth/users)
   - You should see a new user with an email like `anonymous-XXXXX@supabase.com`
   - If you don't see any users, anonymous auth is **NOT** enabled

---

## Step 4: Test the Full Flow

1. **Delete the app from simulator** (press and hold app icon → Remove App)
2. **Run the app again** (⌘+R in Xcode)
3. **Complete onboarding** and select a role
4. **Check console logs** - you should see:
   ```
   ✅ Auth session exists. User ID: [UUID]
   ✅ Session is anonymous: true
   User profile updated successfully
   ```
5. The error should be gone!

---

## Troubleshooting

### Still seeing "You must be signed in"?

**Check if RLS is enabled on tables:**

```sql
SELECT schemaname, tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
AND tablename IN ('user_profiles', 'templates', 'edits');
```

If `rowsecurity` is `false` for any table, enable it:

```sql
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.edits ENABLE ROW LEVEL SECURITY;
```

Then re-run the CREATE POLICY commands.

---

### Error: "new row violates row-level security policy"

This means the policy's `WITH CHECK` condition is too restrictive. Make sure:
- Anonymous users are signing in successfully
- The `auth.uid()` matches the user's `id` in the database
- The policy uses `TO authenticated` (not `TO anon`)

**Debug query:**

```sql
-- Check what auth.uid() returns for your session
SELECT auth.uid();
```

If this returns `null`, you're not authenticated. Check:
1. Environment variables are set correctly
2. Anonymous sign-in is working (check app logs)

---

**Last Updated:** December 10, 2025
**Status:** Required for anonymous auth to work
