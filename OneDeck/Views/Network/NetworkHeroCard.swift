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
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            // MARK: - Header
            HStack(spacing: 8) {
                BentoSectionHeader(title: L10n.Network.linkStatusTitle, icon: net.linkType.iconName)

                Spacer()

                // Status Badge
                HStack(spacing: SpacingTheme.tight) {
                    Circle()
                        .fill(net.isConnected ? Color.green : Color.red)
                        .frame(width: 7, height: 7)

                    Text(net.isConnected ? L10n.Network.connected : L10n.Network.disconnected)
                        .font(Typography.calloutBold)
                        .foregroundStyle(net.isConnected ? Color.green : Color.red)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background((net.isConnected ? Color.green : Color.red).opacity(0.12))
                .clipShape(Capsule())
            }

            // MARK: - Main Interface Banner
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: SpacingTheme.tight) {
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
                            .font(Typography.title1)
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)

                        // Generation Badge (5G NR, 4G LTE, Wi-Fi 6, Wi-Fi 7)
                        let genTag = net.linkType == .cellular ? net.cellularGeneration : (net.linkType == .wifi ? net.wifiHardwareGeneration : "")
                        if !genTag.isEmpty {
                            Text(genTag)
                                .font(Typography.caption)
                                .fontWeight(.bold)
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
                            .font(Typography.captionMono)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)

                        if net.isExpensive {
                            Text(L10n.Network.expensiveCellular)
                                .font(Typography.badgeTag)
                                .foregroundStyle(.orange)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.orange.opacity(0.14))
                                .clipShape(Capsule())
                        }

                        if net.isConstrained {
                            Text(L10n.Network.lowDataMode)
                                .font(Typography.badgeTag)
                                .foregroundStyle(.yellow)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.yellow.opacity(0.14))
                                .clipShape(Capsule())
                        }
                    }
                }

                Spacer()

                // Quick Copy Banner Action
                if let copied = copiedItem {
                    Text("\(copied) \(L10n.Network.copied)")
                        .font(Typography.captionBold)
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
                        .font(Typography.badgeTag)
                        .foregroundStyle(appState.accentColor)
                        .padding(.horizontal, 4)
                        .padding(.vertical, SpacingTheme.micro)
                        .background(appState.accentColor.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.micro, style: .continuous))

                    Text("\(net.interfaceMtu) B")
                        .font(Typography.caption)
                        .fontDesign(.monospaced)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }

                Spacer()

                if net.subnetRange != "--" {
                    HStack(spacing: 4) {
                        Text(L10n.Network.subnetRange)
                            .font(Typography.badgeTagMedium)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)

                        Text(net.subnetRange)
                            .font(Typography.captionMono)
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
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: icon)
                        .font(IconTheme.tileLeading)
                        .foregroundStyle(appState.accentColor.opacity(0.85))

                    Text(label)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    Spacer(minLength: 0)

                    if canCopy {
                        Image(systemName: "doc.on.doc")
                            .font(IconTheme.copyIndicator)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    }
                }

                Text(value)
                    .font(Typography.bodyValueMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
            )
        }
        .buttonStyle(.plain)
    }
}

