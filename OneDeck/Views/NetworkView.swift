//
//  NetworkView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Network Tab: Real-Time Darwin POSIX Network Intelligence Orchestrator.
//

import SwiftUI

struct NetworkView: View {
    @Bindable var appState = AppState.shared
    @Bindable var net = NetworkService.shared
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        // MARK: - 1. Hero Link & Network Interface HUD
                        NetworkHeroCard()

                        // MARK: - 2. Real POSIX Latency & Jitter Monitor
                        NetworkLatencyCard()

                        // MARK: - 3. Live Throughput Waveform (Download/Upload)
                        NetworkTrafficCard()

                        // MARK: - 4. Public Gateway & GeoIP Resolver
                        NetworkPublicIPCard()

                        // MARK: - 5. LAN Bonjour mDNS Device Scanner
                        NetworkLanScannerCard()

                        // MARK: - 6. Common Services & Port Scanner
                        NetworkPortScannerCard()

                        // MARK: - 7. POSIX DNS Domain Resolution (Dig)
                        NetworkDnsLookupCard()

                        // MARK: - 8. Wake-on-LAN Magic Packet Dispatcher
                        NetworkWolCard()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .frame(width: geometry.size.width)
                }
                .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            }
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
}
