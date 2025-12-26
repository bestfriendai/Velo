//
//  Constants.swift
//  Velo
//
//  Created by Ky Vu on 12/9/25.
//

import Foundation
import SwiftUI

enum Constants {
    // MARK: - API Configuration
    enum API {
        // Supabase - P0-1 Fix: Use Secrets instead of ProcessInfo
        static var supabaseURL: String {
            Secrets.supabaseURL
        }
        static var supabaseAnonKey: String {
            Secrets.supabaseAnonKey
        }

        // Edge Functions
        static let processEditFunctionName = "process-edit"

        // Nano Banana (accessed via backend only)
        // API key stored in Supabase Edge Function environment

        // Endpoints
        static var processEditURL: URL? {
            guard let url = URL(string: supabaseURL) else { return nil }
            return url.appendingPathComponent("functions/v1/\(processEditFunctionName)")
        }
    }

    // MARK: - Component Sizes (CQ-2 Fix: Design Tokens)
    enum ComponentSize {
        // Icons
        static let iconSmall: CGFloat = 40
        static let iconMedium: CGFloat = 60
        static let iconLarge: CGFloat = 70

        // Avatars
        static let avatarSmall: CGFloat = 32
        static let avatarMedium: CGFloat = 48
        static let avatarLarge: CGFloat = 64

        // Buttons
        static let buttonHeight: CGFloat = 48
        static let inputHeight: CGFloat = 44
        static let voiceButtonSize: CGFloat = 70
        static let voiceButtonRingSize: CGFloat = 90

        // Cards
        static let cardImageHeight: CGFloat = 160
        static let chatHeight: CGFloat = 200
        static let photoPreviewSize: CGFloat = 100

        // Role Cards
        static let roleCardIconSize: CGFloat = 60
        static let roleCardWidth: CGFloat = 160
    }

    // MARK: - App Configuration
    enum App {
        static let name = "Velo"
        static let tagline = "The Photo Editor Where You Just Talk"

        // Limits
        static let freeMonthlyEditLimit = 5
        static let maxBatchPhotos = 20
        static let maxImageSizeMB = 10

        // Watermark
        static let watermarkText = "Edited with Velo - Get it free"
        static let watermarkOpacity: CGFloat = 0.3
    }

    // MARK: - Subscription Configuration
    enum Subscription {
        // Product IDs (must match App Store Connect)
        static let proMonthlyProductID = "com.velo.pro.monthly"
        static let proAnnualProductID = "com.velo.pro.annual"
        static let businessMonthlyProductID = "com.velo.business.monthly"
        static let businessAnnualProductID = "com.velo.business.annual"

        // Credit packs
        static let credits10ProductID = "com.velo.credits.10"
        static let credits25ProductID = "com.velo.credits.25"

        // Pricing (for display only)
        static let proMonthlyPrice = "$6.99"
        static let proAnnualPrice = "$59.99"
        static let businessMonthlyPrice = "$14.99"
        static let businessAnnualPrice = "$129.99"
    }

    // MARK: - RevenueCat
    enum RevenueCat {
        // P0-1 Fix: Use Secrets instead of ProcessInfo
        static var apiKey: String {
            Secrets.revenueCatAPIKey
        }
        static let proEntitlementID = "pro"
        static let businessEntitlementID = "business"
    }

    // MARK: - Design System
    enum Colors {
        // Brand Colors
        static let brandBlue = Color.blue
        static let brandCyan = Color.cyan
        static let brandPurple = Color.purple
        static let brandPink = Color.pink
        static let brandGreen = Color.green
        static let brandMint = Color.mint
        static let brandOrange = Color.orange
        static let brandRed = Color.red

        // Gradients
        static let onboardingGradient = [Color.black, Color.blue.opacity(0.2)]
        static let parentGradient = [Color.blue, Color.cyan]
        static let salonGradient = [Color.purple, Color.pink]
        static let realtorGradient = [Color.green, Color.mint]
        static let businessGradient = [Color.orange, Color.red]
        static let explorerGradient = [Color.pink, Color.purple]

        // UI Elements
        static let backgroundDark = Color.black
        static let backgroundCard = Color.white.opacity(0.1)
        static let borderLight = Color.white.opacity(0.2)
        static let textPrimary = Color.white
        static let textSecondary = Color.white.opacity(0.7)
        static let textTertiary = Color.white.opacity(0.5)
    }

    enum Fonts {
        static let largeTitle: CGFloat = 48
        static let title: CGFloat = 34
        static let title2: CGFloat = 28
        static let title3: CGFloat = 22
        static let headline: CGFloat = 17
        static let body: CGFloat = 17
        static let caption: CGFloat = 12
    }

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 40
    }

    enum CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
    }

    // MARK: - Voice Recognition
    enum Voice {
        static let localeIdentifier = "en-US"
        static let recognitionTimeout: TimeInterval = 5.0 // Seconds of silence before ending
        static let maxRecordingDuration: TimeInterval = 30.0 // Maximum recording length
    }

    // MARK: - Analytics Events
    enum AnalyticsEvent {
        static let appOpened = "app_opened"
        static let onboardingStarted = "onboarding_started"
        static let roleSelected = "role_selected"
        static let onboardingCompleted = "onboarding_completed"
        static let photoSelected = "photo_selected"
        static let voiceButtonTapped = "voice_button_tapped"
        static let commandSpoken = "command_spoken"
        static let editStarted = "edit_started"
        static let editCompleted = "edit_completed"
        static let editSaved = "edit_saved"
        static let paywallViewed = "paywall_viewed"
        static let subscriptionPurchased = "subscription_purchased"
        static let subscriptionCancelled = "subscription_cancelled"
        static let templateViewed = "template_viewed"
        static let templateApplied = "template_applied"
    }

    // MARK: - User Defaults Keys
    enum UserDefaultsKey {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let selectedRoleType = "selectedRoleType"
        static let isAnonymousUser = "isAnonymousUser"
        static let localUserID = "localUserID"
        static let editsThisMonth = "editsThisMonth"
        static let lastEditResetDate = "lastEditResetDate"
    }

    // MARK: - Notification Names
    enum NotificationName {
        static let userProfileUpdated = Notification.Name("userProfileUpdated")
        static let subscriptionUpdated = Notification.Name("subscriptionUpdated")
        static let editCompleted = Notification.Name("editCompleted")
        static let quotaExceeded = Notification.Name("quotaExceeded")
    }
}
