//
//  NetworkDnsLookupCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Network DNS Lookup Card: Direct POSIX getaddrinfo Domain Name Resolution (A / AAAA).
//

import SwiftUI
import UniformTypeIdentifiers

struct NetworkDnsLookupCard: View {
    @Bindable var appState = AppState.shared
    @Bindable var net = NetworkService.shared
    @Environment(\.colorScheme) private var colorScheme

    @State private var domainText: String = "apple.com"
    @State private var isResolving: Bool = false
    @State private var lookupResult: DnsDigResult? = DnsDigResult(
        domain: "apple.com",
        ipv4List: ["17.253.144.10", "17.253.142.4"],
        ipv6List: ["2603:9001:500::10"],
        queryTimeMs: 14.2
    )

    private let domainPresets = ["apple.com", "cloudflare.com", "bilibili.com", "google.com"]

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            // MARK: - Header
            HStack(spacing: 8) {
                BentoSectionHeader(title: L10n.Network.dnsLookupTitle, icon: "magnifyingglass.circle.fill")

                Spacer()

                Text(L10n.Network.dnsPortBadge)
                    .font(Typography.captionMono)
                    .foregroundStyle(appState.accentColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, SpacingTheme.micro)
                    .background(appState.accentColor.opacity(0.12))
                    .clipShape(Capsule())
            }

            // MARK: - Domain Input & Resolve Button
            HStack(spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "globe")
                        .font(IconTheme.sectionHeader)
                        .foregroundStyle(appState.accentColor)

                    TextField(L10n.Network.domainInputPlaceholder, text: $domainText)
                        .font(Typography.bodyValueMono)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.URL)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                        .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                        .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                )

                Button {
                    Haptics.tick()
                    resolveCurrentDomain()
                } label: {
                    HStack(spacing: 4) {
                        if isResolving {
                            ProgressView()
                                .tint(.white)
                                .scaleEffect(0.65)
                        } else {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(IconTheme.actionButton)
                        }

                        Text(L10n.Network.resolveDomain)
                            .font(Typography.calloutBold)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                            .fill(appState.accentColor)
                    )
                }
                .disabled(isResolving || domainText.isEmpty)
                .buttonStyle(.plain)
            }

            // Quick Preset Pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(domainPresets, id: \.self) { p in
                        Button {
                            domainText = p
                            Haptics.selection()
                            resolveCurrentDomain()
                        } label: {
                            Text(p)
                                .font(Typography.badgeTagMonoMedium)
                                .foregroundStyle(domainText == p ? appState.accentColor : Theme.textSecondary(for: colorScheme))
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous)
                                        .fill(domainText == p ? appState.accentColor.opacity(0.12) : Theme.cardBackground(for: colorScheme).opacity(0.5))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, SpacingTheme.micro)
            }

            // MARK: - Resolution Result HUD
            if let res = lookupResult {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(res.domain)
                            .font(Typography.bodyValueMono)
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))
                            .lineLimit(1)

                        Spacer()

                        HStack(spacing: SpacingTheme.tight) {
                            Text(L10n.Network.queryTime)
                                .font(Typography.badgeTagMedium)
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))

                            Text(String(format: "%.1f ms", res.queryTimeMs))
                                .font(Typography.captionMono)
                                .foregroundStyle(appState.accentColor)
                        }
                    }

                    Divider().opacity(0.2)

                    // A Records (IPv4)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(L10n.Network.dnsRecordA)
                            .font(Typography.badgeTagMedium)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))

                        ForEach(res.ipv4List, id: \.self) { ip in
                            HStack {
                                Text(ip)
                                    .font(Typography.calloutMono)
                                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                                    .lineLimit(1)

                                Spacer()

                                Button {
                                    UIPasteboard.general.string = ip
                                    Haptics.tick()
                                } label: {
                                    Image(systemName: "doc.on.doc")
                                        .font(IconTheme.copyIndicator)
                                        .foregroundStyle(Theme.textTertiary(for: colorScheme))
                                }
                            }
                        }
                    }

                    // AAAA Records (IPv6)
                    if !res.ipv6List.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(L10n.Network.dnsRecordAaaa)
                                .font(Typography.badgeTagMedium)
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))

                            ForEach(res.ipv6List, id: \.self) { ip in
                                HStack {
                                    Text(ip)
                                        .font(Typography.captionMono)
                                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)

                                    Spacer()

                                    Button {
                                        UIPasteboard.general.string = ip
                                        Haptics.tick()
                                    } label: {
                                        Image(systemName: "doc.on.doc")
                                            .font(IconTheme.copyIndicator)
                                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .fill(Theme.cardBackground(for: colorScheme).opacity(0.5))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                )
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    private func resolveCurrentDomain() {
        guard !domainText.isEmpty else { return }
        isResolving = true
        Task {
            let res = await net.resolveDomainName(domain: domainText)
            await MainActor.run {
                if let r = res {
                    self.lookupResult = r
                }
                self.isResolving = false
            }
        }
    }
}
