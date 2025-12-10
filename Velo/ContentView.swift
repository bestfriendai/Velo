//
//  ContentView.swift
//  Velo
//
//  Created by Ky Vu on 12/6/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedMockup: MockupScreen?

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.black, Color.blue.opacity(0.2)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Velo")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)

                        Text("UI Mockup Gallery")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.7))

                        Text("Tap any screen to preview")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.top, 40)

                    // Mockup Buttons
                    ScrollView {
                        VStack(spacing: 16) {
                            MockupButton(
                                title: "Onboarding Flow",
                                description: "3-screen intro with examples",
                                icon: "hand.wave.fill",
                                gradient: [Color.blue, Color.cyan]
                            ) {
                                selectedMockup = .onboarding
                            }

                            MockupButton(
                                title: "Role Selection",
                                description: "Customize experience by user type",
                                icon: "person.3.fill",
                                gradient: [Color.purple, Color.pink]
                            ) {
                                selectedMockup = .roleSelection
                            }

                            MockupButton(
                                title: "Home/Gallery",
                                description: "Recent edits, templates & community",
                                icon: "square.grid.2x2.fill",
                                gradient: [Color.green, Color.mint]
                            ) {
                                selectedMockup = .home
                            }

                            MockupButton(
                                title: "Editing Interface",
                                description: "Main chat-based editing screen",
                                icon: "bubble.left.and.bubble.right.fill",
                                gradient: [Color.orange, Color.red]
                            ) {
                                selectedMockup = .editing
                            }
                        }
                        .padding(.horizontal, 20)
                    }

                    Spacer()

                    // Footer
                    Text("Built with SwiftUI • Voice-First Photo Editor")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.4))
                        .padding(.bottom, 20)
                }
            }
            .fullScreenCover(item: $selectedMockup) { screen in
                Group {
                    switch screen {
                    case .onboarding:
                        OnboardingView()
                    case .roleSelection:
                        RoleSelectionView()
                    case .home:
                        HomeView(userRole: OldUserRole(
                            id: "parent",
                            icon: "person.2.fill",
                            title: "Parent",
                            description: "Perfect family photos",
                            features: ["Fix closed eyes", "Group photo touch-ups", "Event highlights"],
                            gradient: [Color.pink, Color.orange]
                        ))
                    case .editing:
                        EditingInterfaceView()
                    }
                }
            }
        }
    }
}

struct MockupButton: View {
    let title: String
    let description: String
    let icon: String
    let gradient: [Color]
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)

                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

enum MockupScreen: Identifiable {
    case onboarding
    case roleSelection
    case home
    case editing

    var id: String {
        switch self {
        case .onboarding: return "onboarding"
        case .roleSelection: return "roleSelection"
        case .home: return "home"
        case .editing: return "editing"
        }
    }
}

#Preview {
    ContentView()
}
