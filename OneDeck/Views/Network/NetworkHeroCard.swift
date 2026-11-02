//
//  NetworkHeroCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Network Hero Card: Hardware Link State, Local IP, Gateway, Subnet & DNS.
//

import SwiftUI
import UniformTypeIdentifiers

struct NetworkHeroCard: View {
    @Bindable var appState = AppState.shared
    @Bindable var net = NetworkService.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var copiedItem: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // MARK: - Header
            HStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(appState.accentColor.opacity(0.12))
                        .frame(width: 30, height: 30)

                    Image(systemName: net.linkType.iconName)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(appState.accentColor)
                }

                Text(L10n.Network.linkStatusTitle)
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))

                Spacer()

                // Status Badge
                HStack(spacing: 5) {
                    Circle()
                        .fill(net.isConnected ? Color.green : Color.red)
                        .frame(width: 7, height: 7)

                    Text(net.isConnected ? L10n.Network.connected : L10n.Network.disconnected)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(net.isConnected ? Color.green : Color.red)
                }
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background((net.isConnected ? Color.green : Color.red).opacity(0.12))
                .clipShape(Capsule())
            }

            // MARK: - Main Interface Banner
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        let bannerTitle: String = {
                            if net.linkType == .wifi {
                                if let ssid = net.wifiSSID, !ssid.isEmpty { return ssid }
                                return net.linkType.localizedName
                            } else if net.linkType == .cellular {
                                return net.carrierName.isEmpty ? L10n.Network.cellular : net.carrierName
                            } else {
                                return net.linkType.localizedName
                            }
                        }()

                        Text(bannerTitle)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))
                            .lineLimit(1)

                        // Generation Badge (5G NR, 4G LTE, Wi-Fi 6, Wi-Fi 7)
                        let genTag = net.linkType == .cellular ? net.cellularGeneration : (net.linkType == .wifi ? net.wifiHardwareGeneration : "")
                        if !genTag.isEmpty {
                            Text(genTag)
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundStyle(net.linkType == .cellular ? Color.orange : appState.accentColor)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background((net.linkType == .cellular ? Color.orange : appState.accentColor).opacity(0.14))
                                .clipShape(Capsule())
                        }
                    }

                    HStack(spacing: 6) {
                        let subDetails: String = {
                            if net.linkType == .wifi {
                                var parts = ["en0", net.wifiStandard]
                                if let rssi = net.wifiRssiDbm { parts.append("\(rssi) dBm") }
                                if let ch = net.wifiChannel { parts.append("CH\(ch)") }
                                if let rate = net.wifiTxRateMbps { parts.append("\(rate) Mbps") }
                                return parts.joined(separator: " · ")
                            } else if net.linkType == .cellular {
                                return "pdp_ip0 · \(L10n.Network.cellularBasebandDesc)"
                            } else {
                                return "lo0"
                            }
                        }()

                        Text(subDetails)
                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .lineLimit(1)

                        if net.isExpensive {
                            Text(L10n.Network.expensiveCellular)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(.orange)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 1.5)
                                .background(Color.orange.opacity(0.14))
                                .clipShape(Capsule())
                        }

                        if net.isConstrained {
                            Text(L10n.Network.lowDataMode)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(.yellow)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 1.5)
                                .background(Color.yellow.opacity(0.14))
                                .clipShape(Capsule())
                        }
                    }
                }

                Spacer()

                // Quick Copy Banner Action
                if let copied = copiedItem {
                    Text("\(copied) \(L10n.Network.copied)")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(appState.accentColor)
                        .transition(.opacity.combined(with: .scale))
                }
            }
            .padding(.vertical, 2)

            Divider().opacity(0.3)

            // MARK: - 4-Metric Grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                metricCell(
                    label: L10n.Network.localIP,
                    value: net.localIPv4,
                    icon: "network",
                    canCopy: true
                )

                metricCell(
                    label: L10n.Network.gateway,
                    value: net.gatewayIPv4,
                    icon: "point.3.connected.trianglepath.dotted",
                    canCopy: true
                )

                metricCell(
                    label: L10n.Network.subnetMask,
                    value: net.subnetMask,
                    icon: "slider.horizontal.2.square",
                    canCopy: false
                )

                metricCell(
                    label: L10n.Network.dnsServer,
                    value: net.dnsServers.first ?? "--",
                    icon: "server.rack",
                    canCopy: true
                )
            }

            // MARK: - Hardware Link Specs Footer
            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Text("MTU")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(appState.accentColor)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(appState.accentColor.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 3, style: .continuous))

                    Text("\(net.interfaceMtu) B")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }

                Spacer()

                if net.subnetRange != "--" {
                    HStack(spacing: 4) {
                        Text(L10n.Network.subnetRange)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)

                        Text(net.subnetRange)
                            .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                }
            }
            .padding(.top, 2)
        }
        .bentoCard(accent: appState.accentColor)
    }

    @ViewBuilder
    private func metricCell(label: String, value: String, icon: String, canCopy: Bool) -> some View {
        Button {
            guard canCopy && value != "--" && !value.isEmpty else { return }
            UIPasteboard.general.string = value
            Haptics.tick()
            withAnimation(.easeInOut(duration: 0.2)) {
                copiedItem = label
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation {
                    if copiedItem == label {
                        copiedItem = nil
                    }
                }
            }
        } label: {
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 5) {
                    Image(systemName: icon)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(appState.accentColor.opacity(0.85))

                    Text(label)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    Spacer(minLength: 0)

                    if canCopy {
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 9))
                            .foregroundStyle(Theme.textSecondary(for: colorScheme).opacity(0.6))
                    }
                }

                Text(value)
                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .padding(.horizontal, 11)
            .padding(.vertical, 9)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
            )
        }
        .buttonStyle(.plain)
    }
}

