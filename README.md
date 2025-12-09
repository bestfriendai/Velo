# Velo

**The Photo Editor Where You Just Talk**

Velo is an iOS photo editing app that uses voice/text-first conversational AI to make photo editing simple, fast, and accessible for everyone. No complicated menus, no overwhelming toolsets—just tell it what you want.

## 🎯 The Problem

Existing photo editing apps are:
- **Too complex** - Hundreds of sliders, filters, and tools that overwhelm casual users
- **Time-consuming** - Decision fatigue from endless preset scrolling
- **Not accessible** - Require technical knowledge of editing terminology

## ✨ Our Solution

Voice-first conversational editing powered by AI:
- **Just speak or type** what you want: "Make my kid's eyes open and brighten the background"
- **Role-based experience** - Customized for parents, salon owners, real estate agents, etc.
- **Zero learning curve** - No need to know what "saturation" or "HSL" means

## 🚀 Key Features

- **Conversational AI editing** - Natural language commands via voice or text
- **Smart context awareness** - Proactively suggests fixes (closed eyes, poor lighting, etc.)
- **Role-based templates** - Pre-configured workflows for different user types
- **Batch processing** - Edit multiple photos with one command
- **Inspiration gallery** - Community-powered template library
- **Non-destructive editing** - Undo tree lets you jump to any edit point

## 🎨 Target Users

1. **Non-tech-savvy everyday users** - Parents, seniors, casual photo editors
2. **Local business owners** - Hair salons, boutiques, cafes needing quick social media content
3. **Real estate agents** - Fast, professional property photo editing

## 🛠 Tech Stack

- **Platform**: iOS 16+ (Swift/SwiftUI)
- **Architecture**: MVVM (Model-View-ViewModel)
- **AI Backend**: Nano Banana (Gemini 3 Pro Image API)
- **Voice Recognition**: Apple Speech Framework (SFSpeechRecognizer)
- **Backend**: Supabase (PostgreSQL + Auth + Storage + Edge Functions)
- **Payments**: StoreKit 2 + RevenueCat
- **Analytics**: Mixpanel/Amplitude (planned)

## 📊 Market Opportunity

- AI photo editing is the **fastest-growing software category** (441% YoY growth)
- **40%+ of smartphone users** in major markets use AI photo editors
- Photo/Video apps have the **highest monetization success rates** (27.57% reach $1K revenue in 2 years)

## 💰 Monetization

- **Free Tier**: 5 edits/month with watermark
- **Pro**: $6.99/month - unlimited edits, no watermark, batch processing
- **Business**: $14.99/month - team sharing, multiple brand kits, analytics

## 📝 Project Status

✅ **Week 1 Complete** - Foundation built (MVVM architecture, voice recognition, Supabase integration)

🚧 **Next**: Week 2 - Edge Functions, ViewModels, and real AI integration

## 🚀 Getting Started

**New to the project?** Start here:
- [📘 Quick Start Guide](docs/QUICK-START.md) - Get running in 15 minutes
- [📋 Product Requirements](docs/PRD.md) - Complete product specification
- [⚙️ Setup Guide](docs/SETUP.md) - Detailed configuration instructions

**For Development:**
1. Clone the repository
2. Follow the [Quick Start Guide](docs/QUICK-START.md) to set up Supabase and API keys
3. Open `Velo.xcodeproj` in Xcode
4. Build and run (Cmd+R)

## 📁 Project Structure

```
Velo/
├── Models/          # Data models (User, EditSession, Template, BrandKit)
├── Views/           # SwiftUI views organized by feature
│   ├── Onboarding/  # Role selection, tutorial
│   ├── Editing/     # Main editing interface
│   ├── Templates/   # Template gallery (coming soon)
│   └── Settings/    # Settings, account (coming soon)
├── ViewModels/      # Business logic layer (Week 2)
├── Services/        # Backend integration
│   ├── VoiceRecognitionService.swift
│   └── SupabaseService.swift
├── Utilities/       # Constants, extensions, logger
└── Resources/       # Assets, fonts

docs/
├── PRD.md                  # Product Requirements Document
├── QUICK-START.md          # 15-minute setup guide
├── SETUP.md                # Detailed setup instructions
└── database-schema.sql     # Supabase PostgreSQL schema
```

## 📄 License

TBD

## 👤 Author

Created with passion to solve real photo editing frustrations.

---

*"The anti-complexity photo editor for people overwhelmed by Photoshop"*
