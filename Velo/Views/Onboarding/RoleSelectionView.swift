//
//  RoleSelectionView.swift
//  Velo
//
//  Created by Ky Vu on 12/9/25.
//

import SwiftUI

struct RoleSelectionView: View {
    @StateObject private var supabaseService = SupabaseService.shared
    @State private var selectedRole: RoleType?
    @State private var showHome = false
    @State private var isLoading = false

    // Role display data
    struct RoleDisplayData {
        let roleType: RoleType
        let features: [String]
    }

    let roleData: [RoleDisplayData] = [
        RoleDisplayData(
            roleType: .parent,
            features: ["Fix closed eyes", "Group photo touch-ups", "Event highlights"]
        ),
        RoleDisplayData(
            roleType: .salon,
            features: ["Before/after transformations", "Professional lighting", "Brand logo placement"]
        ),
        RoleDisplayData(
            roleType: .realtor,
            features: ["Property enhancement", "Batch processing", "Sky replacement"]
        ),
        RoleDisplayData(
            roleType: .business,
            features: ["Product photos", "Social media ready", "Brand consistency"]
        ),
        RoleDisplayData(
            roleType: .explorer,
            features: ["Creative filters", "Quick enhancements", "Easy sharing"]
        )
    ]

    var body: some View {
        ZStack {
            Constants.Colors.backgroundDark.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Text("Who are you?")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Constants.Colors.textPrimary)

                    Text("We'll customize Velo for your needs")
                        .font(.body)
                        .foregroundColor(Constants.Colors.textSecondary)
                }
                .padding(.top, 60)
                .padding(.bottom, 40)

                // Role Cards
                ScrollView {
                    VStack(spacing: Constants.Spacing.md) {
                        ForEach(roleData, id: \.roleType) { data in
                            RoleCard(
                                roleType: data.roleType,
                                features: data.features,
                                isSelected: selectedRole == data.roleType
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedRole = data.roleType
                                    Logger.logEvent(Constants.AnalyticsEvent.roleSelected, parameters: ["role": data.roleType.rawValue])
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Constants.Spacing.lg)
                }

                // Continue Button
                Button(action: continueToApp) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Continue")
                                .font(.headline)
                        }
                    }
                    .foregroundColor(Constants.Colors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        selectedRole != nil ?
                        LinearGradient(
                            colors: gradientForRole(selectedRole!),
                            startPoint: .leading,
                            endPoint: .trailing
                        ) :
                        LinearGradient(
                            colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.3)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(Constants.CornerRadius.lg)
                    .shadow(
                        color: selectedRole != nil ? gradientForRole(selectedRole!)[0].opacity(0.3) : .clear,
                        radius: 10,
                        x: 0,
                        y: 5
                    )
                }
                .disabled(selectedRole == nil || isLoading)
                .padding(.horizontal, 30)
                .padding(.vertical, 30)

                // Skip Option
                Button("Skip for now") {
                    selectedRole = .explorer
                    continueToApp()
                }
                .font(.subheadline)
                .foregroundColor(Constants.Colors.textTertiary)
                .padding(.bottom, 20)
                .disabled(isLoading)
            }
        }
        .fullScreenCover(isPresented: $showHome) {
            // TODO: Replace with actual HomeView using new architecture
            HomeView(userRole: OldUserRole(
                id: selectedRole?.rawValue ?? "explorer",
                icon: selectedRole?.icon ?? "sparkles",
                title: selectedRole?.displayName ?? "Explorer",
                description: selectedRole?.description ?? "",
                features: [],
                gradient: gradientForRole(selectedRole ?? .explorer)
            ))
        }
    }

    // MARK: - Helper Functions

    private func continueToApp() {
        guard let role = selectedRole else { return }

        isLoading = true
        Logger.info("User selected role: \(role.rawValue)", category: Logger.ui)

        Task {
            do {
                // Update user profile with selected role
                try await supabaseService.updateUserProfile(roleType: role)

                // Mark onboarding as complete
                UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.hasCompletedOnboarding)
                UserDefaults.standard.set(role.rawValue, forKey: Constants.UserDefaultsKey.selectedRoleType)

                Logger.logEvent(Constants.AnalyticsEvent.onboardingCompleted, parameters: ["role": role.rawValue])

                await MainActor.run {
                    isLoading = false
                    showHome = true
                }
            } catch {
                Logger.error("Failed to save user role", error: error, category: Logger.auth)
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }

    private func gradientForRole(_ role: RoleType) -> [Color] {
        switch role {
        case .parent: return Constants.Colors.parentGradient
        case .salon: return Constants.Colors.salonGradient
        case .realtor: return Constants.Colors.realtorGradient
        case .business: return Constants.Colors.businessGradient
        case .explorer: return Constants.Colors.explorerGradient
        }
    }
}

struct RoleCard: View {
    let roleType: RoleType
    let features: [String]
    let isSelected: Bool

    private var gradient: [Color] {
        switch roleType {
        case .parent: return Constants.Colors.parentGradient
        case .salon: return Constants.Colors.salonGradient
        case .realtor: return Constants.Colors.realtorGradient
        case .business: return Constants.Colors.businessGradient
        case .explorer: return Constants.Colors.explorerGradient
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.md) {
            HStack(spacing: Constants.Spacing.md) {
                // Icon
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

                    Image(systemName: roleType.icon)
                        .font(.system(size: 26))
                        .foregroundColor(Constants.Colors.textPrimary)
                }

                // Title & Description
                VStack(alignment: .leading, spacing: 4) {
                    Text(roleType.displayName)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Constants.Colors.textPrimary)

                    Text(roleType.description)
                        .font(.subheadline)
                        .foregroundColor(Constants.Colors.textSecondary)
                }

                Spacer()

                // Checkmark
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(gradient[0])
                }
            }

            // Features
            VStack(alignment: .leading, spacing: Constants.Spacing.sm) {
                ForEach(features, id: \.self) { feature in
                    HStack(spacing: Constants.Spacing.sm) {
                        Image(systemName: "checkmark")
                            .font(.caption)
                            .foregroundColor(gradient[0])

                        Text(feature)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .padding(.leading, 76)
        }
        .padding(Constants.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: Constants.CornerRadius.lg)
                .fill(Color.white.opacity(isSelected ? 0.15 : 0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.CornerRadius.lg)
                        .stroke(
                            isSelected ?
                            LinearGradient(
                                colors: gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [Color.clear, Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

#Preview {
    RoleSelectionView()
}
