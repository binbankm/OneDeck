//
//  BatteryCellCalibrationCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Custom cell capacity calibration and health target adjustment card.
//

import SwiftUI

struct BatteryCellCalibrationCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var battery = BatteryViewModel.shared

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerSection
            toggleSection

            if battery.isCustomBattery {
                Divider().opacity(0.25)
                customCalibrationSection
            }
        }
        .bentoCard(accent: appState.accentColor)
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: battery.isCustomBattery)
    }

    // MARK: - Subviews
    @ViewBuilder
    private var headerSection: some View {
        OverviewSectionHeader(title: L10n.Battery.cellSettingsTitle, icon: "wrench.adjustable.fill")
    }

    @ViewBuilder
    private var toggleSection: some View {
        Toggle(isOn: Binding(
            get: { battery.isCustomBattery },
            set: { battery.setCustomBattery(enabled: $0) }
        )) {
            VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                Text(L10n.Battery.isCustomToggle)
                    .font(Typography.bodyMedium)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))

                Text(L10n.Battery.calibrateDesc)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }
        }
        .tint(appState.accentColor)
    }

    @ViewBuilder
    private var customCalibrationSection: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            Text(L10n.Battery.customCapacityLabel)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))

            // Preset Quick Switchers
            HStack(spacing: SpacingTheme.compact) {
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
                    .font(Typography.bodyValue)
                    .foregroundStyle(appState.accentColor)

                Spacer()

                HStack(spacing: SpacingTheme.rowStandard) {
                    Button {
                        Haptics.tick()
                        battery.setCustomBattery(enabled: true, customMah: max(500, battery.customCapacityMah - 50))
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(IconTheme.launcherIcon)
                            .foregroundStyle(appState.accentColor)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("-50 mAh")

                    Button {
                        Haptics.tick()
                        battery.setCustomBattery(enabled: true, customMah: min(20000, battery.customCapacityMah + 50))
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(IconTheme.launcherIcon)
                            .foregroundStyle(appState.accentColor)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("+50 mAh")
                }
            }
            .padding(.horizontal, SpacingTheme.row)
            .padding(.vertical, SpacingTheme.standard)
            .background(colorScheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.03))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }

    // MARK: - Pill Helper
    @ViewBuilder
    private func capacityPill(title: String, mah: Int) -> some View {
        Button {
            Haptics.tick()
            battery.setCustomBattery(enabled: true, customMah: mah)
        } label: {
            VStack(spacing: SpacingTheme.micro) {
                Text(title)
                    .font(Typography.badgeTag)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                Text("\(mah)")
                    .font(Typography.captionBold)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, SpacingTheme.compact)
            .background(
                battery.customCapacityMah == mah
                    ? appState.accentColor
                    : (colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.04))
            )
            .foregroundStyle(
                battery.customCapacityMah == mah
                    ? Theme.contrastingForeground(for: appState.accentColor)
                    : Theme.textSecondary(for: colorScheme)
            )
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    BatteryCellCalibrationCard()
        .padding()
}
