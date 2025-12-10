//
//  SupabaseService.swift
//  Velo
//
//  Created by Ky Vu on 12/9/25.
//

import Foundation
import UIKit
import Combine
import Supabase

/// Supabase service for backend API calls
@MainActor
class SupabaseService: ObservableObject {
    // MARK: - Singleton
    static let shared = SupabaseService()

    // MARK: - Published Properties
    @Published var isAuthenticated = false
    @Published var currentUserProfile: UserProfile?

    // MARK: - Private Properties
    private let supabase: SupabaseClient
    private var authToken: String?
    private var anonymousUserID: String?

    // MARK: - Initialization
    private init() {
        // Initialize Supabase client
        guard let url = URL(string: Constants.API.supabaseURL),
              !Constants.API.supabaseAnonKey.isEmpty else {
            Logger.error("Supabase credentials not configured", category: Logger.network)
            fatalError("Supabase credentials missing. Check environment variables.")
        }

        self.supabase = SupabaseClient(
            supabaseURL: url,
            supabaseKey: Constants.API.supabaseAnonKey
        )

        Logger.info("Supabase client initialized", category: Logger.network)

        // Load cached user data
        loadLocalUser()

        // Set up auth state listener
        Task {
            await setupAuthStateListener()
        }
    }

    // MARK: - Auth State Listener

    private func setupAuthStateListener() async {
        for await state in await supabase.auth.authStateChanges {
            Logger.debug("Auth state changed: \(state.event)", category: Logger.auth)

            switch state.event {
            case .signedIn:
                if let user = state.session?.user {
                    self.isAuthenticated = true
                    self.anonymousUserID = user.id.uuidString
                    try? await loadUserProfile(userId: user.id.uuidString)
                }
            case .signedOut:
                self.isAuthenticated = false
                self.currentUserProfile = nil
                self.anonymousUserID = nil
            default:
                break
            }
        }
    }

    // MARK: - Authentication

    /// Create anonymous user session
    func createAnonymousSession() async throws -> String {
        Logger.info("Creating anonymous session", category: Logger.auth)

        // Check if we already have a valid session
        if let session = try? await supabase.auth.session {
            Logger.info("Found existing session for user: \(session.user.id)", category: Logger.auth)
            let userId = session.user.id.uuidString
            self.anonymousUserID = userId
            self.isAuthenticated = true

            // Try to load existing profile
            try? await loadUserProfile(userId: userId)
            return userId
        }

        // Create new anonymous session
        do {
            let session = try await supabase.auth.signInAnonymously()
            let userId = session.user.id.uuidString

            Logger.info("Anonymous session created: \(userId)", category: Logger.auth)

            self.anonymousUserID = userId
            self.isAuthenticated = true

            // Cache locally
            UserDefaults.standard.set(userId, forKey: Constants.UserDefaultsKey.localUserID)
            UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.isAnonymousUser)

            // Create user profile in database with default values
            let profile = UserProfile(
                id: userId,
                roleType: .explorer,
                subscriptionTier: .free,
                editsThisMonth: 0,
                editsMonthStart: Date(),
                createdAt: Date()
            )

            try await createUserProfile(profile)

            self.currentUserProfile = profile
            saveUserProfile(profile)

            return userId
        } catch {
            Logger.error("Failed to create anonymous session: \(error.localizedDescription)", category: Logger.auth)
            throw SupabaseError.authenticationFailed(error.localizedDescription)
        }
    }

    /// Sign in with Apple (placeholder)
    func signInWithApple(idToken: String) async throws -> UserProfile {
        // TODO: Implement Sign in with Apple via Supabase Auth
        throw SupabaseError.notImplemented
    }

    /// Sign out
    func signOut() async throws {
        Logger.info("Signing out user", category: Logger.auth)

        do {
            try await supabase.auth.signOut()

            authToken = nil
            isAuthenticated = false
            currentUserProfile = nil

            // Clear local data
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.localUserID)
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.isAnonymousUser)
            UserDefaults.standard.removeObject(forKey: "userProfile")

            Logger.info("User signed out successfully", category: Logger.auth)
        } catch {
            Logger.error("Failed to sign out: \(error.localizedDescription)", category: Logger.auth)
            throw SupabaseError.authenticationFailed(error.localizedDescription)
        }
    }

    // MARK: - User Profile

    /// Create user profile in database
    private func createUserProfile(_ profile: UserProfile) async throws {
        Logger.info("Creating user profile in database: \(profile.id)", category: Logger.network)

        struct UserProfileRow: Encodable {
            let id: String
            let role_type: String
            let subscription_tier: String
            let edits_this_month: Int
            let edits_month_start: String
        }

        let dateFormatter = ISO8601DateFormatter()
        let row = UserProfileRow(
            id: profile.id,
            role_type: profile.roleType.rawValue,
            subscription_tier: profile.subscriptionTier.rawValue,
            edits_this_month: profile.editsThisMonth,
            edits_month_start: dateFormatter.string(from: profile.editsMonthStart)
        )

        do {
            try await supabase.database
                .from("user_profiles")
                .insert(row)
                .execute()

            Logger.info("User profile created successfully", category: Logger.network)
        } catch {
            Logger.error("Failed to create user profile: \(error.localizedDescription)", category: Logger.network)
            throw SupabaseError.databaseError(error.localizedDescription)
        }
    }

    /// Load user profile from database
    private func loadUserProfile(userId: String) async throws {
        Logger.info("Loading user profile from database: \(userId)", category: Logger.network)

        struct UserProfileRow: Decodable {
            let id: String
            let role_type: String
            let subscription_tier: String
            let edits_this_month: Int
            let edits_month_start: String
            let created_at: String
        }

        do {
            let response: UserProfileRow = try await supabase.database
                .from("user_profiles")
                .select()
                .eq("id", value: userId)
                .single()
                .execute()
                .value

            let dateFormatter = ISO8601DateFormatter()
            let profile = UserProfile(
                id: response.id,
                roleType: RoleType(rawValue: response.role_type) ?? .explorer,
                subscriptionTier: SubscriptionTier(rawValue: response.subscription_tier) ?? .free,
                editsThisMonth: response.edits_this_month,
                editsMonthStart: dateFormatter.date(from: response.edits_month_start) ?? Date(),
                createdAt: dateFormatter.date(from: response.created_at) ?? Date()
            )

            self.currentUserProfile = profile
            saveUserProfile(profile)

            Logger.info("User profile loaded successfully", category: Logger.network)
        } catch {
            Logger.error("Failed to load user profile: \(error.localizedDescription)", category: Logger.network)
            throw SupabaseError.databaseError(error.localizedDescription)
        }
    }

    /// Update user profile
    func updateUserProfile(roleType: RoleType? = nil, subscriptionTier: SubscriptionTier? = nil) async throws {
        guard var profile = currentUserProfile else {
            throw SupabaseError.notAuthenticated
        }

        Logger.info("Updating user profile: \(profile.id)", category: Logger.network)

        if let roleType = roleType {
            profile.roleType = roleType
        }

        if let subscriptionTier = subscriptionTier {
            profile.subscriptionTier = subscriptionTier
        }

        // Update in database
        struct UpdateData: Encodable {
            let role_type: String?
            let subscription_tier: String?
        }

        let updateData = UpdateData(
            role_type: roleType?.rawValue,
            subscription_tier: subscriptionTier?.rawValue
        )

        do {
            try await supabase.database
                .from("user_profiles")
                .update(updateData)
                .eq("id", value: profile.id)
                .execute()

            Logger.info("User profile updated successfully", category: Logger.network)

            // Update local cache
            currentUserProfile = profile
            saveUserProfile(profile)

            NotificationCenter.default.post(name: Constants.NotificationName.userProfileUpdated, object: profile)
        } catch {
            Logger.error("Failed to update user profile: \(error.localizedDescription)", category: Logger.network)
            throw SupabaseError.databaseError(error.localizedDescription)
        }
    }

    /// Increment edit count for current month
    func incrementEditCount() async throws {
        guard let profile = currentUserProfile else {
            throw SupabaseError.notAuthenticated
        }

        Logger.info("Incrementing edit count for user: \(profile.id)", category: Logger.network)

        do {
            // Call the Supabase function that handles monthly reset logic
            try await supabase.database.rpc("increment_edit_count", params: ["user_uuid": profile.id]).execute()

            // Reload profile to get updated count
            try await loadUserProfile(userId: profile.id)

            Logger.info("Edit count incremented successfully", category: Logger.network)
        } catch {
            Logger.error("Failed to increment edit count: \(error.localizedDescription)", category: Logger.network)
            throw SupabaseError.databaseError(error.localizedDescription)
        }
    }

    /// Check if user has edits remaining
    func checkEditQuota() throws -> Bool {
        guard let profile = currentUserProfile else {
            throw SupabaseError.notAuthenticated
        }

        return profile.hasEditsRemaining
    }

    // MARK: - Image Processing

    /// Process edit request via Supabase Edge Function
    func processEdit(command: String, image: UIImage) async throws -> EditResponse {
        guard let profile = currentUserProfile else {
            throw SupabaseError.notAuthenticated
        }

        // Check quota first
        guard profile.hasEditsRemaining else {
            throw SupabaseError.quotaExceeded
        }

        // Compress image
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw SupabaseError.imageProcessingFailed
        }

        let base64Image = imageData.base64EncodedString()

        Logger.info("Calling process-edit edge function", category: Logger.network)

        // Create request payload
        let requestBody: [String: Any] = [
            "user_id": profile.id,
            "command_text": command,
            "image_base64": base64Image,
            "user_tier": profile.subscriptionTier.rawValue
        ]

        do {
            // Call edge function
            let response = try await supabase.functions.invoke(
                "process-edit",
                options: FunctionInvokeOptions(body: requestBody)
            )

            // Decode response
            guard let jsonData = response.data else {
                throw SupabaseError.imageProcessingFailed
            }

            let decoder = JSONDecoder()
            let editResponse = try decoder.decode(EditResponse.self, from: jsonData)

            Logger.info("Edit completed: \(editResponse.editsRemaining ?? 0) edits remaining", category: Logger.network)

            // Reload user profile to get updated quota
            try? await loadUserProfile(userId: profile.id)

            return editResponse
        } catch {
            Logger.error("Failed to process edit: \(error.localizedDescription)", category: Logger.network)
            throw SupabaseError.imageProcessingFailed
        }
    }

    // MARK: - Templates

    /// Fetch templates for user's role
    func fetchTemplates(for roleType: RoleType) async throws -> [Template] {
        Logger.info("Fetching templates for role: \(roleType.rawValue)", category: Logger.network)

        struct TemplateRow: Decodable {
            let id: String
            let name: String
            let description: String?
            let prompt_text: String
            let role_tags: [String]
            let category: String
            let preview_url: String?
            let usage_count: Int
        }

        do {
            let response: [TemplateRow] = try await supabase.database
                .from("templates")
                .select()
                .eq("is_active", value: true)
                .execute()
                .value

            let templates = response.compactMap { row -> Template? in
                guard let category = TemplateCategory(rawValue: row.category) else {
                    return nil
                }

                let roleTags = row.role_tags.compactMap { RoleType(rawValue: $0) }

                return Template(
                    id: row.id,
                    name: row.name,
                    description: row.description ?? "",
                    promptText: row.prompt_text,
                    roleTags: roleTags,
                    category: category,
                    previewUrl: row.preview_url,
                    usageCount: row.usage_count,
                    isActive: true
                )
            }

            // Filter by role
            let filteredTemplates = templates.filter { $0.isAvailableFor(role: roleType) }

            Logger.info("Fetched \(filteredTemplates.count) templates", category: Logger.network)
            return filteredTemplates
        } catch {
            Logger.error("Failed to fetch templates: \(error.localizedDescription)", category: Logger.network)
            // Fallback to local templates
            Logger.info("Falling back to local templates", category: Logger.network)
            return Template.samples.filter { $0.isAvailableFor(role: roleType) }
        }
    }

    /// Increment template usage count
    func incrementTemplateUsage(templateId: String) async throws {
        Logger.info("Incrementing usage count for template: \(templateId)", category: Logger.network)

        do {
            struct UpdateData: Encodable {
                let usage_count: Int
            }

            // Increment usage_count in database
            try await supabase.database
                .from("templates")
                .update(["usage_count": "usage_count + 1"])
                .eq("id", value: templateId)
                .execute()

            Logger.info("Template usage count incremented", category: Logger.network)
        } catch {
            Logger.error("Failed to increment template usage: \(error.localizedDescription)", category: Logger.network)
            // Non-critical error, don't throw
        }
    }

    // MARK: - Brand Kits

    /// Fetch brand kits for current user
    func fetchBrandKits() async throws -> [BrandKit] {
        guard let profile = currentUserProfile else {
            throw SupabaseError.notAuthenticated
        }

        // TODO: Fetch from Supabase database
        return []
    }

    /// Upload brand kit logo
    func uploadBrandKitLogo(name: String, logoImage: UIImage) async throws -> BrandKit {
        guard let profile = currentUserProfile else {
            throw SupabaseError.notAuthenticated
        }

        // Check tier limits
        let existingKits = try await fetchBrandKits()
        if existingKits.count >= profile.subscriptionTier.brandKitLimit {
            throw SupabaseError.brandKitLimitReached
        }

        // TODO: Upload image to Supabase Storage
        // TODO: Create brand_kit record in database

        throw SupabaseError.notImplemented
    }

    // MARK: - Edit History

    /// Fetch edit history for current user
    func fetchEditHistory(limit: Int = 50) async throws -> [EditSession] {
        guard currentUserProfile != nil else {
            throw SupabaseError.notAuthenticated
        }

        // TODO: Fetch from Supabase database
        return []
    }

    // MARK: - Local Storage Helpers

    private func loadLocalUser() {
        if let userID = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.localUserID) {
            self.anonymousUserID = userID
            self.isAuthenticated = true

            // Load user profile from UserDefaults
            if let profile: UserProfile = UserDefaults.standard.codable(forKey: "userProfile") {
                self.currentUserProfile = profile
            }
        }
    }

    private func saveUserProfile(_ profile: UserProfile) {
        UserDefaults.standard.setCodable(profile, forKey: "userProfile")
    }
}

// MARK: - Error Types
enum SupabaseError: LocalizedError {
    case notAuthenticated
    case authenticationFailed(String)
    case databaseError(String)
    case quotaExceeded
    case imageProcessingFailed
    case brandKitLimitReached
    case notImplemented

    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "You must be signed in to perform this action."
        case .authenticationFailed(let message):
            return "Authentication failed: \(message)"
        case .databaseError(let message):
            return "Database error: \(message)"
        case .quotaExceeded:
            return "You've used all your free edits this month. Upgrade to Pro for unlimited edits."
        case .imageProcessingFailed:
            return "Failed to process image. Please try again."
        case .brandKitLimitReached:
            return "You've reached your brand kit limit. Upgrade to add more."
        case .notImplemented:
            return "This feature is coming soon."
        }
    }
}
