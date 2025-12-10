//
//  LegacyModels.swift
//  Velo
//
//  Created by Ky Vu on 12/9/25.
//

import Foundation
import SwiftUI

// MARK: - Legacy Models for Backward Compatibility

/// Old UserRole struct for backward compatibility with existing HomeView
/// TODO: Remove once HomeView is refactored to use RoleType enum
struct OldUserRole: Identifiable {
    let id: String
    let icon: String
    let title: String
    let description: String
    let features: [String]
    let gradient: [Color]
}
