//
//  BentoComponents.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Shared Bento UI primitives ensuring visual, contrast, and accessibility consistency.
//

import SwiftUI

// MARK: - Standardized Capsule Progress Bar
struct BentoCapsuleProgressBar: View {
    @Environment(\.colorScheme) private var colorScheme

    let value: Double
    let tint: Color
    var height: CGFloat = 6
    var trackColor: Color?
    var accessibilityLabel: String?
    var accessibilityValue: String?

    private var clampedProgress: Double {
        guard value.isFinite else { return 0.0 }
        return min(1.0, max(0.0, value))
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(trackColor ?? Theme.chipBackground(for: colorScheme))

            if clampedProgress > 0 {
                Capsule()
                    .fill(tint)
                    .scaleEffect(x: clampedProgress, y: 1.0, anchor: .leading)
            }
        }
        .clipShape(Capsule())
        .frame(height: height)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel ?? "")
        .accessibilityValue(accessibilityValue ?? "\(Int((clampedProgress * 100).rounded()))%")
    }
}

// MARK: - Compact Empty & Waiting State
struct BentoEmptyStateView: View {
    @Environment(\.colorScheme) private var colorScheme

    let icon: String
    let message: String
    var subtitle: String?
    var showsProgress: Bool = false
    var height: CGFloat = 120

    var body: some View {
        VStack(spacing: SpacingTheme.compact) {
            if showsProgress {
                ProgressView()
                    .controlSize(.small)
                    .tint(Theme.textTertiary(for: colorScheme))
            } else {
                Image(systemName: icon)
                    .font(IconTheme.sectionHeader)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .accessibilityHidden(true)
            }

            Text(message)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            if let subtitle {
                Text(subtitle)
                    .font(Typography.captionRegular)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, minHeight: height)
        .padding(.horizontal, SpacingTheme.cardStack)
        .padding(.vertical, SpacingTheme.rowStandard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.6)
        )
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Calibrated Card Hairline Divider
struct BentoHairlineDivider: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Rectangle()
            .fill(Theme.cardBorder(for: colorScheme))
            .frame(height: 0.5)
            .accessibilityHidden(true)
    }
}

