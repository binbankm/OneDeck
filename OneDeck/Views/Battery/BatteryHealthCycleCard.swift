//
//  BatteryHealthCycleCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Battery health retention, cycle count, and capacity matrix card.
//

import SwiftUI

struct BatteryHealthCycleCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var battery = BatteryViewModel.shared

    // MARK: - State
    @State private var showAnalyticsSheet: Bool = false

    private var readableAccent: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerRow
            matrixSection
            if !battery.hasRealTelemetry {
                baselineNoticeSection
            }
            hardwareDetailsSection
            diagnosticsActionSection
        }
        .bentoCard(accent: appState.accentColor)
        .sheet(isPresented: $showAnalyticsSheet) {
            BatteryAnalyticsSheet()
        }
    }

    // MARK: - Subviews
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            OverviewSectionHeader(title: L10n.Battery.healthTitle, icon: "heart.text.square.fill")
                .layoutPriority(1)

            Spacer(minLength: SpacingTheme.compact)

            let isDataActive = battery.hasRealTelemetry
            let badgeColor: Color = isDataActive
                ? Theme.readableGreen(for: colorScheme)
                : Theme.readableOrange(for: colorScheme)
            let badgeText: String = battery.hasImportedBMS ? L10n.Battery.bmsRaw : (battery.hasRealTelemetry ? L10n.Battery.hardwareDirectTag : L10n.Battery.pendingImport)

            HStack(spacing: SpacingTheme.tight) {
                Circle()
                    .fill(badgeColor)
                    .frame(width: 6, height: 6)
                    .accessibilityHidden(true)

                Text(badgeText)
                    .font(Typography.captionBold)
                    .foregroundStyle(badgeColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .padding(.horizontal, SpacingTheme.standard)
            .padding(.vertical, SpacingTheme.micro)
            .background(badgeColor.opacity(0.12))
            .clipShape(Capsule())
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(L10n.Battery.healthTitle): \(badgeText)")
        }
    }

    @ViewBuilder
    private var matrixSection: some View {
        let isDataActive = battery.hasRealTelemetry
        let accent = readableAccent
        let orange = Theme.readableOrange(for: colorScheme)

        VStack(spacing: SpacingTheme.standard) {
            let cycleTile = healthTile(
                icon: "arrow.triangle.2.circlepath",
                label: L10n.Battery.cycleCount,
                value: isDataActive ? "\(battery.cycleCountDisplay)" : "--",
                unit: isDataActive ? L10n.Battery.cyclesUnit : "",
                status: isDataActive ? cycleTierText : L10n.Battery.pendingImport,
                statusColor: isDataActive ? cycleTierColor : orange
            )
            let healthTileView = healthTile(
                icon: "heart.fill",
                label: L10n.Battery.health,
                value: isDataActive ? String(format: "%.1f", battery.healthPercentDisplay.isFinite ? battery.healthPercentDisplay : 0.0) : "--",
                unit: isDataActive ? "%" : "",
                status: isDataActive ? healthTierText : L10n.Battery.pendingImport,
                statusColor: isDataActive ? healthTierColor : orange
            )
            let maxCapTile = healthTile(
                icon: "battery.100.bolt",
                label: L10n.Battery.currentMaxCapacity,
                value: isDataActive ? "\(battery.actualMaxCapacityMahDisplay)" : "--",
                unit: isDataActive ? "mAh" : "",
                status: isDataActive ? L10n.Battery.effectiveCap : L10n.Battery.pendingImport,
                statusColor: isDataActive ? accent : orange
            )
            let designCapTile = healthTile(
                icon: "bolt.badge.clock.fill",
                label: L10n.Battery.designCapacity,
                value: "\(battery.effectiveDesignCapacityMah)",
                unit: "mAh",
                status: battery.isCustomBattery ? L10n.Battery.customCalibrated : L10n.Battery.oemNominal,
                statusColor: battery.isCustomBattery ? orange : Theme.textSecondary(for: colorScheme)
            )

            if dynamicTypeSize.isAccessibilitySize {
                VStack(spacing: SpacingTheme.standard) {
                    cycleTile
                    healthTileView
                    maxCapTile
                    designCapTile
                }
            } else {
                HStack(spacing: SpacingTheme.row) {
                    cycleTile
                    healthTileView
                }

                HStack(spacing: SpacingTheme.row) {
                    maxCapTile
                    designCapTile
                }
            }
        }
    }

    @ViewBuilder
    private var baselineNoticeSection: some View {
        let orange = Theme.readableOrange(for: colorScheme)

        Button {
            Haptics.impact(.medium)
            showAnalyticsSheet = true
        } label: {
            HStack(spacing: SpacingTheme.compact) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(orange)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                    Text(L10n.Battery.pendingImportNotice)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Text(L10n.Battery.calibrateViaLogPrompt)
                        .font(Typography.microAxis)
                        .foregroundStyle(orange)
                }

                Spacer(minLength: SpacingTheme.compact)

                Image(systemName: "chevron.right")
                    .font(IconTheme.badgeInline)
                    .foregroundStyle(orange.opacity(0.85))
                    .accessibilityHidden(true)
            }
            .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget, alignment: .leading)
            .padding(.horizontal, SpacingTheme.row)
            .padding(.vertical, SpacingTheme.compact)
            .background(orange.opacity(colorScheme == .dark ? 0.14 : 0.08))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .stroke(orange.opacity(0.28), lineWidth: 0.6)
            )
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
    }

    @ViewBuilder
    private var hardwareDetailsSection: some View {
        if let sn = battery.batterySerialNumber, !sn.isEmpty {
            hardwareRow(icon: "barcode.viewfinder", label: L10n.Battery.batterySerial, value: sn)
        }

        if let mDate = battery.batteryManufactureDate, !mDate.isEmpty {
            hardwareRow(icon: "calendar.circle.fill", label: L10n.Battery.manufactureDate, value: mDate)
        }

        if let chem = battery.batteryChemistry, !chem.isEmpty {
            hardwareRow(icon: "atom", label: L10n.Battery.batteryChemistry, value: chem)
        }

        if !battery.cellVoltages.isEmpty {
            let cellVoltagesText = battery.cellVoltages.map { "\($0) mV" }.joined(separator: " · ")
            let accent = readableAccent

            hardwareRow(
                icon: "battery.100.bolt",
                label: L10n.Battery.cellVoltagesLabel,
                value: cellVoltagesText,
                valueColor: accent
            )
        }
    }

    @ViewBuilder
    private func hardwareRow(
        icon: String,
        label: String,
        value: String,
        valueColor: Color? = nil
    ) -> some View {
        let accent = readableAccent
        let resolvedColor = valueColor ?? Theme.textPrimary(for: colorScheme)

        Group {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                    HStack(spacing: SpacingTheme.compact) {
                        Image(systemName: icon)
                            .font(IconTheme.tileLeading)
                            .foregroundStyle(accent)
                            .accessibilityHidden(true)

                        Text(label)
                            .font(Typography.caption)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    }

                    Text(value)
                        .font(Typography.captionMono)
                        .monospacedDigit()
                        .foregroundStyle(resolvedColor)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                HStack(spacing: SpacingTheme.compact) {
                    Image(systemName: icon)
                        .font(IconTheme.tileLeading)
                        .foregroundStyle(accent)
                        .accessibilityHidden(true)

                    Text(label)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    Spacer(minLength: SpacingTheme.compact)

                    Text(value)
                        .font(Typography.captionMono)
                        .monospacedDigit()
                        .foregroundStyle(resolvedColor)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(Theme.tileBackground(for: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.5)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityValue(value)
    }

    @ViewBuilder
    private var diagnosticsActionSection: some View {
        if let record = battery.analyticsRecord {
            let accent = readableAccent

            HStack(spacing: SpacingTheme.standard) {
                HStack(spacing: SpacingTheme.compact) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(IconTheme.actionButton)
                        .accessibilityHidden(true)

                    Text(L10n.Battery.importedSuccess)
                        .font(Typography.calloutBold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    Spacer(minLength: SpacingTheme.compact)

                    Text(record.logDate, format: .dateTime.month(.twoDigits).day(.twoDigits))
                        .font(Typography.badgeTagMono)
                        .monospacedDigit()
                        .foregroundStyle(accent.opacity(0.85))
                }
                .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
                .padding(.horizontal, SpacingTheme.row)
                .background(accent.opacity(0.12))
                .foregroundStyle(accent)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(accent.opacity(0.25), lineWidth: 0.5)
                )
                .accessibilityElement(children: .combine)

                Button {
                    Haptics.impact(.medium)
                    battery.clearAnalyticsRecord()
                } label: {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(IconTheme.actionButton)
                        .frame(minWidth: LayoutTheme.minTapTarget, minHeight: LayoutTheme.minTapTarget)
                        .background(Theme.chipBackground(for: colorScheme))
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                                .stroke(Theme.chipBorder(for: colorScheme), lineWidth: 0.5)
                        )
                        .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                }
                .buttonStyle(BentoCardButtonStyle())
                .accessibilityLabel(L10n.Battery.clearRecord)
            }
        }
    }

    // MARK: - Health Tile Helper
    @ViewBuilder
    private func healthTile(
        icon: String,
        label: String,
        value: String,
        unit: String,
        status: String,
        statusColor: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: SpacingTheme.compact) {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: icon)
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(readableAccent)
                    .accessibilityHidden(true)

                Text(label)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.micro) {
                Text(value)
                    .font(Typography.title1)
                    .monospacedDigit()
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                if !unit.isEmpty {
                    Text(unit)
                        .font(Typography.captionBold)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)
                }
            }

            Text(status)
                .font(Typography.badgeTag)
                .padding(.horizontal, SpacingTheme.compact)
                .padding(.vertical, SpacingTheme.micro)
                .background(statusColor.opacity(0.12))
                .foregroundStyle(statusColor)
                .clipShape(Capsule())
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(Theme.tileBackground(for: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.5)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityValue("\(value)\(unit.isEmpty ? "" : " \(unit)"), \(status)")
    }

    // MARK: - Status Helpers
    private var cycleTierText: String {
        let count = battery.cycleCountDisplay
        if count < 500 { return L10n.Battery.healthTierNormal }
        if count < 800 { return L10n.Battery.healthTierAging }
        return L10n.Battery.healthTierService
    }

    private var cycleTierColor: Color {
        let count = battery.cycleCountDisplay
        if count < 500 { return readableAccent }
        if count < 800 { return Theme.readableYellow(for: colorScheme) }
        return Theme.readableOrange(for: colorScheme)
    }

    private var healthTierText: String {
        let health = battery.healthPercentDisplay
        if health >= 85 { return L10n.Battery.healthTierNormal }
        if health >= 80 { return L10n.Battery.healthTierAging }
        return L10n.Battery.healthTierService
    }

    private var healthTierColor: Color {
        let health = battery.healthPercentDisplay
        if health >= 85 { return readableAccent }
        if health >= 80 { return Theme.readableYellow(for: colorScheme) }
        return Theme.readableOrange(for: colorScheme)
    }
}

// MARK: - Preview
#Preview {
    BatteryHealthCycleCard()
        .padding()
}
