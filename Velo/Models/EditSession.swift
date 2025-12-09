//
//  EditSession.swift
//  Velo
//
//  Created by Ky Vu on 12/9/25.
//

import Foundation
import UIKit

/// AI model type used for editing
enum AIModelType: String, Codable {
    case base = "base" // $0.02/image - Simple edits
    case pro = "pro"   // $0.12-0.24/image - Complex edits

    var estimatedCost: Decimal {
        switch self {
        case .base: return 0.02
        case .pro: return 0.12
        }
    }
}

/// Edit session model (syncs with Supabase edits table)
struct EditSession: Codable, Identifiable {
    let id: String // UUID
    let userId: String
    let createdAt: Date
    let commandText: String
    var originalImageUrl: String? // Only if synced to cloud
    var editedImageUrl: String?
    var modelUsed: AIModelType
    var processingTimeMs: Int?
    var costUsd: Decimal?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case createdAt = "created_at"
        case commandText = "command_text"
        case originalImageUrl = "original_image_url"
        case editedImageUrl = "edited_image_url"
        case modelUsed = "model_used"
        case processingTimeMs = "processing_time_ms"
        case costUsd = "cost_usd"
    }
}

/// Local edit history item (stored in CoreData)
struct LocalEditHistory: Identifiable {
    let id: UUID
    let timestamp: Date
    let commandText: String
    let localImageIdentifier: String // iOS Photos library identifier
    let editedImageData: Data? // Cached edited image
    let modelUsed: AIModelType
}

/// Edit request payload for backend API
struct EditRequest: Codable {
    let userId: String
    let commandText: String
    let imageBase64: String
    let userTier: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case commandText = "command_text"
        case imageBase64 = "image_base64"
        case userTier = "user_tier"
    }
}

/// Edit response from backend API
struct EditResponse: Codable {
    let success: Bool
    let editedImageUrl: String?
    let editsRemaining: Int?
    let modelUsed: String?
    let processingTimeMs: Int?
    let error: String?

    enum CodingKeys: String, CodingKey {
        case success
        case editedImageUrl = "edited_image_url"
        case editsRemaining = "edits_remaining"
        case modelUsed = "model_used"
        case processingTimeMs = "processing_time_ms"
        case error
    }
}
