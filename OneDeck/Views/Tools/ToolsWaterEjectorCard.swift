//
//  ToolsWaterEjectorCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  165Hz Acoustic Water Ejector Bento Launcher Card.
//

import SwiftUI

struct ToolsWaterEjectorCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: WaterEjectorDetailView()) {
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

            // Quick Toggle Trigger on Card
            Button {
                tools.toggleWaterEjector()
            } label: {
                Image(systemName: tools.waterEjector.isRunning ? "stop.circle.fill" : "play.circle.fill")
                    .font(IconTheme.prominentAction)
                    .foregroundStyle(tools.waterEjector.isRunning ? Color.red : appState.accentColor)
            }
            .buttonStyle(.plain)

            Image(systemName: "chevron.right")
                .font(IconTheme.badgeInline)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
        }
    }

    // MARK: - Middle Status Row
    @ViewBuilder
    private var middleStatusRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            if tools.waterEjector.isRunning {
                HStack(spacing: SpacingTheme.compact) {
                    ProgressView(value: tools.waterEjector.progress)
                        .tint(Color.cyan)
                    Text("\(tools.waterEjector.remainingSeconds)s")
                        .font(Typography.captionMono)
                        .foregroundStyle(Color.cyan)
                }
            } else {
                HStack(spacing: SpacingTheme.tight) {
                    Circle()
                        .fill(appState.accentColor)
                        .frame(width: 6, height: 6)
                    Text(L10n.Tools.waterEjectorSub)
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }

                Spacer()

                Text(tools.waterEjector.selectedMode == .deep165Hz ? L10n.Tools.deepEject165 : L10n.Tools.dustClear440)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(appState.accentColor)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsWaterEjectorCard()
        .padding()
}

