//
//  ToolsHapticLabCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Bento Card launcher for Apple Taptic Engine & Haptic Motor Diagnostics.
//

import SwiftUI

struct ToolsHapticLabCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: HapticLabDetailView()) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                // Top Header Row
                headerRow

                // Middle Quick Trigger Pills
                quickPillsRow
            }
            .bentoCard(accent: appState.accentColor)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Header Row
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.hapticLab,
                icon: "dot.radiowaves.left.and.right",
                subtitle: L10n.Tools.hapticLabSub
            )

            Spacer()

            Text(L10n.Tools.ready)
                .font(Typography.captionMono)
                .foregroundStyle(appState.accentColor)

            Image(systemName: "chevron.right")
                .font(IconTheme.badgeInline)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
        }
    }

    // MARK: - Quick Pills Row
    @ViewBuilder
    private var quickPillsRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            HStack(spacing: SpacingTheme.compact) {
                Circle()
                    .fill(appState.accentColor)
                    .frame(width: 6, height: 6)

                Text(L10n.Tools.impactFeedback)
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }

            Spacer()

            Text(L10n.Tools.notificationFeedback)
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsHapticLabCard()
        .padding()
}

