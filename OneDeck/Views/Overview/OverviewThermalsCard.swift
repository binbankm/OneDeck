//
//  OverviewThermalsCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Real-time thermal pressure, SoC, and battery temperature card.
//

import SwiftUI

struct OverviewThermalsCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var system = SystemViewModel.shared

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerRow
            dualTemperatureTiles
            thermalPressureBar
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    @ViewBuilder
    private var headerRow: some View {
        HStack {
            OverviewSectionHeader(title: L10n.Overview.thermalSectionTitle, icon: "flame.fill")

            Spacer()

            HStack(spacing: SpacingTheme.tight) {
                Circle()
                    .fill(thermalColor)
                    .frame(width: 6, height: 6)

                Text(thermalText)
                    .font(Typography.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(thermalColor)
                    .lineLimit(1)
            }
            .padding(.horizontal, SpacingTheme.standard)
            .padding(.vertical, SpacingTheme.micro)
            .background(thermalColor.opacity(0.12))
            .clipShape(Capsule())
        }
    }

    @ViewBuilder
    private var dualTemperatureTiles: some View {
        HStack(spacing: SpacingTheme.row) {
            TemperatureBentoTile(
                icon: "cpu.fill",
                iconColor: thermalColor,
                label: L10n.Overview.socTemp,
                value: system.socTemperature
            )

            TemperatureBentoTile(
                icon: "battery.100.bolt",
                iconColor: appState.accentColor,
                label: L10n.Overview.batteryTemp,
                value: system.batteryTemperature
            )
        }
    }

    @ViewBuilder
    private var thermalPressureBar: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            HStack {
                Text(L10n.Overview.thermalPressure)
                    .font(Typography.badgeTag)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)

                Spacer()

                Text(system.thermalPressurePercent <= 25 ? L10n.Overview.thermalOptimal : "\(system.thermalPressurePercent)%")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(thermalColor)
                    .lineLimit(1)
            }

            ProgressView(value: min(1.0, max(0.0, Double(system.thermalPressurePercent) / 100.0)))
                .tint(thermalColor)
                .scaleEffect(x: 1, y: 1.25, anchor: .center)
                .frame(height: 5)
        }
    }

    // MARK: - Dynamic Thermal Colors & Text
    private var thermalColor: Color {
        switch system.thermalState {
        case .nominal: return appState.accentColor
        case .fair: return .yellow
        case .serious: return .orange
        case .critical: return .red
        @unknown default: return appState.accentColor
        }
    }

    private var thermalText: String {
        switch system.thermalState {
        case .nominal: return L10n.Overview.thermalNominal
        case .fair: return L10n.Overview.thermalFair
        case .serious: return L10n.Overview.thermalSerious
        case .critical: return L10n.Overview.thermalCritical
        @unknown default: return L10n.Overview.thermalNominal
        }
    }
}

// MARK: - Extracted Component
private struct TemperatureBentoTile: View {
    let icon: String
    let iconColor: Color
    let label: String
    let value: Double
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.compact) {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: icon)
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(iconColor)

                Text(label)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }

            HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.micro) {
                Text(String(format: "%.1f", value))
                    .font(Typography.title1)
                    .monospacedDigit()
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .contentTransition(.numericText())

                Text("°C")
                    .font(Typography.calloutLabel)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(SpacingTheme.row)
        .background(colorScheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
    }
}

// MARK: - Preview
#Preview {
    OverviewThermalsCard()
        .padding()
}
