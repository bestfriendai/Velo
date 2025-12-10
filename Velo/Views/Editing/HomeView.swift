//
//  HomeView.swift
//  Velo
//
//  Created by Ky Vu on 12/9/25.
//

import SwiftUI

struct HomeView: View {
    let userRole: OldUserRole
    @State private var showEditingInterface = false
    @State private var selectedTab = 0
    @State private var messageText = ""

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                header

                // Tab Selector
                tabSelector

                // Content
                TabView(selection: $selectedTab) {
                    recentPhotosView
                        .tag(0)

                    templatesView
                        .tag(1)

                    communityView
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Quick Chat Bar
                quickChatBar
            }
        }
        .fullScreenCover(isPresented: $showEditingInterface) {
            EditingInterfaceView()
        }
    }

    // MARK: - Header
    private var header: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome back!")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))

                    Text(userRole.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }

                Spacer()

                // Profile/Settings
                Button(action: {}) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: userRole.gradient,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)

                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            // Usage Stats (for Pro users)
            UsageStatsCard(editsThisMonth: 23, limit: nil)
                .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
    }

    // MARK: - Tab Selector
    private var tabSelector: some View {
        HStack(spacing: 20) {
            TabButton(title: "Recent", isSelected: selectedTab == 0) {
                withAnimation { selectedTab = 0 }
            }
            TabButton(title: "Templates", isSelected: selectedTab == 1) {
                withAnimation { selectedTab = 1 }
            }
            TabButton(title: "Community", isSelected: selectedTab == 2) {
                withAnimation { selectedTab = 2 }
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }

    // MARK: - Recent Photos
    private var recentPhotosView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Quick Actions
                HStack(spacing: 12) {
                    QuickActionButton(
                        icon: "photo.on.rectangle.angled",
                        title: "New Edit",
                        gradient: userRole.gradient
                    ) {
                        showEditingInterface = true
                    }

                    QuickActionButton(
                        icon: "square.stack.3d.up.fill",
                        title: "Batch Edit",
                        gradient: [Color.orange, Color.red]
                    ) {
                        // Batch edit action
                    }
                }
                .padding(.horizontal, 20)

                // Recent Edits
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Edits")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(0..<5) { index in
                                RecentPhotoCard()
                                    .onTapGesture {
                                        showEditingInterface = true
                                    }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }

                // Suggested for You
                VStack(alignment: .leading, spacing: 12) {
                    Text("Suggested for \(userRole.title)s")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)

                    ForEach(userRole.features, id: \.self) { feature in
                        SuggestedFeatureCard(
                            feature: feature,
                            gradient: userRole.gradient
                        )
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
            }
            .padding(.vertical)
        }
    }

    // MARK: - Templates View
    private var templatesView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Popular Templates")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(0..<8) { index in
                        TemplateCard(
                            title: "Template \(index + 1)",
                            uses: Int.random(in: 100...5000)
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical)
        }
    }

    // MARK: - Community View
    private var communityView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Trending Edits")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)

                LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                    ForEach(0..<6) { index in
                        CommunityPostCard()
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical)
        }
    }

    // MARK: - Quick Chat Bar
    private var quickChatBar: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.white.opacity(0.2))

            HStack(spacing: 12) {
                // Voice Button
                Button(action: {}) {
                    Image(systemName: "mic.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            LinearGradient(
                                colors: userRole.gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(12)
                }

                // Text Input
                TextField("Try: \"Fix closed eyes in recent photos\"", text: $messageText)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .foregroundColor(.white)

                // Send Button
                Button(action: { showEditingInterface = true }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundColor(userRole.gradient[0])
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color(white: 0.05))
        }
    }
}

// MARK: - Supporting Views
struct UsageStatsCard: View {
    let editsThisMonth: Int
    let limit: Int?

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("This Month")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))

                HStack(spacing: 4) {
                    Text("\(editsThisMonth)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    if let limit = limit {
                        Text("/ \(limit) edits")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    } else {
                        Text("edits")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                        Image(systemName: "infinity")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }

            Spacer()

            if limit == nil {
                HStack(spacing: 4) {
                    Image(systemName: "crown.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    Text("PRO")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? .white : .white.opacity(0.5))

                if isSelected {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 2)
                }
            }
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let gradient: [Color]
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(12)
        }
    }
}

struct RecentPhotoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 140, height: 180)
                .cornerRadius(12)
                .overlay(
                    VStack {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.white.opacity(0.5))
                    }
                )

            Text("2 hours ago")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(width: 140)
    }
}

struct SuggestedFeatureCard: View {
    let feature: String
    let gradient: [Color]

    var body: some View {
        HStack {
            Image(systemName: "sparkles")
                .foregroundColor(gradient[0])

            Text(feature)
                .font(.subheadline)
                .foregroundColor(.white)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

struct TemplateCard: View {
    let title: String
    let uses: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.purple.opacity(0.3), Color.pink.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 160)
                .cornerRadius(12)
                .overlay(
                    VStack {
                        Image(systemName: "wand.and.stars")
                            .font(.largeTitle)
                            .foregroundColor(.white.opacity(0.5))
                    }
                )

            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)

            Text("\(uses) uses")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
    }
}

struct CommunityPostCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.caption)
                            .foregroundColor(.white)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text("User Name")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)

                    Text("2 days ago")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }

                Spacer()

                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.white.opacity(0.6))
                }
            }

            // Before/After Images
            HStack(spacing: 8) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .cornerRadius(8)
                    .overlay(
                        VStack {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.white.opacity(0.3))
                            Text("Before")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                        }
                    )

                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 200)
                    .cornerRadius(8)
                    .overlay(
                        VStack {
                            Image(systemName: "sparkles")
                                .font(.largeTitle)
                                .foregroundColor(.white.opacity(0.5))
                            Text("After")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    )
            }

            // Caption
            Text("\"Made the sunset more vibrant and removed background distractions\"")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .italic()

            // Actions
            HStack(spacing: 20) {
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "heart")
                        Text("234")
                            .font(.caption)
                    }
                    .foregroundColor(.white.opacity(0.7))
                }

                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "square.and.arrow.down")
                        Text("Use Template")
                            .font(.caption)
                    }
                    .foregroundColor(.blue)
                }

                Spacer()
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}

#Preview {
    HomeView(userRole: UserRole(
        id: "parent",
        icon: "person.2.fill",
        title: "Parent",
        description: "Perfect family photos",
        features: ["Fix closed eyes", "Group photo touch-ups", "Event highlights"],
        gradient: [Color.pink, Color.orange]
    ))
}
