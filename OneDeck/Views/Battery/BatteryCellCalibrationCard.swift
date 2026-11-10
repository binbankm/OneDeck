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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var battery = BatteryViewModel.shared

    private var readableAccent: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerSection
            toggleSection

            if battery.isCustomBattery {
                BentoHairlineDivider()
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
                    .fixedSize(horizontal: false, vertical: true)

                Text(L10n.Battery.calibrateDesc)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .tint(readableAccent)
    }

    @ViewBuilder
    private var customCalibrationSection: some View {
        let accent = readableAccent

        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            Text(L10n.Battery.customCapacityLabel)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))

            // Preset Quick Switchers
            Group {
                if dynamicTypeSize.isAccessibilitySize {
                    VStack(spacing: SpacingTheme.compact) {
                        presetPills
                    }
                } else {
                    HStack(spacing: SpacingTheme.compact) {
                        presetPills
                    }
                }
            }

            // Stepper Adjustment Row
            HStack(spacing: SpacingTheme.standard) {
                Text("\(battery.customCapacityMah) mAh")
                    .font(Typography.bodyValue)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .foregroundStyle(accent)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Spacer(minLength: SpacingTheme.compact)

                HStack(spacing: SpacingTheme.tight) {
                    Button {
                        Haptics.tick()
                        battery.setCustomBattery(enabled: true, customMah: max(500, battery.customCapacityMah - 50))
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(IconTheme.launcherIcon)
                            .foregroundStyle(accent)
                            .frame(minWidth: LayoutTheme.minTapTarget, minHeight: LayoutTheme.minTapTarget)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(BentoCardButtonStyle())
                    .disabled(battery.customCapacityMah <= 500)
                    .opacity(battery.customCapacityMah <= 500 ? 0.4 : 1.0)
                    .accessibilityLabel(L10n.Battery.capacityAdjustMinus(50))

                    Button {
                        Haptics.tick()
                        battery.setCustomBattery(enabled: true, customMah: min(20000, battery.customCapacityMah + 50))
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(IconTheme.launcherIcon)
                            .foregroundStyle(accent)
                            .frame(minWidth: LayoutTheme.minTapTarget, minHeight: LayoutTheme.minTapTarget)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(BentoCardButtonStyle())
                    .disabled(battery.customCapacityMah >= 20000)
                    .opacity(battery.customCapacityMah >= 20000 ? 0.4 : 1.0)
                    .accessibilityLabel(L10n.Battery.capacityAdjustPlus(50))
                }
            }
            .padding(.leading, SpacingTheme.row)
            .padding(.trailing, SpacingTheme.tight)
            .padding(.vertical, SpacingTheme.tight)
            .background(Theme.tileBackground(for: colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.5)
            )
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }

    @ViewBuilder
    private var presetPills: some View {
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

    // MARK: - Pill Helper
    @ViewBuilder
    private func capacityPill(title: String, mah: Int) -> some View {
        let isSelected = (battery.customCapacityMah == mah)

        Button {
            Haptics.tick()
            battery.setCustomBattery(enabled: true, customMah: mah)
        } label: {
            VStack(spacing: SpacingTheme.micro) {
                Text(title)
                    .font(Typography.badgeTag)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text("\(mah)")
                    .font(Typography.captionBold)
                    .monospacedDigit()
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
            .padding(.horizontal, SpacingTheme.tight)
            .padding(.vertical, SpacingTheme.tight)
            .background(
                isSelected
                    ? appState.accentColor
                    : Theme.chipBackground(for: colorScheme)
            )
            .foregroundStyle(
                isSelected
                    ? Theme.contrastingForeground(for: appState.accentColor)
                    : Theme.textSecondary(for: colorScheme)
            )
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .stroke(isSelected ? Color.clear : Theme.chipBorder(for: colorScheme), lineWidth: 0.5)
            )
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
        .accessibilityLabel("\(title), \(mah) mAh")
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

// MARK: - Preview
#Preview {
    BatteryCellCalibrationCard()
        .padding()
}
