//
//  RoleSelectionView.swift
//  Velo
//
//  Created by Ky Vu on 12/9/25.
//

import SwiftUI

struct RoleSelectionView: View {
    @State private var selectedRole: UserRole?
    @State private var showHome = false

    let roles: [UserRole] = [
        UserRole(
            id: "parent",
            icon: "person.2.fill",
            title: "Parent",
            description: "Perfect family photos every time",
            features: ["Fix closed eyes", "Group photo touch-ups", "Event highlights"],
            gradient: [Color.pink, Color.orange]
        ),
        UserRole(
            id: "business",
            icon: "bag.fill",
            title: "Business Owner",
            description: "Professional content in seconds",
            features: ["Product photos", "Social media ready", "Brand consistency"],
            gradient: [Color.purple, Color.blue]
        ),
        UserRole(
            id: "realtor",
            icon: "house.fill",
            title: "Real Estate",
            description: "Stunning property photos",
            features: ["HDR enhancement", "Virtual staging", "Batch processing"],
            gradient: [Color.blue, Color.cyan]
        ),
        UserRole(
            id: "casual",
            icon: "camera.fill",
            title: "Just for Fun",
            description: "Make any photo look amazing",
            features: ["Creative filters", "Quick enhancements", "Easy sharing"],
            gradient: [Color.green, Color.mint]
        )
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Text("Who are you?")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)

                    Text("We'll customize Velo for your needs")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.top, 60)
                .padding(.bottom, 40)

                // Role Cards
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(roles) { role in
                            RoleCard(
                                role: role,
                                isSelected: selectedRole?.id == role.id
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedRole = role
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }

                // Continue Button
                Button(action: {
                    showHome = true
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            selectedRole != nil ?
                            LinearGradient(
                                colors: selectedRole!.gradient,
                                startPoint: .leading,
                                endPoint: .trailing
                            ) :
                            LinearGradient(
                                colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.3)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: selectedRole != nil ? selectedRole!.gradient[0].opacity(0.3) : .clear, radius: 10, x: 0, y: 5)
                }
                .disabled(selectedRole == nil)
                .padding(.horizontal, 30)
                .padding(.vertical, 30)

                // Skip Option
                Button("Skip for now") {
                    selectedRole = roles[3] // Default to "Just for Fun"
                    showHome = true
                }
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.5))
                .padding(.bottom, 20)
            }
        }
        .fullScreenCover(isPresented: $showHome) {
            HomeView(userRole: selectedRole ?? roles[3])
        }
    }
}

struct RoleCard: View {
    let role: UserRole
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: role.gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)

                    Image(systemName: role.icon)
                        .font(.system(size: 26))
                        .foregroundColor(.white)
                }

                // Title & Description
                VStack(alignment: .leading, spacing: 4) {
                    Text(role.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text(role.description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                // Checkmark
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(role.gradient[0])
                }
            }

            // Features
            VStack(alignment: .leading, spacing: 8) {
                ForEach(role.features, id: \.self) { feature in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark")
                            .font(.caption)
                            .foregroundColor(role.gradient[0])

                        Text(feature)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .padding(.leading, 76)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(isSelected ? 0.15 : 0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            isSelected ?
                            LinearGradient(
                                colors: role.gradient,
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

struct UserRole: Identifiable {
    let id: String
    let icon: String
    let title: String
    let description: String
    let features: [String]
    let gradient: [Color]
}

#Preview {
    RoleSelectionView()
}
