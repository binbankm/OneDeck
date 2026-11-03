//
//  ToolsGnssHubCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Multi-Constellation GNSS Satellite Telemetry Bento Launcher Card.
//

import SwiftUI

struct ToolsGnssHubCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: GnssHubDetailView()) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                headerRow
                middleStatusRow
            }
            .bentoCard(accent: tools.gnssHub.isFixAcquired ? Color.green : Color.orange)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Header
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.gnssHub,
                icon: "antenna.radiowaves.left.and.right",
                subtitle: L10n.Tools.gnssHubSub
            )

            Spacer()

            Text(tools.gnssHub.isFixAcquired ? "3D FIX" : "SEARCH")
                .font(Typography.headlineValue)
                .fontDesign(.monospaced)
                .foregroundStyle(tools.gnssHub.isFixAcquired ? Color.green : Color.orange)
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
                    .fill(tools.gnssHub.isFixAcquired ? Color.green : Color.orange)
                    .frame(width: 6, height: 6)

                Text(tools.gnssHub.mgrsString.isEmpty ? tools.gnssHub.fixStatusText : tools.gnssHub.mgrsString)
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            Spacer()

            Text(String(format: "HDOP %.1f · %.0f m", tools.gnssHub.hdop, tools.gnssHub.altitudeM))
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsGnssHubCard()
        .padding()
}
