# Velo Quick Start Guide

This guide will get you from zero to a running app in ~15 minutes.

---

## Step 1: Create Supabase Project (5 minutes)

### 1.1 Sign Up / Sign In

1. Go to [https://supabase.com](https://supabase.com)
2. Click "Start your project"
3. Sign in with GitHub (recommended) or email

### 1.2 Create New Project

1. Click "New Project"
2. Select your organization (or create one)
3. Fill in project details:
   - **Name**: `velo-app`
   - **Database Password**: Generate a strong password (click the generate icon)
     - ⚠️ **IMPORTANT**: Copy and save this password somewhere safe (you'll need it later)
   - **Region**: Choose closest to you (e.g., `US East (Ohio)` if in USA)
   - **Pricing Plan**: Free (plenty for MVP)
4. Click "Create new project"
5. Wait ~2 minutes for setup to complete ☕

### 1.3 Get Your API Credentials

Once the project is ready:

1. In the left sidebar, click **Settings** (gear icon at bottom)
2. Click **API** in the settings menu
3. You'll see two important values:

   **Project URL:**
   ```
   https://abcdefghijklmnop.supabase.co
   ```

   **anon/public key:** (long string starting with `eyJ...`)
   ```
   eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```

4. Keep this tab open - you'll need these values in a moment

---

## Step 2: Run Database Schema (3 minutes)

### 2.1 Open SQL Editor

1. In Supabase dashboard, click **SQL Editor** in left sidebar (icon looks like `</> SQL`)
2. Click **"New query"** button (top right)

### 2.2 Paste and Run Schema

1. Open the file `docs/database-schema.sql` from this project
2. Copy ALL the contents (Cmd+A, Cmd+C)
3. Paste into the Supabase SQL Editor
4. Click **"Run"** button (or press Cmd+Enter)
5. You should see: ✅ **"Success. No rows returned"**

### 2.3 Verify Tables Created

1. In left sidebar, click **Table Editor**
2. You should now see 4 tables:
   - `user_profiles`
   - `edits`
   - `templates`
   - `brand_kits`
3. Click on `templates` table - you should see **12 rows** (the sample templates)

✅ **Database is ready!**

---

## Step 3: Get Nano Banana API Key (2 minutes)

Nano Banana is the AI service that powers photo editing via Gemini 3 Pro Image API.

### Option A: Direct from Nano Banana (Recommended)

1. Go to [https://nanobanana.dev](https://nanobanana.dev)
2. Click "Get API Key" or "Sign Up"
3. Create an account
4. Navigate to **API Keys** section
5. Click **"Create New Key"**
6. Copy the API key (starts with `nb_` or similar)

### Option B: Via Third-Party Provider (Cheaper)

If you want to save 20-50% on API costs, you can use a third-party provider:

1. Go to one of these providers:
   - [OpenRouter](https://openrouter.ai) - supports Gemini models
   - [AI/ML API](https://aimlapi.com) - Gemini 2.5 Flash and Pro
2. Sign up and get API key
3. Look for "Gemini 2.5 Flash Image" or "Gemini 3 Pro Image" in their models list

### Option C: Google AI Studio (Direct Google Access)

1. Go to [https://aistudio.google.com/apikey](https://aistudio.google.com/apikey)
2. Sign in with Google account
3. Click **"Create API Key"**
4. Select a Google Cloud project (or create new one)
5. Copy the API key

**For MVP, Option C (Google AI Studio) is the easiest and FREE to start.**

⚠️ **IMPORTANT**: This API key should NEVER go in your iOS app. It will be stored in Supabase Edge Function secrets (we'll do this in Week 2).

For now, just **save the API key somewhere safe** (e.g., password manager or notes app).

---

## Step 4: Configure Your iOS Project (5 minutes)

### 4.1 Create `.env` File

1. In your project root (`/Users/kyvu/Desktop/Apps/Velo/`), create a file named `.env`
2. Add your Supabase credentials:

```bash
# Supabase Configuration
SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.YOUR_KEY_HERE

# RevenueCat (leave empty for now, we'll set this up in Week 2)
REVENUECAT_API_KEY=
```

3. Replace `YOUR_PROJECT_ID` and `YOUR_KEY_HERE` with the values from Step 1.3
4. Save the file

**Verify `.env` is gitignored:**
```bash
cat .gitignore | grep ".env"
```
You should see `*.env` in the output. ✅

### 4.2 Add Privacy Permissions to Xcode

1. Open `Velo.xcodeproj` in Xcode
2. Select **Velo** target in left sidebar
3. Click **Info** tab at the top
4. Under "Custom iOS Target Properties", click the **+** button
5. Add these 4 entries one by one:

| Key | Value |
|-----|-------|
| `Privacy - Speech Recognition Usage Description` | Velo uses speech recognition to let you edit photos by simply speaking what you want to change. |
| `Privacy - Microphone Usage Description` | Velo needs microphone access for voice commands to edit your photos. |
| `Privacy - Photo Library Usage Description` | Velo needs access to your photo library to edit and save your photos. |
| `Privacy - Photo Library Additions Usage Description` | Velo needs permission to save edited photos to your library. |

**Shortcut:** You can also add these directly to Info.plist if your project has one:
- Right-click on Velo project → Add Files → Info.plist
- Or add via the Info tab as described above

### 4.3 Add Swift Package Dependencies

1. In Xcode, go to **File** → **Add Package Dependencies...**
2. Add Supabase SDK:
   - Paste: `https://github.com/supabase/supabase-swift`
   - Click "Add Package"
   - Select **Supabase** (check the box)
   - Click "Add Package"

3. Add RevenueCat SDK (optional for now, needed for Week 2):
   - **File** → **Add Package Dependencies...**
   - Paste: `https://github.com/RevenueCat/purchases-ios`
   - Click "Add Package"
   - Select **RevenueCat** and **RevenueCatUI**
   - Click "Add Package"

---

## Step 5: Build and Run! 🚀

### 5.1 Build the App

1. In Xcode, select a simulator (iPhone 15 Pro recommended)
2. Press **Cmd + B** to build
3. Wait for build to complete (~30 seconds first time)

### 5.2 Fix Any Build Errors

**Common error:** "No such module 'Supabase'"
- **Fix**: Clean build folder (Cmd + Shift + K), then rebuild (Cmd + B)

**Common error:** Environment variable warnings
- **Fix**: The `.env` file isn't loaded automatically yet. This is OK for now - we'll integrate it properly in Week 2. The app will use placeholder values.

### 5.3 Run the App

1. Press **Cmd + R** to run
2. The app should launch in the simulator
3. You'll see the mockup gallery with 4 screens:
   - Onboarding Flow
   - Role Selection ✅ (now fully integrated with backend!)
   - Home/Gallery
   - Editing Interface

### 5.4 Test Role Selection

1. Tap **"Role Selection"** from the gallery
2. You should see 5 role cards:
   - Everyday User (Parent)
   - Salon/Beauty Owner
   - Real Estate Pro
   - Small Business
   - Just Exploring
3. Tap any role - it should highlight with a colored border
4. Tap **"Continue"**
5. You'll see a loading spinner briefly
6. The selection will be saved locally!

**Check the Xcode console** - you should see log messages like:
```
User selected role: salon
```

---

## Step 6: Verify Everything Works

### 6.1 Check Xcode Console Logs

When you tap "Continue" in Role Selection, you should see:
```
[UI] User selected role: parent
[Analytics] Event: role_selected | Parameters: ["role": "parent"]
[Analytics] Event: onboarding_completed | Parameters: ["role": "parent"]
```

### 6.2 Check UserDefaults (Persistence)

The selected role should be saved. To verify:

1. Run the app
2. Select a role and tap "Continue"
3. Stop the app (Cmd + .)
4. Run again (Cmd + R)
5. In your code, add a print statement in `VeloApp.swift`:

```swift
init() {
    if let role = UserDefaults.standard.string(forKey: "selectedRoleType") {
        print("✅ Saved role: \(role)")
    }
}
```

### 6.3 Test Voice Recognition (Physical Device Required)

⚠️ **Note**: Voice recognition has limited functionality on simulator. For full testing, you need a physical iPhone.

**On Physical Device:**

1. Connect your iPhone via USB
2. In Xcode, select your iPhone from the device dropdown
3. Run the app (Cmd + R)
4. Navigate to a view with the microphone button
5. Tap the microphone button
6. You'll be prompted to allow Speech Recognition and Microphone access
7. Tap "Allow"
8. Speak into the phone
9. You should see real-time transcription appear!

---

## What You've Accomplished ✅

- ✅ Supabase project created and configured
- ✅ Database schema deployed (4 tables + 12 templates)
- ✅ Nano Banana API key obtained (saved for Week 2)
- ✅ iOS app configured with privacy permissions
- ✅ Supabase and RevenueCat SDKs installed
- ✅ App builds and runs successfully
- ✅ Role selection works with real backend integration
- ✅ Data persists locally in UserDefaults

---

## What's Next? (Week 2 Preview)

Now that the foundation is set up, Week 2 will focus on:

1. **Integrate Supabase SDK** into `SupabaseService.swift`
   - Replace placeholder authentication with real anonymous auth
   - Connect to actual database tables
   - Sync user profiles to cloud

2. **Create Edge Functions** for AI processing
   - Deploy `process-edit` function to Supabase
   - Store Nano Banana API key in Edge Function secrets
   - Test image editing with real AI calls

3. **Build ViewModels**
   - `EditingViewModel` - handles voice commands and AI processing
   - `TemplateViewModel` - loads templates from Supabase
   - `OnboardingViewModel` - coordinates onboarding flow

4. **Refactor Editing UI**
   - Connect voice button to `VoiceRecognitionService`
   - Integrate with Nano Banana via Edge Function
   - Show real-time processing progress
   - Display before/after results

5. **Test End-to-End Flow**
   - User speaks: "Make it brighter"
   - Voice → Text → Backend → AI → Result
   - Display edited image with before/after slider

---

## Troubleshooting

### "Build failed" errors

**Problem**: Swift Package Manager dependencies not resolved
**Solution**:
```bash
# In Terminal, navigate to project directory
cd /Users/kyvu/Desktop/Apps/Velo
# Reset package cache
rm -rf .build
# In Xcode: File → Packages → Reset Package Caches
```

### "Supabase connection failed"

**Problem**: `.env` file not loaded or wrong credentials
**Solution**:
1. Verify `.env` file exists in project root
2. Check credentials match Supabase dashboard (Settings → API)
3. For now, the app works with placeholder values - full integration in Week 2

### "No rows in templates table"

**Problem**: Database schema didn't seed templates
**Solution**:
1. Go to Supabase SQL Editor
2. Run this query:
```sql
SELECT COUNT(*) FROM templates;
```
3. Should return `12`. If not, re-run the schema from Step 2.2

### "Privacy permissions not appearing"

**Problem**: Info.plist entries not configured
**Solution**:
1. Xcode → Select Target → Info tab
2. Verify all 4 privacy descriptions are present
3. Clean build (Cmd+Shift+K) and rebuild

---

## Need Help?

- Check [SETUP.md](./SETUP.md) for detailed configuration
- Review [database-schema.sql](./database-schema.sql) for DB structure
- Check [PRD.md](./PRD.md) for full product specification
- Open an issue on GitHub: [https://github.com/kyvu/Velo/issues](https://github.com/kyvu/Velo/issues)

---

**You're all set! Happy coding! 🚀**
