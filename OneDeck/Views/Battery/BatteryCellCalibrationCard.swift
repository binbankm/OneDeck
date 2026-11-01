//
//  BatteryCellCalibrationCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Third-Party & Aftermarket Battery Calibration Hub: Custom Capacity & Super-Cell Tuning.
//

import SwiftUI

struct BatteryCellCalibrationCard: View {
    @Bindable var appState = AppState.shared
    @Bindable var battery = BatteryService.shared
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header Row
            OverviewSectionHeader(title: L10n.Battery.cellSettingsTitle, icon: "slider.horizontal.2.square.badge.arrow.down")

            // Toggle Row
            Toggle(isOn: Binding(
                get: { battery.isCustomBattery },
                set: { battery.setCustomBattery(enabled: $0) }
            )) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(L10n.Battery.isCustomToggle)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))

                    Text(L10n.Battery.calibrateDesc)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }
            }
            .tint(appState.accentColor)

            if battery.isCustomBattery {
                Divider().opacity(0.25)

                VStack(alignment: .leading, spacing: 8) {
                    Text(L10n.Battery.customCapacityLabel)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))

                    // Preset Quick Switchers
                    HStack(spacing: 6) {
                        capacityPill(
                            title: L10n.Battery.oemNominal,
                            mah: battery.officialDesignCapacityMah
                        )

                        capacityPill(
                            title: L10n.Battery.highCap,
                            mah: Int(Double(battery.officialDesignCapacityMah) * 1.12)
                        )

                        capacityPill(
                            title: L10n.Battery.superCap,
                            mah: Int(Double(battery.officialDesignCapacityMah) * 1.22)
                        )
                    }

                    // Stepper Adjustment Row
                    HStack {
                        Text("\(battery.customCapacityMah) mAh")
                            .font(.system(.subheadline, design: .rounded, weight: .bold))
                            .foregroundStyle(appState.accentColor)

                        Spacer()

                        HStack(spacing: 12) {
                            Button {
                                Haptics.tick()
                                battery.setCustomBattery(enabled: true, customMah: max(1000, battery.customCapacityMah - 50))
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title3)
                                    .foregroundStyle(appState.accentColor)
                            }

                            Button {
                                Haptics.tick()
                                battery.setCustomBattery(enabled: true, customMah: min(12000, battery.customCapacityMah + 50))
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title3)
                                    .foregroundStyle(appState.accentColor)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(colorScheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.03))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .bentoCard(accent: appState.accentColor)
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: battery.isCustomBattery)
    }

    @ViewBuilder
    private func capacityPill(title: String, mah: Int) -> some View {
        Button {
            Haptics.tick()
            battery.setCustomBattery(enabled: true, customMah: mah)
        } label: {
            VStack(spacing: 2) {
                Text(title)
                    .font(.system(size: 10, weight: .medium))
                Text("\(mah)")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(
                battery.customCapacityMah == mah
                ? appState.accentColor
                : (colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.04))
            )
            .foregroundStyle(
                battery.customCapacityMah == mah
                ? Color.black
                : Theme.textSecondary(for: colorScheme)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

