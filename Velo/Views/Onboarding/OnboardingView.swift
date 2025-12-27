//
//  OnboardingView.swift
//  Velo
//
//  Created by Ky Vu on 12/9/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showRoleSelection = false

    let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "mic.fill",
            title: "Just Talk",
            description: "Tell Velo what you want. No complicated menus or confusing sliders.",
            examples: ["Make the sky bluer", "Fix my kid's closed eyes", "Brighten this photo"]
        ),
        OnboardingPage(
            icon: "sparkles",
            title: "AI Does the Work",
            description: "Advanced AI understands your request and edits your photo professionally.",
            examples: ["Remove background", "Make me look taller", "Add more contrast"]
        ),
        OnboardingPage(
            icon: "bolt.fill",
            title: "Fast & Simple",
            description: "Get stunning results in seconds. Edit one photo or batch process hundreds.",
            examples: ["Enhance all photos", "Make them Instagram-ready", "Fix lighting"]
        )
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color.blue.opacity(0.3)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Skip Button
                HStack {
                    Spacer()
                    Button("Skip") {
                        showRoleSelection = true
                    }
                    .foregroundColor(.white.opacity(0.7))
                    .padding()
                }

                Spacer()

                // Page Content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 500)

                // Page Indicators
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.blue : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.top, 20)

                Spacer()

                // Continue Button
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        showRoleSelection = true
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.blue, Color.cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showRoleSelection) {
            RoleSelectionView()
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 30) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.3), Color.cyan.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)

                Image(systemName: page.icon)
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }

            // Title & Description
            VStack(spacing: 12) {
                Text(page.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)

                Text(page.description)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }

            // Example Commands
            VStack(spacing: 12) {
                Text("Try saying:")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                    .textCase(.uppercase)
                    .tracking(1.2)

                VStack(spacing: 10) {
                    ForEach(page.examples, id: \.self) { example in
                        ExampleCommandPill(text: example)
                    }
                }
            }
            .padding(.top, 20)
        }
    }
}

struct ExampleCommandPill: View {
    let text: String

    var body: some View {
        HStack {
            Image(systemName: "quote.bubble")
                .font(.caption)
                .foregroundColor(.blue)

            Text("\"\(text)\"")
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let examples: [String]
}

#Preview {
    OnboardingView()
}
