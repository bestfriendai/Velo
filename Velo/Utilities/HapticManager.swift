//
//  HapticManager.swift
//  Velo
//
//  UX-3 Fix: Haptic feedback manager
//

import UIKit

/// Manager for haptic feedback throughout the app
/// Note: All haptic calls are dispatched to main thread as required by UIKit
enum HapticManager {
    // MARK: - Impact Feedback

    /// Trigger impact feedback
    /// - Parameter style: The style of impact (light, medium, heavy, soft, rigid)
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        DispatchQueue.main.async {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            generator.impactOccurred()
        }
    }

    /// Light impact - for subtle UI interactions
    static func lightImpact() {
        impact(.light)
    }

    /// Medium impact - for button presses
    static func mediumImpact() {
        impact(.medium)
    }

    /// Heavy impact - for significant actions
    static func heavyImpact() {
        impact(.heavy)
    }

    // MARK: - Notification Feedback

    /// Trigger notification feedback
    /// - Parameter type: The type of notification (success, warning, error)
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }

    /// Success notification - for completed actions
    static func success() {
        notification(.success)
    }

    /// Warning notification - for caution situations
    static func warning() {
        notification(.warning)
    }

    /// Error notification - for failed actions
    static func error() {
        notification(.error)
    }

    // MARK: - Selection Feedback

    /// Selection changed feedback - for UI selections
    static func selection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }

    // MARK: - Convenience Methods for App Actions

    /// Haptic for voice button tap
    static func voiceButtonTap() {
        mediumImpact()
    }

    /// Haptic for voice recording start
    static func voiceRecordingStart() {
        heavyImpact()
    }

    /// Haptic for voice recording stop
    static func voiceRecordingStop() {
        mediumImpact()
    }

    /// Haptic for edit completion success
    static func editComplete() {
        success()
    }

    /// Haptic for edit failure
    static func editFailed() {
        error()
    }

    /// Haptic for role selection
    static func roleSelected() {
        selection()
    }

    /// Haptic for suggestion card tap
    static func suggestionTap() {
        lightImpact()
    }

    /// Haptic for tab change
    static func tabChanged() {
        selection()
    }
}
