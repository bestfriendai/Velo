//
//  SkeletonView.swift
//  Velo
//
//  UX-2 Fix: Skeleton loading states
//

import SwiftUI

/// Animated skeleton loading view
struct SkeletonView: View {
    let width: CGFloat?
    let height: CGFloat

    @State private var isAnimating = false

    var body: some View {
        RoundedRectangle(cornerRadius: Constants.CornerRadius.sm)
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.1),
                        Color.white.opacity(0.2),
                        Color.white.opacity(0.1)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: width, height: height)
            .mask(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white, .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: isAnimating ? 200 : -200)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

// MARK: - Specialized Skeletons

/// Skeleton for template cards
struct TemplateCardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.sm) {
            SkeletonView(width: nil, height: Constants.ComponentSize.cardImageHeight)
            SkeletonView(width: 120, height: 16)
            SkeletonView(width: 80, height: 12)
        }
        .frame(width: 160)
    }
}

/// Skeleton for recent photo cards
struct PhotoCardSkeleton: View {
    var body: some View {
        VStack(spacing: Constants.Spacing.sm) {
            SkeletonView(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.md))
            SkeletonView(width: 80, height: 12)
        }
    }
}

/// Skeleton for community post cards
struct CommunityPostSkeleton: View {
    var body: some View {
        HStack(spacing: Constants.Spacing.md) {
            SkeletonView(width: nil, height: 120)
            SkeletonView(width: nil, height: 120)
        }
        .frame(height: 120)
    }
}

/// Skeleton for chat messages
struct ChatMessageSkeleton: View {
    let isUser: Bool

    var body: some View {
        HStack {
            if isUser { Spacer() }
            SkeletonView(width: isUser ? 200 : 250, height: 40)
            if !isUser { Spacer() }
        }
    }
}

/// Skeleton for user profile/stats
struct ProfileStatsSkeleton: View {
    var body: some View {
        HStack(spacing: Constants.Spacing.lg) {
            VStack(spacing: Constants.Spacing.xs) {
                SkeletonView(width: 40, height: 24)
                SkeletonView(width: 60, height: 12)
            }
            VStack(spacing: Constants.Spacing.xs) {
                SkeletonView(width: 40, height: 24)
                SkeletonView(width: 60, height: 12)
            }
            VStack(spacing: Constants.Spacing.xs) {
                SkeletonView(width: 40, height: 24)
                SkeletonView(width: 60, height: 12)
            }
        }
    }
}

// MARK: - Loading Grid

/// Grid of skeleton items for loading states
struct SkeletonGrid<Skeleton: View>: View {
    let columns: Int
    let rows: Int
    let skeleton: () -> Skeleton

    init(columns: Int = 2, rows: Int = 2, @ViewBuilder skeleton: @escaping () -> Skeleton) {
        self.columns = columns
        self.rows = rows
        self.skeleton = skeleton
    }

    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible()), count: columns),
            spacing: Constants.Spacing.md
        ) {
            ForEach(0..<(columns * rows), id: \.self) { _ in
                skeleton()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        ScrollView {
            VStack(spacing: 24) {
                Text("Skeleton Views")
                    .font(.title)
                    .foregroundColor(.white)

                TemplateCardSkeleton()

                PhotoCardSkeleton()

                CommunityPostSkeleton()

                ChatMessageSkeleton(isUser: false)
                ChatMessageSkeleton(isUser: true)

                ProfileStatsSkeleton()
            }
            .padding()
        }
    }
}
