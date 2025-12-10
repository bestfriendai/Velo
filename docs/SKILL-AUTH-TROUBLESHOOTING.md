# Skill: Authentication Troubleshooting

**Purpose:** Step-by-step checklist to debug "You must be signed in" or authentication-related errors.

**When to Use:** When you get auth errors like:
- "You must be signed in to perform this action"
- "Invalid API key"
- "Unauthorized"
- "Session not found"
- Database operations fail with permission errors

---

## 🚦 PHASE 1: VERIFY CREDENTIALS (Do This FIRST!)

### ✅ Step 1.1: Check Environment Variables Exist

**In Xcode:**
1. Select scheme (top toolbar) → Edit Scheme
2. Run → Arguments tab
3. Verify these exist and are **CHECKED**:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`

**In Terminal:**
```bash
# For testing, you can temporarily print them (remove after)
echo "URL: $SUPABASE_URL"
echo "KEY: ${SUPABASE_ANON_KEY:0:20}..."  # First 20 chars only
```

**Expected Result:** Both variables should have values.

---

### ✅ Step 1.2: Verify API Key is Correct

**Get the correct key from Supabase:**
1. Go to: https://supabase.com/dashboard/project/[your-project-ref]/settings/api
2. Find **"Project API keys"** section
3. Copy the **`anon` `public`** key (NOT service_role!)

**Compare with Xcode:**
1. Xcode → Edit Scheme → Run → Arguments
2. Check `SUPABASE_ANON_KEY` value matches what you just copied
3. **Common mistake:** Using service_role key instead of anon key

**Fix if wrong:**
- Delete old value
- Paste new value from dashboard
- Make sure checkbox is CHECKED
- Close scheme editor
- Clean build (⌘+Shift+K)

---

### ✅ Step 1.3: Verify URL is Correct

**Expected format:** `https://[project-ref].supabase.co`

**Common mistakes:**
- ❌ `https://[project-ref].supabase.co/` (trailing slash)
- ❌ `https://supabase.com/dashboard/project/[ref]` (dashboard URL, not API URL)
- ❌ Missing `https://`

**Fix:**
```
Correct: https://ycuxojvbqodicewurpxp.supabase.co
Wrong:   https://ycuxojvbqodicewurpxp.supabase.co/
Wrong:   ycuxojvbqodicewurpxp.supabase.co
```

---

### ✅ Step 1.4: Test Basic API Connection

**Add temporary debug code:**
```swift
// In SupabaseService.init() after client initialization
Task {
    do {
        // Try to get session (should be nil initially, but call should succeed)
        let session = try? await supabase.auth.session
        Logger.info("✅ API connection test: SUCCESS", category: Logger.network)
        Logger.info("Session exists: \(session != nil)", category: Logger.network)
    } catch {
        Logger.error("❌ API connection test: FAILED", category: Logger.network)
        Logger.error("Error: \(error)", category: Logger.network)
    }
}
```

**Expected logs:**
```
✅ API connection test: SUCCESS
Session exists: false
```

**If you see "Invalid API key" here:** Your credentials are wrong (go back to 1.2)

---

## 🔍 PHASE 2: ADD COMPREHENSIVE LOGGING

### ✅ Step 2.1: Add Auth Function Logging

**In `createAnonymousSession()`:**
```swift
func createAnonymousSession() async throws -> String {
    Logger.info("🎬 STARTING createAnonymousSession()", category: Logger.auth)

    do {
        let session = try await supabase.auth.signInAnonymously()
        Logger.info("✅ SIGN IN SUCCESS! User ID: \(session.user.id)", category: Logger.auth)
        Logger.info("✅ Access token: \(session.accessToken.prefix(20))...", category: Logger.auth)
        return session.user.id.uuidString
    } catch let error as NSError {
        Logger.error("❌ SIGN IN FAILED!", category: Logger.auth)
        Logger.error("❌ Error domain: \(error.domain)", category: Logger.auth)
        Logger.error("❌ Error code: \(error.code)", category: Logger.auth)
        Logger.error("❌ Error: \(error.localizedDescription)", category: Logger.auth)
        throw error
    }
}
```

---

### ✅ Step 2.2: Add Database Operation Logging

**In database update/insert functions:**
```swift
func updateUserProfile(...) async throws {
    // Verify session exists
    guard let session = try? await supabase.auth.session else {
        Logger.error("❌ NO AUTH SESSION!", category: Logger.auth)
        throw SupabaseError.notAuthenticated
    }

    Logger.info("✅ Auth session verified", category: Logger.auth)
    Logger.info("Executing database operation...", category: Logger.network)

    do {
        try await supabase.database.from("table").update(...).execute()
        Logger.info("✅ Database operation SUCCESS", category: Logger.network)
    } catch let error as PostgrestError {
        Logger.error("❌ Postgrest error: \(error.message)", category: Logger.network)
        Logger.error("❌ Error code: \(error.code ?? "unknown")", category: Logger.network)
        throw error
    }
}
```

---

## 🔄 PHASE 3: VERIFY CODE FLOW

### ✅ Step 3.1: Check Function Call Order

**Correct order:**
```swift
// 1. Create session FIRST
let userId = try await createAnonymousSession()

// 2. THEN do database operations
try await updateUserProfile(roleType: role)
```

**Wrong order (causes "NO AUTH SESSION"):**
```swift
// ❌ WRONG - no session created
try await updateUserProfile(roleType: role)
```

**Search your codebase:**
```bash
cd /path/to/project
grep -r "updateUserProfile" --include="*.swift"
grep -r "createAnonymousSession" --include="*.swift"
```

Make sure every `updateUserProfile` call is preceded by `createAnonymousSession`.

---

### ✅ Step 3.2: Check Error Handling Doesn't Swallow Errors

**Bad:**
```swift
try? await supabaseService.createAnonymousSession()  // ❌ Errors are silently ignored
```

**Good:**
```swift
do {
    let userId = try await supabaseService.createAnonymousSession()
} catch {
    Logger.error("Failed to create session: \(error)", category: Logger.auth)
    throw error  // Re-throw or handle properly
}
```

---

## 🗄️ PHASE 4: VERIFY BACKEND CONFIGURATION

### ✅ Step 4.1: Check Anonymous Auth is Enabled

1. Go to: https://supabase.com/dashboard/project/[ref]/auth/settings
2. Scroll to **"Anonymous sign-ins"**
3. **Toggle should be GREEN/ON**
4. Click **"Save"**
5. **Refresh page** to verify it's still ON

---

### ✅ Step 4.2: Verify Database Tables Exist

**Run this SQL:**
```sql
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_name IN ('user_profiles', 'templates', 'edits')
ORDER BY table_name;
```

**Expected:** 3 tables listed.

---

### ✅ Step 4.3: Check RLS is Enabled

**Run this SQL:**
```sql
SELECT schemaname, tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
AND tablename IN ('user_profiles', 'templates', 'edits');
```

**Expected:** All tables have `rowsecurity = true`.

---

### ✅ Step 4.4: Verify RLS Policies Exist

**Run this SQL:**
```sql
SELECT tablename, policyname, cmd, roles
FROM pg_policies
WHERE schemaname = 'public'
AND tablename IN ('user_profiles', 'templates', 'edits')
ORDER BY tablename, policyname;
```

**Expected policies:**
- `user_profiles` - "Users can create own profile" (INSERT, authenticated)
- `user_profiles` - "Users can view own profile" (SELECT, authenticated)
- `user_profiles` - "Users can update own profile" (UPDATE, authenticated)
- `templates` - "Templates are publicly readable" (SELECT, authenticated)
- `edits` - "Users can view own edits" (SELECT, authenticated)
- `edits` - "Users can create own edits" (INSERT, authenticated)

---

### ✅ Step 4.5: Check RLS Policy Syntax

**Policies should use:**
```sql
-- For UUID columns
auth.uid() = id          -- ✅ Correct
auth.uid() = user_id     -- ✅ Correct

-- NOT:
auth.uid()::text = id    -- ❌ Wrong (type mismatch)
auth.uid() = id::text    -- ❌ Wrong (comparing UUID to text)
```

---

## 📊 PHASE 5: VERIFY DATA

### ✅ Step 5.1: Check Auth Users Exist

1. Go to: https://supabase.com/dashboard/project/[ref]/auth/users
2. After running app, you should see user with email like:
   - `anonymous-XXXXX@supabase.com` (for anonymous users)

**If no users appear:** Anonymous auth is NOT working (go back to Phase 4.1)

---

### ✅ Step 5.2: Check Database Records Created

**Run this SQL:**
```sql
SELECT id, role_type, subscription_tier, created_at
FROM user_profiles
ORDER BY created_at DESC
LIMIT 5;
```

**Expected:** At least one row with your user's UUID.

**If no rows:** Database insert is failing (check Phase 4 policies)

---

## 🎯 DECISION TREE

```
START: Getting "You must be signed in" error
    |
    ├─> Do you see "🎬 STARTING createAnonymousSession" in logs?
    │   ├─> NO → Code flow issue (Phase 3)
    │   └─> YES → Continue
    │
    ├─> Do you see "✅ SIGN IN SUCCESS" after that?
    │   ├─> NO → Check error message:
    │   │   ├─> "Invalid API key" → Phase 1.2 (Wrong API key)
    │   │   ├─> "Anonymous sign-ins disabled" → Phase 4.1
    │   │   └─> Other error → Phase 1.4 (API connection test)
    │   └─> YES → Continue
    │
    ├─> Do you see "✅ Auth session verified" before database op?
    │   ├─> NO → Session not persisting between calls
    │   │   └─> Check if using `try?` that swallows errors (Phase 3.2)
    │   └─> YES → Continue
    │
    ├─> Do you see "❌ Postgrest error"?
    │   ├─> YES → RLS policies blocking (Phase 4.3, 4.4)
    │   └─> NO → Check Phase 5 (data verification)
    │
    └─> Still failing? → Review DEBUGGING-AUTH-RABBIT-HOLE.md
```

---

## 🚀 QUICK WIN CHECKLIST

**Before spending hours debugging, verify these in order:**

1. [ ] Xcode environment variables are set and CHECKED
2. [ ] `SUPABASE_ANON_KEY` matches Supabase dashboard API key
3. [ ] `SUPABASE_URL` is correct format (no trailing slash)
4. [ ] Clean build (⌘+Shift+K) and run (⌘+R)
5. [ ] Check console logs show "🎬 STARTING createAnonymousSession"
6. [ ] Check console logs show "✅ SIGN IN SUCCESS"
7. [ ] Anonymous sign-ins enabled in Supabase dashboard
8. [ ] Database tables exist
9. [ ] RLS policies exist
10. [ ] `createAnonymousSession` called before `updateUserProfile`

**If all 10 are ✅ and it still fails:** Read the full debugging guide above.

---

## 📖 Related Documentation

- [DEBUGGING-AUTH-RABBIT-HOLE.md](DEBUGGING-AUTH-RABBIT-HOLE.md) - Full debugging story
- [DATABASE-POLICIES-SETUP.md](DATABASE-POLICIES-SETUP.md) - RLS policy setup
- [DATABASE-COMPLETE-SETUP.md](DATABASE-COMPLETE-SETUP.md) - Full schema setup
- [XCODE-SETUP.md](XCODE-SETUP.md) - Environment variables
- [QUICK-FIX-CHECKLIST.md](QUICK-FIX-CHECKLIST.md) - Quick troubleshooting

---

**Last Updated:** December 10, 2025
**Version:** 1.0
**Status:** Production-ready troubleshooting guide
