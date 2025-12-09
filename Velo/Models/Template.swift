//
//  Template.swift
//  Velo
//
//  Created by Ky Vu on 12/9/25.
//

import Foundation

/// Template category for organization
enum TemplateCategory: String, Codable, CaseIterable {
    case quickFixes = "quick_fixes"
    case backgrounds = "backgrounds"
    case business = "business"
    case seasonal = "seasonal"

    var displayName: String {
        switch self {
        case .quickFixes: return "Quick Fixes"
        case .backgrounds: return "Backgrounds"
        case .business: return "Business"
        case .seasonal: return "Seasonal"
        }
    }
}

/// Template model (syncs with Supabase templates table)
struct Template: Codable, Identifiable {
    let id: String // UUID
    let name: String
    let description: String
    let promptText: String
    let roleTags: [RoleType] // Which user roles see this template
    let category: TemplateCategory
    var previewUrl: String?
    var usageCount: Int
    var isActive: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case promptText = "prompt_text"
        case roleTags = "role_tags"
        case category
        case previewUrl = "preview_url"
        case usageCount = "usage_count"
        case isActive = "is_active"
    }

    /// Check if template is available for given role
    func isAvailableFor(role: RoleType) -> Bool {
        return isActive && (roleTags.isEmpty || roleTags.contains(role))
    }
}

/// Sample templates for MVP (before Supabase is set up)
extension Template {
    static let samples: [Template] = [
        // Quick Fixes
        Template(
            id: UUID().uuidString,
            name: "Fix Closed Eyes",
            description: "Open eyes in photos where someone blinked",
            promptText: "Open the closed eyes in this photo naturally",
            roleTags: [.parent, .salon, .explorer],
            category: .quickFixes,
            previewUrl: nil,
            usageCount: 0,
            isActive: true
        ),
        Template(
            id: UUID().uuidString,
            name: "Remove Red Eyes",
            description: "Fix red eye from camera flash",
            promptText: "Remove red eye effect from this photo",
            roleTags: [.parent, .explorer],
            category: .quickFixes,
            previewUrl: nil,
            usageCount: 0,
            isActive: true
        ),
        Template(
            id: UUID().uuidString,
            name: "Brighten Photo",
            description: "Enhance overall brightness naturally",
            promptText: "Brighten this photo naturally without overexposing",
            roleTags: [], // Available to all
            category: .quickFixes,
            previewUrl: nil,
            usageCount: 0,
            isActive: true
        ),
        Template(
            id: UUID().uuidString,
            name: "Professional Lighting",
            description: "Enhance lighting for professional look",
            promptText: "Enhance the lighting to look professional and natural",
            roleTags: [.salon, .realtor, .business],
            category: .quickFixes,
            previewUrl: nil,
            usageCount: 0,
            isActive: true
        ),

        // Backgrounds
        Template(
            id: UUID().uuidString,
            name: "Beach Sunset",
            description: "Change background to beach at sunset",
            promptText: "Change the background to a beautiful beach sunset scene, keeping the subject natural",
            roleTags: [.parent, .explorer],
            category: .backgrounds,
            previewUrl: nil,
            usageCount: 0,
            isActive: true
        ),
        Template(
            id: UUID().uuidString,
            name: "Studio White",
            description: "Clean white studio background",
            promptText: "Replace background with clean white studio background",
            roleTags: [.salon, .business],
            category: .backgrounds,
            previewUrl: nil,
            usageCount: 0,
            isActive: true
        ),
        Template(
            id: UUID().uuidString,
            name: "Blur Background",
            description: "Blur background for portrait effect",
            promptText: "Blur the background while keeping the subject sharp, creating a professional portrait effect",
            roleTags: [], // Available to all
            category: .backgrounds,
            previewUrl: nil,
            usageCount: 0,
            isActive: true
        ),
        Template(
            id: UUID().uuidString,
            name: "Remove Background",
            description: "Remove background completely",
            promptText: "Remove the background completely, leaving only the subject with transparent background",
            roleTags: [.salon, .business],
            category: .backgrounds,
            previewUrl: nil,
            usageCount: 0,
            isActive: true
        ),

        // Business Templates
        Template(
            id: UUID().uuidString,
            name: "Salon Before/After",
            description: "Create side-by-side transformation",
            promptText: "Create a professional before/after side-by-side comparison suitable for salon social media",
            roleTags: [.salon],
            category: .business,
            previewUrl: nil,
            usageCount: 0,
            isActive: true
        ),
        Template(
            id: UUID().uuidString,
            name: "Real Estate Ready",
            description: "Perfect for property listings",
            promptText: "Enhance this property photo: brighten interior, improve lighting, make it look professional for real estate listing",
            roleTags: [.realtor],
            category: .business,
            previewUrl: nil,
            usageCount: 0,
            isActive: true
        ),
        Template(
            id: UUID().uuidString,
            name: "Fix Overhead Lighting",
            description: "Correct harsh overhead lights",
            promptText: "Fix harsh overhead fluorescent lighting, make the lighting look natural and flattering",
            roleTags: [.salon, .business],
            category: .business,
            previewUrl: nil,
            usageCount: 0,
            isActive: true
        ),
        Template(
            id: UUID().uuidString,
            name: "Instagram-Ready",
            description: "Optimize for social media",
            promptText: "Make this photo Instagram-ready: enhance colors, improve composition, make it eye-catching while keeping it natural",
            roleTags: [.salon, .business],
            category: .business,
            previewUrl: nil,
            usageCount: 0,
            isActive: true
        )
    ]
}
