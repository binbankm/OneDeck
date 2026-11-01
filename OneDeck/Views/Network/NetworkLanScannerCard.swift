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
        VStack(alignment: .leading, spacing: 14) {
            // MARK: - Header
            HStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(appState.accentColor.opacity(0.12))
                        .frame(width: 30, height: 30)

                    Image(systemName: "bonjour")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(appState.accentColor)
                }

                Text(L10n.Network.lanScanTitle)
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)

                if !net.discoveredDevices.isEmpty {
                    Text("\(net.discoveredDevices.count)")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
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
                                .font(.system(size: 11, weight: .semibold))
                        }

                        Text(net.isScanningLan ? L10n.Network.scanning : L10n.Network.startScan)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .foregroundStyle(appState.accentColor)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(appState.accentColor.opacity(0.12))
                    .clipShape(Capsule())
                }
                .disabled(net.isScanningLan)
            }

            // MARK: - Discovered Devices List
            if net.discoveredDevices.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: net.isScanningLan ? "antenna.radiowaves.left.and.right" : "wifi.router")
                        .font(.system(size: 26))
                        .foregroundStyle(appState.accentColor.opacity(0.7))
                        .symbolEffect(.pulse, isActive: net.isScanningLan)

                    Text(net.isScanningLan ? L10n.Network.scanning : L10n.Network.noLanDevices)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))

                    Text(L10n.Network.noLanDevicesHint)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Theme.cardBackground(for: colorScheme).opacity(0.4))
                )
            } else {
                VStack(spacing: 8) {
                    ForEach(net.discoveredDevices) { device in
                        HStack(spacing: 10) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(appState.accentColor.opacity(0.1))
                                    .frame(width: 32, height: 32)

                                Image(systemName: device.iconName)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(appState.accentColor)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(device.name)
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)

                                HStack(spacing: 6) {
                                    Text(friendlyServiceType(device.serviceType))
                                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                                        .foregroundStyle(Theme.textSecondary(for: colorScheme))

                                    Text("· \(device.interfaceName)")
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                                }
                            }

                            Spacer()

                            // Active Signal Badge
                            Circle()
                                .fill(Color.green)
                                .frame(width: 6, height: 6)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
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
