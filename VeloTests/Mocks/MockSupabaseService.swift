//
//  MockSupabaseService.swift
//  VeloTests
//
//  Mock implementation of SupabaseService for testing
//

import Foundation
import UIKit
@testable import Velo

/// Mock Supabase service for unit testing
@MainActor
class MockSupabaseService: ObservableObject {
    // MARK: - Published Properties

    @Published var isAuthenticated = false
    @Published var currentUserProfile: UserProfile?
    @Published var configurationError = false

    // MARK: - Mock Data

    var mockUserProfile: UserProfile?
    var mockTemplates: [Template] = []
    var mockEditResponse: EditResponse?

    // MARK: - Tracking

    var createAnonymousSessionCalled = false
    var signOutCalled = false
    var updateUserProfileCalled = false
    var processEditCalled = false
    var fetchTemplatesCalled = false

    // MARK: - Error Simulation

    var shouldThrowError = false
    var errorToThrow: SupabaseError = .notAuthenticated

    // MARK: - Mock Methods

    func createAnonymousSession() async throws -> String {
        createAnonymousSessionCalled = true

        if shouldThrowError {
            throw errorToThrow
        }

        let userId = UUID().uuidString
        isAuthenticated = true
        return userId
    }

    func signOut() async throws {
        signOutCalled = true

        if shouldThrowError {
            throw errorToThrow
        }

        isAuthenticated = false
        currentUserProfile = nil
    }

    func updateUserProfile(roleType: RoleType? = nil, subscriptionTier: SubscriptionTier? = nil) async throws {
        updateUserProfileCalled = true

        if shouldThrowError {
            throw errorToThrow
        }

        if var profile = currentUserProfile {
            if let roleType = roleType {
                profile.roleType = roleType
            }
            if let subscriptionTier = subscriptionTier {
                profile.subscriptionTier = subscriptionTier
            }
            currentUserProfile = profile
        } else if let role = roleType {
            currentUserProfile = UserProfile(
                id: UUID().uuidString,
                roleType: role,
                subscriptionTier: subscriptionTier ?? .free,
                editsThisMonth: 0,
                editsMonthStart: Date(),
                createdAt: Date()
            )
        }
    }

    func processEdit(command: String, image: UIImage) async throws -> EditResponse {
        processEditCalled = true

        if shouldThrowError {
            throw errorToThrow
        }

        if let mockResponse = mockEditResponse {
            return mockResponse
        }

        // Return default successful response
        return EditResponse(
            success: true,
            editedImageUrl: "https://example.com/edited.jpg",
            editsRemaining: 4,
            modelUsed: "gemini-2.5-flash-image",
            processingTimeMs: 1500,
            error: nil
        )
    }

    func fetchTemplates(for roleType: RoleType) async throws -> [Template] {
        fetchTemplatesCalled = true

        if shouldThrowError {
            throw errorToThrow
        }

        if !mockTemplates.isEmpty {
            return mockTemplates.filter { $0.isAvailableFor(role: roleType) }
        }

        // Return sample templates
        return Template.samples.filter { $0.isAvailableFor(role: roleType) }
    }
}

// MARK: - Mock Factory

extension MockSupabaseService {
    /// Create a mock with a pre-configured authenticated user
    static func authenticatedUser(roleType: RoleType = .explorer) -> MockSupabaseService {
        let mock = MockSupabaseService()
        mock.isAuthenticated = true
        mock.currentUserProfile = UserProfile(
            id: UUID().uuidString,
            roleType: roleType,
            subscriptionTier: .free,
            editsThisMonth: 2,
            editsMonthStart: Date(),
            createdAt: Date()
        )
        return mock
    }

    /// Create a mock that simulates errors
    static func failingService(error: SupabaseError = .notAuthenticated) -> MockSupabaseService {
        let mock = MockSupabaseService()
        mock.shouldThrowError = true
        mock.errorToThrow = error
        return mock
    }
}
