//
//  ToolsDecibelMeterCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Bento Card launcher for Acoustic Sound Level Meter.
//

import SwiftUI

struct ToolsDecibelMeterCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: DecibelMeterDetailView()) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                headerRow
                middleStatusRow
            }
            .bentoCard(accent: tools.decibelMeter.isRecording ? Color.green : appState.accentColor)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Header Row
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.decibelMeter,
                icon: "mic.fill",
                subtitle: L10n.Tools.decibelMeterSub
            )

            Spacer()

            Text(tools.decibelMeter.isRecording ? String(format: "%.1f dB", tools.decibelMeter.currentDb) : L10n.Tools.ready)
                .font(Typography.headlineValue)
                .fontDesign(.monospaced)
                .foregroundStyle(tools.decibelMeter.isRecording ? Color.green : Theme.textSecondary(for: colorScheme))
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
                    .fill(tools.decibelMeter.isRecording ? Color.green : Theme.textTertiary(for: colorScheme))
                    .frame(width: 6, height: 6)

                Text(tools.decibelMeter.isRecording ? L10n.Tools.noiseLevelTitle(for: tools.decibelMeter.currentDb) : L10n.Tools.ready)
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            Spacer()

            Text(String(format: "%@: %.1f dB", L10n.Tools.peakNoise, tools.decibelMeter.peakDb))
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsDecibelMeterCard()
        .padding()
}
