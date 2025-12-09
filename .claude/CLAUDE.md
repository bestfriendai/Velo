# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Velo is a voice-first AI photo editing app for iOS. The core differentiator is conversational editing - users speak or type natural language commands like "Make my kid's eyes open and brighten the background" instead of using complex menus and sliders.

**Target Users:**
- Non-tech-savvy everyday users (parents, elderly)
- Local business owners (hair salons, boutiques, real estate agents)
- Content creators needing quick social media edits

**Business Model:**
- Free tier: 5 edits/month with watermark
- Pro: $6.99/month (unlimited edits, no watermark)
- Business: $14.99/month (batch processing, brand kits, team sharing)

## Development Commands

### Build & Run
```bash
# Open project in Xcode
open Velo.xcodeproj

# Build from command line (requires xcodebuild)
xcodebuild -project Velo.xcodeproj -scheme Velo -destination 'platform=iOS Simulator,name=iPhone 15' build

# Run on simulator
xcodebuild -project Velo.xcodeproj -scheme Velo -destination 'platform=iOS Simulator,name=iPhone 15' run
```

### Git Operations
```bash
# Standard workflow
git add .
git commit -m "message"
git push origin main
```

## Architecture

### Current State: UI Mockup Gallery
The app is currently in **mockup/prototyping phase**. ContentView serves as a gallery launcher for viewing different UI screens in isolation. This is NOT the production architecture - it's a design exploration tool.

### View Structure

**ContentView.swift** - Mockup gallery launcher (temporary)
- Navigation hub showing 4 mockup screens
- Uses `MockupScreen` enum to identify screens
- Full-screen modal presentation of each mockup

**Key Views (Velo/Views/):**

1. **OnboardingView.swift** - 3-screen onboarding flow
   - Welcome screen with app positioning
   - Feature highlights (voice-first, smart, fast)
   - Role selection teaser

2. **RoleSelectionView.swift** - User type segmentation
   - Defines `UserRole` model with role-specific config
   - 4 role types: Parent, Business Owner, Real Estate, Just for Fun
   - Each role has custom features list and gradient colors
   - Feeds into HomeView with selected role

3. **HomeView.swift** - Main dashboard (role-aware)
   - Receives `UserRole` as input to customize experience
   - 3 tabs: Recent Photos, Templates, Community Gallery
   - Quick chat bar at bottom for fast voice/text input
   - Transitions to EditingInterfaceView

4. **EditingInterfaceView.swift** - Core editing experience
   - Defines `ChatMessage` model for conversation UI
   - Chat-based interface for AI interactions
   - Photo preview with before/after toggle
   - Floating voice button (primary interaction)
   - AI suggestion cards for contextual prompts

### Data Models

Models are currently defined inline within views (will need extraction):

**UserRole** (in RoleSelectionView.swift)
```swift
struct UserRole: Identifiable {
    let id: String
    let icon: String
    let title: String
    let description: String
    let features: [String]
    let gradient: [Color]
}
```

**ChatMessage** (in EditingInterfaceView.swift)
```swift
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}
```

### UI Design Patterns

**Color Scheme:**
- Primary: Black background with gradient overlays
- Role-based gradients for personalization
- White text with opacity variations for hierarchy

**Navigation:**
- Uses `NavigationStack` for iOS 16+ navigation
- `.fullScreenCover` for modal presentations
- `@State` for local view state management

**Interaction Model:**
- Voice-first: Large, prominent voice button
- Text fallback: Chat input field always available
- Suggestions: AI-driven contextual prompt cards

## Next Implementation Steps

Based on the validation plan (see `/Users/kyvu/.claude/plans/linked-brewing-star.md`):

1. **Remove mockup gallery** - Replace ContentView with production navigation flow
2. **Add backend integration** - Nano Banana API for AI image editing
3. **Implement voice recognition** - Apple Speech Framework integration
4. **Add photo library access** - PhotoKit integration
5. **Create data layer** - Extract models, add UserDefaults/Core Data
6. **Build template system** - Role-specific prompt library
7. **Add subscription handling** - StoreKit 2 for IAP

## Critical Design Principles

These are non-negotiable based on market research:

1. **Voice-first is the brand** - Every feature must be voice-accessible
2. **Sub-60-second first edit** - Activation metric target
3. **Role-based personalization** - Generic experience = failure
4. **Zero learning curve** - No photo editing terminology visible
5. **Context awareness** - AI proactively suggests fixes

## File Organization

```
Velo/
├── VeloApp.swift           # App entry point
├── ContentView.swift       # Current: Mockup gallery (temporary)
├── Views/
│   ├── OnboardingView.swift
│   ├── RoleSelectionView.swift
│   ├── HomeView.swift
│   └── EditingInterfaceView.swift
└── Assets.xcassets/        # App icons, colors
```

Future structure will need:
```
Velo/
├── Models/                 # Data models (UserRole, ChatMessage, Photo, etc.)
├── Services/              # API clients (NanoBanana, Speech, Analytics)
├── ViewModels/            # MVVM layer for business logic
└── Views/                 # UI components
```

## Key Dependencies (Planned)

- **Nano Banana API** - AI image editing backend (Gemini 3 Pro Image)
- **Apple Speech Framework** - Voice recognition
- **PhotoKit** - Photo library access
- **StoreKit 2** - Subscription management
- **Core Data / CloudKit** - User data persistence (TBD)

## Testing Strategy (Not Yet Implemented)

When building tests:
- Focus on voice command parsing accuracy (target: >90%)
- Test role-based template loading
- Verify subscription tier access control
- Mock AI API responses for UI tests

## Reference Documents

- **Market validation**: `/Users/kyvu/.claude/plans/linked-brewing-star.md`
- **Project README**: `README.md`
- **Repository**: https://github.com/kyvu/Velo
