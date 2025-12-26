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
    @Published var configurationError: Bool = false  // P0-2 Fix: Track configuration state

    // MARK: - Private Properties
    private var supabase: SupabaseClient?  // P0-2 Fix: Made optional for graceful handling
    private var authToken: String?
    private var anonymousUserID: String?

    // MARK: - Initialization
    private init() {
        // P0-2 Fix: Handle missing credentials gracefully instead of fatalError
        guard Secrets.isConfigured,
              let url = URL(string: Constants.API.supabaseURL),
              !Constants.API.supabaseAnonKey.isEmpty else {
            Logger.fault("Supabase credentials not configured", category: Logger.network)
            self.configurationError = true
            self.supabase = nil
            return
        }

        self.supabase = SupabaseClient(
            supabaseURL: url,
            supabaseKey: Constants.API.supabaseAnonKey
        )
        self.configurationError = false

        Logger.info("Supabase client initialized", category: Logger.network)

        // Load cached user data
        loadLocalUser()

        // Set up auth state listener
        Task {
            await setupAuthStateListener()
        }
    }

    // MARK: - Configuration Check

    /// Ensure Supabase client is available before operations
    private func requireClient() throws -> SupabaseClient {
        guard let client = supabase else {
            throw SupabaseError.configurationError(Secrets.configurationError ?? "Supabase not configured")
        }
        return client
    }

    // MARK: - Auth State Listener

    private func setupAuthStateListener() async {
        guard let client = supabase else { return }

        for await state in await client.auth.authStateChanges {
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
        let client = try requireClient()  // P0-2 Fix: Check configuration

        Logger.info("Starting createAnonymousSession()", category: Logger.auth)

        do {
            let session = try await client.auth.signInAnonymously()
            let userId = session.user.id.uuidString

            Logger.info("Sign in success - User ID: \(userId)", category: Logger.auth)
            Logger.info("User is anonymous: \(session.user.isAnonymous)", category: Logger.auth)
            // SEC-3 Fix: Never log tokens, even partially
            Logger.info("Access token exists: \(!session.accessToken.isEmpty)", category: Logger.auth)

            self.anonymousUserID = userId
            self.isAuthenticated = true

            // Cache locally
            UserDefaults.standard.set(userId, forKey: Constants.UserDefaultsKey.localUserID)
            UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.isAnonymousUser)

            Logger.info("Session created and stored. Ready for profile creation.", category: Logger.auth)

            return userId
        } catch let error as NSError {
            Logger.error("Sign in failed - Error code: \(error.code)", category: Logger.auth)
            Logger.error("Sign in failed - \(error.localizedDescription)", category: Logger.auth)

            // If anonymous auth is disabled in Supabase, we'll get an error here
            Logger.error("Possible cause: Anonymous sign-ins NOT enabled in Supabase settings", category: Logger.auth)

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
        let client = try requireClient()
        Logger.info("Signing out user", category: Logger.auth)

        do {
            try await client.auth.signOut()

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
        let client = try requireClient()
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
            // Verify we have an auth session before inserting
            guard let session = try? await client.auth.session else {
                Logger.error("Cannot create profile: No auth session", category: Logger.auth)
                throw SupabaseError.notAuthenticated
            }
            Logger.info("Have auth session for INSERT: \(session.user.id)", category: Logger.auth)

            try await client.database
                .from("user_profiles")
                .insert(row)
                .execute()

            Logger.info("User profile created successfully", category: Logger.network)
        } catch let error as PostgrestError {
            Logger.error("Postgrest error creating profile: \(error.localizedDescription)", category: Logger.network)
            throw SupabaseError.databaseError(error.localizedDescription)
        } catch {
            Logger.error("Failed to create user profile: \(error.localizedDescription)", category: Logger.network)
            throw SupabaseError.databaseError(error.localizedDescription)
        }
    }

    /// Load user profile from database
    private func loadUserProfile(userId: String) async throws {
        guard let client = supabase else { return }  // Silent return if not configured
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
            let response: UserProfileRow = try await client.database
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
        } catch let error as PostgrestError {
            Logger.error("Postgrest error loading profile: \(error.message)", category: Logger.network)
            Logger.debug("This is usually safe to ignore during onboarding", category: Logger.network)
            // Don't throw - this is not critical, profile is already set locally
        } catch {
            Logger.error("Failed to load user profile: \(error.localizedDescription)", category: Logger.network)
            // Don't throw - this is not critical, profile is already set locally
        }
    }

    /// Update user profile (or create if doesn't exist)
    func updateUserProfile(roleType: RoleType? = nil, subscriptionTier: SubscriptionTier? = nil) async throws {
        let client = try requireClient()

        // Verify auth session exists
        guard let session = try? await client.auth.session else {
            Logger.error("No auth session - cannot update profile", category: Logger.auth)
            throw SupabaseError.notAuthenticated
        }

        Logger.info("Auth session verified. User ID: \(session.user.id)", category: Logger.auth)
        // SEC-3 Fix: Never log tokens
        Logger.info("Access token exists: \(!session.accessToken.isEmpty)", category: Logger.auth)

        let userId = session.user.id.uuidString

        // If no profile exists locally, this is the first time - CREATE instead of UPDATE
        if currentUserProfile == nil {
            Logger.info("No existing profile. Creating new profile with selected role.", category: Logger.network)

            let newProfile = UserProfile(
                id: userId,
                roleType: roleType ?? .explorer,
                subscriptionTier: subscriptionTier ?? .free,
                editsThisMonth: 0,
                editsMonthStart: Date(),
                createdAt: Date()
            )

            try await createUserProfile(newProfile)
            self.currentUserProfile = newProfile
            saveUserProfile(newProfile)

            Logger.info("Profile created successfully with role: \(newProfile.roleType.rawValue)", category: Logger.network)
            NotificationCenter.default.post(name: Constants.NotificationName.userProfileUpdated, object: newProfile)
            return
        }

        // P1-4 Fix: Use guard instead of force unwrap
        guard var profile = currentUserProfile else {
            Logger.error("Attempted to update nil profile", category: Logger.network)
            throw SupabaseError.notAuthenticated
        }
        Logger.info("Updating existing profile: \(profile.id)", category: Logger.network)

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
            try await client.database
                .from("user_profiles")
                .update(updateData)
                .eq("id", value: profile.id)
                .execute()

            Logger.info("Profile updated successfully", category: Logger.network)

            // Update local cache
            currentUserProfile = profile
            saveUserProfile(profile)

            NotificationCenter.default.post(name: Constants.NotificationName.userProfileUpdated, object: profile)
        } catch let error as PostgrestError {
            Logger.error("Postgrest error: \(error.message)", category: Logger.network)
            throw SupabaseError.databaseError("Database error: \(error.message)")
        } catch {
            Logger.error("Update failed: \(error.localizedDescription)", category: Logger.network)
            throw SupabaseError.databaseError(error.localizedDescription)
        }
    }

    /// Increment edit count for current month
    func incrementEditCount() async throws {
        let client = try requireClient()

        guard let profile = currentUserProfile else {
            throw SupabaseError.notAuthenticated
        }

        Logger.info("Incrementing edit count for user: \(profile.id)", category: Logger.network)

        do {
            // Call the Supabase function that handles monthly reset logic
            try await client.database.rpc("increment_edit_count", params: ["user_uuid": profile.id]).execute()

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
        let client = try requireClient()

        guard let profile = currentUserProfile else {
            throw SupabaseError.notAuthenticated
        }

        // Check quota first
        guard profile.hasEditsRemaining else {
            throw SupabaseError.quotaExceeded
        }

        // PERF-1 Fix: Process image off main thread
        let base64Image: String
        do {
            base64Image = try await image.base64EncodedJPEGAsync(compressionQuality: 0.8, maxDimension: 2048)
        } catch {
            throw SupabaseError.imageProcessingFailed
        }

        Logger.info("Calling process-edit edge function", category: Logger.network)

        // Create request payload
        struct EditRequest: Encodable {
            let user_id: String
            let command_text: String
            let image_base64: String
            let user_tier: String
        }

        let requestBody = EditRequest(
            user_id: profile.id,
            command_text: command,
            image_base64: base64Image,
            user_tier: profile.subscriptionTier.rawValue
        )

        do {
            // Call edge function and decode response directly
            let editResponse: EditResponse = try await client.functions.invoke(
                "process-edit",
                options: FunctionInvokeOptions(body: requestBody)
            )

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
        guard let client = supabase else {
            // Fallback to local templates if not configured
            Logger.info("Supabase not configured, using local templates", category: Logger.network)
            return Template.samples.filter { $0.isAvailableFor(role: roleType) }
        }

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
            let response: [TemplateRow] = try await client.database
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
        guard let client = supabase else { return }  // Silent return if not configured

        Logger.info("Incrementing usage count for template: \(templateId)", category: Logger.network)

        do {
            // Increment usage_count in database
            try await client.database
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
    case configurationError(String)  // P0-2 Fix: Added for graceful config handling

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
        case .configurationError(let message):
            return "Configuration error: \(message)"
        }
    }
}
