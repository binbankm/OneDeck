//
//  ToolsBleRadarCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Bluetooth Low Energy Proximity & Radar Bento Launcher Card.
//

import SwiftUI

struct ToolsBleRadarCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: BleRadarDetailView()) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                headerRow
                middleStatusRow
            }
            .bentoCard(accent: tools.bleRadar.isScanning ? Color.cyan : appState.accentColor)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Header
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.bleRadar,
                icon: "sensor.tag.radiowaves.forward.fill",
                subtitle: L10n.Tools.bleRadarSub
            )

            Spacer()

            Text(tools.bleRadar.isScanning ? "\(tools.bleRadar.devices.count) DEV" : L10n.Tools.ready)
                .font(Typography.headlineValue)
                .fontDesign(.monospaced)
                .foregroundStyle(tools.bleRadar.isScanning ? Color.cyan : Theme.textSecondary(for: colorScheme))
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
                    .fill(tools.bleRadar.isScanning ? Color.cyan : Theme.textTertiary(for: colorScheme))
                    .frame(width: 6, height: 6)

                Text(tools.bleRadar.isScanning ? (tools.bleRadar.nearestDeviceName.isEmpty ? L10n.Tools.bleScanStatus : tools.bleRadar.nearestDeviceName) : L10n.Tools.ready)
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            Spacer()

            Text(tools.bleRadar.devices.isEmpty ? "0 dBm · 0.0m" : String(format: "%d dBm · ~%.1fm", tools.bleRadar.nearestDeviceRssi, tools.bleRadar.estimatedDistanceMeters))
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsBleRadarCard()
        .padding()
}
