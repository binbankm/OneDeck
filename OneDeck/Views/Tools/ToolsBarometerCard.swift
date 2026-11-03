//
//  ToolsBarometerCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Atmospheric pressure and barometric altimeter launcher card.
//

import SwiftUI

struct ToolsBarometerCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: LazyView(BarometerDetailView())) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                headerRow
                middleMetricRow
            }
            .bentoCard(accent: appState.accentColor)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Header
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.barometer,
                icon: "gauge.with.needle.fill",
                subtitle: L10n.Tools.barometerSub
            )

            Spacer()

            Text(String(format: "%.1f hPa", tools.barometer.pressureHpa))
                .font(Typography.headlineValue)
                .fontDesign(.monospaced)
                .foregroundStyle(appState.accentColor)
                .lineLimit(1)

            Image(systemName: "chevron.right")
                .font(IconTheme.badgeInline)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
        }
    }

    // MARK: - Middle Metric Row
    @ViewBuilder
    private var middleMetricRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            HStack(spacing: SpacingTheme.tight) {
                Circle()
                    .fill(appState.accentColor)
                    .frame(width: 6, height: 6)

                Text(String(format: "%@: %+.1f m", L10n.Tools.relativeElevation, tools.barometer.relativeAltitudeMeters))
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            Spacer()

            Text(String(format: "%@: %+.1f m/s", L10n.Tools.verticalSpeed, tools.barometer.verticalSpeedMps))
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsBarometerCard()
        .padding()
}
