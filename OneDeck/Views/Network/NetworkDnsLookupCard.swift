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
        VStack(alignment: .leading, spacing: 14) {
            // MARK: - Header
            HStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(appState.accentColor.opacity(0.12))
                        .frame(width: 30, height: 30)

                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(appState.accentColor)
                }

                Text(L10n.Network.dnsLookupTitle)
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)

                Spacer()

                Text(L10n.Network.dnsPortBadge)
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .foregroundStyle(appState.accentColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(appState.accentColor.opacity(0.12))
                    .clipShape(Capsule())
            }

            // MARK: - Domain Input & Resolve Button
            HStack(spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "globe")
                        .font(.system(size: 13))
                        .foregroundStyle(appState.accentColor)

                    TextField(L10n.Network.domainInputPlaceholder, text: $domainText)
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.URL)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
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
                                .font(.system(size: 12))
                        }

                        Text(L10n.Network.resolveDomain)
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
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
                                .font(.system(size: 10, weight: .medium, design: .monospaced))
                                .foregroundStyle(domainText == p ? appState.accentColor : Theme.textSecondary(for: colorScheme))
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(domainText == p ? appState.accentColor.opacity(0.12) : Theme.cardBackground(for: colorScheme).opacity(0.5))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 1)
            }

            // MARK: - Resolution Result HUD
            if let res = lookupResult {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(res.domain)
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))
                            .lineLimit(1)

                        Spacer()

                        HStack(spacing: 3) {
                            Text(L10n.Network.queryTime)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))

                            Text(String(format: "%.1f ms", res.queryTimeMs))
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundStyle(appState.accentColor)
                        }
                    }

                    Divider().opacity(0.2)

                    // A Records (IPv4)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(L10n.Network.dnsRecordA)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))

                        ForEach(res.ipv4List, id: \.self) { ip in
                            HStack {
                                Text(ip)
                                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                                    .lineLimit(1)

                                Spacer()

                                Button {
                                    UIPasteboard.general.string = ip
                                    Haptics.tick()
                                } label: {
                                    Image(systemName: "doc.on.doc")
                                        .font(.system(size: 10))
                                        .foregroundStyle(Theme.textSecondary(for: colorScheme).opacity(0.6))
                                }
                            }
                        }
                    }

                    // AAAA Records (IPv6)
                    if !res.ipv6List.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(L10n.Network.dnsRecordAaaa)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))

                            ForEach(res.ipv6List, id: \.self) { ip in
                                HStack {
                                    Text(ip)
                                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)

                                    Spacer()

                                    Button {
                                        UIPasteboard.general.string = ip
                                        Haptics.tick()
                                    } label: {
                                        Image(systemName: "doc.on.doc")
                                            .font(.system(size: 10))
                                            .foregroundStyle(Theme.textSecondary(for: colorScheme).opacity(0.6))
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 11)
                .padding(.vertical, 9)
                .background(
                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                        .fill(Theme.cardBackground(for: colorScheme).opacity(0.5))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 9, style: .continuous)
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
