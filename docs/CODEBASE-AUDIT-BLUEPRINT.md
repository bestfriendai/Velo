# Velo Codebase Improvement Blueprint

> **Generated:** December 2025
> **Platform Detected:** iOS 16+ (Swift/SwiftUI)
> **App Category:** Voice-First AI Photo Editing
> **Current Phase:** Prototype/MVP
> **Health Score:** 62/100

---

## Executive Summary

Velo is a well-conceived voice-first photo editing app with solid foundational architecture. The codebase demonstrates good separation of concerns with MVVM patterns, proper use of SwiftUI, and a well-designed Supabase backend. However, several areas require attention before production deployment:

**Critical Findings:**
1. **Security:** API credentials loaded from environment variables at runtime may fail in production iOS builds
2. **Architecture:** Legacy model (`OldUserRole`) creates technical debt and type confusion
3. **Error Handling:** Inconsistent error handling patterns across services
4. **Testing:** Zero test coverage - no unit, integration, or UI tests
5. **Accessibility:** Missing VoiceOver support, dynamic type, and accessibility labels

**Strengths:**
- Clean MVVM architecture with proper separation
- Well-documented codebase with comprehensive inline comments
- Robust Supabase integration with RLS policies
- Good use of Swift Combine for reactive programming
- Comprehensive logging infrastructure

---

## Table of Contents

1. [Critical Issues (P0)](#critical-issues-p0)
2. [High Priority Issues (P1)](#high-priority-issues-p1)
3. [Architecture Improvements](#architecture-improvements)
4. [Code Quality Issues](#code-quality-issues)
5. [UI/UX Enhancements](#uiux-enhancements)
6. [Performance Optimizations](#performance-optimizations)
7. [Security Hardening](#security-hardening)
8. [Testing Strategy](#testing-strategy)
9. [CI/CD Recommendations](#cicd-recommendations)
10. [Production Readiness Checklist](#production-readiness-checklist)

---

## Critical Issues (P0)

### P0-1: API Credentials Configuration Failure Risk

**File:** `Velo/Utilities/Constants.swift:15-16`

**Problem:** Environment variables via `ProcessInfo.processInfo.environment` don't work in production iOS apps - they only work in Xcode debug schemes.

```swift
// ❌ CURRENT (Constants.swift:15-16)
static let supabaseURL = ProcessInfo.processInfo.environment["SUPABASE_URL"] ?? ""
static let supabaseAnonKey = ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"] ?? ""
```

**Impact:** App will crash or fail silently in TestFlight/App Store builds.

**Solution:** Use a secure configuration approach:

```swift
// ✅ RECOMMENDED - Create Secrets.swift (add to .gitignore)
// Velo/Configuration/Secrets.swift
enum Secrets {
    // These are compile-time constants, safe for anon key (not secret)
    #if DEBUG
    static let supabaseURL = "https://your-dev-project.supabase.co"
    static let supabaseAnonKey = "eyJ..."
    #else
    static let supabaseURL = "https://your-prod-project.supabase.co"
    static let supabaseAnonKey = "eyJ..."
    #endif
}

// For truly sensitive keys, use Keychain or fetch from secure backend
// Never embed API keys that grant write access in client apps
```

**Alternative:** Use `.xcconfig` files for build-time configuration:

```
// Debug.xcconfig
SUPABASE_URL = https://dev-project.supabase.co
SUPABASE_ANON_KEY = eyJ...

// Release.xcconfig
SUPABASE_URL = https://prod-project.supabase.co
SUPABASE_ANON_KEY = eyJ...
```

**Resources:**
- [Apple: Managing Configuration](https://developer.apple.com/documentation/xcode/adding-a-build-configuration-file-to-your-project)
- [NSHipster: Xcode Build Configuration Files](https://nshipster.com/xcconfig/)

---

### P0-2: Fatal Error on Missing Credentials

**File:** `Velo/Services/SupabaseService.swift:34`

**Problem:** `fatalError()` will crash the app if credentials are missing.

```swift
// ❌ CURRENT (SupabaseService.swift:34)
fatalError("Supabase credentials missing. Check environment variables.")
```

**Impact:** App crashes instead of graceful degradation.

**Solution:** Handle gracefully with user feedback:

```swift
// ✅ RECOMMENDED
private init() {
    guard let url = URL(string: Constants.API.supabaseURL),
          !Constants.API.supabaseAnonKey.isEmpty else {
        Logger.fault("Supabase credentials not configured", category: Logger.network)
        // Set a flag to show error state in UI
        self.configurationError = true
        self.supabase = nil
        return
    }

    self.supabase = SupabaseClient(
        supabaseURL: url,
        supabaseKey: Constants.API.supabaseAnonKey
    )
    self.configurationError = false
}

// Add published property for UI to observe
@Published var configurationError = false
```

---

### P0-3: Singleton with @MainActor May Cause Deadlocks

**File:** `Velo/Services/SupabaseService.swift:17`

**Problem:** Accessing `SupabaseService.shared` from a background thread while `@MainActor` is blocked can cause deadlocks.

```swift
// ❌ CURRENT
@MainActor
class SupabaseService: ObservableObject {
    static let shared = SupabaseService()
```

**Solution:** Use a proper dependency injection pattern:

```swift
// ✅ RECOMMENDED - Dependency Container
@MainActor
final class AppDependencies: ObservableObject {
    let supabaseService: SupabaseService
    let voiceService: VoiceRecognitionService

    init() {
        self.supabaseService = SupabaseService()
        self.voiceService = VoiceRecognitionService()
    }
}

// In VeloApp.swift
@main
struct VeloApp: App {
    @StateObject private var dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dependencies.supabaseService)
                .environmentObject(dependencies.voiceService)
        }
    }
}
```

**Resources:**
- [Swift Concurrency: MainActor](https://developer.apple.com/documentation/swift/mainactor)
- [Dependency Injection in SwiftUI](https://www.swiftbysundell.com/articles/dependency-injection-in-swiftui/)

---

## High Priority Issues (P1)

### P1-1: Legacy Model Creates Type Confusion

**File:** `Velo/Models/LegacyModels.swift`

**Problem:** `OldUserRole` struct duplicates functionality of `RoleType` enum, causing confusion and maintenance burden.

```swift
// ❌ CURRENT - Two different role representations
struct OldUserRole: Identifiable {
    let id: String
    let icon: String
    let title: String
    let description: String
    let features: [String]
    let gradient: [Color]
}

// Also exists:
enum RoleType: String, Codable, CaseIterable { ... }
```

**Used in:** `ContentView.swift:99-106`, `RoleSelectionView.swift:135-143`, `HomeView.swift:11`

**Solution:** Remove `OldUserRole` and extend `RoleType`:

```swift
// ✅ RECOMMENDED - Extend RoleType with computed properties
extension RoleType {
    var gradient: [Color] {
        switch self {
        case .parent: return [.blue, .cyan]
        case .salon: return [.purple, .pink]
        case .realtor: return [.green, .mint]
        case .business: return [.orange, .red]
        case .explorer: return [.pink, .purple]
        }
    }

    var features: [String] {
        switch self {
        case .parent: return ["Fix closed eyes", "Group photo touch-ups", "Event highlights"]
        case .salon: return ["Before/after transformations", "Professional lighting", "Brand logo placement"]
        case .realtor: return ["Property enhancement", "Batch processing", "Sky replacement"]
        case .business: return ["Product photos", "Social media ready", "Brand consistency"]
        case .explorer: return ["Creative filters", "Quick enhancements", "Easy sharing"]
        }
    }
}

// Update HomeView to accept RoleType directly
struct HomeView: View {
    let userRole: RoleType  // Changed from OldUserRole
    // ...
}
```

---

### P1-2: Inconsistent Error Handling Patterns

**Problem:** Error handling varies across the codebase - some places throw, some log and ignore, some use optionals.

**Examples:**

```swift
// SupabaseService.swift:233-236 - Silently ignores errors
} catch {
    Logger.error("Failed to load user profile: \(error.localizedDescription)", category: Logger.network)
    // Don't throw - this is not critical
}

// VoiceRecognitionService.swift:132 - Uses try? to ignore
try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)

// EditingViewModel.swift:216-224 - Catches and displays to user
} catch {
    Logger.error("Edit failed: \(error.localizedDescription)", category: Logger.general)
    errorMessage = error.localizedDescription
}
```

**Solution:** Implement consistent error handling strategy:

```swift
// ✅ RECOMMENDED - Create a centralized error handler

// Utilities/ErrorHandler.swift
enum AppError: LocalizedError {
    case network(underlying: Error)
    case authentication(message: String)
    case validation(field: String, message: String)
    case quota(remaining: Int)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .network(let error):
            return "Network error: \(error.localizedDescription)"
        case .authentication(let message):
            return message
        case .validation(let field, let message):
            return "\(field): \(message)"
        case .quota(let remaining):
            return "You've used all \(remaining) free edits this month."
        case .unknown(let error):
            return "Something went wrong: \(error.localizedDescription)"
        }
    }

    var isRecoverable: Bool {
        switch self {
        case .network, .authentication: return true
        case .validation, .quota, .unknown: return false
        }
    }
}

@MainActor
class ErrorHandler: ObservableObject {
    static let shared = ErrorHandler()

    @Published var currentError: AppError?
    @Published var showError = false

    func handle(_ error: Error, context: String = "") {
        Logger.error("\(context): \(error.localizedDescription)", category: Logger.general)

        let appError: AppError
        if let supabaseError = error as? SupabaseError {
            appError = mapSupabaseError(supabaseError)
        } else {
            appError = .unknown(error)
        }

        self.currentError = appError
        self.showError = true
    }

    private func mapSupabaseError(_ error: SupabaseError) -> AppError {
        switch error {
        case .notAuthenticated:
            return .authentication(message: "Please sign in to continue")
        case .quotaExceeded:
            return .quota(remaining: 0)
        default:
            return .unknown(error)
        }
    }
}
```

---

### P1-3: Memory Leak in Combine Subscriptions

**File:** `Velo/ViewModels/EditingViewModel.swift:319-321`

**Problem:** Manual cancellable cleanup in `deinit` isn't needed with `@StateObject` and can indicate deeper issues.

```swift
// ❌ CURRENT
deinit {
    cancellables.forEach { $0.cancel() }
}
```

**Issue:** With `@StateObject`, the view model lifecycle is managed by SwiftUI. If you're seeing issues requiring manual cleanup, there may be retain cycles.

**Solution:** Ensure proper weak references:

```swift
// ✅ RECOMMENDED - Use [weak self] consistently
private func setupVoiceRecognition() {
    voiceService.$transcribedText
        .receive(on: DispatchQueue.main)
        .sink { [weak self] text in
            guard let self = self, !text.isEmpty else { return }
            self.messageText = text
        }
        .store(in: &cancellables)
}

// Remove deinit - AnyCancellable automatically cancels when deallocated
// deinit { } // Not needed
```

---

### P1-4: Unsafe Force Unwrap

**File:** `Velo/Services/SupabaseService.swift:275`

**Problem:** Force unwrapping optional that could theoretically be nil.

```swift
// ❌ CURRENT
var profile = currentUserProfile!  // Line 275
```

**Solution:**

```swift
// ✅ RECOMMENDED
guard var profile = currentUserProfile else {
    Logger.error("Attempted to update nil profile", category: Logger.network)
    throw SupabaseError.notAuthenticated
}
```

---

### P1-5: Deprecated SwiftUI API Usage

**File:** `Velo/Views/Editing/EditingInterfaceView.swift:205`

**Problem:** `.onChange(of:perform:)` is deprecated in iOS 17+.

```swift
// ❌ CURRENT (iOS 17 deprecation warning)
.onChange(of: viewModel.messages.count) { _ in
    if let lastMessage = viewModel.messages.last {
        // ...
    }
}
```

**Solution:**

```swift
// ✅ RECOMMENDED - iOS 17+ syntax
.onChange(of: viewModel.messages.count) { oldValue, newValue in
    if let lastMessage = viewModel.messages.last {
        withAnimation {
            proxy.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
}

// For iOS 16 compatibility, use:
.onChange(of: viewModel.messages.count) { [messages = viewModel.messages] _ in
    if let lastMessage = messages.last {
        // ...
    }
}
```

---

## Architecture Improvements

### Current Architecture Assessment

```
┌─────────────────────────────────────────────────────────────┐
│                        VeloApp                               │
│                           │                                  │
│                      ContentView                             │
│                     (Mockup Gallery)                         │
│                           │                                  │
│    ┌──────────┬───────────┼───────────┬──────────────┐      │
│    ▼          ▼           ▼           ▼              ▼      │
│ Onboarding  Role      HomeView    Editing        (Future)   │
│   View    Selection              Interface                   │
│    │          │           │           │                      │
│    └──────────┴───────────┴───────────┘                      │
│                    │                                         │
│              ViewModels                                      │
│         (Onboarding, Editing,                               │
│              Template)                                       │
│                    │                                         │
│    ┌───────────────┴────────────────┐                       │
│    ▼                                ▼                        │
│ SupabaseService            VoiceRecognitionService          │
│ (Singleton)                    (Instance)                    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Recommended Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        VeloApp                               │
│                           │                                  │
│                   AppCoordinator                             │
│              (Navigation State Machine)                      │
│                           │                                  │
│         ┌─────────────────┼─────────────────┐               │
│         ▼                 ▼                 ▼               │
│    OnboardingFlow    MainTabView      SettingsFlow          │
│         │                 │                 │               │
│    ┌────┴────┐     ┌──────┴──────┐    ┌────┴────┐          │
│    ▼         ▼     ▼      ▼      ▼    ▼         ▼          │
│ Welcome   Role   Home  Gallery  Edit  Profile  Subscription │
│                                                              │
│              ViewModels (per feature)                        │
│                           │                                  │
│              ┌────────────┴────────────┐                    │
│              ▼                         ▼                     │
│         Repositories              Services                   │
│    (UserRepo, EditRepo,     (Voice, Photo, Analytics)       │
│     TemplateRepo)                                            │
│              │                         │                     │
│              └────────────┬────────────┘                    │
│                           ▼                                  │
│                    Data Sources                              │
│             (Supabase, CoreData, Keychain)                  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Implementation: App Coordinator

```swift
// Velo/Coordinators/AppCoordinator.swift
import SwiftUI

enum AppState: Equatable {
    case loading
    case onboarding
    case main
    case error(String)
}

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var appState: AppState = .loading
    @Published var selectedTab: Tab = .home

    private let authService: AuthServiceProtocol
    private let userRepository: UserRepositoryProtocol

    enum Tab: Int, CaseIterable {
        case home = 0
        case gallery = 1
        case settings = 2
    }

    init(
        authService: AuthServiceProtocol,
        userRepository: UserRepositoryProtocol
    ) {
        self.authService = authService
        self.userRepository = userRepository
    }

    func start() async {
        do {
            // Check for existing session
            if let user = try await authService.getCurrentUser() {
                // Load user profile
                _ = try await userRepository.getProfile(userId: user.id)
                appState = .main
            } else if hasCompletedOnboarding {
                appState = .main
            } else {
                appState = .onboarding
            }
        } catch {
            appState = .error(error.localizedDescription)
        }
    }

    private var hasCompletedOnboarding: Bool {
        UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.hasCompletedOnboarding)
    }

    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.hasCompletedOnboarding)
        appState = .main
    }
}
```

---

## Code Quality Issues

### CQ-1: Duplicate Code in Gradient Calculations

**Files:** `RoleSelectionView.swift:186-194`, `RoleSelectionView.swift:202-209`

**Problem:** `gradientForRole(_:)` function duplicated in view and in `RoleCard`.

**Solution:** Move to `RoleType` extension (shown in P1-1).

---

### CQ-2: Magic Numbers

**Files:** Multiple locations

```swift
// ❌ CURRENT - Magic numbers scattered
.frame(width: 60, height: 60)  // RoleSelectionView.swift:225
.frame(width: 70, height: 70)  // EditingInterfaceView.swift:263
.padding(.horizontal, 30)       // Multiple files
.frame(height: 200)            // EditingInterfaceView.swift:213
```

**Solution:** Use design tokens from Constants:

```swift
// ✅ RECOMMENDED - Add to Constants.swift
enum ComponentSize {
    static let iconSmall: CGFloat = 40
    static let iconMedium: CGFloat = 60
    static let iconLarge: CGFloat = 70

    static let avatarSmall: CGFloat = 32
    static let avatarMedium: CGFloat = 48
    static let avatarLarge: CGFloat = 64

    static let buttonHeight: CGFloat = 48
    static let inputHeight: CGFloat = 44

    static let chatHeight: CGFloat = 200
    static let cardImageHeight: CGFloat = 160
}

// Usage
.frame(width: Constants.ComponentSize.iconMedium,
       height: Constants.ComponentSize.iconMedium)
```

---

### CQ-3: Inconsistent Naming Conventions

**Examples:**

```swift
// Inconsistent property naming
@Published var isRecording = false      // Bool prefix "is"
@Published var showBeforeAfter = false  // Bool prefix "show"
@Published var errorMessage: String?    // No prefix

// Inconsistent function naming
func startVoiceRecording()   // Verb first
func toggleVoiceRecording()  // Verb first
func applySuggestion(_:)     // Verb first ✓
func shareEditedImage()      // Returns optional, should indicate
```

**Solution:** Establish naming conventions:

```swift
// ✅ RECOMMENDED naming conventions
// Booleans: use "is", "has", "should", "can" prefixes
@Published var isRecording = false
@Published var isShowingBeforeAfter = false
@Published var hasError = false

// Optionals that represent errors: use specific naming
@Published var errorMessage: String?

// Functions that return optionals: indicate in name
func getShareableImage() -> UIImage?
func fetchTemplatesIfNeeded() async throws -> [Template]
```

---

### CQ-4: Missing Access Control

**Problem:** Most types use default `internal` access, exposing implementation details.

```swift
// ❌ CURRENT - Everything is internal by default
struct UserProfile: Codable, Identifiable {
    let id: String
    var roleType: RoleType
    // ...
}
```

**Solution:** Apply appropriate access levels:

```swift
// ✅ RECOMMENDED
public struct UserProfile: Codable, Identifiable, Sendable {
    public let id: String
    public private(set) var roleType: RoleType
    public private(set) var subscriptionTier: SubscriptionTier
    public private(set) var editsThisMonth: Int

    // Internal mutating methods
    internal mutating func incrementEdits() {
        editsThisMonth += 1
    }
}
```

---

## UI/UX Enhancements

### UX-1: Missing Accessibility Support

**Problem:** No accessibility labels, hints, or traits throughout the app.

**Files Affected:** All view files

```swift
// ❌ CURRENT - No accessibility
Button(action: { viewModel.toggleVoiceRecording() }) {
    Image(systemName: viewModel.isRecording ? "stop.fill" : "mic.fill")
        .font(.system(size: 28))
        .foregroundColor(.white)
}
```

**Solution:**

```swift
// ✅ RECOMMENDED - Full accessibility support
Button(action: { viewModel.toggleVoiceRecording() }) {
    Image(systemName: viewModel.isRecording ? "stop.fill" : "mic.fill")
        .font(.system(size: 28))
        .foregroundColor(.white)
}
.accessibilityLabel(viewModel.isRecording ? "Stop recording" : "Start voice recording")
.accessibilityHint("Double tap to \(viewModel.isRecording ? "stop" : "start") voice input")
.accessibilityAddTraits(.isButton)
.accessibilityRemoveTraits(.isImage)
```

**Comprehensive Accessibility Checklist:**

```swift
// Create an accessibility modifier for common patterns
extension View {
    func accessibleButton(
        label: String,
        hint: String? = nil,
        isEnabled: Bool = true
    ) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(.isButton)
            .accessibilityRemoveTraits(isEnabled ? [] : .isButton)
            .accessibilityValue(isEnabled ? "" : "Disabled")
    }
}

// Usage
voiceButton
    .accessibleButton(
        label: viewModel.isRecording ? "Stop recording" : "Start voice recording",
        hint: "Double tap to control voice input",
        isEnabled: !viewModel.isProcessing
    )
```

---

### UX-2: No Loading State Skeletons

**Problem:** Loading states show basic spinners instead of content-aware skeletons.

**Current:** `ProgressView()` or simple text

**Solution:**

```swift
// ✅ RECOMMENDED - Skeleton loading component
struct SkeletonView: View {
    let width: CGFloat?
    let height: CGFloat

    @State private var isAnimating = false

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.1),
                        Color.white.opacity(0.2),
                        Color.white.opacity(0.1)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: width, height: height)
            .mask(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white, .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: isAnimating ? 200 : -200)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

// Template card skeleton
struct TemplateCardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SkeletonView(width: nil, height: 160)
            SkeletonView(width: 120, height: 16)
            SkeletonView(width: 80, height: 12)
        }
    }
}
```

---

### UX-3: No Haptic Feedback

**Problem:** Voice button and other interactive elements lack haptic feedback.

**Solution:**

```swift
// ✅ RECOMMENDED - Haptic feedback manager
enum HapticManager {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

// Usage in voice button
Button(action: {
    HapticManager.impact(.medium)
    viewModel.toggleVoiceRecording()
}) {
    // ...
}

// On successful edit
HapticManager.notification(.success)

// On error
HapticManager.notification(.error)
```

---

### UX-4: Missing Empty States

**Problem:** No guidance when lists are empty.

**Solution:**

```swift
// ✅ RECOMMENDED - Empty state component
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))

            VStack(spacing: 8) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text(message)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }

            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
            }
        }
        .padding(40)
    }
}

// Usage
if viewModel.recentEdits.isEmpty {
    EmptyStateView(
        icon: "photo.on.rectangle.angled",
        title: "No edits yet",
        message: "Start by selecting a photo and telling Velo what you'd like to change.",
        actionTitle: "Start Editing",
        action: { showEditingInterface = true }
    )
}
```

---

### UX-5: No Dynamic Type Support

**Problem:** Fixed font sizes don't respect user's accessibility settings.

```swift
// ❌ CURRENT
.font(.system(size: 48, weight: .bold))
```

**Solution:**

```swift
// ✅ RECOMMENDED - Use semantic font styles with custom sizing
extension Font {
    static func adaptiveTitle(_ size: CGFloat = 34, weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
}

// Better: Use standard text styles that scale
.font(.largeTitle)  // Scales with Dynamic Type
.font(.title)
.font(.headline)
.font(.body)

// If custom size needed, use @ScaledMetric
struct CustomHeadline: View {
    @ScaledMetric(relativeTo: .title) var fontSize: CGFloat = 36

    var body: some View {
        Text("Velo")
            .font(.system(size: fontSize, weight: .bold))
    }
}
```

---

## Performance Optimizations

### PERF-1: Image Processing on Main Thread

**File:** `Velo/Services/SupabaseService.swift:366-370`

**Problem:** Image compression happens on main thread, blocking UI.

```swift
// ❌ CURRENT
guard let imageData = image.jpegData(compressionQuality: 0.8) else {
    throw SupabaseError.imageProcessingFailed
}
let base64Image = imageData.base64EncodedString()
```

**Solution:**

```swift
// ✅ RECOMMENDED - Process on background thread
func processEdit(command: String, image: UIImage) async throws -> EditResponse {
    // Move heavy work off main thread
    let base64Image = try await Task.detached(priority: .userInitiated) {
        // Resize image if needed (prevent huge uploads)
        let resized = image.resized(to: 2048) ?? image

        guard let imageData = resized.jpegData(compressionQuality: 0.8) else {
            throw SupabaseError.imageProcessingFailed
        }

        return imageData.base64EncodedString()
    }.value

    // Continue with network call...
}
```

---

### PERF-2: No Image Caching

**File:** `Velo/ViewModels/EditingViewModel.swift:230-248`

**Problem:** Images downloaded each time, no caching.

**Solution:**

```swift
// ✅ RECOMMENDED - Use NSCache for image caching
actor ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()
    private var inFlightRequests: [String: Task<UIImage, Error>] = [:]

    func image(for urlString: String) async throws -> UIImage {
        // Check cache first
        if let cached = cache.object(forKey: urlString as NSString) {
            return cached
        }

        // Check if already fetching
        if let existingTask = inFlightRequests[urlString] {
            return try await existingTask.value
        }

        // Create new fetch task
        let task = Task<UIImage, Error> {
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }

            let (data, _) = try await URLSession.shared.data(from: url)

            guard let image = UIImage(data: data) else {
                throw URLError(.cannotDecodeContentData)
            }

            // Cache the result
            cache.setObject(image, forKey: urlString as NSString)

            return image
        }

        inFlightRequests[urlString] = task

        defer {
            inFlightRequests[urlString] = nil
        }

        return try await task.value
    }
}
```

---

### PERF-3: Unnecessary View Redraws

**File:** `Velo/Views/Editing/HomeView.swift`

**Problem:** Large view body with nested components causes unnecessary redraws.

**Solution:** Extract subviews and use `@ViewBuilder`:

```swift
// ✅ RECOMMENDED - Extract components
struct HomeView: View {
    let userRole: RoleType
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                HomeHeaderView(userRole: userRole)
                HomeTabSelector(selectedTab: $selectedTab)
                HomeContentView(selectedTab: selectedTab, userRole: userRole)
                HomeQuickChatBar(userRole: userRole)
            }
        }
    }
}

// Separate file: HomeHeaderView.swift
struct HomeHeaderView: View {
    let userRole: RoleType

    var body: some View {
        // Header content - only redraws when userRole changes
    }
}
```

---

## Security Hardening

### SEC-1: CORS Wildcard in Edge Function

**File:** `supabase/functions/process-edit/index.ts:8`

```typescript
// ❌ CURRENT
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',  // Too permissive
```

**Solution:**

```typescript
// ✅ RECOMMENDED
const ALLOWED_ORIGINS = [
  'capacitor://localhost',  // iOS app
  'http://localhost:3000',  // Development
  // Add production domains as needed
];

const corsHeaders = (origin: string | null) => ({
  'Access-Control-Allow-Origin': ALLOWED_ORIGINS.includes(origin || '') ? origin : ALLOWED_ORIGINS[0],
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
});
```

---

### SEC-2: No Rate Limiting

**Problem:** Edge function has no rate limiting, vulnerable to abuse.

**Solution:** Implement rate limiting with Supabase:

```typescript
// ✅ RECOMMENDED - Add rate limiting
async function checkRateLimit(userId: string, supabase: SupabaseClient): Promise<boolean> {
  const windowMs = 60 * 1000; // 1 minute
  const maxRequests = 10;

  const { count, error } = await supabase
    .from('rate_limits')
    .select('*', { count: 'exact', head: true })
    .eq('user_id', userId)
    .gte('created_at', new Date(Date.now() - windowMs).toISOString());

  if (error) {
    console.error('Rate limit check failed:', error);
    return true; // Allow on error to prevent blocking legitimate users
  }

  if ((count ?? 0) >= maxRequests) {
    return false;
  }

  // Log this request
  await supabase.from('rate_limits').insert({ user_id: userId });

  return true;
}
```

---

### SEC-3: Sensitive Data in Logs

**File:** `Velo/Services/SupabaseService.swift:91`

```swift
// ❌ CURRENT - Logs partial access token
Logger.info("✅ Access token exists: \(session.accessToken.prefix(20))...", category: Logger.auth)
```

**Solution:**

```swift
// ✅ RECOMMENDED - Never log tokens, even partially
Logger.info("✅ Access token exists: [REDACTED]", category: Logger.auth)

// Or just log boolean
Logger.info("✅ Has access token: \(!session.accessToken.isEmpty)", category: Logger.auth)
```

---

### SEC-4: Missing Input Validation

**Problem:** Command text sent directly to AI without sanitization.

**Solution:**

```swift
// ✅ RECOMMENDED - Validate and sanitize input
extension String {
    var sanitizedForAI: String {
        // Remove potential injection patterns
        self.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "<", with: "")
            .replacingOccurrences(of: ">", with: "")
            .prefix(500) // Limit length
            .description
    }

    var isValidEditCommand: Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed.count >= 3 && trimmed.count <= 500
    }
}

// Usage
func sendMessage() async {
    guard messageText.isValidEditCommand else {
        errorMessage = "Please enter a valid editing command"
        return
    }

    let sanitizedCommand = messageText.sanitizedForAI
    await processEdit(command: sanitizedCommand)
}
```

---

## Testing Strategy

### Current State: 0% Coverage

No tests exist in the project.

### Recommended Testing Pyramid

```
                    ┌─────────────┐
                    │   E2E/UI    │  10%
                    │   Tests     │
                    └──────┬──────┘
                   ┌───────┴───────┐
                   │  Integration  │  20%
                   │    Tests      │
                   └───────┬───────┘
              ┌────────────┴────────────┐
              │       Unit Tests        │  70%
              │  (ViewModels, Services, │
              │   Models, Utilities)    │
              └─────────────────────────┘
```

### Unit Test Examples

```swift
// VeloTests/ViewModels/EditingViewModelTests.swift
import XCTest
@testable import Velo

@MainActor
final class EditingViewModelTests: XCTestCase {
    var sut: EditingViewModel!
    var mockSupabaseService: MockSupabaseService!
    var mockVoiceService: MockVoiceRecognitionService!

    override func setUp() async throws {
        mockSupabaseService = MockSupabaseService()
        mockVoiceService = MockVoiceRecognitionService()
        sut = EditingViewModel(
            image: nil,
            supabaseService: mockSupabaseService,
            voiceService: mockVoiceService
        )
    }

    override func tearDown() async throws {
        sut = nil
        mockSupabaseService = nil
        mockVoiceService = nil
    }

    // MARK: - Initial State Tests

    func test_initialState_hasWelcomeMessage() {
        XCTAssertEqual(sut.messages.count, 1)
        XCTAssertFalse(sut.messages[0].isUser)
        XCTAssertTrue(sut.messages[0].text.contains("ready to edit"))
    }

    func test_initialState_hasSuggestions() {
        XCTAssertFalse(sut.suggestions.isEmpty)
        XCTAssertEqual(sut.suggestions.count, 4)
    }

    func test_initialState_isNotProcessing() {
        XCTAssertFalse(sut.isProcessing)
        XCTAssertFalse(sut.isRecording)
    }

    // MARK: - Send Message Tests

    func test_sendMessage_addsUserMessageToChat() async {
        sut.messageText = "Make the sky bluer"

        await sut.sendMessage()

        XCTAssertTrue(sut.messages.contains { $0.isUser && $0.text == "Make the sky bluer" })
    }

    func test_sendMessage_clearsMessageText() async {
        sut.messageText = "Test message"

        await sut.sendMessage()

        XCTAssertTrue(sut.messageText.isEmpty)
    }

    func test_sendMessage_emptyText_doesNothing() async {
        let initialMessageCount = sut.messages.count
        sut.messageText = ""

        await sut.sendMessage()

        XCTAssertEqual(sut.messages.count, initialMessageCount)
    }

    // MARK: - Voice Recording Tests

    func test_startVoiceRecording_requestsAuthorization() async {
        mockVoiceService.authorizationStatus = .notDetermined

        await sut.startVoiceRecording()

        XCTAssertTrue(mockVoiceService.didRequestAuthorization)
    }

    func test_startVoiceRecording_denied_showsError() async {
        mockVoiceService.authorizationStatus = .denied

        await sut.startVoiceRecording()

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.errorMessage?.contains("permission") ?? false)
    }
}

// VeloTests/Models/UserProfileTests.swift
import XCTest
@testable import Velo

final class UserProfileTests: XCTestCase {

    func test_hasEditsRemaining_freeUserUnderLimit_returnsTrue() {
        let profile = UserProfile(
            id: "test",
            roleType: .explorer,
            subscriptionTier: .free,
            editsThisMonth: 3,
            editsMonthStart: Date(),
            createdAt: Date()
        )

        XCTAssertTrue(profile.hasEditsRemaining)
    }

    func test_hasEditsRemaining_freeUserAtLimit_returnsFalse() {
        let profile = UserProfile(
            id: "test",
            roleType: .explorer,
            subscriptionTier: .free,
            editsThisMonth: 5,
            editsMonthStart: Date(),
            createdAt: Date()
        )

        XCTAssertFalse(profile.hasEditsRemaining)
    }

    func test_hasEditsRemaining_proUser_alwaysReturnsTrue() {
        let profile = UserProfile(
            id: "test",
            roleType: .salon,
            subscriptionTier: .pro,
            editsThisMonth: 1000,
            editsMonthStart: Date(),
            createdAt: Date()
        )

        XCTAssertTrue(profile.hasEditsRemaining)
    }

    func test_editsRemaining_freeUser_calculatesCorrectly() {
        let profile = UserProfile(
            id: "test",
            roleType: .explorer,
            subscriptionTier: .free,
            editsThisMonth: 2,
            editsMonthStart: Date(),
            createdAt: Date()
        )

        XCTAssertEqual(profile.editsRemaining, 3)
    }

    func test_editsRemaining_proUser_returnsNil() {
        let profile = UserProfile(
            id: "test",
            roleType: .salon,
            subscriptionTier: .pro,
            editsThisMonth: 50,
            editsMonthStart: Date(),
            createdAt: Date()
        )

        XCTAssertNil(profile.editsRemaining)
    }
}
```

### Mock Objects

```swift
// VeloTests/Mocks/MockSupabaseService.swift
@MainActor
final class MockSupabaseService: SupabaseServiceProtocol {
    var currentUserProfile: UserProfile?
    var isAuthenticated = false

    var processEditResult: Result<EditResponse, Error> = .success(
        EditResponse(
            success: true,
            editedImageUrl: "https://example.com/edited.jpg",
            editsRemaining: 4,
            modelUsed: "base",
            processingTimeMs: 1500,
            error: nil
        )
    )

    func processEdit(command: String, image: UIImage) async throws -> EditResponse {
        switch processEditResult {
        case .success(let response): return response
        case .failure(let error): throw error
        }
    }

    // ... other protocol requirements
}
```

---

## CI/CD Recommendations

### Recommended GitHub Actions Workflow

```yaml
# .github/workflows/ios.yml
name: iOS CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  build-and-test:
    name: Build & Test
    runs-on: macos-14

    steps:
      - uses: actions/checkout@v4

      - name: Select Xcode
        run: sudo xcode-select -s /Applications/Xcode_15.2.app

      - name: Cache SPM
        uses: actions/cache@v4
        with:
          path: |
            ~/Library/Caches/org.swift.swiftpm
            .build
          key: ${{ runner.os }}-spm-${{ hashFiles('**/Package.resolved') }}
          restore-keys: |
            ${{ runner.os }}-spm-

      - name: Build
        run: |
          xcodebuild build \
            -project Velo.xcodeproj \
            -scheme Velo \
            -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.2' \
            -configuration Debug \
            CODE_SIGNING_ALLOWED=NO

      - name: Run Tests
        run: |
          xcodebuild test \
            -project Velo.xcodeproj \
            -scheme Velo \
            -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.2' \
            -resultBundlePath TestResults.xcresult \
            CODE_SIGNING_ALLOWED=NO

      - name: Upload Test Results
        uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: test-results
          path: TestResults.xcresult

  lint:
    name: SwiftLint
    runs-on: macos-14

    steps:
      - uses: actions/checkout@v4

      - name: Run SwiftLint
        run: |
          brew install swiftlint
          swiftlint lint --reporter github-actions-logging

  deploy-testflight:
    name: Deploy to TestFlight
    runs-on: macos-14
    needs: [build-and-test, lint]
    if: github.ref == 'refs/heads/main'

    steps:
      - uses: actions/checkout@v4

      - name: Install Fastlane
        run: gem install fastlane

      - name: Build and Upload
        env:
          APP_STORE_CONNECT_API_KEY: ${{ secrets.APP_STORE_CONNECT_API_KEY }}
          MATCH_PASSWORD: ${{ secrets.MATCH_PASSWORD }}
        run: fastlane beta
```

### SwiftLint Configuration

```yaml
# .swiftlint.yml
included:
  - Velo

excluded:
  - Velo/Generated
  - Pods
  - .build

disabled_rules:
  - trailing_whitespace
  - line_length

opt_in_rules:
  - empty_count
  - empty_string
  - force_unwrapping
  - implicitly_unwrapped_optional
  - multiline_arguments
  - multiline_parameters
  - vertical_whitespace_closing_braces

force_unwrapping:
  severity: error

line_length:
  warning: 120
  error: 150

type_body_length:
  warning: 300
  error: 400

function_body_length:
  warning: 50
  error: 100

identifier_name:
  min_length: 2
  excluded:
    - id
    - x
    - y

nesting:
  type_level: 2
  function_level: 3

reporter: "github-actions-logging"
```

---

## Production Readiness Checklist

### Security
- [ ] Remove ProcessInfo.environment for production config
- [ ] Implement proper secrets management
- [ ] Remove sensitive data from logs
- [ ] Add input validation/sanitization
- [ ] Implement rate limiting
- [ ] Review CORS settings in edge functions
- [ ] Audit RLS policies in Supabase

### Code Quality
- [ ] Remove OldUserRole legacy model
- [ ] Standardize error handling
- [ ] Add access control modifiers
- [ ] Remove magic numbers
- [ ] Fix deprecated API usage
- [ ] Resolve all compiler warnings

### Performance
- [ ] Move image processing off main thread
- [ ] Implement image caching
- [ ] Optimize view hierarchies
- [ ] Add lazy loading for lists
- [ ] Profile memory usage

### UI/UX
- [ ] Add accessibility labels throughout
- [ ] Implement skeleton loading states
- [ ] Add haptic feedback
- [ ] Create empty states for all lists
- [ ] Support Dynamic Type
- [ ] Test on all device sizes

### Testing
- [ ] Add unit tests (target: 80% coverage)
- [ ] Add integration tests for services
- [ ] Add UI tests for critical flows
- [ ] Set up CI test automation

### DevOps
- [ ] Set up GitHub Actions CI/CD
- [ ] Configure SwiftLint
- [ ] Set up Fastlane for deployment
- [ ] Configure crash reporting (Sentry/Firebase)
- [ ] Set up analytics (Mixpanel/Amplitude)

### Documentation
- [ ] Update README with architecture
- [ ] Add API documentation
- [ ] Create onboarding guide for developers
- [ ] Document deployment process

---

## Priority Matrix

| Issue | Impact | Effort | Priority |
|-------|--------|--------|----------|
| P0-1: API Credentials | Critical | Low | Immediate |
| P0-2: Fatal Error | Critical | Low | Immediate |
| P0-3: Singleton Deadlock | High | Medium | This Sprint |
| P1-1: Legacy Model | Medium | Low | This Sprint |
| P1-2: Error Handling | Medium | Medium | This Sprint |
| SEC-1: CORS | High | Low | This Sprint |
| UX-1: Accessibility | High | High | Next Sprint |
| Testing | High | High | Ongoing |
| PERF-1: Image Thread | Medium | Low | Next Sprint |

---

## Resources & References

### Swift/SwiftUI
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Swift Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)

### Architecture
- [Clean Architecture for SwiftUI](https://nalexn.github.io/clean-architecture-swiftui/)
- [MVVM in SwiftUI](https://www.swiftbysundell.com/articles/mvvm-in-swiftui/)

### Testing
- [XCTest Documentation](https://developer.apple.com/documentation/xctest)
- [Swift Testing Framework](https://developer.apple.com/documentation/testing)

### Security
- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)
- [iOS Security Guide](https://support.apple.com/guide/security/welcome/web)

### Supabase
- [Supabase Swift Client](https://supabase.com/docs/reference/swift/introduction)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)

---

*This blueprint was generated by analyzing 19 Swift files, 1 TypeScript edge function, and supporting configuration files. Last updated: December 2025*
