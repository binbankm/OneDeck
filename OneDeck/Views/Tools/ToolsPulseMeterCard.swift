//
//  ToolsPulseMeterCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Camera optical PPG heart rate and pulse launcher card.
//

import SwiftUI

struct ToolsPulseMeterCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: LazyView(PulseMeterDetailView())) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                headerRow
                middleStatusRow
            }
            .bentoCard(accent: tools.pulseMeter.isMeasuring ? Color.red : appState.accentColor)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Header
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.pulseMeter,
                icon: "heart.circle.fill",
                subtitle: L10n.Tools.pulseMeterSub
            )

            Spacer()

            Text(tools.pulseMeter.bpm > 0 ? "\(tools.pulseMeter.bpm) BPM" : L10n.Tools.ready)
                .font(Typography.headlineValue)
                .fontDesign(.monospaced)
                .foregroundStyle(tools.pulseMeter.isMeasuring ? Color.red : Theme.textSecondary(for: colorScheme))
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
                    .fill(tools.pulseMeter.isMeasuring ? Color.red : Theme.textTertiary(for: colorScheme))
                    .frame(width: 6, height: 6)

                Text(tools.pulseMeter.isFingerDetected ? L10n.Tools.fingerDetected : (tools.pulseMeter.isMeasuring ? L10n.Tools.measuringPulse : L10n.Tools.ready))
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            Spacer()

            Text(tools.pulseMeter.hrvMs > 0 ? String(format: "HRV: %.0f ms", tools.pulseMeter.hrvMs) : L10n.Tools.pulseWaveform)
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsPulseMeterCard()
        .padding()
}
