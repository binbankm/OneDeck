//
//  ToolsTouchMatrixCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Bento Card launcher for Capacitive Touch Screen Grid Matrix Test.
//

import SwiftUI

struct ToolsTouchMatrixCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: TouchMatrixDetailView()) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                // Top Header Row
                headerRow

                // Middle Coverage Ratio Row
                middleStatusRow
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
                title: L10n.Tools.touchMatrix,
                icon: "circle.grid.3x3.fill",
                subtitle: L10n.Tools.touchMatrixSub
            )

            Spacer()

            let percent = Int((Double(tools.touchMatrixPassedCount) / 80.0) * 100.0)
            Text("\(percent)%")
                .font(Typography.captionMono)
                .foregroundStyle(percent == 100 ? Color.green : appState.accentColor)

            Image(systemName: "chevron.right")
                .font(IconTheme.badgeInline)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
        }
    }

    // MARK: - Middle Status Row
    @ViewBuilder
    private var middleStatusRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            HStack(spacing: SpacingTheme.compact) {
                Circle()
                    .fill(tools.touchMatrixPassedCount == 80 ? Color.green : appState.accentColor)
                    .frame(width: 6, height: 6)

                Text("\(tools.touchMatrixPassedCount)/80 \(L10n.Tools.passedCells)")
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }

            Spacer()

            Text(tools.touchMatrixPassedCount == 80 ? L10n.Tools.levelBalanced : L10n.Tools.sweepAllCells)
                .lineLimit(1)
                .font(Typography.badgeTag)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsTouchMatrixCard()
        .padding()
}
