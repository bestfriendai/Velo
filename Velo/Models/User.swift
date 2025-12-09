//
//  User.swift
//  Velo
//
//  Created by Ky Vu on 12/9/25.
//

import Foundation

/// User role types that determine template filtering and personalization
enum RoleType: String, Codable, CaseIterable {
    case parent = "parent"
    case salon = "salon"
    case realtor = "realtor"
    case business = "business"
    case explorer = "explorer"

    var displayName: String {
        switch self {
        case .parent: return "Everyday User"
        case .salon: return "Salon/Beauty Owner"
        case .realtor: return "Real Estate Pro"
        case .business: return "Small Business"
        case .explorer: return "Just Exploring"
        }
    }

    var icon: String {
        switch self {
        case .parent: return "person.2.fill"
        case .salon: return "scissors"
        case .realtor: return "house.fill"
        case .business: return "storefront.fill"
        case .explorer: return "sparkles"
        }
    }

    var description: String {
        switch self {
        case .parent: return "Fix family photos quickly"
        case .salon: return "Professional client photos"
        case .realtor: return "Fast property photo editing"
        case .business: return "Social media content creation"
        case .explorer: return "I want to see what's possible"
        }
    }
}

/// Subscription tier levels
enum SubscriptionTier: String, Codable {
    case free = "free"
    case pro = "pro"
    case business = "business"

    var monthlyEditLimit: Int? {
        switch self {
        case .free: return 5
        case .pro, .business: return nil // Unlimited
        }
    }

    var hasWatermark: Bool {
        switch self {
        case .free: return true
        case .pro, .business: return false
        }
    }

    var canBatchProcess: Bool {
        switch self {
        case .free: return false
        case .pro, .business: return true
        }
    }

    var brandKitLimit: Int {
        switch self {
        case .free: return 0
        case .pro: return 1
        case .business: return 5
        }
    }
}

/// User profile model (syncs with Supabase user_profiles table)
struct UserProfile: Codable, Identifiable {
    let id: String // UUID from Supabase Auth
    var roleType: RoleType
    var subscriptionTier: SubscriptionTier
    var editsThisMonth: Int
    var editsMonthStart: Date
    var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case roleType = "role_type"
        case subscriptionTier = "subscription_tier"
        case editsThisMonth = "edits_this_month"
        case editsMonthStart = "edits_month_start"
        case createdAt = "created_at"
    }

    /// Check if user has edits remaining this month
    var hasEditsRemaining: Bool {
        guard let limit = subscriptionTier.monthlyEditLimit else {
            return true // Unlimited
        }
        return editsThisMonth < limit
    }

    /// Number of edits remaining (nil if unlimited)
    var editsRemaining: Int? {
        guard let limit = subscriptionTier.monthlyEditLimit else {
            return nil // Unlimited
        }
        return max(0, limit - editsThisMonth)
    }

    /// Check if monthly reset is needed
    var needsMonthlyReset: Bool {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let resetMonth = calendar.component(.month, from: editsMonthStart)
        return currentMonth != resetMonth
    }
}
