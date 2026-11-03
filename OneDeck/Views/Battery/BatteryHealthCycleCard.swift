//
//  BatteryHealthCycleCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Battery Health & Cycle Count: 2x2 Bento Matrix & Apple Diagnostics Importer.
//

import SwiftUI

struct BatteryHealthCycleCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var battery = BatteryViewModel.shared

    // MARK: - State
    @State private var showAnalyticsSheet: Bool = false

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
        HStack {
            OverviewSectionHeader(title: L10n.Battery.healthTitle, icon: "heart.text.square.fill")

            Spacer()

            let isDataActive = battery.hasRealTelemetry
            let badgeColor: Color = isDataActive ? .green : .orange
            let badgeText: String = battery.hasImportedBMS ? L10n.Battery.bmsRaw : (battery.hasRealTelemetry ? L10n.Battery.hardwareDirectTag : L10n.Battery.baselineEstimated)

            HStack(spacing: SpacingTheme.tight) {
                Circle()
                    .fill(badgeColor)
                    .frame(width: 6, height: 6)

                Text(badgeText)
                    .font(Typography.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(badgeColor)
                    .lineLimit(1)
            }
            .padding(.horizontal, SpacingTheme.standard)
            .padding(.vertical, SpacingTheme.micro)
            .background(badgeColor.opacity(0.12))
            .clipShape(Capsule())
        }
    }

    @ViewBuilder
    private var matrixSection: some View {
        let isDataActive = battery.hasRealTelemetry
        VStack(spacing: SpacingTheme.standard) {
            HStack(spacing: SpacingTheme.row) {
                healthTile(
                    icon: "arrow.triangle.2.circlepath",
                    label: L10n.Battery.cycleCount,
                    value: "\(battery.cycleCountDisplay)",
                    unit: L10n.Battery.cyclesUnit,
                    status: isDataActive ? cycleTierText : L10n.Battery.baselineEstimated,
                    statusColor: isDataActive ? cycleTierColor : .orange
                )

                healthTile(
                    icon: "heart.fill",
                    label: L10n.Battery.health,
                    value: String(format: "%.1f", battery.healthPercentDisplay),
                    unit: "%",
                    status: isDataActive ? healthTierText : L10n.Battery.baselineEstimated,
                    statusColor: isDataActive ? healthTierColor : .orange
                )
            }

            HStack(spacing: SpacingTheme.row) {
                healthTile(
                    icon: "battery.100.bolt",
                    label: L10n.Battery.currentMaxCapacity,
                    value: "\(battery.actualMaxCapacityMahDisplay)",
                    unit: "mAh",
                    status: isDataActive ? L10n.Battery.effectiveCap : L10n.Battery.baselineEstimated,
                    statusColor: isDataActive ? appState.accentColor : .orange
                )

                healthTile(
                    icon: "bolt.badge.clock.fill",
                    label: L10n.Battery.designCapacity,
                    value: "\(battery.effectiveDesignCapacityMah)",
                    unit: "mAh",
                    status: battery.isCustomBattery ? L10n.Battery.customCalibrated : L10n.Battery.oemNominal,
                    statusColor: battery.isCustomBattery ? .orange : Theme.textSecondary(for: colorScheme)
                )
            }
        }
    }

    @ViewBuilder
    private var baselineNoticeSection: some View {
        HStack(spacing: SpacingTheme.compact) {
            Image(systemName: "info.circle.fill")
                .font(IconTheme.tileLeading)
                .foregroundStyle(.orange)

            Text(L10n.Battery.baselineNotice)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(2)
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.compact)
        .background(Color.orange.opacity(colorScheme == .dark ? 0.08 : 0.06))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
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
            HStack(spacing: SpacingTheme.compact) {
                Image(systemName: "battery.100.bolt")
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(appState.accentColor)

                Text(L10n.Battery.cellVoltagesLabel)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))

                Spacer()

                Text(battery.cellVoltages.map { "\($0) mV" }.joined(separator: " · "))
                    .font(Typography.captionMono)
                    .foregroundStyle(appState.accentColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .padding(.horizontal, SpacingTheme.row)
            .padding(.vertical, SpacingTheme.standard)
            .background(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        }
    }

    @ViewBuilder
    private func hardwareRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: SpacingTheme.compact) {
            Image(systemName: icon)
                .font(IconTheme.tileLeading)
                .foregroundStyle(appState.accentColor)

            Text(label)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))

            Spacer()

            Text(value)
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
    }

    @ViewBuilder
    private var diagnosticsActionSection: some View {
        HStack(spacing: SpacingTheme.standard) {
            Button {
                Haptics.impact(.medium)
                showAnalyticsSheet = true
            } label: {
                HStack(spacing: SpacingTheme.compact) {
                    Image(systemName: battery.analyticsRecord != nil ? "checkmark.seal.fill" : "sparkles")
                        .font(IconTheme.actionButton)

                    Text(battery.analyticsRecord != nil ? L10n.Battery.importedSuccess : L10n.Battery.importLogButton)
                        .font(Typography.calloutLabel)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    if let record = battery.analyticsRecord {
                        Spacer()
                        Text(formatDate(record.logDate))
                            .font(Typography.badgeTagMono)
                            .foregroundStyle(appState.accentColor.opacity(0.8))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .padding(.horizontal, SpacingTheme.row)
                .background(appState.accentColor.opacity(0.12))
                .foregroundStyle(appState.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(appState.accentColor.opacity(0.25), lineWidth: 0.5)
                )
            }

            if battery.analyticsRecord != nil {
                Button {
                    Haptics.impact(.medium)
                    battery.clearAnalyticsRecord()
                } label: {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(IconTheme.actionButton)
                        .frame(width: 36, height: 36)
                        .background(colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.04))
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                }
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
                    .foregroundStyle(appState.accentColor)

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

                Text(unit)
                    .font(Typography.captionBold)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
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
        .background(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
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
        if count < 500 { return appState.accentColor }
        if count < 800 { return .yellow }
        return .orange
    }

    private var healthTierText: String {
        let health = battery.healthPercentDisplay
        if health >= 85 { return L10n.Battery.healthTierNormal }
        if health >= 80 { return L10n.Battery.healthTierAging }
        return L10n.Battery.healthTierService
    }

    private var healthTierColor: Color {
        let health = battery.healthPercentDisplay
        if health >= 85 { return appState.accentColor }
        if health >= 80 { return .yellow }
        return .orange
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        return formatter.string(from: date)
    }
}

// MARK: - Preview
#Preview {
    BatteryHealthCycleCard()
        .padding()
}
