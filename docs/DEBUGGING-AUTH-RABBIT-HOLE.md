# The Authentication Rabbit Hole: A Debugging Story

**Date:** December 10, 2025
**Issue:** "You must be signed in to perform this action"
**Time to Resolution:** ~2 hours
**Root Cause:** Invalid Supabase API key

---

## 🐰 The Journey

### Initial Symptom
```
Failed to save user role: You must be signed in to perform this action.
```

### What We Thought It Was (In Order)

1. ❌ **RLS policies missing** → Created policies, still failed
2. ❌ **Anonymous auth not enabled** → User confirmed it was enabled, still failed
3. ❌ **SQL type casting issues** → Fixed `auth.uid()::text = id` to `auth.uid() = id::uuid`, still failed
4. ❌ **Database table structure wrong** → Recreated tables with correct UUID types, still failed
5. ❌ **INSERT + UPDATE timing issue** → Refactored to single INSERT, still failed
6. ❌ **Code flow calling updateUserProfile without createAnonymousSession** → Fixed the flow, still failed
7. ✅ **Invalid API key** → This was the actual problem!

---

## 🔍 Debugging Steps (What We Did)

### Phase 1: Database Policies Investigation
**Hypothesis:** RLS policies are blocking the request.

**Actions Taken:**
- Created `DATABASE-POLICIES-SETUP.md` with RLS policy SQL
- Added policies for `user_profiles`, `templates`, `edits` tables
- Verified policies with `SELECT * FROM pg_policies`

**Result:** Policies created, error persisted → Not the issue

---

### Phase 2: Anonymous Authentication
**Hypothesis:** Anonymous sign-ins not enabled in Supabase.

**Actions Taken:**
- Created step-by-step guide to enable anonymous auth
- User confirmed toggling it ON multiple times
- Created verification queries to check auth state

**Result:** Anonymous auth enabled, error persisted → Not the issue

---

### Phase 3: SQL Type Casting
**Hypothesis:** `auth.uid()` returns UUID but comparing to TEXT column.

**Actions Taken:**
- Fixed RLS policies from `auth.uid()::text = id` to `auth.uid() = id::uuid`
- Got "policy already exists" error (policies were there)

**Result:** Policies correct, error persisted → Not the issue

---

### Phase 4: Database Schema Mismatch
**Hypothesis:** Table columns have wrong types (TEXT vs UUID).

**Actions Taken:**
- Created `DATABASE-COMPLETE-SETUP.md` with full schema recreation
- Dropped and recreated all tables with `id UUID PRIMARY KEY`
- Verified table structure with `information_schema.tables`

**Result:** Tables correct, error persisted → Not the issue

---

### Phase 5: Code Flow Analysis
**Hypothesis:** INSERT then UPDATE pattern causing session persistence issue.

**Actions Taken:**
- Refactored `createAnonymousSession()` to NOT create profile
- Changed `updateUserProfile()` to create profile if doesn't exist (single INSERT)
- Avoided INSERT + UPDATE in sequence

**Result:** Flow improved, error persisted → Not the issue

---

### Phase 6: The Breakthrough - Missing Session Creation
**Hypothesis:** `createAnonymousSession()` not being called at all.

**Console Logs Showed:**
```
User selected role: parent
❌ NO AUTH SESSION! Cannot update profile.
```

**Missing Logs:**
- No "🎬 STARTING createAnonymousSession()"
- No "🔄 Calling supabase.auth.signInAnonymously()..."

**Discovery:**
Checked `RoleSelectionView.swift` line 157:
```swift
// WRONG - calls updateUserProfile without creating session first
try await supabaseService.updateUserProfile(roleType: role)
```

**Fix:**
```swift
// CORRECT - create session first
let userId = try await supabaseService.createAnonymousSession()
try await supabaseService.updateUserProfile(roleType: role)
```

**Result:** Code flow fixed, but NOW we see the real error!

---

### Phase 7: The ACTUAL Root Cause
**With fixed code flow, console now showed:**
```
🎬 STARTING createAnonymousSession()
🔄 Calling supabase.auth.signInAnonymously()...
❌ SIGN IN FAILED!
❌ Error: Invalid API key
Status Code: 401
```

**Real Problem:** The `SUPABASE_ANON_KEY` environment variable in Xcode had an invalid/expired API key.

**Solution:**
1. Went to Supabase dashboard → Project Settings → API
2. Copied the correct `anon` `public` key
3. Updated Xcode scheme environment variables
4. Clean build and run

**Result:** ✅ **SUCCESS!** Anonymous sign-in worked, profile created, onboarding completed.

---

## 💡 Key Learnings

### 1. Error Messages Can Be Misleading
- "You must be signed in" suggested RLS/auth config issues
- Actual cause was invalid API credentials
- The RLS error only appeared AFTER the auth call succeeded

### 2. Progressive Debugging is Essential
- Each hypothesis eliminated a possibility
- Built comprehensive logging to see actual flow
- Logs revealed the code flow issue (Phase 6)
- Which revealed the real error (Phase 7)

### 3. Always Verify Credentials First
**Should have checked earlier:**
- ✅ Environment variables are set
- ✅ API keys are correct and not expired
- ✅ URL is correct
- ❌ We assumed these were correct and debugged everything else first

### 4. Detailed Logging Saves Time
**The logging we added revealed:**
- Which functions were called (or not called)
- Exact error messages from Supabase
- Order of operations
- Session state at each step

### 5. Code Flow Bugs Can Hide Real Issues
- RoleSelectionView calling updateUserProfile without createAnonymousSession
- This meant we never tried to authenticate
- So we never saw the "Invalid API key" error
- Fixing the flow revealed the real problem

---

## ✅ The Correct Debugging Order (For Next Time)

### Step 1: Verify Basics FIRST
1. ✅ Check environment variables are set
2. ✅ Verify API keys match Supabase dashboard
3. ✅ Confirm URL is correct
4. ✅ Test API connection (simple query or auth call)

### Step 2: Add Comprehensive Logging
1. Log function entry/exit
2. Log all async call results
3. Log errors with full details (domain, code, message)
4. Log session state before operations

### Step 3: Check Code Flow
1. Verify functions are called in correct order
2. Check error handling doesn't swallow errors
3. Ensure async operations complete before next step

### Step 4: Check Backend Configuration
1. Database tables exist with correct schema
2. RLS policies are correct
3. Auth providers are enabled
4. Service is not paused/rate-limited

### Step 5: Check Data
1. Values are correct types (UUID vs String)
2. Foreign keys are valid
3. Required fields are populated

---

## 🛠️ Tools We Built During Debugging

### Documentation
1. `DATABASE-POLICIES-SETUP.md` - RLS policy setup guide
2. `DATABASE-COMPLETE-SETUP.md` - Full schema recreation
3. `XCODE-SETUP.md` - Environment variable configuration
4. `QUICK-FIX-CHECKLIST.md` - Step-by-step troubleshooting

### Code Improvements
1. Enhanced error logging in `SupabaseService.swift`
2. PostgrestError-specific error handling
3. Detailed auth state verification
4. Step-by-step logs for createAnonymousSession
5. Fixed RoleSelectionView to create session before updating profile

---

## 📊 Time Breakdown

- **Phase 1 (Database Policies):** 20 minutes
- **Phase 2 (Anonymous Auth):** 15 minutes
- **Phase 3 (SQL Casting):** 10 minutes
- **Phase 4 (Schema Recreation):** 20 minutes
- **Phase 5 (Code Refactoring):** 25 minutes
- **Phase 6 (Flow Analysis):** 15 minutes
- **Phase 7 (API Key Fix):** 5 minutes

**Total:** ~2 hours

**Time saved if checked API key first:** 1 hour 55 minutes 😅

---

## 🎯 Prevention Checklist

Before debugging complex auth issues, ALWAYS check:

- [ ] Environment variables exist
- [ ] API keys are correct (copy from dashboard)
- [ ] API keys are not expired
- [ ] URL matches project
- [ ] Test basic API call (like auth.session)
- [ ] Check console for actual error messages
- [ ] Add logging if errors are swallowed
- [ ] Verify code flow is correct
- [ ] Check backend configuration last

---

## 📝 Summary

**What seemed like:** A complex authentication, RLS policy, and database configuration issue.

**What it actually was:**
1. Invalid API key (90% of the problem)
2. Missing createAnonymousSession call in RoleSelectionView (10% of the problem)

**Lesson:** Always verify the simple things (credentials, configuration) before diving into complex debugging.

**Silver lining:** We now have excellent documentation, comprehensive error logging, and a robust onboarding flow!

---

**Last Updated:** December 10, 2025
**Status:** Resolved - Anonymous auth working perfectly!
