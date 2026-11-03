//
//  ToolsWaterEjectorCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Acoustic diaphragm water and dust ejection launcher card.
//

import SwiftUI

struct ToolsWaterEjectorCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: LazyView(WaterEjectorDetailView())) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                headerRow
                middleStatusRow
            }
            .bentoCard(accent: tools.waterEjector.isRunning ? Color.cyan : appState.accentColor)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Header
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.waterEjector,
                icon: "drop.triangle.fill",
                subtitle: L10n.Tools.waterEjectorSub
            )

            Spacer()

            Text(tools.waterEjector.isRunning ? "\(tools.waterEjector.remainingSeconds)s" : "\(Int(tools.waterEjector.selectedMode.targetFrequency)) Hz")
                .font(Typography.headlineValue)
                .fontDesign(.monospaced)
                .foregroundStyle(tools.waterEjector.isRunning ? Color.cyan : appState.accentColor)
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
                    .fill(tools.waterEjector.isRunning ? Color.cyan : Theme.textTertiary(for: colorScheme))
                    .frame(width: 6, height: 6)

                Text(tools.waterEjector.isRunning ? L10n.Tools.ejecting : L10n.Tools.ready)
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            Spacer()

            Text(tools.waterEjector.selectedMode == .deep165Hz ? L10n.Tools.deepEject165 : L10n.Tools.dustClear440)
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsWaterEjectorCard()
        .padding()
}
