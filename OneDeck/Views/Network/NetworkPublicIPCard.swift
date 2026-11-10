//
//  NetworkPublicIPCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  External public IP address, ISP provider, and geolocation card.
//

import SwiftUI

struct NetworkPublicIPCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var net = NetworkViewModel.shared

    private enum CopyTarget: Equatable {
        case primary
        case ipv6
        case proxy
    }

    // MARK: - State
    @State private var copiedTarget: CopyTarget?
    @State private var copyToastTask: Task<Void, Never>?

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerRow
            ipHeroSection
            proxyExitBanner
            geoGrid
        }
        .bentoCard(accent: appState.accentColor)
        .onDisappear {
            copyToastTask?.cancel()
            copyToastTask = nil
        }
    }

    // MARK: - Subviews
    @ViewBuilder
    private var headerRow: some View {
        let refreshButton = Button {
            Haptics.tick()
            net.fetchPublicIPInfo(force: true)
        } label: {
            HStack(spacing: SpacingTheme.tight) {
                if net.isQueryingPublicIP {
                    ProgressView()
                        .controlSize(.small)
                        .tint(accentFg)

                    Text(L10n.Network.querying)
                        .font(Typography.captionBold)
                        .lineLimit(1)
                } else {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(IconTheme.actionButton)
                        .accessibilityHidden(true)

                    Text(L10n.Network.refresh)
                        .font(Typography.captionBold)
                        .lineLimit(1)
                }
            }
            .foregroundStyle(accentFg)
            .padding(.horizontal, SpacingTheme.row)
            .frame(minHeight: LayoutTheme.minTapTarget)
            .background(appState.accentColor.opacity(0.12))
            .clipShape(Capsule())
            .contentShape(Capsule())
        }
        .buttonStyle(BentoCardButtonStyle())
        .accessibilityLabel(net.isQueryingPublicIP ? L10n.Network.querying : L10n.Network.refresh)

        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                BentoSectionHeader(title: L10n.Network.publicIPTitle, icon: "globe.asia.australia.fill")
                refreshButton
            }
        } else {
            HStack(spacing: SpacingTheme.standard) {
                BentoSectionHeader(title: L10n.Network.publicIPTitle, icon: "globe.asia.australia.fill")
                Spacer(minLength: SpacingTheme.compact)
                refreshButton
            }
        }
    }

    @ViewBuilder
    private var ipHeroSection: some View {
        let primaryCopyable = net.publicIP != "--" && !net.publicIP.isEmpty
        let hasDualIpv6 = !net.publicIPv6.isEmpty && net.publicIPv6 != net.publicIP

        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            Button {
                copyIP(net.publicIP, target: .primary)
            } label: {
                HStack(spacing: SpacingTheme.row) {
                    VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                        HStack(spacing: SpacingTheme.compact) {
                            Text(L10n.Network.publicIP)
                                .font(Typography.caption)
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))

                            Text(net.publicIP.contains(":") ? "IPv6" : "IPv4")
                                .font(Typography.badgeTag)
                                .foregroundStyle(accentFg)
                                .padding(.horizontal, SpacingTheme.compact)
                                .padding(.vertical, SpacingTheme.micro)
                                .background(appState.accentColor.opacity(0.14))
                                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.micro, style: .continuous))
                        }

                        Text(net.publicIP)
                            .font(Typography.heroSubValueMono)
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))
                            .lineLimit(dynamicTypeSize.isAccessibilitySize ? 2 : 1)
                            .minimumScaleFactor(0.7)
                    }

                    Spacer(minLength: SpacingTheme.compact)

                    if copiedTarget == .primary {
                        Text(L10n.Network.copied)
                            .font(Typography.captionBold)
                            .foregroundStyle(accentFg)
                    } else if primaryCopyable {
                        Image(systemName: "doc.on.doc.fill")
                            .font(IconTheme.copyIndicator)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                            .accessibilityHidden(true)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(BentoCardButtonStyle())
            .disabled(!primaryCopyable)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(net.publicIP.contains(":") ? L10n.Network.copyIpv6 : L10n.Network.copyIpv4)
            .accessibilityValue(net.publicIP)
            .accessibilityHint(primaryCopyable ? L10n.Common.copyValue : "")

            // Dual-stack IPv6 display if both are present
            if hasDualIpv6 {
                let ipv6Copyable = net.publicIPv6 != "--"

                Button {
                    copyIP(net.publicIPv6, target: .ipv6)
                } label: {
                    HStack(spacing: SpacingTheme.compact) {
                        Text("IPv6")
                            .font(Typography.badgeTag)
                            .foregroundStyle(accentFg)
                            .padding(.horizontal, SpacingTheme.compact)
                            .padding(.vertical, SpacingTheme.micro)
                            .background(appState.accentColor.opacity(0.14))
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.micro, style: .continuous))

                        Text(net.publicIPv6)
                            .font(Typography.captionMono)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .lineLimit(2)
                            .minimumScaleFactor(0.7)
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer(minLength: SpacingTheme.compact)

                        if copiedTarget == .ipv6 {
                            Text(L10n.Network.copied)
                                .font(Typography.captionBold)
                                .foregroundStyle(accentFg)
                        } else if ipv6Copyable {
                            Image(systemName: "doc.on.doc.fill")
                                .font(IconTheme.copyIndicator)
                                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                                .accessibilityHidden(true)
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget, alignment: .leading)
                    .contentShape(Rectangle())
                }
                .buttonStyle(BentoCardButtonStyle())
                .disabled(!ipv6Copyable)
                .accessibilityElement(children: .combine)
                .accessibilityLabel(L10n.Network.copyIpv6)
                .accessibilityValue(net.publicIPv6)
                .accessibilityHint(ipv6Copyable ? L10n.Common.copyValue : "")
            }
        }
        .padding(.horizontal, SpacingTheme.rowStandard)
        .padding(.vertical, SpacingTheme.row)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
        )
    }

    @ViewBuilder
    private var proxyExitBanner: some View {
        if !net.proxyExitIP.isEmpty && net.proxyExitIP != net.publicIP && net.proxyExitIP != net.publicIPv6 {
            let orange = Theme.readableOrange(for: colorScheme)

            Button {
                copyIP(net.proxyExitIP, target: .proxy)
            } label: {
                let leadingLabel = HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "shield.lefthalf.filled")
                        .font(IconTheme.tileLeading)
                        .foregroundStyle(orange)
                        .accessibilityHidden(true)

                    Text(L10n.Network.proxyExit)
                        .font(Typography.captionBold)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)
                }

                let trailingValue = HStack(spacing: SpacingTheme.tight) {
                    Text(net.proxyExitIP)
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)

                    if copiedTarget == .proxy {
                        Text(L10n.Network.copied)
                            .font(Typography.badgeTag)
                            .foregroundStyle(accentFg)
                    } else if !net.proxyExitLocation.isEmpty {
                        Text("· \(net.proxyExitLocation)")
                            .font(Typography.badgeTag)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }

                Group {
                    if dynamicTypeSize.isAccessibilitySize {
                        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                            leadingLabel
                            trailingValue
                        }
                    } else {
                        HStack(spacing: SpacingTheme.standard) {
                            leadingLabel
                            Spacer(minLength: SpacingTheme.compact)
                            trailingValue
                        }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget, alignment: .leading)
                .padding(.horizontal, SpacingTheme.row)
                .padding(.vertical, SpacingTheme.compact)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                        .fill(orange.opacity(0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                        .stroke(orange.opacity(0.22), lineWidth: 0.8)
                )
                .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
            }
            .buttonStyle(BentoCardButtonStyle())
            .accessibilityElement(children: .combine)
            .accessibilityLabel(L10n.Network.copyExitIp)
            .accessibilityValue(net.proxyExitIP)
            .accessibilityHint(L10n.Common.copyValue)
        }
    }

    private func copyIP(_ value: String, target: CopyTarget) {
        guard value != "--" && !value.isEmpty else { return }
        UIPasteboard.general.string = value
        Haptics.tick()
        withAnimation(.easeInOut(duration: 0.2)) {
            copiedTarget = target
        }
        copyToastTask?.cancel()
        copyToastTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(1.8))
            guard !Task.isCancelled else { return }
            withAnimation {
                if copiedTarget == target {
                    copiedTarget = nil
                }
            }
        }
    }

    @ViewBuilder
    private var geoGrid: some View {
        let city = (net.geoCity == "--" || net.geoCity.isEmpty) ? "" : net.geoCity
        let country = (net.geoCountry == "--" || net.geoCountry.isEmpty) ? "" : net.geoCountry
        let locationString: String = {
            if city.isEmpty && country.isEmpty {
                return "--"
            } else if city.isEmpty {
                return country
            } else if country.isEmpty {
                return city
            } else {
                return "\(city), \(country)"
            }
        }()

        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: SpacingTheme.row))
            : AnyLayout(HStackLayout(spacing: SpacingTheme.row))

        layout {
            geoCell(
                title: L10n.Network.carrierIsp,
                value: net.ispName,
                icon: "building.2.crop.circle.fill"
            )

            geoCell(
                title: L10n.Network.geoCity,
                value: locationString,
                icon: "mappin.circle.fill"
            )
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    @ViewBuilder
    private func geoCell(title: String, value: String, icon: String) -> some View {
        let resolvedValue = value.isEmpty ? "--" : value

        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: icon)
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(accentFg)
                    .accessibilityHidden(true)

                Text(title)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            Text(resolvedValue)
                .font(Typography.bodyValue)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(3)
                .minimumScaleFactor(0.75)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .frame(minHeight: 58)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityValue(resolvedValue)
    }
}

// MARK: - Preview
#Preview {
    NetworkPublicIPCard()
        .padding()
}
