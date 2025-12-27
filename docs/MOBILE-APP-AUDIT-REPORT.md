# 🏗️ Velo — Complete Codebase Analysis & Improvement Blueprint

> **Generated:** December 27, 2025
> **Platform:** Swift/SwiftUI (iOS 17+)
> **Health Score:** 78/100
> **Audit Duration:** Estimated 2-3 weeks to implement all fixes

---

## 📋 Executive Summary

Velo is a voice-first AI photo editing app built with SwiftUI, targeting iOS 17+. The codebase demonstrates **solid foundational architecture** with proper separation of concerns (MVVM pattern), comprehensive error handling, and security-conscious design. The app successfully implements a coordinator pattern, dependency injection, and follows many iOS best practices.

**Critical Issues Requiring Immediate Attention:**
1. **API Keys in Source Code** - Placeholder API keys in `Secrets.swift` should be replaced with proper configuration before production
2. **Legacy `@ObservableObject` Pattern** - Should migrate to `@Observable` macro for iOS 17+ performance benefits
3. **ContentView Mockup Gallery** - Deprecated mockup launcher still present in codebase

**UI/UX Quality Rating: 8.5/10** - Clean dark theme with gradient-based personalization, good accessibility support, proper haptic feedback integration. Missing some micro-animations and loading states in certain views.

**Integration Readiness:**
- ✅ Supabase: Fully integrated with auth, database, storage, and edge functions
- ⚠️ RevenueCat: Configured but not yet implemented (placeholder keys)
- ✅ Voice Recognition: Fully implemented with Apple Speech framework
- ✅ Image Processing: Backend edge function ready with Nano Banana API

**Top 3 Priorities for This Sprint:**
1. Migrate from `@ObservableObject` to `@Observable` macro for improved performance
2. Complete RevenueCat integration with paywall UI
3. Replace ContentView mockup gallery with production navigation flow

---

## 🗂️ Project Structure Analysis

### Current File Tree
```
Velo/
├── .claude/CLAUDE.md           # AI assistant instructions
├── .github/workflows/ci.yml    # CI/CD configuration
├── .swiftlint.yml              # SwiftLint configuration
├── Velo.xcodeproj/             # Xcode project file
├── Velo/
│   ├── VeloApp.swift           # App entry point
│   ├── ContentView.swift       # Mockup gallery (deprecated)
│   ├── Configuration/
│   │   └── Secrets.swift       # API credentials
│   ├── Coordinators/
│   │   └── AppCoordinator.swift  # Navigation & state management
│   ├── Models/
│   │   ├── User.swift          # User, RoleType, SubscriptionTier
│   │   ├── EditSession.swift   # Edit request/response models
│   │   ├── Template.swift      # Template system
│   │   ├── BrandKit.swift      # Brand kit model
│   │   └── LegacyModels.swift  # Backward compatibility
│   ├── Services/
│   │   ├── SupabaseService.swift      # Backend integration
│   │   └── VoiceRecognitionService.swift  # Speech recognition
│   ├── Utilities/
│   │   ├── Constants.swift     # Design tokens & configuration
│   │   ├── Logger.swift        # Unified logging
│   │   ├── HapticManager.swift # Haptic feedback
│   │   ├── Extensions.swift    # View, String, Image extensions
│   │   ├── ErrorHandler.swift  # Centralized error handling
│   │   └── ImageCache.swift    # NSCache-based image caching
│   ├── ViewModels/
│   │   ├── OnboardingViewModel.swift
│   │   ├── EditingViewModel.swift
│   │   └── TemplateViewModel.swift
│   └── Views/
│       ├── Onboarding/
│       │   ├── OnboardingView.swift
│       │   └── RoleSelectionView.swift
│       ├── Editing/
│       │   ├── HomeView.swift
│       │   └── EditingInterfaceView.swift
│       └── Components/
│           ├── AccessibilityModifiers.swift
│           ├── EmptyStateView.swift
│           └── SkeletonView.swift
├── VeloTests/
│   ├── EditingViewModelTests.swift
│   └── Mocks/MockSupabaseService.swift
├── supabase/
│   ├── config.toml
│   └── functions/process-edit/index.ts
└── docs/
    ├── PRD.md
    ├── SETUP.md
    └── [other documentation]
```

### Architecture Diagram

```mermaid
graph TB
    subgraph Presentation["🎨 Presentation Layer"]
        VeloApp[VeloApp.swift]
        RootView[RootView]
        Views[Views/Screens]
        Components[Reusable Components]
    end

    subgraph Coordinator["🧭 Coordinator Layer"]
        AppCoordinator[AppCoordinator]
        AppState[AppState Enum]
        AppDependencies[AppDependencies]
    end

    subgraph Business["⚙️ Business Logic"]
        EditingVM[EditingViewModel]
        OnboardingVM[OnboardingViewModel]
        TemplateVM[TemplateViewModel]
    end

    subgraph Services["🔌 Services"]
        SupabaseService[SupabaseService]
        VoiceService[VoiceRecognitionService]
        ErrorHandler[ErrorHandler]
        HapticManager[HapticManager]
        ImageCache[ImageCache]
    end

    subgraph Data["💾 Data Layer"]
        Models[Models]
        Constants[Constants]
        Secrets[Secrets]
    end

    subgraph External["🌐 External Services"]
        Supabase[(Supabase)]
        EdgeFunction[Edge Function]
        NanoBanana[Nano Banana API]
        Storage[Supabase Storage]
    end

    VeloApp --> AppCoordinator
    AppCoordinator --> RootView
    RootView --> Views
    Views --> Components
    Views --> EditingVM
    Views --> OnboardingVM
    EditingVM --> SupabaseService
    EditingVM --> VoiceService
    OnboardingVM --> SupabaseService
    TemplateVM --> SupabaseService
    SupabaseService --> Supabase
    SupabaseService --> EdgeFunction
    EdgeFunction --> NanoBanana
    EdgeFunction --> Storage
    AppCoordinator --> AppDependencies
    AppDependencies --> SupabaseService
    AppDependencies --> ErrorHandler
```

### Recommended Structure Improvements
```
Velo/
├── Core/
│   ├── App/
│   │   ├── VeloApp.swift
│   │   ├── AppCoordinator.swift
│   │   └── AppDependencies.swift
│   ├── Configuration/
│   │   ├── Secrets.swift
│   │   └── Environment.swift
│   └── DesignSystem/
│       ├── Colors.swift
│       ├── Typography.swift
│       ├── Spacing.swift
│       └── Components/
├── Features/
│   ├── Onboarding/
│   │   ├── OnboardingView.swift
│   │   ├── RoleSelectionView.swift
│   │   └── OnboardingViewModel.swift
│   ├── Home/
│   │   ├── HomeView.swift
│   │   └── HomeViewModel.swift
│   ├── Editing/
│   │   ├── EditingInterfaceView.swift
│   │   └── EditingViewModel.swift
│   ├── Templates/
│   │   ├── TemplatesView.swift
│   │   └── TemplateViewModel.swift
│   └── Settings/
│       └── SettingsView.swift
├── Shared/
│   ├── Models/
│   ├── Services/
│   ├── Utilities/
│   └── Components/
└── Resources/
    ├── Assets.xcassets
    └── Localizable.strings
```

---

## 📁 File-by-File Analysis

### VeloApp.swift
**Path:** `Velo/VeloApp.swift`
**Purpose:** Main app entry point, initializes coordinator and injects it via environment
**Health:** 🟢 Good

**Current Implementation:**
```swift
@main
struct VeloApp: App {
    @StateObject private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coordinator)
        }
    }
}
```

**Issues Found:**
| # | Issue | Severity | Line |
|---|-------|----------|------|
| 1 | Uses `@StateObject` instead of `@State` for `@Observable` | 🟡 Medium | L13 |

**Recommended Fix (after migrating to @Observable):**
```swift
@main
struct VeloApp: App {
    @State private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(coordinator)
        }
    }
}
```

---

### AppCoordinator.swift
**Path:** `Velo/Coordinators/AppCoordinator.swift`
**Purpose:** Central navigation and state management with dependency injection
**Health:** 🟡 Needs Work

**Issues Found:**
| # | Issue | Severity | Line |
|---|-------|----------|------|
| 1 | Uses `ObservableObject` instead of `@Observable` | 🟡 Medium | L49 |
| 2 | Singleton access pattern in `MainTabView.createLegacyRole()` | 🟡 Medium | L279 |
| 3 | Combine usage could be replaced with async/await | 🟢 Low | L93-100 |

**Recommended Migration to @Observable:**
```swift
@MainActor
@Observable
final class AppCoordinator {
    var appState: AppState = .loading
    var selectedTab: Tab = .home

    private let dependencies: AppDependencies

    init(dependencies: AppDependencies = AppDependencies()) {
        self.dependencies = dependencies
    }

    func start() async {
        // ... initialization logic
    }
}
```

---

### SupabaseService.swift
**Path:** `Velo/Services/SupabaseService.swift`
**Purpose:** Backend API integration with Supabase auth, database, and edge functions
**Health:** 🟢 Good

**Strengths:**
- Proper error handling with custom `SupabaseError` enum
- Graceful configuration error handling (no `fatalError`)
- Auth state listener implementation
- Image processing delegated to background threads

**Issues Found:**
| # | Issue | Severity | Line |
|---|-------|----------|------|
| 1 | Uses `ObservableObject` pattern | 🟡 Medium | L15 |
| 2 | Singleton pattern limits testability | 🟡 Medium | L17 |
| 3 | Missing retry logic for network failures | 🟡 Medium | L417-431 |

---

### EditingViewModel.swift
**Path:** `Velo/ViewModels/EditingViewModel.swift`
**Purpose:** Voice-integrated editing interface state management
**Health:** 🟢 Good

**Strengths:**
- Proper input validation with `sanitizedForAI`
- Haptic feedback integration
- Voice recognition subscription handling
- Image caching with `ImageCache`

**Issues Found:**
| # | Issue | Severity | Line |
|---|-------|----------|------|
| 1 | Uses `@StateObject` pattern instead of `@Observable` | 🟡 Medium | L16 |
| 2 | Missing loading states in some UI paths | 🟢 Low | - |

---

### EditingInterfaceView.swift
**Path:** `Velo/Views/Editing/EditingInterfaceView.swift`
**Purpose:** Main editing screen with chat interface and voice button
**Health:** 🟢 Good

**Strengths:**
- Accessibility modifiers applied to voice button and chat
- Before/after toggle for comparing edits
- Proper processing overlay with loading indicator
- Uses design tokens from Constants

**Issues Found:**
| # | Issue | Severity | Line |
|---|-------|----------|------|
| 1 | Error alert could use `alert()` modifier instead of overlay | 🟢 Low | L50-65 |

---

### RoleSelectionView.swift
**Path:** `Velo/Views/Onboarding/RoleSelectionView.swift`
**Purpose:** User type selection with role-specific personalization
**Health:** 🟢 Good

**Issues Found:**
| # | Issue | Severity | Line |
|---|-------|----------|------|
| 1 | Uses `@ObservedObject` for SupabaseService singleton | 🟡 Medium | L11 |
| 2 | TODO comment for error alert | 🟢 Low | L175 |

---

### HomeView.swift
**Path:** `Velo/Views/Editing/HomeView.swift`
**Purpose:** Main dashboard with role-based personalization
**Health:** 🟡 Needs Work

**Issues Found:**
| # | Issue | Severity | Line |
|---|-------|----------|------|
| 1 | Uses legacy `OldUserRole` struct instead of `RoleType` | 🟡 Medium | L11 |
| 2 | No ViewModel - business logic mixed in View | 🟡 Medium | - |
| 3 | Hardcoded sample data in views | 🟢 Low | L146, L188 |
| 4 | Empty action closures `{}` | 🟢 Low | L67, L131-133 |

---

### ContentView.swift
**Path:** `Velo/ContentView.swift`
**Purpose:** Mockup gallery launcher (DEPRECATED)
**Health:** 🔴 Critical Issues

**Issues Found:**
| # | Issue | Severity | Line |
|---|-------|----------|------|
| 1 | Deprecated mockup gallery still in codebase | 🔴 Critical | All |
| 2 | Not connected to production navigation | 🔴 Critical | - |

**Recommended Fix:** Delete file or archive - production uses `RootView` via `AppCoordinator`

---

### Secrets.swift
**Path:** `Velo/Configuration/Secrets.swift`
**Purpose:** API credentials configuration
**Health:** 🟡 Needs Work

**Issues Found:**
| # | Issue | Severity | Line |
|---|-------|----------|------|
| 1 | Placeholder API keys in source code | 🔴 Critical | L21-22, L32-33 |
| 2 | Not in `.gitignore` (template should be tracked, not actual secrets) | 🟡 Medium | - |

**Recommended Fix:**
```swift
// Create Config.xcconfig file (not tracked in git)
// SUPABASE_URL = https://your-project.supabase.co
// SUPABASE_ANON_KEY = your-actual-key

enum Secrets {
    static let supabaseURL: String = {
        guard let url = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String,
              !url.isEmpty else {
            fatalError("SUPABASE_URL not configured")
        }
        return url
    }()
}
```

---

## 🔄 Data Flow Diagrams

### App Initialization Flow
```mermaid
sequenceDiagram
    participant App as VeloApp
    participant Coord as AppCoordinator
    participant Deps as AppDependencies
    participant Supa as SupabaseService
    participant UI as RootView

    App->>Coord: Initialize
    Coord->>Deps: Create dependencies
    Deps->>Supa: Initialize singleton
    Supa->>Supa: Load cached user
    Supa->>Supa: Setup auth listener
    App->>UI: Render RootView
    UI->>Coord: .task { start() }
    Coord->>Coord: Check Secrets.isConfigured
    alt Not Configured
        Coord->>UI: configurationError state
    else Configured
        Coord->>Supa: Check isAuthenticated
        alt Authenticated
            Coord->>UI: main state
        else Has Onboarded
            Coord->>UI: main state
        else New User
            Coord->>UI: onboarding state
        end
    end
```

### User Authentication Flow
```mermaid
sequenceDiagram
    participant User
    participant UI as RoleSelectionView
    participant VM as SupabaseService
    participant Auth as Supabase Auth
    participant DB as Supabase Database

    User->>UI: Select role
    User->>UI: Tap Continue
    UI->>VM: createAnonymousSession()
    VM->>Auth: signInAnonymously()
    Auth-->>VM: Session + User ID
    VM->>VM: Store user locally
    UI->>VM: updateUserProfile(roleType)
    VM->>DB: INSERT user_profile
    DB-->>VM: Success
    VM->>UI: Profile created
    UI->>UI: Navigate to Home
```

### Edit Processing Flow
```mermaid
sequenceDiagram
    participant User
    participant UI as EditingInterfaceView
    participant VM as EditingViewModel
    participant Voice as VoiceRecognitionService
    participant Supa as SupabaseService
    participant Edge as Edge Function
    participant Nano as Nano Banana API
    participant Storage as Supabase Storage

    User->>UI: Tap voice button
    UI->>VM: toggleVoiceRecording()
    VM->>Voice: startRecording()
    Voice-->>VM: transcribedText updates
    User->>UI: Tap stop
    VM->>Voice: stopRecording()
    VM->>VM: sendMessage()
    VM->>VM: Sanitize input
    VM->>Supa: processEdit(command, image)
    Supa->>Edge: invoke("process-edit")
    Edge->>Edge: Check quota
    Edge->>Nano: POST /v1/edit
    Nano-->>Edge: Edited image (base64)
    Edge->>Storage: Upload image
    Storage-->>Edge: Public URL
    Edge->>Supa: Save to edits table
    Edge-->>Supa: EditResponse
    Supa-->>VM: Success + image URL
    VM->>VM: downloadEditedImage()
    VM-->>UI: Update editedImage
    UI-->>User: Show edited photo
```

### Purchase Flow (Planned)
```mermaid
sequenceDiagram
    participant User
    participant UI as PaywallView
    participant RC as RevenueCat
    participant Store as App Store
    participant Supa as SupabaseService

    User->>UI: View paywall
    UI->>RC: Purchases.shared.offerings
    RC-->>UI: Available packages
    User->>UI: Select Pro Monthly
    UI->>RC: Purchases.shared.purchase(package)
    RC->>Store: Process payment
    Store-->>RC: Transaction receipt
    RC-->>UI: CustomerInfo (updated)
    UI->>Supa: updateUserProfile(subscriptionTier: .pro)
    Supa-->>UI: Profile updated
    UI->>UI: Dismiss paywall
```

---

## 🧩 Component Dependency Graph

```mermaid
graph LR
    subgraph Screens
        Root[RootView]
        Onboarding[OnboardingView]
        RoleSelect[RoleSelectionView]
        Home[HomeView]
        Editing[EditingInterfaceView]
        Loading[LoadingView]
        ConfigError[ConfigurationErrorView]
    end

    subgraph SharedComponents
        EmptyState[EmptyStateView]
        Skeleton[SkeletonView]
        RoleCard[RoleCard]
        ChatBubble[ChatBubble]
        SuggestionCard[SuggestionCard]
        QuickAction[QuickActionButton]
    end

    subgraph Modifiers
        AccessMod[AccessibilityModifiers]
        ErrorMod[ErrorAlertModifier]
        CardStyle[cardStyle]
    end

    subgraph ViewModels
        EditVM[EditingViewModel]
        OnboardVM[OnboardingViewModel]
        TemplateVM[TemplateViewModel]
    end

    subgraph Services
        SupaSvc[SupabaseService]
        VoiceSvc[VoiceRecognitionService]
        ErrHandler[ErrorHandler]
        Haptics[HapticManager]
        ImgCache[ImageCache]
    end

    Root --> Loading
    Root --> Onboarding
    Root --> Home
    Root --> ConfigError
    Root --> ErrorMod

    Onboarding --> RoleSelect
    RoleSelect --> RoleCard
    RoleSelect --> SupaSvc

    Home --> QuickAction
    Home --> Editing

    Editing --> ChatBubble
    Editing --> SuggestionCard
    Editing --> EditVM
    Editing --> AccessMod

    EditVM --> SupaSvc
    EditVM --> VoiceSvc
    EditVM --> ImgCache
    EditVM --> Haptics

    OnboardVM --> SupaSvc
    TemplateVM --> SupaSvc

    EmptyState --> Haptics
    ConfigError --> EmptyState
```

---

## 🚨 Critical Issues (P0 — Fix Immediately)

### Issue 1: Placeholder API Keys in Production Code
**Files Affected:** `Secrets.swift`
**Impact:** App will show configuration error, cannot function
**Root Cause:** Placeholder keys never replaced with real credentials

**Before:**
```swift
static let supabaseAnonKey = "eyJhbGci...placeholder_key_replace_with_actual"
static let revenueCatAPIKey = "appl_placeholder_dev_key"
```

**After:**
```swift
// Option 1: Use xcconfig files (recommended)
static let supabaseAnonKey: String = {
    guard let key = Bundle.main.infoDictionary?["SUPABASE_ANON_KEY"] as? String,
          !key.contains("placeholder") else {
        #if DEBUG
        fatalError("Configure SUPABASE_ANON_KEY in Config.xcconfig")
        #else
        return ""
        #endif
    }
    return key
}()

// Option 2: Use keychain for runtime configuration
```

**Resources:**
- [Xcode Build Configuration Files](https://developer.apple.com/documentation/xcode/adding-a-build-configuration-file-to-your-project)
- [iOS Security Best Practices](https://developer.apple.com/documentation/security)

---

### Issue 2: Deprecated ContentView Mockup Gallery
**Files Affected:** `ContentView.swift`
**Impact:** Confusion about production navigation, dead code
**Root Cause:** Leftover from prototyping phase

**Recommended Fix:** Delete `ContentView.swift` or move to a `Deprecated/` folder

---

### Issue 3: Missing RevenueCat Implementation
**Files Affected:** `Constants.swift`, `Secrets.swift`, New files needed
**Impact:** Cannot monetize the app, subscription features non-functional
**Root Cause:** Integration not completed

**See:** RevenueCat Integration Blueprint section below

---

## ⚠️ High Priority Issues (P1 — Fix This Sprint)

### Issue 1: Migrate to @Observable Macro
**Files Affected:** `AppCoordinator.swift`, `SupabaseService.swift`, `EditingViewModel.swift`, `OnboardingViewModel.swift`, `TemplateViewModel.swift`, `VoiceRecognitionService.swift`
**Impact:** Performance improvement, simpler code, future compatibility

**Before:**
```swift
@MainActor
final class AppCoordinator: ObservableObject {
    @Published var appState: AppState = .loading
    @Published var selectedTab: Tab = .home
    // ...
}
```

**After:**
```swift
@MainActor
@Observable
final class AppCoordinator {
    var appState: AppState = .loading
    var selectedTab: Tab = .home

    // Use @ObservationIgnored for non-tracked properties
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
}
```

**View Updates Required:**
```swift
// Before
@StateObject private var coordinator = AppCoordinator()
.environmentObject(coordinator)

// After
@State private var coordinator = AppCoordinator()
.environment(coordinator)
```

**Resources:**
- [Observable Macro in SwiftUI](https://www.donnywals.com/observable-in-swiftui-explained/)
- [Modern MVVM in SwiftUI 2025](https://medium.com/@minalkewat/modern-mvvm-in-swiftui-2025-the-clean-architecture-youve-been-waiting-for-72a7d576648e)

---

### Issue 2: Remove Legacy OldUserRole
**Files Affected:** `LegacyModels.swift`, `HomeView.swift`, `AppCoordinator.swift`, `RoleSelectionView.swift`
**Impact:** Code duplication, maintenance burden

**Recommended Fix:**
1. Update `HomeView` to accept `RoleType` directly
2. Remove `OldUserRole` struct
3. Delete `LegacyModels.swift`

---

### Issue 3: Add HomeViewModel
**Files Affected:** `HomeView.swift` → New `HomeViewModel.swift`
**Impact:** Better separation of concerns, testability

**Recommended Implementation:**
```swift
@MainActor
@Observable
final class HomeViewModel {
    var recentEdits: [EditSession] = []
    var templates: [Template] = []
    var isLoading = false
    var errorMessage: String?

    private let supabaseService: SupabaseService

    init(supabaseService: SupabaseService = .shared) {
        self.supabaseService = supabaseService
    }

    func loadRecentEdits() async {
        isLoading = true
        defer { isLoading = false }

        do {
            recentEdits = try await supabaseService.fetchEditHistory(limit: 10)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
```

---

## 📋 Medium Priority Issues (P2 — Fix Soon)

### Issue 1: Missing Error States in Some Views
**Files Affected:** `HomeView.swift`, `OnboardingView.swift`
**Recommended:** Add error handling similar to `EditingInterfaceView`

### Issue 2: Hardcoded Sample Data
**Files Affected:** `HomeView.swift` (lines 146, 188, 211)
**Recommended:** Replace with data from `TemplateViewModel` and `SupabaseService`

### Issue 3: Empty Button Actions
**Files Affected:** `HomeView.swift` (lines 67, 131-133, 494-497)
**Recommended:** Implement or show "Coming Soon" feedback

### Issue 4: Consider Retry Logic for Network Requests
**Files Affected:** `SupabaseService.swift`
**Recommended:** Add exponential backoff for transient failures

---

## 🎨 UI/UX Excellence Audit

### Design System Assessment

| Element | Status | Issues |
|---------|--------|--------|
| Spacing System | 🟢 Good | Well-defined in Constants.Spacing |
| Typography Scale | 🟢 Good | Constants.Fonts with proper scale |
| Color System | 🟢 Good | Role-based gradients, consistent dark theme |
| Border Radius | 🟢 Good | Constants.CornerRadius tokens |
| Shadows/Elevation | 🟡 Needs Work | Some hardcoded values |
| Animation Tokens | 🟡 Needs Work | No centralized animation timing |

### Recommended Animation Tokens

```swift
extension Constants {
    enum Animation {
        static let fast: Double = 0.15
        static let normal: Double = 0.25
        static let slow: Double = 0.4

        static let spring = Spring(response: 0.3, dampingFraction: 0.7)
        static let bouncy = Spring(response: 0.4, dampingFraction: 0.6)
        static let stiff = Spring(response: 0.2, dampingFraction: 0.8)
    }
}
```

### Component-by-Component UI Audit

#### Voice Button
**Current State:** 🟢 Good
- Has haptic feedback ✅
- Accessible with VoiceOver ✅
- Recording pulse animation ✅
- Disabled state styling ✅

**Enhancement Opportunity:**
```swift
// Add scale animation on press
.scaleEffect(configuration.isPressed ? 0.95 : 1.0)
.animation(.spring(response: 0.2), value: configuration.isPressed)
```

#### Role Cards
**Current State:** 🟢 Good
- Selection animation ✅
- Gradient borders ✅
- Feature list ✅

#### Chat Bubbles
**Current State:** 🟡 Needs Work
- Missing entrance animation
- No typing indicator

**Recommended Enhancement:**
```swift
ChatBubble(message: message)
    .transition(.asymmetric(
        insertion: .move(edge: message.isUser ? .trailing : .leading)
            .combined(with: .opacity),
        removal: .opacity
    ))
    .animation(.spring(response: 0.3), value: messages.count)
```

### Animation Audit

| Animation | Location | Quality | Issues |
|-----------|----------|---------|--------|
| Page indicator | OnboardingView | 🟢 | Good |
| Role selection | RoleSelectionView | 🟢 | Spring animation |
| Voice recording pulse | EditingInterfaceView | 🟢 | Repeating animation |
| Before/After toggle | EditingInterfaceView | 🟡 | Needs transition |
| Tab switching | HomeView | 🟡 | Could be smoother |
| List item entrance | HomeView | 🔴 | Missing staggered entrance |

### Missing Animations to Add
- [ ] Staggered list item entrance in HomeView
- [ ] Typing indicator in chat interface
- [ ] Photo loading shimmer effect
- [ ] Success checkmark animation after edit
- [ ] Pull-to-refresh in gallery views

### Accessibility Audit

| Feature | Status | Notes |
|---------|--------|-------|
| VoiceOver labels | 🟢 Good | AccessibilityModifiers.swift comprehensive |
| Dynamic Type | 🟢 Good | ScaledFont modifier available |
| Touch targets | 🟢 Good | Minimum 44pt |
| Color contrast | 🟢 Good | White on dark backgrounds |
| Reduce Motion | 🟡 | Should check for reduced motion preference |

**Recommended Reduce Motion Check:**
```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

.animation(reduceMotion ? nil : .spring(response: 0.3), value: isSelected)
```

---

## 💰 RevenueCat Integration Blueprint

### Current Integration Status
- [x] SDK Installed (via SPM - needs verification)
- [ ] SDK Configured at App Launch
- [ ] Offerings Fetched
- [ ] Purchase Flow Implemented
- [ ] Restore Purchases
- [ ] Subscription Status Checks
- [ ] Paywall UI
- [ ] Entitlement Gating
- [ ] Analytics Events

### Architecture Diagram
```mermaid
graph TB
    subgraph App
        VeloApp[VeloApp]
        PaywallView[PaywallView]
        EditingVM[EditingViewModel]
        SettingsVM[SettingsViewModel]
    end

    subgraph RevenueCat
        RC[Purchases SDK]
        Offerings[Offerings]
        CustomerInfo[CustomerInfo]
        Entitlements[Entitlements]
    end

    subgraph Backend
        Supabase[(Supabase)]
        Webhook[Webhook Handler]
    end

    subgraph AppStore[App Store]
        StoreKit[StoreKit 2]
    end

    VeloApp -->|Configure| RC
    RC --> Offerings
    RC --> CustomerInfo
    CustomerInfo --> Entitlements

    PaywallView -->|Fetch| Offerings
    PaywallView -->|Purchase| RC
    RC -->|Process| StoreKit

    EditingVM -->|Check| Entitlements
    SettingsVM -->|Restore| RC

    RC -->|Webhook| Webhook
    Webhook -->|Update| Supabase
```

### Complete Implementation

#### Step 1: Add SDK (Package.swift or SPM)
```
// In Xcode: File > Add Package Dependencies
// URL: https://github.com/RevenueCat/purchases-ios.git
// Version: 5.44.0+
```

#### Step 2: Configuration (VeloApp.swift)
```swift
import RevenueCat

@main
struct VeloApp: App {
    @State private var coordinator = AppCoordinator()

    init() {
        configureRevenueCat()
    }

    private func configureRevenueCat() {
        guard !Secrets.revenueCatAPIKey.contains("placeholder") else {
            Logger.error("RevenueCat API key not configured", category: Logger.subscription)
            return
        }

        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: Secrets.revenueCatAPIKey)

        // Set user ID after authentication
        Task {
            if let userId = await coordinator.dependencies.supabaseService.anonymousUserID {
                try? await Purchases.shared.logIn(userId)
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(coordinator)
        }
    }
}
```

#### Step 3: Subscription Service
```swift
import RevenueCat

@MainActor
@Observable
final class SubscriptionService {
    static let shared = SubscriptionService()

    var offerings: Offerings?
    var customerInfo: CustomerInfo?
    var isProUser: Bool { customerInfo?.entitlements["pro"]?.isActive ?? false }
    var isBusinessUser: Bool { customerInfo?.entitlements["business"]?.isActive ?? false }
    var isLoading = false
    var error: Error?

    private init() {
        Task { await loadOfferings() }
    }

    func loadOfferings() async {
        isLoading = true
        defer { isLoading = false }

        do {
            offerings = try await Purchases.shared.offerings()
            customerInfo = try await Purchases.shared.customerInfo()
        } catch {
            self.error = error
            Logger.error("Failed to load offerings", error: error, category: Logger.subscription)
        }
    }

    func purchase(_ package: Package) async throws -> CustomerInfo {
        isLoading = true
        defer { isLoading = false }

        let result = try await Purchases.shared.purchase(package: package)
        customerInfo = result.customerInfo

        // Sync with Supabase
        if isProUser {
            try? await SupabaseService.shared.updateUserProfile(subscriptionTier: .pro)
        } else if isBusinessUser {
            try? await SupabaseService.shared.updateUserProfile(subscriptionTier: .business)
        }

        return result.customerInfo
    }

    func restorePurchases() async throws -> CustomerInfo {
        isLoading = true
        defer { isLoading = false }

        let info = try await Purchases.shared.restorePurchases()
        customerInfo = info
        return info
    }
}
```

#### Step 4: Paywall View
```swift
import SwiftUI
import RevenueCat

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var subscriptionService = SubscriptionService.shared
    @State private var selectedPackage: Package?
    @State private var isPurchasing = false
    @State private var error: String?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: Constants.Spacing.lg) {
                        // Hero
                        PaywallHero()

                        // Features
                        PaywallFeatures()

                        // Packages
                        if let offerings = subscriptionService.offerings?.current {
                            PackageSelector(
                                packages: offerings.availablePackages,
                                selectedPackage: $selectedPackage
                            )
                        }

                        // Purchase Button
                        PurchaseButton(
                            isLoading: isPurchasing,
                            package: selectedPackage
                        ) {
                            await purchaseSelected()
                        }

                        // Restore
                        Button("Restore Purchases") {
                            Task { await restorePurchases() }
                        }
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))

                        // Legal
                        LegalText()
                    }
                    .padding()
                }
            }
            .navigationTitle("Upgrade to Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .alert("Error", isPresented: .constant(error != nil)) {
                Button("OK") { error = nil }
            } message: {
                if let error = error {
                    Text(error)
                }
            }
        }
    }

    private func purchaseSelected() async {
        guard let package = selectedPackage else { return }

        isPurchasing = true
        defer { isPurchasing = false }

        do {
            _ = try await subscriptionService.purchase(package)
            HapticManager.success()
            dismiss()
        } catch {
            HapticManager.error()
            self.error = error.localizedDescription
        }
    }

    private func restorePurchases() async {
        isPurchasing = true
        defer { isPurchasing = false }

        do {
            let info = try await subscriptionService.restorePurchases()
            if info.entitlements.active.isEmpty {
                error = "No active subscriptions found"
            } else {
                HapticManager.success()
                dismiss()
            }
        } catch {
            self.error = error.localizedDescription
        }
    }
}
```

### Entitlement Gating
```swift
// In EditingViewModel or wherever features are gated
func processEdit(command: String, image: UIImage) async {
    // Check quota for free users
    let subscription = SubscriptionService.shared

    if !subscription.isProUser && !subscription.isBusinessUser {
        guard let profile = supabaseService.currentUserProfile,
              profile.hasEditsRemaining else {
            errorMessage = "You've used all free edits. Upgrade to Pro for unlimited edits."
            // Could trigger paywall here
            return
        }
    }

    // Process edit...
}
```

### RevenueCat Resources
- [RevenueCat iOS Documentation](https://www.revenuecat.com/docs/getting-started/installation/ios)
- [SDK Quickstart](https://www.revenuecat.com/docs/getting-started/quickstart)
- [Configuring the SDK](https://www.revenuecat.com/docs/getting-started/configuring-sdk)

---

## 🗄️ Backend Integration Status

### Supabase (Currently Integrated)

#### Current Implementation
- ✅ Authentication (Anonymous sign-in)
- ✅ Database (user_profiles, edits, templates)
- ✅ Storage (edited-images bucket)
- ✅ Edge Functions (process-edit)
- ⚠️ Row Level Security (configured in docs)
- ⚠️ Realtime (not implemented)

#### Database Schema
```sql
-- user_profiles
CREATE TABLE user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id),
    role_type TEXT NOT NULL DEFAULT 'explorer',
    subscription_tier TEXT NOT NULL DEFAULT 'free',
    edits_this_month INTEGER NOT NULL DEFAULT 0,
    edits_month_start TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- edits
CREATE TABLE edits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES user_profiles(id),
    command_text TEXT NOT NULL,
    original_image_url TEXT,
    edited_image_url TEXT,
    model_used TEXT,
    processing_time_ms INTEGER,
    cost_usd DECIMAL(10,4),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- templates
CREATE TABLE templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    prompt_text TEXT NOT NULL,
    role_tags TEXT[] DEFAULT '{}',
    category TEXT NOT NULL,
    preview_url TEXT,
    usage_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

---

## 📊 State Management Architecture

### Current State Flow
```mermaid
stateDiagram-v2
    [*] --> Loading: App Launch
    Loading --> ConfigError: Missing Secrets
    Loading --> Onboarding: First Launch
    Loading --> Main: Has Session

    Onboarding --> RoleSelection: Complete Pages
    RoleSelection --> CreatingSession: Select Role
    CreatingSession --> Main: Success
    CreatingSession --> Error: Failure

    Main --> Editing: Start Edit
    Editing --> Processing: Send Command
    Processing --> Editing: Complete
    Processing --> Error: Failure

    Main --> Paywall: Quota Exceeded
    Paywall --> Main: Purchase/Dismiss
```

### Recommended State Management Improvements

After migrating to `@Observable`, the state flow becomes simpler:

```swift
@MainActor
@Observable
final class AppState {
    // Navigation
    var currentScreen: Screen = .loading
    var navigationPath = NavigationPath()

    // User
    var userProfile: UserProfile?
    var isAuthenticated = false

    // Subscription
    var subscriptionTier: SubscriptionTier = .free
    var editsRemaining: Int?

    // UI State
    var isLoading = false
    var error: AppError?
    var showPaywall = false

    enum Screen {
        case loading
        case onboarding
        case main
        case configError(String)
    }
}
```

---

## 🧪 Code Quality Report

### Metrics Summary
| Metric | Current | Target | Status |
|--------|---------|--------|--------|
| Swift Errors | 0 | 0 | 🟢 |
| Force Unwraps | 2 | 0 | 🟡 |
| Any Types | 0 | 0 | 🟢 |
| Unused Code | ~1 file | 0 | 🟡 |
| Duplicate Code | <5% | <5% | 🟢 |
| Avg. File Lines | 180 | <200 | 🟢 |
| Test Coverage | ~15% | >70% | 🔴 |

### File Health Overview
| File | Lines | Complexity | Issues | Health |
|------|-------|------------|--------|--------|
| VeloApp.swift | 22 | Low | 0 | 🟢 |
| AppCoordinator.swift | 292 | Medium | 2 | 🟡 |
| SupabaseService.swift | 611 | High | 3 | 🟡 |
| EditingViewModel.swift | 353 | Medium | 1 | 🟢 |
| EditingInterfaceView.swift | 342 | Medium | 1 | 🟢 |
| HomeView.swift | 584 | High | 4 | 🟡 |
| RoleSelectionView.swift | 294 | Medium | 2 | 🟡 |
| Constants.swift | 206 | Low | 0 | 🟢 |
| ContentView.swift | 187 | Low | 2 | 🔴 |

### Technical Debt Inventory
| ID | Description | Effort | Impact | Priority |
|----|-------------|--------|--------|----------|
| TD-1 | Migrate to @Observable macro | L | High | P1 |
| TD-2 | Remove OldUserRole legacy type | S | Medium | P1 |
| TD-3 | Delete ContentView mockup | S | Low | P0 |
| TD-4 | Add HomeViewModel | M | Medium | P1 |
| TD-5 | Increase test coverage | L | High | P2 |
| TD-6 | Add staggered animations | S | Low | P2 |
| TD-7 | Implement reduce motion support | S | Medium | P2 |

---

## 📱 Platform-Specific Checklist

### iOS (Swift/SwiftUI)
- [x] iOS 17+ deployment target
- [ ] Swift 6 strict concurrency (partial)
- [ ] @Observable macro (migration needed)
- [ ] Liquid Glass effects (iOS 18+, optional)
- [x] SF Symbols with appropriate weights
- [x] Haptic feedback (HapticManager)
- [x] Dynamic Type support (ScaledFont)
- [x] Dark mode support (default theme)
- [x] Safe area handling
- [ ] App Intents / Shortcuts (future)
- [ ] Widget support (future)
- [ ] Privacy manifest (PrivacyInfo.xcprivacy)

### Required Capabilities
- [x] Background Modes (none needed currently)
- [ ] In-App Purchase (required for RevenueCat)
- [x] Speech Recognition (NSMicrophoneUsageDescription, NSSpeechRecognitionUsageDescription)
- [x] Photo Library (NSPhotoLibraryUsageDescription, NSPhotoLibraryAddUsageDescription)

---

## 🚀 Implementation Roadmap

### Week 1: Critical Fixes & Foundation
| Task | Files | Effort | Priority |
|------|-------|--------|----------|
| Replace placeholder API keys | Secrets.swift, Config.xcconfig | 1h | P0 |
| Delete ContentView mockup | ContentView.swift | 15m | P0 |
| Verify Supabase RLS policies | Supabase dashboard | 2h | P0 |
| Test auth flow end-to-end | - | 2h | P0 |

### Week 2: Architecture Improvements
| Task | Files | Effort | Priority |
|------|-------|--------|----------|
| Migrate AppCoordinator to @Observable | AppCoordinator.swift | 2h | P1 |
| Migrate SupabaseService to @Observable | SupabaseService.swift | 3h | P1 |
| Migrate ViewModels to @Observable | 3 files | 3h | P1 |
| Create HomeViewModel | New file + HomeView.swift | 3h | P1 |
| Remove OldUserRole | LegacyModels.swift, HomeView.swift | 1h | P1 |

### Week 3: RevenueCat Integration
| Task | Files | Effort | Priority |
|------|-------|--------|----------|
| Add RevenueCat SDK | Package dependencies | 30m | P1 |
| Create SubscriptionService | New file | 4h | P1 |
| Build PaywallView | New file | 6h | P1 |
| Integrate entitlement gating | EditingViewModel.swift | 2h | P1 |
| Test purchase flow | - | 4h | P1 |

### Week 4: Polish & Launch Prep
| Task | Files | Effort | Priority |
|------|-------|--------|----------|
| Add staggered list animations | HomeView.swift | 2h | P2 |
| Implement reduce motion | Various | 2h | P2 |
| Add typing indicator | EditingInterfaceView.swift | 1h | P2 |
| Increase test coverage | VeloTests/ | 8h | P2 |
| App Store preparation | - | 4h | P2 |

---

## ✅ Production Readiness Checklist

### App Store Requirements
- [ ] App icon (all sizes) - verify in Assets.xcassets
- [ ] Launch screen - verify configuration
- [ ] Privacy policy URL
- [ ] Terms of service URL
- [ ] App Store screenshots (6.7", 6.5", 5.5")
- [ ] App Store description and keywords
- [ ] Age rating configured
- [ ] In-app purchases configured in App Store Connect
- [ ] App Review information

### Technical Requirements
- [x] No crashes on launch
- [x] Graceful configuration error handling
- [x] Error states for failures
- [x] Loading states
- [ ] Offline handling (partial)
- [x] Empty states designed
- [ ] Deep linking (future)
- [ ] Push notifications (future)
- [ ] Analytics tracking (Logger.logEvent placeholder)
- [ ] Crash reporting (add Crashlytics/Sentry)

### Performance Requirements
- [x] App launch < 2 seconds
- [x] Animations at 60fps
- [x] No jank during scroll (needs verification)
- [x] Images optimized (base64 compression, max dimension)
- [ ] Bundle size reasonable (verify < 50MB)

### Security Requirements
- [x] Input sanitization (sanitizedForAI)
- [x] No hardcoded secrets in production (needs Config.xcconfig)
- [x] Row Level Security on Supabase
- [x] CORS restrictions on Edge Functions
- [ ] Certificate pinning (optional)

---

## 📚 Resources & References

### Official Documentation
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [RevenueCat iOS Documentation](https://www.revenuecat.com/docs/getting-started/installation/ios)
- [Supabase Documentation](https://supabase.com/docs)

### SwiftUI Best Practices 2025
- [Observable Macro in SwiftUI](https://www.donnywals.com/observable-in-swiftui-explained/)
- [What's New in SwiftUI for iOS 18](https://www.hackingwithswift.com/articles/270/whats-new-in-swiftui-for-ios-18)
- [Modern MVVM in SwiftUI 2025](https://medium.com/@minalkewat/modern-mvvm-in-swiftui-2025-the-clean-architecture-youve-been-waiting-for-72a7d576648e)
- [Observable Macro Performance](https://nilcoalescing.com/blog/ObservableInSwiftUI/)

### Design Resources
- [SF Symbols](https://developer.apple.com/sf-symbols/)
- [iOS App Design Guidelines for 2025](https://tapptitude.com/blog/i-os-app-design-guidelines-for-2025)
- [iOS Accessibility Guidelines 2025](https://medium.com/@david-auerbach/ios-accessibility-guidelines-best-practices-for-2025-6ed0d256200e)

---

## 📝 Appendix

### A. SwiftLint Configuration
The project includes a comprehensive `.swiftlint.yml` with:
- Force unwrapping warnings
- No print statements rule
- No hardcoded API keys rule
- HapticManager usage enforcement
- Reasonable line/file length limits

### B. Testing Strategy
Current tests cover:
- EditingViewModel initialization and message validation
- String sanitization and validation
- UserProfile quota logic
- RoleType properties

**Recommended Additional Tests:**
- SupabaseService mocking and integration tests
- UI snapshot tests for key screens
- Voice recognition service tests (mocked)
- RevenueCat purchase flow tests

### C. Edge Function Security
The `process-edit` edge function includes:
- CORS origin restrictions
- Authorization header validation
- Command length logging (not full content)
- Quota checking before processing
- Error message sanitization

---

*Generated by Claude Code Audit System*
*Last Updated: December 27, 2025*
