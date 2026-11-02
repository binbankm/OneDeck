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
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var net = NetworkViewModel.shared

    // MARK: - State
    @State private var isCopied: Bool = false

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerRow
            ipHeroSection
            proxyExitBanner
            geoGrid
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(title: L10n.Network.publicIPTitle, icon: "globe.asia.australia.fill")

            Spacer()

            // Refresh Button
            Button {
                Haptics.tick()
                net.fetchPublicIPInfo(force: true)
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    if net.isQueryingPublicIP {
                        ProgressView()
                            .tint(appState.accentColor)
                            .scaleEffect(0.65)

                        Text(L10n.Network.querying)
                            .font(Typography.captionBold)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    } else {
                        Image(systemName: "arrow.clockwise")
                            .font(IconTheme.actionButton)

                        Text(L10n.Network.refresh)
                            .font(Typography.captionBold)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                }
                .foregroundStyle(appState.accentColor)
                .padding(.horizontal, SpacingTheme.row)
                .padding(.vertical, SpacingTheme.tight)
                .background(appState.accentColor.opacity(0.12))
                .clipShape(Capsule())
            }
            .fixedSize(horizontal: true, vertical: false)
        }
    }

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
            VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                HStack(spacing: SpacingTheme.row) {
                    VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                        HStack(spacing: SpacingTheme.compact) {
                            Text(L10n.Network.publicIP)
                                .font(Typography.caption)
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))

                            Text(net.publicIP.contains(":") ? "IPv6" : "IPv4")
                                .font(Typography.badgeTag)
                                .foregroundStyle(appState.accentColor)
                                .padding(.horizontal, SpacingTheme.compact)
                                .padding(.vertical, SpacingTheme.micro)
                                .background(appState.accentColor.opacity(0.14))
                                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.micro, style: .continuous))
                        }

                        Text(net.publicIP)
                            .font(Typography.heroSubValueMono)
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }

                    Spacer()

                    if isCopied {
                        Text(L10n.Network.copied)
                            .font(Typography.caption)
                            .foregroundStyle(appState.accentColor)
                    } else {
                        Image(systemName: "doc.on.doc")
                            .font(IconTheme.copyIndicator)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    }
                }

                // Dual-stack IPv6 display if both are present
                if !net.publicIPv6.isEmpty && net.publicIPv6 != net.publicIP {
                    HStack(spacing: SpacingTheme.compact) {
                        Text("IPv6")
                            .font(Typography.badgeTag)
                            .foregroundStyle(appState.accentColor)
                            .padding(.horizontal, SpacingTheme.compact)
                            .padding(.vertical, SpacingTheme.micro)
                            .background(appState.accentColor.opacity(0.14))
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.micro, style: .continuous))

                        Text(net.publicIPv6)
                            .font(Typography.captionMono)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .lineLimit(1)
                            .minimumScaleFactor(0.65)

                        Spacer()
                    }
                    .padding(.top, SpacingTheme.micro)
                }
            }
            .padding(.horizontal, SpacingTheme.rowStandard)
            .padding(.vertical, SpacingTheme.row)
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

    @ViewBuilder
    private var proxyExitBanner: some View {
        if !net.proxyExitIP.isEmpty && net.proxyExitIP != net.publicIP && net.proxyExitIP != net.publicIPv6 {
            HStack(spacing: SpacingTheme.standard) {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "shield.lefthalf.filled")
                        .font(IconTheme.tileLeading)
                        .foregroundStyle(Color.orange)

                    Text(L10n.Network.proxyExit)
                        .font(Typography.captionBold)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }

                Spacer(minLength: SpacingTheme.compact)

                HStack(spacing: SpacingTheme.tight) {
                    Text(net.proxyExitIP)
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    if !net.proxyExitLocation.isEmpty {
                        Text("· \(net.proxyExitLocation)")
                            .font(Typography.badgeTag)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
                .lineLimit(1)
            }
            .padding(.horizontal, SpacingTheme.row)
            .padding(.vertical, SpacingTheme.compact)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .fill(Color.orange.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .stroke(Color.orange.opacity(0.18), lineWidth: 0.8)
            )
        }
    }

    @ViewBuilder
    private var geoGrid: some View {
        HStack(spacing: SpacingTheme.row) {
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
        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: icon)
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(appState.accentColor)

                Text(title)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            Text(value.isEmpty ? "--" : value)
                .font(Typography.bodyValue)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(3)
                .minimumScaleFactor(0.7)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .frame(minHeight: 58)
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

// MARK: - Preview
#Preview {
    NetworkPublicIPCard()
        .padding()
}
