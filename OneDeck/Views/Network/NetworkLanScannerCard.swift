//
//  NetworkLanScannerCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Network LAN Scanner Card: Real NWBrowser Bonjour mDNS Subnet Device Discovery.
//

import SwiftUI

struct NetworkLanScannerCard: View {
    @Bindable var appState = AppState.shared
    @Bindable var net = NetworkService.shared
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            // MARK: - Header
            HStack(spacing: 8) {
                BentoSectionHeader(title: L10n.Network.lanScanTitle, icon: "bonjour")

                if !net.discoveredDevices.isEmpty {
                    Text("\(net.discoveredDevices.count)")
                        .font(Typography.captionMono)
                        .foregroundStyle(appState.accentColor)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(appState.accentColor.opacity(0.12))
                        .clipShape(Capsule())
                }

                Spacer()

                // Trigger Scan Button
                Button {
                    Haptics.impact(.medium)
                    net.startLanScan()
                } label: {
                    HStack(spacing: 4) {
                        if net.isScanningLan {
                            ProgressView()
                                .tint(appState.accentColor)
                                .scaleEffect(0.65)
                        } else {
                            Image(systemName: "dot.radiowaves.left.and.right")
                                .font(IconTheme.actionButton)
                        }

                        Text(net.isScanningLan ? L10n.Network.scanning : L10n.Network.startScan)
                            .font(Typography.captionBold)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .foregroundStyle(appState.accentColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(appState.accentColor.opacity(0.12))
                    .clipShape(Capsule())
                }
                .disabled(net.isScanningLan)
            }

            // MARK: - Discovered Devices List
            if net.discoveredDevices.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: net.isScanningLan ? "antenna.radiowaves.left.and.right" : "wifi.router")
                        .font(IconTheme.emptyState)
                        .foregroundStyle(appState.accentColor.opacity(0.7))
                        .symbolEffect(.pulse, isActive: net.isScanningLan)

                    Text(net.isScanningLan ? L10n.Network.scanning : L10n.Network.noLanDevices)
                        .font(Typography.bodyValue)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))

                    Text(L10n.Network.noLanDevicesHint)
                        .font(Typography.captionRegular)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .fill(Theme.cardBackground(for: colorScheme).opacity(0.4))
                )
            } else {
                VStack(spacing: 8) {
                    ForEach(net.discoveredDevices) { device in
                        HStack(spacing: 10) {
                            ZStack {
                                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                    .fill(appState.accentColor.opacity(0.1))
                                    .frame(width: 32, height: 32)

                                Image(systemName: device.iconName)
                                    .font(IconTheme.sectionHeader)
                                    .foregroundStyle(appState.accentColor)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 6) {
                                    Text(device.name)
                                        .font(Typography.bodyValue)
                                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.85)

                                    if let vendor = device.vendorName, vendor != device.name {
                                        Text(vendor)
                                            .font(Typography.badgeTagMedium)
                                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                                            .lineLimit(1)
                                    }
                                }

                                HStack(spacing: 6) {
                                    if device.ipAddress != "--" {
                                        Text(device.ipAddress)
                                            .font(Typography.captionMono)
                                            .foregroundStyle(appState.accentColor)
                                    }

                                    if let mac = device.macAddress {
                                        Text(mac.uppercased())
                                            .font(Typography.badgeTagMonoMedium)
                                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                                    }

                                    Text("· \(friendlyServiceType(device.serviceType))")
                                        .font(Typography.badgeTagMedium)
                                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                                }
                            }

                            Spacer()

                            if let lat = device.latencyMs {
                                Text(String(format: "%.0fms", lat))
                                    .font(Typography.badgeTagMono)
                                    .foregroundStyle(Color.green)
                                    .padding(.horizontal, SpacingTheme.compact)
                                    .padding(.vertical, 2)
                                    .background(Color.green.opacity(0.12))
                                    .clipShape(Capsule())
                            } else {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 6, height: 6)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if device.ipAddress != "--" {
                                UIPasteboard.general.string = device.ipAddress
                                Haptics.tick()
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                        )
                    }
                }
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    private func friendlyServiceType(_ type: String) -> String {
        if type.contains("airplay") {
            return "AirPlay"
        } else if type.contains("smb") {
            return "SMB"
        } else if type.contains("raop") {
            return "AirPlay Audio"
        } else if type.contains("http") {
            return "HTTP"
        } else {
            return type.replacingOccurrences(of: "._tcp", with: "").replacingOccurrences(of: "_", with: "")
        }
    }
}
