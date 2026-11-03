//
//  ToolsTouchMatrixCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Capacitive touch digitizer and multi-touch test launcher card.
//

import SwiftUI

struct ToolsTouchMatrixCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: LazyView(TouchMatrixDetailView())) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                headerRow
                middleStatusRow
            }
            .bentoCard(accent: tools.touchMatrixPassedCount == 80 ? Color.green : appState.accentColor)
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

            Text(tools.touchMatrixPassedCount == 80 ? L10n.Tools.levelBalanced : "\(tools.touchMatrixPassedCount)/80")
                .font(Typography.headlineValue)
                .fontDesign(.monospaced)
                .foregroundStyle(
                    tools.touchMatrixPassedCount == 80 ? Color.green : (tools.touchMatrixPassedCount > 0 ? appState.accentColor : Theme.textSecondary(for: colorScheme))
                )
                .lineLimit(1)

            Image(systemName: "chevron.right")
                .font(IconTheme.badgeInline)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
        }
    }

    // MARK: - Middle Status Row
    @ViewBuilder
    private var middleStatusRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            HStack(spacing: SpacingTheme.tight) {
                Circle()
                    .fill(tools.touchMatrixPassedCount == 80 ? Color.green : (tools.touchMatrixPassedCount > 0 ? appState.accentColor : Theme.textTertiary(for: colorScheme)))
                    .frame(width: 6, height: 6)

                Text(tools.touchMatrixPassedCount > 0 ? "\(tools.touchMatrixPassedCount)/80 \(L10n.Tools.passedCells)" : L10n.Tools.ready)
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            Spacer()

            Text(tools.touchMatrixPassedCount == 80 ? L10n.Tools.levelBalanced : "10×8 \(L10n.Tools.touchGrid)")
                .lineLimit(1)
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsTouchMatrixCard()
        .padding()
}
