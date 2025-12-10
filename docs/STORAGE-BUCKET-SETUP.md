# Storage Bucket Setup Guide

This guide walks you through creating the `edited-images` storage bucket and setting up Row Level Security policies.

---

## Quick Setup (5 minutes)

### Step 1: Create the Bucket

**Via Supabase Dashboard (Recommended):**

1. Go to [Supabase Storage](https://supabase.com/dashboard/project/ycuxojvbqodicewurpxp/storage/buckets)
2. Click **"New bucket"** button
3. Fill in the form:
   - **Name:** `edited-images`
   - **Public:** ❌ **Uncheck** (we'll use RLS policies)
   - **File size limit:** `52428800` (50 MB)
   - **Allowed MIME types:** `image/jpeg, image/png`
4. Click **"Create bucket"**

**Via Supabase CLI (Alternative):**

```bash
# Make sure you're in the project directory
cd /Users/kyvu/Desktop/Apps/Velo

# Create the bucket
supabase storage create edited-images --private
```

---

### Step 2: Set Up Row Level Security Policies

**Via Supabase SQL Editor:**

1. Go to [SQL Editor](https://supabase.com/dashboard/project/ycuxojvbqodicewurpxp/sql/new)
2. Copy and paste the SQL below
3. Click **"Run"**

```sql
-- ============================================================================
-- STORAGE BUCKET POLICIES FOR edited-images
-- ============================================================================
-- These policies ensure users can only access their own edited images
-- Images are stored in folders named by user ID: edited-images/{user_id}/...
-- ============================================================================

-- Policy 1: Allow users to UPLOAD images to their own folder
CREATE POLICY "Users can upload own images"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'edited-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Policy 2: Allow users to VIEW their own images
CREATE POLICY "Users can view own images"
ON storage.objects
FOR SELECT
TO authenticated
USING (
  bucket_id = 'edited-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Policy 3: Allow users to DELETE their own images
CREATE POLICY "Users can delete own images"
ON storage.objects
FOR DELETE
TO authenticated
USING (
  bucket_id = 'edited-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Policy 4: Allow Edge Functions to manage all images (using service role)
-- This is automatically handled by Supabase when using service_role key in functions
```

---

### Step 3: Verify the Setup

**Check Bucket Exists:**

```sql
-- Run in SQL Editor
SELECT *
FROM storage.buckets
WHERE id = 'edited-images';
```

**Expected result:**
```
id             | name          | public | file_size_limit | allowed_mime_types
---------------|---------------|--------|-----------------|--------------------
edited-images  | edited-images | false  | 52428800        | {image/jpeg,image/png}
```

**Check Policies Are Applied:**

```sql
-- Run in SQL Editor
SELECT policyname, roles, cmd
FROM pg_policies
WHERE tablename = 'objects'
AND schemaname = 'storage';
```

**Expected result:** Should show 3 policies:
- `Users can upload own images` (INSERT)
- `Users can view own images` (SELECT)
- `Users can delete own images` (DELETE)

---

## How It Works

### Folder Structure

Images are organized by user ID:

```
edited-images/
├── {user-id-1}/
│   ├── 1702123456000.jpg  (timestamp-based filename)
│   ├── 1702123789000.jpg
│   └── 1702124012000.jpg
├── {user-id-2}/
│   ├── 1702125001000.jpg
│   └── 1702125345000.jpg
└── ...
```

### Access Control Flow

**When User Uploads an Image:**

1. Edge Function calls: `supabase.storage.from('edited-images').upload('{user_id}/{timestamp}.jpg', image)`
2. RLS policy checks: `auth.uid() == folder name?`
3. If yes → Upload succeeds ✅
4. If no → Upload blocked ❌

**When User Views an Image:**

1. iOS app calls: `supabase.storage.from('edited-images').getPublicUrl('{user_id}/{filename}.jpg')`
2. RLS policy checks: `auth.uid() == folder owner?`
3. If yes → Returns signed URL ✅
4. If no → Returns 403 Forbidden ❌

---

## Testing the Setup

### Test 1: Upload from Edge Function

The Edge Function automatically tests upload on the next edit request.

**To trigger:**
1. Open the Velo app
2. Select a photo
3. Record a voice command: "Make it brighter"
4. Wait for processing

**Check logs:**
- Go to [Edge Function Logs](https://supabase.com/dashboard/project/ycuxojvbqodicewurpxp/functions/process-edit/logs)
- Look for: `✓ Image uploaded: https://...`

### Test 2: Verify in Storage Browser

1. Go to [Storage Browser](https://supabase.com/dashboard/project/ycuxojvbqodicewurpxp/storage/buckets/edited-images)
2. You should see a folder named with your user ID
3. Inside, you'll see `.jpg` files with timestamp names

### Test 3: Check Database Records

```sql
-- See recent edits with image URLs
SELECT
  id,
  user_id,
  command_text,
  edited_image_url,
  created_at
FROM edits
ORDER BY created_at DESC
LIMIT 5;
```

---

## Troubleshooting

### "Bucket does not exist" Error

**Issue:** Edge Function can't find `edited-images` bucket

**Fix:**
1. Verify bucket exists in dashboard
2. Check exact name (case-sensitive): `edited-images`
3. Ensure bucket is not public (should be private with RLS)

### "Permission denied" Error

**Issue:** RLS policy blocking upload

**Fix:**
1. Verify policies are created (see Step 3 above)
2. Check user is authenticated (JWT token is valid)
3. Ensure folder name matches user ID:
   ```sql
   -- Check user's actual ID
   SELECT auth.uid();
   ```

### "File size too large" Error

**Issue:** Image exceeds 50 MB limit

**Fix:**
- Compress image in iOS app before sending
- Current compression: `image.jpegData(compressionQuality: 0.8)`
- Can reduce to 0.6 for smaller files

### Images Not Appearing in Storage Browser

**Issue:** Upload succeeded but files not visible

**Fix:**
1. Refresh the storage browser page
2. Check correct bucket: `edited-images` (not `images` or `edits`)
3. Expand user ID folder to see files
4. Check database for `edited_image_url`:
   ```sql
   SELECT edited_image_url FROM edits ORDER BY created_at DESC LIMIT 1;
   ```

---

## Storage Costs

**Supabase Free Tier Limits:**
- Storage: **1 GB** (shared with database)
- Bandwidth: **2 GB/month**

**Typical Usage:**
- Average edited image: ~500 KB (after compression)
- Free tier holds: **~2,000 images**
- User with 20 edits/month: **10 MB/month**

**Cost After Free Tier:**
- Storage: **$0.021/GB/month**
- Bandwidth: **$0.09/GB**

**Example (1,000 Users, 20 Edits Each):**
- Images: 20,000 × 0.5 MB = **10 GB storage**
- Downloads (1 view per image): 20,000 × 0.5 MB = **10 GB bandwidth**
- **Monthly cost: $1.11** (storage + bandwidth)

---

## Cleanup and Maintenance

### Delete Old Images (Optional)

To save storage, you can periodically delete images older than 90 days:

```sql
-- Find old image records
SELECT *
FROM storage.objects
WHERE bucket_id = 'edited-images'
AND created_at < NOW() - INTERVAL '90 days';

-- Delete old images (run with caution!)
DELETE FROM storage.objects
WHERE bucket_id = 'edited-images'
AND created_at < NOW() - INTERVAL '90 days';
```

**Or set up automatic cleanup:**

Create a Supabase Edge Function that runs weekly via cron to clean up old images.

---

## Next Steps

After completing this setup:

✅ **Storage bucket created**
✅ **RLS policies applied**
✅ **Ready for testing**

**Now:**
1. Run the iOS app
2. Test a real edit with voice command
3. Check Edge Function logs for success
4. Verify image appears in Storage browser
5. Celebrate! 🎉

---

**Dashboard Link:** https://supabase.com/dashboard/project/ycuxojvbqodicewurpxp/storage/buckets

**Last Updated:** December 10, 2025
**Status:** Ready for setup
