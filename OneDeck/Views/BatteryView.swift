//
//  BatteryView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Battery dashboard view hosting telemetry cards and health matrices.
//

import SwiftUI

struct BatteryView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var battery = BatteryViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                cardStack
                    .frame(maxWidth: 680)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, SpacingTheme.cardStack)
                    .padding(.vertical, SpacingTheme.rowStandard)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
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

    // MARK: - Subviews
    @ViewBuilder
    private var cardStack: some View {
        VStack(spacing: SpacingTheme.cardStack) {
            // 1. Hero Dynamic Level Gauge & Protocol HUD
            BatteryHeroCard()

            // 2. Device Thermal Chassis Blueprint (Hardware Heatmap Model)
            BatteryThermalChassisCard()

            // 3. Battery Health & Cycle Matrix (Apple Diagnostics Importer)
            BatteryHealthCycleCard()

            // 4. Battery Longevity Assessment & Smart Care Hub
            BatteryLongevityCard()

            // 5. Live Electrical Telemetry (Wattage Waveform, Voltage & Current)
            BatteryLivePowerCard()

            // 6. Third-Party Cell & Super-Capacity Calibration Hub
            BatteryCellCalibrationCard()
        }
    }
}

// MARK: - Preview
#Preview {
    BatteryView()
}
