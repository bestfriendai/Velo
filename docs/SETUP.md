# Velo Setup Guide

This document contains the setup instructions for the Velo iOS app.

## Required Xcode Configuration

### 1. Privacy Permissions (Info.plist)

The following privacy usage descriptions must be added to the app's Info.plist (or via Xcode target settings → Info tab):

**Speech Recognition Permission:**
```xml
<key>NSSpeechRecognitionUsageDescription</key>
<string>Velo uses speech recognition to let you edit photos by simply speaking what you want to change.</string>
```

**Microphone Permission:**
```xml
<key>NSMicrophoneUsageDescription</key>
<string>Velo needs microphone access for voice commands to edit your photos.</string>
```

**Photo Library Usage (Add & Read):**
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Velo needs access to your photo library to edit and save your photos.</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>Velo needs permission to save edited photos to your library.</string>
```

### 2. Xcode Target Settings

**To add these via Xcode UI:**

1. Select the Velo target in Xcode
2. Go to the "Info" tab
3. Click the "+" button under "Custom iOS Target Properties"
4. Add each key-value pair listed above

Alternatively, you can add them directly to the Info.plist file if your project uses one.

---

## Environment Variables

The app requires the following environment variables for API integration:

### Supabase Configuration

Create a `.env` file in the project root (this file is gitignored):

```bash
# Supabase Configuration
SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here

# RevenueCat Configuration (for subscriptions)
REVENUECAT_API_KEY=your_revenuecat_api_key_here
```

**Note:** The Nano Banana API key should NEVER be stored in the iOS app. It will be stored securely in the Supabase Edge Function environment.

---

## Supabase Setup

### Step 1: Create Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Click "New Project"
3. Choose organization and project name: "velo-app"
4. Set a strong database password (save it in a password manager)
5. Choose region closest to your target users (e.g., US East)
6. Wait for project to be created (~2 minutes)

### Step 2: Get API Credentials

1. In Supabase dashboard, go to **Settings** → **API**
2. Copy the **Project URL** → This is your `SUPABASE_URL`
3. Copy the **anon/public key** → This is your `SUPABASE_ANON_KEY`
4. Add both to your `.env` file

### Step 3: Run Database Migrations

Copy the SQL from [database-schema.sql](./database-schema.sql) and:

1. In Supabase dashboard, go to **SQL Editor**
2. Click "New query"
3. Paste the schema SQL
4. Click "Run" to create all tables and Row Level Security policies

### Step 4: Set Up Storage Bucket

1. In Supabase dashboard, go to **Storage**
2. Click "Create bucket"
3. Name: `edited-images`
4. Set to **Private** (RLS policies will control access)
5. Click "Save"

---

## Nano Banana API Setup

### Step 1: Get API Key

1. Go to [https://nanobanana.ai](https://nanobanana.ai) (or appropriate provider)
2. Sign up for an account
3. Navigate to API keys section
4. Create a new API key
5. **IMPORTANT:** Store this key in Supabase Edge Function secrets (NOT in iOS app)

### Step 2: Add to Supabase Edge Function Secrets

```bash
# Install Supabase CLI if not already installed
brew install supabase/tap/supabase

# Link to your project
supabase link --project-ref YOUR_PROJECT_ID

# Set the secret
supabase secrets set NANO_BANANA_API_KEY=your_api_key_here
```

---

## RevenueCat Setup (for Subscriptions)

### Step 1: Create RevenueCat Account

1. Go to [https://www.revenuecat.com](https://www.revenuecat.com)
2. Sign up for free account
3. Create a new project: "Velo"

### Step 2: Configure iOS App

1. In RevenueCat dashboard, go to **Apps** → **Add App**
2. Select **iOS**
3. Enter your app's **Bundle ID**: `com.yourcompany.velo`
4. Upload your App Store Connect API key (or use shared secret)

### Step 3: Create Products

Create the following products in RevenueCat (these must match App Store Connect):

**Subscriptions:**
- `com.velo.pro.monthly` - Pro Monthly ($6.99)
- `com.velo.pro.annual` - Pro Annual ($59.99)
- `com.velo.business.monthly` - Business Monthly ($14.99)
- `com.velo.business.annual` - Business Annual ($129.99)

**Consumables:**
- `com.velo.credits.10` - 10 Edit Credits ($2.99)
- `com.velo.credits.25` - 25 Edit Credits ($4.99)

### Step 4: Create Entitlements

1. Go to **Entitlements** → **Create Entitlement**
2. Create two entitlements:
   - `pro` - Attach Pro Monthly and Pro Annual products
   - `business` - Attach Business Monthly and Business Annual products

### Step 5: Get API Key

1. In RevenueCat dashboard, go to **Settings** → **API Keys**
2. Copy the **Public SDK Key** for iOS
3. Add to your `.env` file as `REVENUECAT_API_KEY`

---

## Swift Package Dependencies

Add the following Swift Package Manager dependencies to the Xcode project:

### To Add Packages in Xcode:

1. In Xcode, go to **File** → **Add Package Dependencies...**
2. Add each package below:

### Supabase Swift SDK

```
https://github.com/supabase/supabase-swift
```
Version: 2.0.0 or later

### RevenueCat SDK

```
https://github.com/RevenueCat/purchases-ios
```
Version: 4.0.0 or later

---

## Running the App

### Prerequisites Checklist

Before running the app, ensure:

- ✅ Privacy permissions added to Info.plist (or target settings)
- ✅ `.env` file created with Supabase credentials
- ✅ Supabase project created and database schema applied
- ✅ Supabase storage bucket `edited-images` created
- ✅ Nano Banana API key stored in Supabase Edge Function secrets
- ✅ RevenueCat project configured
- ✅ Swift package dependencies added

### Build and Run

1. Open `Velo.xcodeproj` in Xcode
2. Select a simulator or physical device
3. Press `Cmd + R` to build and run
4. Grant permissions when prompted:
   - Speech Recognition
   - Microphone
   - Photo Library

### Testing Voice Recognition

1. Tap the microphone button on the editing screen
2. Speak a command: "Make it brighter"
3. The transcribed text should appear immediately
4. Release the button to stop recording

**Note:** Voice recognition works best on physical devices. Simulator may have limited functionality.

---

## Troubleshooting

### Voice Recognition Not Working

**Issue:** "Speech recognition not authorized"
- **Fix:** Check Info.plist has `NSSpeechRecognitionUsageDescription` and `NSMicrophoneUsageDescription`
- **Fix:** Go to iOS Settings → Velo → Enable Microphone and Speech Recognition

### Supabase Connection Failed

**Issue:** "Failed to connect to Supabase"
- **Fix:** Verify `SUPABASE_URL` and `SUPABASE_ANON_KEY` in `.env` file
- **Fix:** Ensure `.env` file is in project root and properly formatted
- **Fix:** Check Supabase project is not paused (free tier pauses after inactivity)

### Build Errors

**Issue:** "No such module 'Supabase'"
- **Fix:** Ensure Supabase Swift SDK is added via Swift Package Manager
- **Fix:** Clean build folder: `Cmd + Shift + K`, then rebuild

**Issue:** "Privacy permission strings missing"
- **Fix:** Add all required Info.plist entries as described above

---

## Next Steps After Setup

Once the app runs successfully:

1. Test the onboarding flow (select a role)
2. Try the voice recognition (speak a simple command)
3. Verify photo picker opens correctly
4. Review the PRD for Week 2 implementation tasks

For production deployment, see [DEPLOYMENT.md](./DEPLOYMENT.md) (coming soon).
