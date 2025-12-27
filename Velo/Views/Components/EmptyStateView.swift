//
//  EmptyStateView.swift
//  Velo
//
//  UX-4 Fix: Empty state component for lists
//

import SwiftUI

/// Reusable empty state view for empty lists and content areas
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?

    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: Constants.Spacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))
                .accessibilityHidden(true)

            VStack(spacing: Constants.Spacing.sm) {
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
                Button(action: {
                    HapticManager.mediumImpact()
                    action()
                }) {
                    Text(actionTitle)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                colors: [Color.blue, Color.cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(Constants.CornerRadius.md)
                }
                .accessibilityLabel(actionTitle)
                .accessibilityHint("Double tap to \(actionTitle.lowercased())")
            }
        }
        .padding(Constants.Spacing.xxl)
        .accessibilityElement(children: .contain)  // Use .contain to keep button accessible
    }
}

// MARK: - Preset Empty States

extension EmptyStateView {
    /// Empty state for no recent edits
    static func noRecentEdits(action: @escaping () -> Void) -> EmptyStateView {
        EmptyStateView(
            icon: "photo.on.rectangle.angled",
            title: "No edits yet",
            message: "Start by selecting a photo and telling Velo what you'd like to change.",
            actionTitle: "Start Editing",
            action: action
        )
    }

    /// Empty state for no templates found
    static func noTemplates(action: (() -> Void)? = nil) -> EmptyStateView {
        EmptyStateView(
            icon: "doc.text.magnifyingglass",
            title: "No templates found",
            message: "We couldn't find any templates matching your search.",
            actionTitle: action != nil ? "Clear Search" : nil,
            action: action
        )
    }

    /// Empty state for empty community feed
    static func noCommunityPosts() -> EmptyStateView {
        EmptyStateView(
            icon: "person.3.fill",
            title: "Community coming soon",
            message: "Share your edits and discover inspiration from other Velo users.",
            actionTitle: nil,
            action: nil
        )
    }

    /// Empty state for no brand kits
    static func noBrandKits(action: @escaping () -> Void) -> EmptyStateView {
        EmptyStateView(
            icon: "briefcase.fill",
            title: "No brand kits",
            message: "Create a brand kit to quickly apply your logo and colors to photos.",
            actionTitle: "Create Brand Kit",
            action: action
        )
    }

    /// Empty state for network error
    static func networkError(action: @escaping () -> Void) -> EmptyStateView {
        EmptyStateView(
            icon: "wifi.exclamationmark",
            title: "Connection issue",
            message: "We couldn't load the content. Please check your connection.",
            actionTitle: "Try Again",
            action: action
        )
    }

    /// Empty state for quota exceeded
    static func quotaExceeded(action: @escaping () -> Void) -> EmptyStateView {
        EmptyStateView(
            icon: "exclamationmark.triangle.fill",
            title: "Monthly limit reached",
            message: "You've used all 5 free edits this month. Upgrade for unlimited edits.",
            actionTitle: "Upgrade to Pro",
            action: action
        )
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        ScrollView {
            VStack(spacing: 40) {
                EmptyStateView.noRecentEdits(action: {})
                EmptyStateView.noTemplates()
                EmptyStateView.networkError(action: {})
            }
        }
    }
}
