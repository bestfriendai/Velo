//
//  AppCoordinator.swift
//  Velo
//
//  P0-3 Fix: App coordinator for navigation and dependency injection
//

import SwiftUI
import Combine

// MARK: - App State

/// Represents the current state of the app
enum AppState: Equatable {
    case loading
    case onboarding
    case main
    case configurationError(String)

    static func == (lhs: AppState, rhs: AppState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.onboarding, .onboarding): return true
        case (.main, .main): return true
        case (.configurationError(let l), .configurationError(let r)): return l == r
        default: return false
        }
    }
}

// MARK: - App Dependencies

/// Container for app-wide dependencies (P0-3 Dependency Injection)
@MainActor
final class AppDependencies: ObservableObject {
    let supabaseService: SupabaseService
    let errorHandler: ErrorHandler

    init() {
        self.supabaseService = SupabaseService.shared
        self.errorHandler = ErrorHandler.shared
    }
}

// MARK: - App Coordinator

/// Coordinates app navigation and state management
@MainActor
final class AppCoordinator: ObservableObject {
    // MARK: - Published State

    @Published var appState: AppState = .loading
    @Published var selectedTab: Tab = .home

    // MARK: - Dependencies

    private let dependencies: AppDependencies
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Tab Enum

    enum Tab: Int, CaseIterable {
        case home = 0
        case gallery = 1
        case settings = 2

        var title: String {
            switch self {
            case .home: return "Home"
            case .gallery: return "Gallery"
            case .settings: return "Settings"
            }
        }

        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .gallery: return "photo.on.rectangle.angled"
            case .settings: return "gearshape.fill"
            }
        }
    }

    // MARK: - Initialization

    init(dependencies: AppDependencies = AppDependencies()) {
        self.dependencies = dependencies
        setupSubscriptions()
    }

    // MARK: - Setup

    private func setupSubscriptions() {
        // Listen for profile updates
        NotificationCenter.default.publisher(for: Constants.NotificationName.userProfileUpdated)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.checkAppState()
            }
            .store(in: &cancellables)
    }

    // MARK: - App Lifecycle

    /// Called when app starts to determine initial state
    func start() async {
        Logger.info("AppCoordinator starting...", category: Logger.general)

        // Check configuration first
        guard Secrets.isConfigured else {
            appState = .configurationError(Secrets.configurationError ?? "Unknown configuration error")
            Logger.error("App configuration error: \(Secrets.configurationError ?? "Unknown")", category: Logger.general)
            return
        }

        // Check for existing session
        if dependencies.supabaseService.isAuthenticated {
            Logger.info("User is authenticated, going to main", category: Logger.auth)
            appState = .main
        } else if hasCompletedOnboarding {
            Logger.info("Onboarding complete but not authenticated, going to main", category: Logger.auth)
            appState = .main
        } else {
            Logger.info("New user, starting onboarding", category: Logger.auth)
            appState = .onboarding
        }
    }

    /// Check and update app state based on current conditions
    private func checkAppState() {
        if hasCompletedOnboarding && dependencies.supabaseService.isAuthenticated {
            appState = .main
        }
    }

    // MARK: - Onboarding

    private var hasCompletedOnboarding: Bool {
        UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.hasCompletedOnboarding)
    }

    /// Call when user completes onboarding
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.hasCompletedOnboarding)
        appState = .main
        Logger.info("Onboarding completed", category: Logger.general)
    }

    /// Reset onboarding state (for testing)
    func resetOnboarding() {
        UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.hasCompletedOnboarding)
        appState = .onboarding
        Logger.info("Onboarding reset", category: Logger.general)
    }

    // MARK: - Navigation

    /// Navigate to a specific tab
    func navigateToTab(_ tab: Tab) {
        HapticManager.tabChanged()
        selectedTab = tab
    }

    // MARK: - Error Handling

    /// Handle an error with the centralized error handler
    func handleError(_ error: Error, context: String = "") {
        dependencies.errorHandler.handle(error, context: context)
    }
}

// MARK: - Root View

/// Root view that switches based on app state
struct RootView: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        Group {
            switch coordinator.appState {
            case .loading:
                LoadingView()

            case .onboarding:
                OnboardingView()
                    .environmentObject(coordinator)

            case .main:
                MainTabView()
                    .environmentObject(coordinator)

            case .configurationError(let message):
                ConfigurationErrorView(message: message)
            }
        }
        .withErrorHandling()
        .task {
            await coordinator.start()
        }
    }
}

// MARK: - Supporting Views

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: Constants.Spacing.lg) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)

                Text("Loading Velo...")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
    }
}

struct ConfigurationErrorView: View {
    let message: String

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            EmptyStateView(
                icon: "exclamationmark.triangle.fill",
                title: "Configuration Error",
                message: message,
                actionTitle: nil,
                action: nil
            )
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            // Home tab - use current user's role or default to explorer
            HomeView(userRole: createLegacyRole())
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(AppCoordinator.Tab.home)

            // Gallery tab
            Text("Gallery Coming Soon")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .foregroundColor(.white)
                .tabItem {
                    Label("Gallery", systemImage: "photo.on.rectangle.angled")
                }
                .tag(AppCoordinator.Tab.gallery)

            // Settings tab
            Text("Settings Coming Soon")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .foregroundColor(.white)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(AppCoordinator.Tab.settings)
        }
        .tint(.white)
    }

    /// Create a legacy OldUserRole from the current profile (temporary until HomeView is refactored)
    private func createLegacyRole() -> OldUserRole {
        let profile = SupabaseService.shared.currentUserProfile
        let roleType = profile?.roleType ?? .explorer

        return OldUserRole(
            id: roleType.rawValue,
            icon: roleType.icon,
            title: roleType.displayName,
            description: roleType.description,
            features: roleType.features,
            gradient: roleType.gradient
        )
    }
}
