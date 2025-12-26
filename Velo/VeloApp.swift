//
//  VeloApp.swift
//  Velo
//
//  Created by Ky Vu on 12/6/25.
//

import SwiftUI

@main
struct VeloApp: App {
    // P0-3: App coordinator manages state and dependencies
    @StateObject private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coordinator)
        }
    }
}
