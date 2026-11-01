//
//  OverviewThermalsCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Thermals Bento Card: Dual-Zone Junction & Cell Telemetry, Thermal Throttling Pressure Bar.
//

import SwiftUI

struct OverviewThermalsCard: View {
    @Bindable var appState = AppState.shared
    @Bindable var system = SystemService.shared
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header Row
            HStack {
                OverviewSectionHeader(title: L10n.Overview.thermalSectionTitle, icon: "flame.fill")

                Spacer()

                HStack(spacing: 4) {
                    Circle()
                        .fill(thermalColor)
                        .frame(width: 6, height: 6)

                    Text(thermalText)
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(thermalColor)
                        .lineLimit(1)
                }
                .padding(.horizontal, 9)
                .padding(.vertical, 3.5)
                .background(thermalColor.opacity(0.12))
                .clipShape(Capsule())
            }

            // Dual Temperature Tiles (SoC Core & Battery Cell)
            HStack(spacing: 10) {
                // 1. SoC Junction Temperature
                temperatureBentoTile(
                    icon: "cpu",
                    iconColor: thermalColor,
                    label: L10n.Overview.socTemp,
                    value: system.socTemperature
                )

                // 2. Battery Cell Temperature
                temperatureBentoTile(
                    icon: "battery.100.bolt",
                    iconColor: appState.accentColor,
                    label: L10n.Overview.batteryTemp,
                    value: system.batteryTemperature
                )
            }

            // Thermal Pressure Load Bar
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(L10n.Overview.thermalPressure)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Theme.textTertiary(for: colorScheme))
                        .lineLimit(1)

                    Spacer()

                    Text(system.thermalPressurePercent <= 25 ? L10n.Overview.thermalOptimal : "\(system.thermalPressurePercent)%")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .foregroundStyle(thermalColor)
                        .lineLimit(1)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.05))

                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [thermalColor, thermalColor.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(8, geo.size.width * CGFloat(system.thermalPressurePercent) / 100.0))
                    }
                }
                .frame(height: 5)
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    @ViewBuilder
    private func temperatureBentoTile(icon: String, iconColor: Color, label: String, value: Double) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundStyle(iconColor)

                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }

            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(String(format: "%.1f", value))
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .contentTransition(.numericText())

                Text("°C")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(colorScheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

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

