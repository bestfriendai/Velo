//
//  AccessibilityModifiers.swift
//  Velo
//
//  UX-1 Fix: Accessibility labels and modifiers
//

import SwiftUI

// MARK: - Accessibility View Extension

extension View {
    /// Make a button accessible with label and hint
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

    /// Make an image accessible
    func accessibleImage(label: String, isDecorative: Bool = false) -> some View {
        if isDecorative {
            return self.accessibilityHidden(true)
                .eraseToAnyView()
        } else {
            return self
                .accessibilityLabel(label)
                .accessibilityAddTraits(.isImage)
                .eraseToAnyView()
        }
    }

    /// Make a header accessible
    func accessibleHeader(_ label: String) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityAddTraits(.isHeader)
    }

    /// Group children for accessibility
    func accessibilityGrouped(label: String? = nil) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label ?? "")
    }

    /// Type eraser for conditional modifiers
    private func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

// MARK: - Voice Button Accessibility

struct VoiceButtonAccessibility: ViewModifier {
    let isRecording: Bool
    let isProcessing: Bool

    func body(content: Content) -> some View {
        content
            .accessibilityLabel(accessibilityLabel)
            .accessibilityHint(accessibilityHint)
            .accessibilityAddTraits(.isButton)
            .accessibilityRemoveTraits(isProcessing ? .isButton : [])
            .accessibilityValue(isRecording ? "Recording" : "")
    }

    private var accessibilityLabel: String {
        if isProcessing {
            return "Voice button disabled, processing"
        }
        return isRecording ? "Stop recording" : "Start voice recording"
    }

    private var accessibilityHint: String {
        if isProcessing {
            return "Wait for processing to complete"
        }
        return "Double tap to \(isRecording ? "stop" : "start") voice input"
    }
}

extension View {
    /// Apply voice button accessibility
    func voiceButtonAccessibility(isRecording: Bool, isProcessing: Bool) -> some View {
        modifier(VoiceButtonAccessibility(isRecording: isRecording, isProcessing: isProcessing))
    }
}

// MARK: - Role Card Accessibility

struct RoleCardAccessibility: ViewModifier {
    let roleTitle: String
    let roleDescription: String
    let isSelected: Bool

    func body(content: Content) -> some View {
        content
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(roleTitle). \(roleDescription)")
            .accessibilityHint("Double tap to select this role")
            .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
            .accessibilityValue(isSelected ? "Selected" : "")
    }
}

extension View {
    /// Apply role card accessibility
    func roleCardAccessibility(title: String, description: String, isSelected: Bool) -> some View {
        modifier(RoleCardAccessibility(roleTitle: title, roleDescription: description, isSelected: isSelected))
    }
}

// MARK: - Template Card Accessibility

struct TemplateCardAccessibility: ViewModifier {
    let templateName: String
    let templateDescription: String

    func body(content: Content) -> some View {
        content
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(templateName). \(templateDescription)")
            .accessibilityHint("Double tap to apply this template")
            .accessibilityAddTraits(.isButton)
    }
}

extension View {
    /// Apply template card accessibility
    func templateCardAccessibility(name: String, description: String) -> some View {
        modifier(TemplateCardAccessibility(templateName: name, templateDescription: description))
    }
}

// MARK: - Chat Message Accessibility

struct ChatMessageAccessibility: ViewModifier {
    let message: String
    let isUser: Bool

    func body(content: Content) -> some View {
        content
            .accessibilityLabel("\(isUser ? "You said" : "Velo said"): \(message)")
    }
}

extension View {
    /// Apply chat message accessibility
    func chatMessageAccessibility(message: String, isUser: Bool) -> some View {
        modifier(ChatMessageAccessibility(message: message, isUser: isUser))
    }
}

// MARK: - Scaled Metric for Dynamic Type (UX-5 Fix)

/// Custom font sizes that scale with Dynamic Type
struct ScaledFont: ViewModifier {
    @ScaledMetric var size: CGFloat
    let weight: Font.Weight

    init(size: CGFloat, relativeTo textStyle: Font.TextStyle = .body, weight: Font.Weight = .regular) {
        _size = ScaledMetric(wrappedValue: size, relativeTo: textStyle)
        self.weight = weight
    }

    func body(content: Content) -> some View {
        content.font(.system(size: size, weight: weight))
    }
}

extension View {
    /// Apply a scaled font that respects Dynamic Type
    func scaledFont(size: CGFloat, relativeTo textStyle: Font.TextStyle = .body, weight: Font.Weight = .regular) -> some View {
        modifier(ScaledFont(size: size, relativeTo: textStyle, weight: weight))
    }
}

// MARK: - Adaptive Colors for High Contrast

extension Color {
    /// Returns a color adapted for accessibility
    func accessibilityAdapted(highContrast: Color) -> Color {
        // In a real implementation, check for high contrast mode
        // For now, return self
        return self
    }
}
