//
//  BatteryView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Battery Tab: Production Apple-Grade Power & Battery Intelligence Orchestrator.
//

import SwiftUI

struct BatteryView: View {
    @Bindable var appState = AppState.shared
    @Bindable var battery = BatteryService.shared
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        // MARK: - 1. Hero Dynamic Level Gauge & Protocol HUD
                        BatteryHeroCard()

                        // MARK: - 2. Device Thermal Chassis Blueprint (Hardware Heatmap Model)
                        BatteryThermalChassisCard()

                        // MARK: - 3. Battery Health & Cycle Matrix (Apple Diagnostics Importer)
                        BatteryHealthCycleCard()

                        // MARK: - 4. Battery Longevity Assessment & Smart Care Hub
                        BatteryLongevityCard()

                        // MARK: - 5. Live Electrical Telemetry (Wattage Waveform, Voltage & Current)
                        BatteryLivePowerCard()

                        // MARK: - 6. Third-Party Cell & Super-Capacity Calibration Hub
                        BatteryCellCalibrationCard()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .frame(width: geometry.size.width)
                }
                .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            }
            .background(Theme.background(for: colorScheme).ignoresSafeArea())
            .navigationTitle(L10n.Battery.title)
            .onAppear {
                battery.startMonitoring()
            }
            .onDisappear {
                battery.stopMonitoring()
            }
        }
    }
}
