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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var system = SystemViewModel.shared

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

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
        HStack(spacing: SpacingTheme.compact) {
            OverviewSectionHeader(title: L10n.Overview.thermalSectionTitle, icon: "flame.fill")
                .layoutPriority(1)

            Spacer(minLength: SpacingTheme.tight)

            FlowLayout(spacing: SpacingTheme.compact, rowSpacing: SpacingTheme.tight) {
                Text(system.isThermalEstimated ? L10n.Overview.modelEstimatedBadge : L10n.Overview.hardwareSensorBadge)
                    .font(Typography.badgeTag)
                    .foregroundStyle(system.isThermalEstimated ? Theme.textSecondary(for: colorScheme) : accentFg)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .padding(.horizontal, SpacingTheme.standard)
                    .padding(.vertical, SpacingTheme.micro)
                    .background(
                        system.isThermalEstimated
                            ? Theme.chipBackground(for: colorScheme)
                            : appState.accentColor.opacity(0.12)
                    )
                    .clipShape(Capsule())

                HStack(spacing: SpacingTheme.tight) {
                    Circle()
                        .fill(thermalColor)
                        .frame(width: 6, height: 6)
                        .accessibilityHidden(true)

                    Text(thermalText)
                        .font(Typography.captionBold)
                        .foregroundStyle(thermalColor)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .padding(.horizontal, SpacingTheme.standard)
                .padding(.vertical, SpacingTheme.micro)
                .background(thermalColor.opacity(0.12))
                .clipShape(Capsule())
                .accessibilityElement(children: .combine)
                .accessibilityLabel(L10n.Overview.thermalPressure)
                .accessibilityValue(thermalText)
            }
        }
    }

    @ViewBuilder
    private var dualTemperatureTiles: some View {
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: SpacingTheme.row))
            : AnyLayout(HStackLayout(spacing: SpacingTheme.row))

        layout {
            TemperatureBentoTile(
                icon: "cpu.fill",
                iconColor: thermalColor,
                label: L10n.Overview.socTemp,
                value: system.socTemperature
            )

            TemperatureBentoTile(
                icon: "battery.100.bolt",
                iconColor: accentFg,
                label: L10n.Overview.batteryTemp,
                value: system.batteryTemperature
            )
        }
    }

    @ViewBuilder
    private var thermalPressureBar: some View {
        let pressureValueText = system.thermalPressurePercent <= 25
            ? L10n.Overview.thermalOptimal
            : "\(system.thermalPressurePercent)%"

        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            HStack {
                Text(L10n.Overview.thermalPressure)
                    .font(Typography.badgeTag)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Spacer()

                Text(pressureValueText)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(thermalColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            BentoCapsuleProgressBar(
                value: Double(system.thermalPressurePercent) / 100.0,
                tint: thermalColor,
                height: 6,
                accessibilityLabel: L10n.Overview.thermalPressure,
                accessibilityValue: pressureValueText
            )
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.Overview.thermalPressure)
        .accessibilityValue(pressureValueText)
    }

    // MARK: - Dynamic Thermal Colors & Text
    private var thermalColor: Color {
        switch system.thermalState {
        case .nominal: return accentFg
        case .fair: return Theme.readableYellow(for: colorScheme)
        case .serious: return Theme.readableOrange(for: colorScheme)
        case .critical: return Theme.readableRed(for: colorScheme)
        @unknown default: return accentFg
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
        let safeValue = value.isFinite ? value : 0.0

        VStack(alignment: .leading, spacing: SpacingTheme.compact) {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: icon)
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(iconColor)
                    .accessibilityHidden(true)

                Text(label)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.micro) {
                Text(String(format: "%.1f", safeValue))
                    .font(Typography.title1)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .contentTransition(.numericText())

                Text("°C")
                    .font(Typography.calloutLabel)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(SpacingTheme.row)
        .background(Theme.tileBackground(for: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.5)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityValue(String(format: "%.1f °C", safeValue))
    }
}

// MARK: - Preview
#Preview {
    OverviewThermalsCard()
        .padding()
}
