//
//  OnboardingViewModel.swift
//  Velo
//
//  Created by Ky Vu on 12/10/25.
//

import Foundation
import Combine

/// ViewModel for onboarding flow
@MainActor
class OnboardingViewModel: ObservableObject {
    // MARK: - Published Properties

    /// Current onboarding step
    @Published var currentStep = 0

    /// Whether onboarding is complete
    @Published var isComplete = false

    /// Selected user role
    @Published var selectedRole: RoleType?

    /// Whether we're creating user session
    @Published var isCreatingSession = false

    /// Error message if something fails
    @Published var errorMessage: String?

    // MARK: - Constants

    let totalSteps = 3

    // MARK: - Private Properties

    private let supabaseService = SupabaseService.shared

    // MARK: - Navigation

    /// Go to next step
    func nextStep() {
        if currentStep < totalSteps - 1 {
            currentStep += 1
            Logger.info("Onboarding: Advanced to step \(currentStep)", category: .app)
        } else {
            completeOnboarding()
        }
    }

    /// Go to previous step
    func previousStep() {
        if currentStep > 0 {
            currentStep -= 1
            Logger.info("Onboarding: Went back to step \(currentStep)", category: .app)
        }
    }

    /// Skip to end
    func skipOnboarding() {
        currentStep = totalSteps - 1
        Logger.info("Onboarding: Skipped to final step", category: .app)
    }

    // MARK: - Role Selection

    /// Select a user role
    func selectRole(_ role: RoleType) {
        selectedRole = role
        Logger.info("Onboarding: Selected role \(role.rawValue)", category: .app)
    }

    // MARK: - Completion

    /// Complete onboarding and create user session
    func completeOnboarding() {
        Task {
            await createUserSession()
        }
    }

    private func createUserSession() async {
        guard let role = selectedRole else {
            errorMessage = "Please select a role to continue"
            return
        }

        isCreatingSession = true
        errorMessage = nil

        Logger.info("Creating anonymous user session", category: .auth)

        do {
            // Create anonymous session
            let userId = try await supabaseService.createAnonymousSession()

            Logger.info("Anonymous session created: \(userId)", category: .auth)

            // Update user profile with selected role
            try await supabaseService.updateUserProfile(roleType: role)

            Logger.info("User profile updated with role: \(role.rawValue)", category: .auth)

            // Mark onboarding as complete
            UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.hasCompletedOnboarding)
            UserDefaults.standard.set(role.rawValue, forKey: Constants.UserDefaultsKey.selectedRoleType)

            isComplete = true

            Logger.info("Onboarding completed successfully", category: .app)

        } catch {
            Logger.error("Failed to complete onboarding: \(error.localizedDescription)", category: .auth)
            errorMessage = "Failed to create account: \(error.localizedDescription)"
        }

        isCreatingSession = false
    }

    // MARK: - Permissions

    /// Request necessary permissions (speech, photos, etc.)
    func requestPermissions() async {
        Logger.info("Requesting app permissions", category: .app)

        // Speech recognition permission will be requested on first use
        // Photo library permission will be requested when user selects a photo
        // For now, just log that we're ready
        Logger.info("Permissions will be requested on first use", category: .app)
    }
}
