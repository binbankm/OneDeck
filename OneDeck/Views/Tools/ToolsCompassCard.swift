//
//  ToolsCompassCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Bento Card launcher for 3D Electronic Compass.
//

import SwiftUI

struct ToolsCompassCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: CompassDetailView()) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                // Top Header Row
                headerRow

                // Middle Heading Status Row
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
                title: L10n.Tools.compass,
                icon: "location.north.circle.fill",
                subtitle: L10n.Tools.compassSub
            )

            Spacer()

            Text("\(Int(tools.compass.trueHeading))° \(tools.compass.cardinalDirection)")
                .font(Typography.headlineValue)
                .fontDesign(.monospaced)
                .foregroundStyle(appState.accentColor)
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
                    .fill(appState.accentColor)
                    .frame(width: 6, height: 6)

                Text(String(format: "%@: %.1f°", L10n.Tools.magneticHeading, tools.compass.magneticHeading))
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            Spacer()

            Text(String(format: "%@: %.0f m", L10n.Tools.relativeElevation, tools.compass.altitudeMeters))
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsCompassCard()
        .padding()
}

