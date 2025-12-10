# Next Session - Quick Start

**Previous Session:** December 9, 2025 - Week 1 Complete ✅
**Next Session:** Week 2 - Real AI Integration

---

## ⚡ Quick Commands

```bash
# Open project in Xcode
cd /Users/kyvu/Desktop/Apps/Velo
open Velo.xcodeproj

# Verify everything works
# Press Cmd+B to build
# Press Cmd+R to run

# Check git status
git pull origin main
git status
```

---

## 📋 First 3 Tasks for Week 2

### 1. Add Supabase Swift SDK (5 minutes)

**In Xcode:**
1. File → Add Package Dependencies...
2. Paste: `https://github.com/supabase/supabase-swift`
3. Click "Add Package"
4. Select "Supabase" checkbox
5. Click "Add Package"

### 2. Update SupabaseService.swift (30 minutes)

**File:** `Velo/Services/SupabaseService.swift`

**Replace placeholder with:**
```swift
import Supabase

private let supabase = SupabaseClient(
    supabaseURL: URL(string: Constants.API.supabaseURL)!,
    supabaseKey: Constants.API.supabaseAnonKey
)
```

**Implement real:**
- Anonymous authentication
- User profile queries
- Template fetching

### 3. Test Anonymous Auth (15 minutes)

**Test flow:**
1. App launches → Auto-creates anonymous user
2. User selects role → Saves to Supabase
3. Check Supabase dashboard → User appears in `user_profiles` table
4. Verify edit quota tracking works

---

## 🎯 Week 2 Goals

### Phase 1: Backend Integration (Days 1-2)
- [ ] Supabase Swift SDK integrated
- [ ] Anonymous auth working
- [ ] User profiles syncing to database
- [ ] Templates loading from database

### Phase 2: Edge Functions (Days 3-4)
- [ ] Create `process-edit` Edge Function
- [ ] Store Nano Banana API key in secrets
- [ ] Test AI image processing
- [ ] Implement quota enforcement

### Phase 3: ViewModels (Days 5-6)
- [ ] EditingViewModel with voice integration
- [ ] TemplateViewModel for gallery
- [ ] OnboardingViewModel for flow
- [ ] Refactor HomeView and EditingInterfaceView

### Phase 4: Testing (Day 7)
- [ ] End-to-end voice → AI flow
- [ ] Quota tracking and reset
- [ ] Watermarking for free tier
- [ ] Performance optimization

---

## 📚 Reference Documents

All documentation is in `/docs/`:

- **WEEK-1-SUMMARY.md** - Complete Week 1 recap
- **PRD.md** - Full product requirements
- **QUICK-START.md** - Setup guide
- **SETUP.md** - Detailed configuration
- **database-schema.sql** - Database structure

---

## ✅ Pre-Session Checklist

Before coding tomorrow:

- [ ] Read WEEK-1-SUMMARY.md to refresh memory
- [ ] Verify app builds (Cmd+B)
- [ ] Check Supabase dashboard - project is live
- [ ] Confirm .env has correct credentials
- [ ] Pull latest from GitHub (`git pull origin main`)

---

## 🔑 Key Files to Know

### Models
- `User.swift` - RoleType, SubscriptionTier, UserProfile
- `Template.swift` - 12 sample templates
- `EditSession.swift` - AI processing types

### Services
- `SupabaseService.swift` ⚠️ **NEEDS WORK** - Placeholder only
- `VoiceRecognitionService.swift` ✅ **COMPLETE** - Ready to use

### Views
- `RoleSelectionView.swift` ✅ **INTEGRATED** - Uses real backend
- `HomeView.swift` ⏳ **REFACTOR NEEDED** - Still uses OldUserRole
- `EditingInterfaceView.swift` ⏳ **REFACTOR NEEDED** - Needs ViewModel

### Utilities
- `Constants.swift` - All config in one place
- `Logger.swift` - Categorized logging
- `Extensions.swift` - Helpful utilities

---

## 💡 Tips for Week 2

1. **Start with SupabaseService** - Foundation for everything else
2. **Test as you go** - Don't wait to test until the end
3. **Use Logger liberally** - Log everything for debugging
4. **Check Supabase dashboard** - Verify data is saving
5. **Commit frequently** - Small, focused commits

---

## 🐛 If Something Breaks

### Build Errors
```bash
# Clean build folder
Cmd + Shift + K

# Reset package cache
File → Packages → Reset Package Caches

# Rebuild
Cmd + B
```

### Git Issues
```bash
# Revert uncommitted changes
git checkout .

# Go back to last commit
git reset --hard HEAD

# Pull latest
git pull origin main
```

### Supabase Issues
1. Check .env file has correct credentials
2. Verify Supabase project isn't paused
3. Check database schema is deployed
4. Look at Supabase logs in dashboard

---

## 📞 Quick Reference

**Supabase Project URL:** https://ycuxojvbqodicewurpxp.supabase.co
**GitHub Repo:** https://github.com/kyvu/Velo
**Current Branch:** main
**iOS Target:** iOS 16+

---

## 🎉 What's Already Working

- ✅ App compiles with zero errors
- ✅ Role selection saves locally
- ✅ Logging system functional
- ✅ Voice recognition ready (needs permissions)
- ✅ 12 templates defined
- ✅ Database schema deployed
- ✅ Environment configured

**You're starting Week 2 from a solid foundation!** 🚀

---

*Last Updated: December 9, 2025*
*Status: Ready for Week 2*
