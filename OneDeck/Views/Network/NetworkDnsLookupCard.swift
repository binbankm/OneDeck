//
//  NetworkDnsLookupCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Domain name resolution and DNS record query card.
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
    @State private var lookupFailed: Bool = false
    @State private var lookupResult: DnsDigResult?
    @State private var resolveTask: Task<Void, Never>?
    @State private var copiedIp: String?
    @State private var copyToastTask: Task<Void, Never>?
    @FocusState private var isDomainFieldFocused: Bool

    private let domainPresets = ["apple.com", "cloudflare.com", "bilibili.com", "google.com"]

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerSection
            inputSection
            presetsSection

            if lookupFailed {
                HStack(spacing: SpacingTheme.compact) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(IconTheme.tileLeading)
                        .foregroundStyle(.orange)

                    Text(L10n.Network.dnsResolveFailed)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(2)

                    Spacer()
                }
                .padding(.horizontal, SpacingTheme.row)
                .padding(.vertical, SpacingTheme.standard)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .fill(Color.orange.opacity(0.10))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(Color.orange.opacity(0.28), lineWidth: 0.8)
                )
            }

            if let res = lookupResult {
                resultSection(res)
            }
        }
        .bentoCard(accent: appState.accentColor)
        .onDisappear {
            resolveTask?.cancel()
            resolveTask = nil
            copyToastTask?.cancel()
            copyToastTask = nil
        }
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
                    .submitLabel(.search)
                    .focused($isDomainFieldFocused)
                    .onSubmit {
                        resolveCurrentDomain()
                    }

                if !domainText.isEmpty {
                    Button {
                        domainText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(IconTheme.actionButton)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(L10n.Common.clearInput)
                }
            }
            .padding(.horizontal, SpacingTheme.row)
            .padding(.vertical, SpacingTheme.standard)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .stroke(isDomainFieldFocused ? appState.accentColor : Theme.cardBorder(for: colorScheme), lineWidth: isDomainFieldFocused ? 1.1 : 0.8)
            )

            let accentForeground = Theme.contrastingForeground(for: appState.accentColor)
            let isDomainEmpty = domainText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

            Button {
                Haptics.tick()
                resolveCurrentDomain()
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    if isResolving {
                        ProgressView()
                            .tint(accentForeground)
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
                .foregroundStyle(accentForeground)
                .padding(.horizontal, SpacingTheme.row)
                .padding(.vertical, SpacingTheme.standard)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                        .fill(appState.accentColor)
                )
            }
            .disabled(isResolving || isDomainEmpty)
            .opacity((isResolving || isDomainEmpty) ? 0.5 : 1.0)
            .buttonStyle(.plain)
            .accessibilityLabel(L10n.Network.resolveDomain)
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

                    Text(String(format: "%.1f ms", res.queryTimeMs.isFinite ? res.queryTimeMs : 0.0))
                        .font(Typography.captionMono)
                        .foregroundStyle(appState.accentColor)
                }
            }

            Divider().opacity(0.2)

            // A Records (IPv4)
            if !res.ipv4List.isEmpty {
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
                                copyRecordIp(ip)
                            } label: {
                                Image(systemName: copiedIp == ip ? "checkmark.circle.fill" : "doc.on.doc.fill")
                                    .font(IconTheme.copyIndicator)
                                    .foregroundStyle(copiedIp == ip ? Color.green : Theme.textTertiary(for: colorScheme))
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("\(L10n.Network.dnsRecordA) \(ip)")
                            .accessibilityHint(L10n.Common.copyValue)
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
                                copyRecordIp(ip)
                            } label: {
                                Image(systemName: copiedIp == ip ? "checkmark.circle.fill" : "doc.on.doc.fill")
                                    .font(IconTheme.copyIndicator)
                                    .foregroundStyle(copiedIp == ip ? Color.green : Theme.textTertiary(for: colorScheme))
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("\(L10n.Network.dnsRecordAaaa) \(ip)")
                            .accessibilityHint(L10n.Common.copyValue)
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
    private func copyRecordIp(_ ip: String) {
        UIPasteboard.general.string = ip
        Haptics.tick()
        copiedIp = ip
        copyToastTask?.cancel()
        copyToastTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(1.5))
            guard !Task.isCancelled else { return }
            if copiedIp == ip {
                copiedIp = nil
            }
        }
    }

    private func resolveCurrentDomain() {
        isDomainFieldFocused = false
        let trimmed = domainText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        resolveTask?.cancel()
        isResolving = true
        lookupFailed = false
        resolveTask = Task { @MainActor in
            let res = await net.resolveDomainName(domain: trimmed)
            guard !Task.isCancelled else { return }
            if let r = res {
                self.lookupResult = r
                self.lookupFailed = false
            } else {
                self.lookupResult = nil
                self.lookupFailed = true
            }
            self.isResolving = false
        }
    }
}

// MARK: - Preview
#Preview {
    NetworkDnsLookupCard()
        .padding()
}
