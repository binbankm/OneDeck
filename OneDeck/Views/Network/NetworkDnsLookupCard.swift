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
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var net = NetworkViewModel.shared

    // MARK: - State
    @State private var domainText: String = "apple.com"
    @State private var isResolving: Bool = false
    @State private var lookupResult: DnsDigResult? = DnsDigResult(
        domain: "apple.com",
        ipv4List: ["17.253.144.10", "17.253.142.4"],
        ipv6List: ["2603:9001:500::10"],
        queryTimeMs: 14.2
    )

    private let domainPresets = ["apple.com", "cloudflare.com", "bilibili.com", "google.com"]

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerSection
            inputSection
            presetsSection

            if let res = lookupResult {
                resultSection(res)
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    @ViewBuilder
    private var headerSection: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(title: L10n.Network.dnsLookupTitle, icon: "magnifyingglass.circle.fill")

            Spacer()

            Text(L10n.Network.dnsPortBadge)
                .font(Typography.captionMono)
                .foregroundStyle(appState.accentColor)
                .padding(.horizontal, SpacingTheme.standard)
                .padding(.vertical, SpacingTheme.micro)
                .background(appState.accentColor.opacity(0.12))
                .clipShape(Capsule())
        }
    }

    @ViewBuilder
    private var inputSection: some View {
        HStack(spacing: SpacingTheme.standard) {
            HStack(spacing: SpacingTheme.compact) {
                Image(systemName: "globe.asia.australia.fill")
                    .font(IconTheme.sectionHeader)
                    .foregroundStyle(appState.accentColor)

                TextField(L10n.Network.domainInputPlaceholder, text: $domainText)
                    .font(Typography.bodyValueMono)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.URL)
            }
            .padding(.horizontal, SpacingTheme.row)
            .padding(.vertical, SpacingTheme.standard)
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
                HStack(spacing: SpacingTheme.tight) {
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
                .padding(.horizontal, SpacingTheme.row)
                .padding(.vertical, SpacingTheme.standard)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                        .fill(appState.accentColor)
                )
            }
            .disabled(isResolving || domainText.isEmpty)
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private var presetsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: SpacingTheme.compact) {
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
                            .padding(.horizontal, SpacingTheme.standard)
                            .padding(.vertical, SpacingTheme.tight)
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
    }

    @ViewBuilder
    private func resultSection(_ res: DnsDigResult) -> some View {
        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
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
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
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
                            Image(systemName: "doc.on.doc.fill")
                                .font(IconTheme.copyIndicator)
                                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                        }
                    }
                }
            }

            // AAAA Records (IPv6)
            if !res.ipv6List.isEmpty {
                VStack(alignment: .leading, spacing: SpacingTheme.tight) {
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
                                Image(systemName: "doc.on.doc.fill")
                                .font(IconTheme.copyIndicator)
                                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
    }

    // MARK: - Actions
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

// MARK: - Preview
#Preview {
    NetworkDnsLookupCard()
        .padding()
}
