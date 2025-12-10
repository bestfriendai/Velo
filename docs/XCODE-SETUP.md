# Xcode Configuration Setup

## Quick Fix for "Supabase credentials missing" Error

### Step 1: Add Config.xcconfig to Xcode

1. Open Xcode
2. In the Project Navigator (left sidebar), right-click on the `Velo` folder
3. Select **"Add Files to Velo..."**
4. Navigate to: `/Users/kyvu/Desktop/Apps/Velo/Velo/Config.xcconfig`
5. Make sure **"Copy items if needed"** is UNCHECKED (file is already in place)
6. Make sure **"Velo" target is checked**
7. Click **"Add"**

### Step 2: Set Configuration File in Build Settings (Easier Alternative)

**Actually, you can skip this step!** Instead, let's add the environment variables directly to the scheme, which is simpler.

Go to **Step 3** below for the easiest solution.

### Step 3: Add Environment Variables to Xcode Scheme (Recommended)

The easiest approach is to add the environment variables directly:

1. Select the **Velo scheme** (top toolbar, next to the device selector - it says "Velo > iPhone 15")
2. Click **"Edit Scheme..."** (or press ⌘+<)
3. Select **"Run"** on the left sidebar
4. Click the **"Arguments"** tab at the top
5. Under **"Environment Variables"** section, click the **+** button twice to add:

| Name | Value |
|------|-------|
| `SUPABASE_URL` | `https://ycuxojvbqodicewurpxp.supabase.co` |
| `SUPABASE_ANON_KEY` | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InljdXhvanZicW9kaWNld3VycHhwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM4MDkwMTUsImV4cCI6MjA0OTM4NTAxNX0.BK_ZbLjdHEIJRKtVLKdpPXXkqr7s_YJLCq4MxgZrcN8` |

6. **Make sure both checkboxes are checked** (enabled)
7. Click **"Close"**

### Step 4: Clean Build and Run

1. Press **⌘+Shift+K** (Clean Build Folder)
2. Press **⌘+B** (Build)
3. Press **⌘+R** (Run)

The "Supabase credentials missing" error should now be gone!

---

## Alternative: Set Environment Variables in Scheme (If Config File Doesn't Work)

If the `.xcconfig` approach doesn't work, you can set environment variables directly:

1. Select the **Velo scheme** → **Edit Scheme...**
2. Select **"Run"** → **"Arguments"** tab
3. Under **"Environment Variables"**, click **+** and add:

| Name | Value |
|------|-------|
| SUPABASE_URL | `https://ycuxojvbqodicewurpxp.supabase.co` |
| SUPABASE_ANON_KEY | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InljdXhvanZicW9kaWNld3VycHhwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM4MDkwMTUsImV4cCI6MjA0OTM4NTAxNX0.BK_ZbLjdHEIJRKtVLKdpPXXkqr7s_YJLCq4MxgZrcN8` |

---

## Troubleshooting

### Error: "Configuration file not found"

1. Make sure `Config.xcconfig` exists at: `/Users/kyvu/Desktop/Apps/Velo/Velo/Config.xcconfig`
2. Run: `ls -la /Users/kyvu/Desktop/Apps/Velo/Velo/Config.xcconfig`
3. If missing, copy from template:
   ```bash
   cp /Users/kyvu/Desktop/Apps/Velo/Velo/Config.xcconfig.template /Users/kyvu/Desktop/Apps/Velo/Velo/Config.xcconfig
   ```
4. Fill in your credentials

### Error: "Build input file cannot be found"

1. Remove the `Config.xcconfig` reference from Xcode (right-click → Delete → Remove Reference)
2. Re-add it following **Step 1** above

### Still seeing "Supabase credentials missing"?

Check that the environment variables are actually being loaded:

Add this temporary debug code to `SupabaseService.swift` at line 31:

```swift
print("DEBUG - SUPABASE_URL: \(Constants.API.supabaseURL)")
print("DEBUG - SUPABASE_ANON_KEY: \(Constants.API.supabaseAnonKey.prefix(20))...")
```

Run the app and check the console. You should see:
```
DEBUG - SUPABASE_URL: https://ycuxojvbqodicewurpxp.supabase.co
DEBUG - SUPABASE_ANON_KEY: eyJhbGciOiJIUzI1NiIsI...
```

If you see empty strings, the environment variables aren't being loaded.

---

## What's Next?

Once the app runs without the credentials error:

1. ✅ **Storage bucket is set up** (you already did this!)
2. ⏳ **Test the full editing flow:**
   - Launch app
   - Complete onboarding (select a role)
   - Tap the microphone button
   - Say "Make it brighter"
   - Select a photo from your library
   - Wait for processing
3. ⏳ **Verify results:**
   - Check [Edge Function logs](https://supabase.com/dashboard/project/ycuxojvbqodicewurpxp/functions/process-edit/logs)
   - Check [Storage browser](https://supabase.com/dashboard/project/ycuxojvbqodicewurpxp/storage/buckets/edited-images)
   - Confirm edited image appears in the app

---

**Last Updated:** December 10, 2025
**Status:** Ready for testing!
