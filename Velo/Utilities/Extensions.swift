//
//  Extensions.swift
//  Velo
//
//  Created by Ky Vu on 12/9/25.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - View Extensions
extension View {
    /// Apply a gradient background
    func gradientBackground(_ colors: [Color], startPoint: UnitPoint = .top, endPoint: UnitPoint = .bottom) -> some View {
        self.background(
            LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
        )
    }

    /// Card style with background and border
    func cardStyle(background: Color = Constants.Colors.backgroundCard,
                   cornerRadius: CGFloat = Constants.CornerRadius.lg,
                   borderColor: Color = Constants.Colors.borderLight) -> some View {
        self
            .padding()
            .background(background)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: 1)
            )
    }

    /// Haptic feedback on tap
    func hapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.onTapGesture {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
        }
    }
}

// MARK: - Color Extensions
extension Color {
    /// Create color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - String Extensions
extension String {
    /// Truncate string to max length
    func truncated(to length: Int, trailing: String = "...") -> String {
        if self.count > length {
            return String(self.prefix(length)) + trailing
        }
        return self
    }

    /// Check if string is valid email
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }

    // SEC-4 Fix: Input validation and sanitization for AI commands

    /// Sanitize string for AI processing
    /// Removes potential injection patterns and limits length
    var sanitizedForAI: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "<", with: "")
            .replacingOccurrences(of: ">", with: "")
            .replacingOccurrences(of: "{", with: "")
            .replacingOccurrences(of: "}", with: "")
            .prefix(500)
            .description
    }

    /// Check if string is a valid edit command
    var isValidEditCommand: Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed.count >= 3 && trimmed.count <= 500
    }
}

// MARK: - UIImage Extensions
extension UIImage {
    /// Resize image to max dimension while maintaining aspect ratio
    func resized(to maxDimension: CGFloat) -> UIImage? {
        let scale = min(maxDimension / size.width, maxDimension / size.height)
        if scale >= 1 { return self } // Don't upscale

        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    /// Convert to JPEG data with compression
    func jpegData(maxSizeMB: Int = Constants.App.maxImageSizeMB) -> Data? {
        var compression: CGFloat = 0.8
        var data = self.jpegData(compressionQuality: compression)

        while let imageData = data, imageData.count > maxSizeMB * 1024 * 1024, compression > 0.1 {
            compression -= 0.1
            data = self.jpegData(compressionQuality: compression)
        }

        return data
    }

    /// Add watermark to image
    func withWatermark(text: String = Constants.App.watermarkText,
                       opacity: CGFloat = Constants.App.watermarkOpacity) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            // Draw original image
            self.draw(at: .zero)

            // Configure watermark text
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16, weight: .medium),
                .foregroundColor: UIColor.white.withAlphaComponent(opacity)
            ]

            let attributedText = NSAttributedString(string: text, attributes: attributes)
            let textSize = attributedText.size()

            // Position at bottom-right corner with padding
            let padding: CGFloat = 16
            let textRect = CGRect(
                x: size.width - textSize.width - padding,
                y: size.height - textSize.height - padding,
                width: textSize.width,
                height: textSize.height
            )

            // Draw watermark
            attributedText.draw(in: textRect)
        }
    }
}

// MARK: - Date Extensions
extension Date {
    /// Format date for display
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

    /// Check if date is today
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// Check if date is in current month
    var isThisMonth: Bool {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let dateMonth = calendar.component(.month, from: self)
        let currentYear = calendar.component(.year, from: Date())
        let dateYear = calendar.component(.year, from: self)
        return currentMonth == dateMonth && currentYear == dateYear
    }
}

// MARK: - UserDefaults Extensions
extension UserDefaults {
    /// Save Codable object
    func setCodable<T: Codable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            set(encoded, forKey: key)
        }
    }

    /// Retrieve Codable object
    func codable<T: Codable>(forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
}
