//
//  BatteryHealthCycleCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Battery Health & Cycle Count: 2x2 Bento Matrix & Apple Diagnostics Importer.
//

import SwiftUI

struct BatteryHealthCycleCard: View {
    @Bindable var appState = AppState.shared
    @Bindable var battery = BatteryService.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var showAnalyticsSheet: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header Row
            HStack {
                OverviewSectionHeader(title: L10n.Battery.healthTitle, icon: "heart.text.square.fill")

                Spacer()

                // Authenticity Badge
                HStack(spacing: 4) {
                    Circle()
                        .fill(battery.hasImportedBMS ? Color.green : Color.orange)
                        .frame(width: 6, height: 6)

                    Text(battery.hasImportedBMS ? L10n.Battery.bmsRaw : L10n.Battery.pendingImport)
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(battery.hasImportedBMS ? Color.green : Color.orange)
                        .lineLimit(1)
                }
                .padding(.horizontal, 9)
                .padding(.vertical, 3.5)
                .background((battery.hasImportedBMS ? Color.green : Color.orange).opacity(0.12))
                .clipShape(Capsule())
            }

            // 2x2 Bento Stat Matrix (Rock-Solid Geometry, Zero Wrap)
            VStack(spacing: 8) {
                HStack(spacing: 10) {
                    // Cell 1: Cycle Count
                    healthTile(
                        icon: "arrow.triangle.2.circlepath",
                        label: L10n.Battery.cycleCount,
                        value: battery.hasImportedBMS ? "\(battery.cycleCountDisplay)" : "--",
                        unit: battery.hasImportedBMS ? L10n.Battery.cyclesUnit : "",
                        status: battery.hasImportedBMS ? cycleTierText : L10n.Battery.pendingImport,
                        statusColor: battery.hasImportedBMS ? cycleTierColor : .orange
                    )

                    // Cell 2: Battery Health %
                    healthTile(
                        icon: "heart.fill",
                        label: L10n.Battery.health,
                        value: battery.hasImportedBMS ? String(format: "%.1f", battery.healthPercentDisplay) : "--",
                        unit: battery.hasImportedBMS ? "%" : "",
                        status: battery.hasImportedBMS ? healthTierText : L10n.Battery.pendingImport,
                        statusColor: battery.hasImportedBMS ? healthTierColor : .orange
                    )
                }

                HStack(spacing: 10) {
                    // Cell 3: Current Max Actual Capacity
                    healthTile(
                        icon: "battery.100.bolt",
                        label: L10n.Battery.currentMaxCapacity,
                        value: battery.hasImportedBMS ? "\(battery.actualMaxCapacityMahDisplay)" : "--",
                        unit: battery.hasImportedBMS ? "mAh" : "",
                        status: battery.hasImportedBMS ? L10n.Battery.effectiveCap : L10n.Battery.pendingImport,
                        statusColor: battery.hasImportedBMS ? appState.accentColor : .orange
                    )

                    // Cell 4: Factory Design Capacity (Known accurately from factory DB)
                    healthTile(
                        icon: "bolt.badge.clock",
                        label: L10n.Battery.designCapacity,
                        value: "\(battery.effectiveDesignCapacityMah)",
                        unit: "mAh",
                        status: battery.isCustomBattery ? L10n.Battery.customCalibrated : L10n.Battery.oemNominal,
                        statusColor: battery.isCustomBattery ? .orange : Theme.textSecondary(for: colorScheme)
                    )
                }
            }

            // Official Diagnostics Log Importer & Reset Row
            HStack(spacing: 8) {
                Button {
                    Haptics.impact(.medium)
                    showAnalyticsSheet = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: battery.analyticsRecord != nil ? "checkmark.seal.fill" : "sparkles")
                            .font(.system(size: 12, weight: .semibold))

                        Text(battery.analyticsRecord != nil ? L10n.Battery.importedSuccess : L10n.Battery.importLogButton)
                            .font(.system(size: 12, weight: .semibold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)

                        if let record = battery.analyticsRecord {
                            Spacer()
                            Text(formatDate(record.logDate))
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundStyle(appState.accentColor.opacity(0.8))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .padding(.horizontal, 10)
                    .background(appState.accentColor.opacity(0.12))
                    .foregroundStyle(appState.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(appState.accentColor.opacity(0.25), lineWidth: 0.5)
                    )
                }

                if battery.analyticsRecord != nil {
                    Button {
                        Haptics.impact(.medium)
                        battery.clearAnalyticsRecord()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 12, weight: .semibold))
                            .frame(width: 36, height: 36)
                            .background(colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.04))
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                }
            }
        }
        .bentoCard(accent: appState.accentColor)
        .sheet(isPresented: $showAnalyticsSheet) {
            BatteryAnalyticsSheet()
        }
    }

    // MARK: - Subviews
    @ViewBuilder
    private func healthTile(
        icon: String,
        label: String,
        value: String,
        unit: String,
        status: String,
        statusColor: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            // Row 1: Icon & Label (100% Dedicated Full-Width Row, Zero Truncation)
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(appState.accentColor)

                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            // Row 2: Bold Hero Metric Value & Unit (100% Dedicated Row, Zero Crowding)
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(value)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(unit)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }

            // Row 3: Status Capsule Pill (Dedicated Row, Zero Competition, Zero Truncation)
            Text(status)
                .font(.system(size: 9, weight: .semibold, design: .rounded))
                .padding(.horizontal, 6)
                .padding(.vertical, 2.5)
                .background(statusColor.opacity(0.12))
                .foregroundStyle(statusColor)
                .clipShape(Capsule())
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
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

