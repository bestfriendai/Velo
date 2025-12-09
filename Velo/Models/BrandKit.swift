//
//  BrandKit.swift
//  Velo
//
//  Created by Ky Vu on 12/9/25.
//

import Foundation

/// Brand kit model for business users (syncs with Supabase brand_kits table)
struct BrandKit: Codable, Identifiable {
    let id: String // UUID
    let userId: String
    let name: String
    let logoUrl: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case name
        case logoUrl = "logo_url"
        case createdAt = "created_at"
    }
}

/// Logo placement options
enum LogoPlacement: String, CaseIterable {
    case bottomRight = "bottom_right"
    case bottomLeft = "bottom_left"
    case topRight = "top_right"
    case topLeft = "top_left"

    var displayName: String {
        switch self {
        case .bottomRight: return "Bottom Right"
        case .bottomLeft: return "Bottom Left"
        case .topRight: return "Top Right"
        case .topLeft: return "Top Left"
        }
    }
}
