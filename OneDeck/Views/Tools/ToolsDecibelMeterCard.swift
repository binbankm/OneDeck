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
                // Top Header Row
                headerRow

                // Middle Metric & Waveform Preview
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
                title: L10n.Tools.decibelMeter,
                icon: "waveform.badge.mic",
                subtitle: L10n.Tools.decibelMeterSub
            )

            Spacer()

            // Quick Toggle Button
            Button {
                tools.toggleDecibelMeter()
            } label: {
                Image(systemName: tools.decibelMeter.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                    .font(IconTheme.prominentAction)
                    .foregroundStyle(tools.decibelMeter.isRecording ? Color.red : appState.accentColor)
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
            HStack(spacing: SpacingTheme.tight) {
                Circle()
                    .fill(tools.decibelMeter.isRecording ? Color.green : appState.accentColor)
                    .frame(width: 6, height: 6)

                Text(String(format: "%.1f dB SPL", tools.decibelMeter.currentDb))
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            Spacer()

            Text(L10n.Tools.noiseLevelTitle(for: tools.decibelMeter.currentDb))
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
