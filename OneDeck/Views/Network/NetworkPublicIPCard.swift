//
//  NetworkPublicIPCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Network Public IP Card: Asynchronous Public IP, ISP ASN & GeoIP Resolution.
//

import SwiftUI
import UniformTypeIdentifiers

struct NetworkPublicIPCard: View {
    @Bindable var appState = AppState.shared
    @Bindable var net = NetworkService.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var isCopied: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            headerRow
            ipHeroSection
            proxyExitBanner
            geoGrid
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Header
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(appState.accentColor.opacity(0.12))
                    .frame(width: 30, height: 30)

                Image(systemName: "globe.asia.australia.fill")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(appState.accentColor)
            }

            Text(L10n.Network.publicIPTitle)
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(1)

            Spacer()

            // Refresh Button
            Button {
                Haptics.tick()
                net.fetchPublicIPInfo(force: true)
            } label: {
                HStack(spacing: 4) {
                    if net.isQueryingPublicIP {
                        ProgressView()
                            .tint(appState.accentColor)
                            .scaleEffect(0.65)

                        Text(L10n.Network.querying)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    } else {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 11, weight: .semibold))

                        Text(L10n.Network.refresh)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                }
                .foregroundStyle(appState.accentColor)
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(appState.accentColor.opacity(0.12))
                .clipShape(Capsule())
            }
            .fixedSize(horizontal: true, vertical: false)
        }
    }

    // MARK: - IP Hero Section
    @ViewBuilder
    private var ipHeroSection: some View {
        Button {
            guard net.publicIP != "--" && !net.publicIP.isEmpty else { return }
            UIPasteboard.general.string = net.publicIP
            Haptics.tick()
            withAnimation { isCopied = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation { isCopied = false }
            }
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 6) {
                            Text(L10n.Network.publicIP)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))

                            Text(net.publicIP.contains(":") ? "IPv6" : "IPv4")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(appState.accentColor)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 1)
                                .background(appState.accentColor.opacity(0.14))
                                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                        }

                        Text(net.publicIP)
                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }

                    Spacer()

                    if isCopied {
                        Text(L10n.Network.copied)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(appState.accentColor)
                    } else {
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.textSecondary(for: colorScheme).opacity(0.6))
                    }
                }

                // Dual-stack IPv6 display if both are present
                if !net.publicIPv6.isEmpty && net.publicIPv6 != net.publicIP {
                    HStack(spacing: 6) {
                        Text("IPv6")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(appState.accentColor)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1)
                            .background(appState.accentColor.opacity(0.14))
                            .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))

                        Text(net.publicIPv6)
                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .lineLimit(1)
                            .minimumScaleFactor(0.65)

                        Spacer()
                    }
                    .padding(.top, 2)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
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

    // MARK: - Proxy Exit Banner (Only when actual proxy exit detected)
    @ViewBuilder
    private var proxyExitBanner: some View {
        if !net.proxyExitIP.isEmpty && net.proxyExitIP != net.publicIP && net.proxyExitIP != net.publicIPv6 {
            HStack(spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "shield.lefthalf.filled")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.orange)

                    Text(L10n.Network.proxyExit)
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }

                Spacer(minLength: 6)

                HStack(spacing: 4) {
                    Text(net.proxyExitIP)
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    if !net.proxyExitLocation.isEmpty {
                        Text("· \(net.proxyExitLocation)")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
                .lineLimit(1)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.orange.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color.orange.opacity(0.18), lineWidth: 0.8)
            )
        }
    }

    // MARK: - Geo Grid
    @ViewBuilder
    private var geoGrid: some View {
        HStack(spacing: 10) {
            geoCell(
                title: L10n.Network.carrierIsp,
                value: net.ispName,
                icon: "building.2.crop.circle"
            )

            let locationString = net.geoCity.isEmpty ? (net.geoCountry.isEmpty ? "--" : net.geoCountry) : "\(net.geoCity), \(net.geoCountry)"
            geoCell(
                title: L10n.Network.geoCity,
                value: locationString,
                icon: "mappin.and.ellipse"
            )
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    @ViewBuilder
    private func geoCell(title: String, value: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(appState.accentColor)

                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            Text(value.isEmpty ? "--" : value)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(3)
                .minimumScaleFactor(0.7)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 11)
        .padding(.vertical, 9)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .frame(minHeight: 58)
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
