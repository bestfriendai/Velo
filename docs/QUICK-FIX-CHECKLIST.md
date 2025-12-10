# Quick Fix Checklist: "You must be signed in" Error

Follow these steps in order. **Do NOT skip any steps!**

---

## ✅ Step 1: Enable Anonymous Authentication (CRITICAL!)

1. Open this link: https://supabase.com/dashboard/project/ycuxojvbqodicewurpxp/auth/settings
2. Scroll down to **"Anonymous sign-ins"** section
3. **Click the toggle to turn it ON** (should be green/blue when enabled)
4. Click **"Save"** button at the bottom
5. **Verify**: Refresh the page and confirm the toggle is still ON

**This is the most common reason for the error!**

---

## ✅ Step 2: Verify RLS Policies Exist

Your policies already exist (you got "already exists" error), so you can skip this step.

---

## ✅ Step 3: Delete App from Simulator

1. In the iOS Simulator, **press and hold the Velo app icon**
2. Click the **X** or select **"Remove App"**
3. Confirm deletion

This clears any cached authentication state.

---

## ✅ Step 4: Rebuild and Run

1. In Xcode, press **⌘+Shift+K** (Clean Build Folder)
2. Press **⌘+B** (Build)
3. Press **⌘+R** (Run)

---

## ✅ Step 5: Check Console Logs

1. When the app starts, **watch the Xcode console** (bottom panel)
2. Look for these messages:
   ```
   🔄 Attempting to sign in anonymously...
   ✅ Anonymous session created successfully! User ID: [UUID]
   ✅ User is anonymous: true
   ```

3. When you select a role, you should see:
   ```
   ✅ Auth session exists. User ID: [UUID]
   ✅ Session is anonymous: true
   User profile updated successfully
   ```

---

## ✅ Step 6: Verify in Supabase Dashboard

1. Open: https://supabase.com/dashboard/project/ycuxojvbqodicewurpxp/auth/users
2. You should see a new user with email like `anonymous-XXXXX@supabase.com`
3. Click on the user to see their profile data

---

## ❌ If It Still Doesn't Work

**Check console logs for these error messages:**

### Error: `❌ NO AUTH SESSION FOUND!`
- **Cause**: Anonymous sign-ins are NOT enabled in Supabase
- **Fix**: Go back to Step 1 and enable it (you probably forgot to click Save)

### Error: `Failed to create anonymous session: [error]`
- **Cause**: Supabase credentials are wrong or anonymous auth is disabled
- **Fix**:
  1. Verify environment variables in Xcode scheme (see [XCODE-SETUP.md](XCODE-SETUP.md))
  2. Verify anonymous auth is enabled (Step 1)

### Error: `operator does not exist: text = uuid`
- **Cause**: Old RLS policies with wrong casting
- **Fix**: See [DATABASE-POLICIES-SETUP.md](DATABASE-POLICIES-SETUP.md) and re-run the SQL with correct `auth.uid() = id::uuid`

---

## 🎉 Success!

If you completed onboarding without seeing any errors, the issue is fixed!

Next steps:
- Follow [XCODE-SETUP.md](XCODE-SETUP.md) if you haven't set up environment variables
- Check [NEXT-SESSION.md](NEXT-SESSION.md) for what to work on next

---

**Last Updated:** December 10, 2025
