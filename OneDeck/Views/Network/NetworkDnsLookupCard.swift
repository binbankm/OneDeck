//
//  NetworkDnsLookupCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Domain name resolution and DNS record query card.
//

import SwiftUI

struct NetworkDnsLookupCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
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

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerSection
            inputSection
            presetsSection

            if lookupFailed {
                ToolNoticeBanner(icon: "exclamationmark.triangle.fill", message: L10n.Network.dnsResolveFailed)
            } else if let res = lookupResult {
                resultSection(res)
            } else if !isResolving {
                BentoEmptyStateView(
                    icon: "globe",
                    message: L10n.Network.dnsEmptyHint,
                    height: 92
                )
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
        let portBadge = Text(L10n.Network.dnsPortBadge)
            .font(Typography.captionMono)
            .foregroundStyle(accentFg)
            .lineLimit(1)
            .padding(.horizontal, SpacingTheme.standard)
            .padding(.vertical, SpacingTheme.micro)
            .background(appState.accentColor.opacity(0.12))
            .clipShape(Capsule())

        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                BentoSectionHeader(title: L10n.Network.dnsLookupTitle, icon: "magnifyingglass.circle.fill")
                portBadge
            }
        } else {
            HStack(spacing: SpacingTheme.standard) {
                BentoSectionHeader(title: L10n.Network.dnsLookupTitle, icon: "magnifyingglass.circle.fill")
                Spacer(minLength: SpacingTheme.compact)
                portBadge
            }
        }
    }

    @ViewBuilder
    private var inputSection: some View {
        let accentForeground = Theme.contrastingForeground(for: appState.accentColor)
        let isDomainEmpty = domainText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

        let inputBox = HStack(spacing: SpacingTheme.compact) {
            Image(systemName: "globe.asia.australia.fill")
                .font(IconTheme.sectionHeader)
                .foregroundStyle(accentFg)
                .accessibilityHidden(true)

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
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        if isDomainFieldFocused {
                            Spacer()
                            Button(L10n.Common.done) {
                                isDomainFieldFocused = false
                            }
                        }
                    }
                }

            if !domainText.isEmpty {
                Button {
                    Haptics.selection()
                    domainText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(IconTheme.actionButton)
                        .foregroundStyle(Theme.textTertiary(for: colorScheme))
                        .frame(width: LayoutTheme.minTapTarget, height: LayoutTheme.minTapTarget)
                        .contentShape(Rectangle())
                }
                .buttonStyle(BentoCardButtonStyle())
                .accessibilityLabel(L10n.Common.clearInput)
            }
        }
        .padding(.leading, SpacingTheme.row)
        .padding(.trailing, domainText.isEmpty ? SpacingTheme.row : SpacingTheme.tight)
        .frame(minHeight: 48)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(isDomainFieldFocused ? accentFg : Theme.tileBorder(for: colorScheme), lineWidth: isDomainFieldFocused ? 1.1 : 0.8)
        )

        let resolveButton = Button {
            Haptics.tick()
            resolveCurrentDomain()
        } label: {
            HStack(spacing: SpacingTheme.tight) {
                if isResolving {
                    ProgressView()
                        .controlSize(.small)
                        .tint(accentForeground)
                } else {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(IconTheme.actionButton)
                        .accessibilityHidden(true)
                }

                Text(L10n.Network.resolveDomain)
                    .font(Typography.calloutBold)
                    .lineLimit(1)
            }
            .foregroundStyle(accentForeground)
            .padding(.horizontal, SpacingTheme.row)
            .frame(maxWidth: dynamicTypeSize.isAccessibilitySize ? .infinity : nil, minHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(appState.accentColor)
            )
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        }
        .disabled(isResolving || isDomainEmpty)
        .opacity((isResolving || isDomainEmpty) ? 0.5 : 1.0)
        .buttonStyle(BentoCardButtonStyle())
        .accessibilityLabel(L10n.Network.resolveDomain)

        if dynamicTypeSize.isAccessibilitySize {
            VStack(spacing: SpacingTheme.standard) {
                inputBox
                resolveButton
            }
        } else {
            HStack(spacing: SpacingTheme.standard) {
                inputBox
                resolveButton
            }
        }
    }

    @ViewBuilder
    private var presetsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: SpacingTheme.compact) {
                ForEach(domainPresets, id: \.self) { preset in
                    let isSelected = domainText == preset

                    Button {
                        domainText = preset
                        Haptics.selection()
                        resolveCurrentDomain()
                    } label: {
                        Text(preset)
                            .font(Typography.badgeTagMonoMedium)
                            .foregroundStyle(isSelected ? accentFg : Theme.textSecondary(for: colorScheme))
                            .lineLimit(1)
                            .padding(.horizontal, SpacingTheme.row)
                            .frame(minHeight: LayoutTheme.minTapTarget)
                            .background(
                                Capsule()
                                    .fill(isSelected ? appState.accentColor.opacity(0.14) : Theme.chipBackground(for: colorScheme))
                            )
                            .overlay(
                                Capsule()
                                    .stroke(isSelected ? accentFg.opacity(0.45) : Theme.chipBorder(for: colorScheme), lineWidth: 0.8)
                            )
                            .contentShape(Capsule())
                    }
                    .buttonStyle(BentoCardButtonStyle())
                    .accessibilityAddTraits(isSelected ? [.isSelected] : [])
                }
            }
            .padding(.horizontal, SpacingTheme.micro)
        }
    }

    @ViewBuilder
    private func resultSection(_ res: DnsDigResult) -> some View {
        let green = Theme.readableGreen(for: colorScheme)
        let queryTimeStr = String(format: "%.1f ms", res.queryTimeMs.isFinite ? res.queryTimeMs : 0.0)

        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            HStack {
                Text(res.domain)
                    .font(Typography.bodyValueMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)

                Spacer(minLength: SpacingTheme.compact)

                HStack(spacing: SpacingTheme.tight) {
                    Text(L10n.Network.queryTime)
                        .font(Typography.badgeTagMedium)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))

                    Text(queryTimeStr)
                        .font(Typography.captionMono)
                        .foregroundStyle(accentFg)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(L10n.Network.queryTime)
                .accessibilityValue(queryTimeStr)
            }

            BentoHairlineDivider()

            if res.ipv4List.isEmpty && res.ipv6List.isEmpty {
                BentoEmptyStateView(
                    icon: "magnifyingglass",
                    message: L10n.Network.dnsNoRecordsFound,
                    height: 84
                )
            } else {
                // A Records (IPv4)
                if !res.ipv4List.isEmpty {
                    VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                        Text(L10n.Network.dnsRecordA)
                            .font(Typography.badgeTagMedium)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))

                        ForEach(res.ipv4List, id: \.self) { ip in
                            recordRow(ip: ip, recordTitle: L10n.Network.dnsRecordA, green: green, isIpv6: false)
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
                            recordRow(ip: ip, recordTitle: L10n.Network.dnsRecordAaaa, green: green, isIpv6: true)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
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
    private func recordRow(ip: String, recordTitle: String, green: Color, isIpv6: Bool) -> some View {
        HStack(spacing: SpacingTheme.compact) {
            Text(ip)
                .font(isIpv6 ? Typography.captionMono : Typography.calloutMono)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(dynamicTypeSize.isAccessibilitySize ? 2 : 1)
                .minimumScaleFactor(0.8)

            Spacer(minLength: SpacingTheme.tight)

            Button {
                copyRecordIp(ip)
            } label: {
                Image(systemName: copiedIp == ip ? "checkmark.circle.fill" : "doc.on.doc.fill")
                    .font(IconTheme.copyIndicator)
                    .foregroundStyle(copiedIp == ip ? green : Theme.textTertiary(for: colorScheme))
                    .frame(width: LayoutTheme.minTapTarget, height: LayoutTheme.minTapTarget)
                    .contentShape(Rectangle())
            }
            .buttonStyle(BentoCardButtonStyle())
            .accessibilityLabel("\(recordTitle) \(ip)")
            .accessibilityHint(L10n.Common.copyValue)
        }
    }

    // MARK: - Actions
    private func copyRecordIp(_ ip: String) {
        UIPasteboard.general.string = ip
        Haptics.tick()
        withAnimation(.easeInOut(duration: 0.2)) {
            copiedIp = ip
        }
        copyToastTask?.cancel()
        copyToastTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(1.5))
            guard !Task.isCancelled else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                if copiedIp == ip {
                    copiedIp = nil
                }
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
            withAnimation(.easeInOut(duration: 0.2)) {
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
}

// MARK: - Preview
#Preview {
    NetworkDnsLookupCard()
        .padding()
}
