//
//  OverviewView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  System overview dashboard view with real-time performance telemetry.
//

import SwiftUI

struct OverviewView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var system = SystemViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    cardStack
                        .padding(.horizontal, SpacingTheme.cardStack)
                        .padding(.vertical, SpacingTheme.rowStandard)
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

    // MARK: - Subviews
    @ViewBuilder
    private var cardStack: some View {
        VStack(spacing: SpacingTheme.cardStack) {
            // 1. Hero Device Flagship Deck
            OverviewHeroCard()

            // 2. CPU Multi-Core Telemetry & Real-Time Waveform
            OverviewCpuCard()

            // 3. Dual-Zone Thermals & Heat Management
            OverviewThermalsCard()

            // 4. Real-Time Network Bandwidth & Sparklines
            OverviewNetworkCard()

            // 5. Memory & Storage Bento (Rigid Zero-Jitter Geometry)
            OverviewMemoryStorageCard()

            // 6. Comprehensive Hardware Inventory Hub
            OverviewHardwareCard()
        }
    }
}

// MARK: - Preview
#Preview {
    OverviewView()
}
