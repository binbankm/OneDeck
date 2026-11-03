//
//  ToolsSeismometerCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Tri-axial micro-seismic vibration intensity launcher card.
//

import SwiftUI

struct ToolsSeismometerCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: LazyView(SeismometerDetailView())) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                headerRow
                middleStatusRow
            }
            .bentoCard(accent: tools.seismometer.intensity.color)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Header Row
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.seismometer,
                icon: "waveform.path.ecg.rectangle.fill",
                subtitle: L10n.Tools.seismometerSub
            )

            Spacer()

            Text(String(format: "%.1f Gal", tools.seismometer.peakGal))
                .font(Typography.headlineValue)
                .fontDesign(.monospaced)
                .foregroundStyle(tools.seismometer.intensity.color)
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
                    .fill(tools.seismometer.intensity.color)
                    .frame(width: 6, height: 6)

                Text(tools.seismometer.intensity.title)
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)
            }

            Spacer()

            Text(String(format: "%@: %.1f Hz", L10n.Tools.vibrationFrequency, tools.seismometer.dominantFrequencyHz))
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsSeismometerCard()
        .padding()
}
