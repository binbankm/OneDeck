//
//  NetworkView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Network dashboard view hosting connection and traffic diagnostics.
//

import SwiftUI

struct NetworkView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var net = NetworkViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                cardStack
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, SpacingTheme.cardStack)
                    .padding(.vertical, SpacingTheme.rowStandard)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            .background(Theme.background(for: colorScheme).ignoresSafeArea())
            .navigationTitle(L10n.Network.title)
            .onAppear {
                net.startMonitoring()
            }
            .onDisappear {
                net.stopMonitoring()
            }
        }
    }

    // MARK: - Subviews
    @ViewBuilder
    private var cardStack: some View {
        VStack(spacing: SpacingTheme.cardStack) {
            // 1. Hero Link & Network Interface HUD
            NetworkHeroCard()

            // 2. Real POSIX Latency & Jitter Monitor
            NetworkLatencyCard()

            // 3. Live Throughput Waveform (Download/Upload)
            NetworkTrafficCard()

            // 4. Public Gateway & GeoIP Resolver
            NetworkPublicIPCard()

            // 5. LAN Bonjour mDNS Device Scanner
            NetworkLanScannerCard()

            // 6. Common Services & Port Scanner
            NetworkPortScannerCard()

            // 7. POSIX DNS Domain Resolution (Dig)
            NetworkDnsLookupCard()

            // 8. Wake-on-LAN Magic Packet Dispatcher
            NetworkWolCard()
        }
    }
}

// MARK: - Preview
#Preview {
    NetworkView()
}
