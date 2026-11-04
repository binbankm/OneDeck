//
//  SettingsSigningDetailSheet.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Certificate credentials, SHA fingerprints, and profile inspect sheet.
//

import SwiftUI

struct SettingsSigningDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    private var probe = ProvisioningHardwareProbe.shared

    @State private var copiedKey: String? = nil

    private var statusColor: Color {
        if probe.signingType == .trollStore {
            return appState.accentColor
        }
        if probe.isExpired {
            return .red
        } else if probe.isExpiringSoon {
            return .orange
        } else {
            return appState.accentColor
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SpacingTheme.cardStack) {
                    // 1. Hero Lifecycle & Health Banner
                    heroCard

                    // 2. Cryptographic Credentials (X.509 SHA Fingerprints)
                    cryptoCard

                    // 3. Provisioning Profile Parameters
                    profileCard

                    // 4. App Entitlements & Sandbox
                    entitlementsCard

                    // 5. Sideload Ecological Stability Guide
                    guideCard
                }
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.rowStandard)
            }
            .background(Theme.background(for: colorScheme).ignoresSafeArea())
            .navigationTitle(L10n.Settings.certSheetTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.Common.done) {
                        dismiss()
                    }
                    .font(Typography.calloutBold)
                    .foregroundStyle(appState.accentColor)
                }
            }
        }
    }

    // MARK: - 1. Hero Card
    @ViewBuilder
    private var heroCard: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.certSectionOverview, icon: probe.signingType.iconName)

            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                    Text(L10n.Settings.certCountdown)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))

                    if probe.signingType == .trollStore {
                        Text(L10n.Settings.certPermanent)
                            .font(Typography.title1)
                            .foregroundStyle(appState.accentColor)
                    } else if probe.isExpired {
                        Text(L10n.Settings.certExpired)
                            .font(Typography.title1)
                            .foregroundStyle(Color.red)
                    } else if probe.hasProvisionProfile {
                        Text(L10n.Settings.certDaysHours(days: probe.remainingDays, hours: probe.remainingHours))
                            .font(Typography.title1)
                            .foregroundStyle(statusColor)
                    } else {
                        Text(L10n.Settings.certPermanent)
                            .font(Typography.title1)
                            .foregroundStyle(appState.accentColor)
                    }
                }

                Spacer()

                // Status Capsule Pill
                HStack(spacing: SpacingTheme.tight) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 8, height: 8)

                    Text(probe.statusText)
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                }
                .padding(.horizontal, SpacingTheme.standard)
                .padding(.vertical, SpacingTheme.tight)
                .background(Theme.background(for: colorScheme))
                .clipShape(Capsule())
            }

            // Visual Lifecycle Progress Bar
            if probe.hasProvisionProfile {
                VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                    let safeRatio = probe.progressRatio.isFinite ? min(1.0, max(0.0, probe.progressRatio)) : 0.0
                    ProgressView(value: safeRatio)
                        .tint(statusColor)
                        .scaleEffect(x: 1, y: 1.4, anchor: .center)

                    HStack {
                        Text("\(L10n.Settings.creationDateLabel): \(probe.creationDate?.formatted(date: .numeric, time: .omitted) ?? "N/A")")
                            .font(Typography.microAxis)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)

                        Spacer()

                        Text("\(L10n.Settings.expirationDateLabel): \(probe.expirationDate?.formatted(date: .numeric, time: .omitted) ?? L10n.Settings.permanentLabel)")
                            .font(Typography.microAxis)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                }
                .padding(.top, SpacingTheme.tight)
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - 2. Cryptographic Credentials Card
    @ViewBuilder
    private var cryptoCard: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.certSectionCrypto, icon: "lock.shield.fill")

            VStack(spacing: SpacingTheme.standard) {
                blockCopyableRow(
                    title: L10n.Settings.certSubject,
                    value: probe.certificateSubject.isEmpty ? "Apple OS Software Provisioning" : probe.certificateSubject,
                    key: "subject"
                )

                if !probe.certificateSha1.isEmpty {
                    blockCopyableRow(title: L10n.Settings.certSha1Fingerprint, value: probe.certificateSha1, key: "sha1", isMono: true)
                }

                if !probe.certificateSha256.isEmpty {
                    blockCopyableRow(title: L10n.Settings.certSha256Fingerprint, value: probe.certificateSha256, key: "sha256", isMono: true)
                }

                if let creation = probe.creationDate, let expiration = probe.expirationDate {
                    let durationDays = Int(expiration.timeIntervalSince(creation) / 86400.0)
                    detailRow(title: L10n.Settings.certValiditySpan, value: L10n.Settings.certValiditySpanDays(days: durationDays), icon: "calendar.badge.clock")
                }
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - 3. Provisioning Profile Parameters
    @ViewBuilder
    private var profileCard: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.certSectionProfile, icon: "doc.badge.gearshape.fill")

            VStack(spacing: SpacingTheme.standard) {
                blockCopyableRow(
                    title: L10n.Settings.certProfileName,
                    value: probe.profileName.isEmpty ? L10n.Settings.certDefaultProfileName : probe.profileName,
                    key: "profileName"
                )

                if !probe.profileUUID.isEmpty {
                    blockCopyableRow(title: L10n.Settings.certProfileUUID, value: probe.profileUUID, key: "uuid", isMono: true)
                }

                // Scope
                let scopeText: String = {
                    if probe.isTrollStore {
                        return L10n.Settings.certScopeTrollStore
                    } else if probe.provisionsAllDevices {
                        return L10n.Settings.certScopeEnterprise
                    } else if probe.provisionedDevicesCount > 0 {
                        return L10n.Settings.certScopeDevices(count: probe.provisionedDevicesCount)
                    } else {
                        return L10n.Settings.certScopeSandbox
                    }
                }()
                detailRow(title: L10n.Settings.certDeviceCount, value: scopeText, icon: "iphone.gen3")

                detailRow(
                    title: L10n.Settings.certDebuggable,
                    value: probe.isTaskAllowEnabled ? L10n.Settings.certDebuggableEnabled : L10n.Settings.certDebuggableStripped,
                    icon: "ant.fill"
                )
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - 4. Entitlements & Sandbox
    @ViewBuilder
    private var entitlementsCard: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.certSectionEntitlements, icon: "key.fill")

            VStack(spacing: SpacingTheme.standard) {
                blockCopyableRow(title: L10n.Settings.certAppId, value: probe.appIdentifier, key: "appId", isMono: true)
                detailRow(title: L10n.Settings.certSandboxMode, value: L10n.Settings.certSandboxHardwareDesc, icon: "shippingbox.fill")

                if !probe.keychainAccessGroups.isEmpty {
                    blockCopyableRow(
                        title: L10n.Settings.certKeychainDomain,
                        value: probe.keychainAccessGroups.first ?? "Default",
                        key: "keychain",
                        isMono: true
                    )
                }
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - 5. Sideloading Guide & Tips
    @ViewBuilder
    private var guideCard: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.certSectionGuide, icon: "lightbulb.fill")

            VStack(alignment: .leading, spacing: SpacingTheme.rowStandard) {
                guideItem(
                    tag: L10n.Settings.certGuideFreeTag,
                    color: .green,
                    desc: L10n.Settings.certGuideFreeDesc
                )

                Divider().opacity(0.3)

                guideItem(
                    tag: L10n.Settings.certGuideTrollTag,
                    color: .purple,
                    desc: L10n.Settings.certGuideTrollDesc
                )

                Divider().opacity(0.3)

                guideItem(
                    tag: L10n.Settings.certGuideEnterpriseTag,
                    color: .orange,
                    desc: L10n.Settings.certGuideEnterpriseDesc
                )

                Divider().opacity(0.3)

                guideItem(
                    tag: L10n.Settings.certGuideDevTag,
                    color: .blue,
                    desc: L10n.Settings.certGuideDevDesc
                )
            }
            .padding(SpacingTheme.row)
            .background(Theme.background(for: colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews & Helpers
    @ViewBuilder
    private func guideItem(tag: String, color: Color, desc: String) -> some View {
        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            HStack(spacing: SpacingTheme.compact) {
                Circle().fill(color).frame(width: 6, height: 6)
                Text(tag)
                    .font(Typography.calloutBold)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            Text(desc)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineSpacing(3)
        }
    }

    @ViewBuilder
    private func detailRow(title: String, value: String, icon: String? = nil) -> some View {
        HStack(alignment: .center, spacing: SpacingTheme.standard) {
            if let icon {
                Image(systemName: icon)
                    .font(IconTheme.badgeInline)
                    .foregroundStyle(appState.accentColor)
            }

            Text(title)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .fixedSize(horizontal: true, vertical: false)

            Spacer(minLength: SpacingTheme.standard)

            Text(value)
                .font(Typography.bodyValue)
                .monospacedDigit()
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .multilineTextAlignment(.trailing)
                .lineLimit(nil)
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
        )
    }

    @ViewBuilder
    private func blockCopyableRow(title: String, value: String, key: String, isMono: Bool = false) -> some View {
        let isCopied = copiedKey == key
        let isHexHash = (key == "sha1" || key == "sha256")
        // Zero-width space allows clean byte wrapping on colon boundaries
        let displayValue = isHexHash ? value.replacingOccurrences(of: ":", with: ":\u{200B}") : value

        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            HStack(alignment: .center) {
                Text(title)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))

                Spacer()

                Button {
                    Haptics.tick()
                    UIPasteboard.general.string = value // Copies clean unformatted string
                    withAnimation(.easeInOut(duration: 0.15)) {
                        copiedKey = key
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            if copiedKey == key {
                                copiedKey = nil
                            }
                        }
                    }
                } label: {
                    HStack(spacing: SpacingTheme.tight) {
                        if isCopied {
                            Text(L10n.Common.copied)
                                .font(Typography.microAxis)
                                .foregroundStyle(appState.accentColor)
                        }

                        ZStack {
                            Image(systemName: "doc.on.doc.fill")
                                .opacity(isCopied ? 0.0 : 1.0)
                                .foregroundStyle(Theme.textTertiary(for: colorScheme))

                            Image(systemName: "checkmark.circle.fill")
                                .opacity(isCopied ? 1.0 : 0.0)
                                .foregroundStyle(appState.accentColor)
                        }
                        .font(IconTheme.copyIndicator)
                        .frame(width: 24, height: 24, alignment: .center)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }

            Text(displayValue)
                .font((isHexHash || isMono) ? Typography.bodyValueMono : Typography.bodyValue)
                .foregroundStyle(isCopied ? appState.accentColor : Theme.textPrimary(for: colorScheme))
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .animation(nil, value: isCopied)
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(isCopied ? appState.accentColor.opacity(0.08) : (colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025)))
        )
    }
}
