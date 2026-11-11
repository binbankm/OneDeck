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

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                cardStack
                    .frame(maxWidth: LayoutTheme.maxContentWidth)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, SpacingTheme.cardStack)
                    .padding(.vertical, SpacingTheme.rowStandard)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            .background(Theme.background(for: colorScheme).ignoresSafeArea())
            .navigationTitle(L10n.Overview.title)
        }
    }

    // MARK: - Subviews
    @ViewBuilder
    private var cardStack: some View {
        LazyVStack(spacing: SpacingTheme.cardStack) {
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
