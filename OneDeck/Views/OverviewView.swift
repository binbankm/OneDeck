//
//  OverviewView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Dashboard Tab: Production Apple-Grade Bento Orchestrator with Zero Horizontal Drift.
//

import SwiftUI

struct OverviewView: View {
    @Bindable var appState = AppState.shared
    @Bindable var system = SystemService.shared
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        // MARK: - 1. Hero Device Flagship Deck
                        OverviewHeroCard()

                        // MARK: - 2. CPU Multi-Core Telemetry & Real-Time Waveform
                        OverviewCpuCard()

                        // MARK: - 3. Dual-Zone Thermals & Heat Management
                        OverviewThermalsCard()

                        // MARK: - 4. Real-Time Network Bandwidth & Sparklines
                        OverviewNetworkCard()

                        // MARK: - 5. Memory & Storage Bento (Rigid Zero-Jitter Geometry)
                        OverviewMemoryStorageCard()

                        // MARK: - 6. Comprehensive Hardware Inventory Hub
                        OverviewHardwareCard()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .frame(width: geometry.size.width)
                }
                .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            }
            .background(Theme.background(for: colorScheme).ignoresSafeArea())
            .navigationTitle(L10n.Overview.title)
            .onAppear {
                system.startMonitoring()
            }
            .onDisappear {
                system.stopMonitoring()
            }
        }
    }
}
