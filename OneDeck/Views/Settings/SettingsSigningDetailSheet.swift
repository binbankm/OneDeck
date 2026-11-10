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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var settings = SettingsViewModel.shared

    @State private var copiedKey: String? = nil
    @State private var copyToastTask: Task<Void, Never>?

    private var readableAccent: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    private var statusColor: Color {
        if settings.isTrollStoreSigning {
            return readableAccent
        }
        if settings.isExpired {
            return Theme.readableRed(for: colorScheme)
        } else if settings.isExpiringSoon {
            return Theme.readableOrange(for: colorScheme)
        } else {
            return readableAccent
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
                .frame(maxWidth: LayoutTheme.maxContentWidth)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.rowStandard)
            }
            .scrollBounceBehavior(.basedOnSize)
            .background(Theme.background(for: colorScheme).ignoresSafeArea())
            .navigationTitle(L10n.Settings.certSheetTitle)
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                copyToastTask?.cancel()
                copyToastTask = nil
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.Common.done) {
                        dismiss()
                    }
                    .font(Typography.calloutBold)
                    .foregroundStyle(readableAccent)
                }
            }
        }
        .presentationDragIndicator(.visible)
    }

    // MARK: - 1. Hero Card
    @ViewBuilder
    private var heroCard: some View {
        let accent = readableAccent
        let red = Theme.readableRed(for: colorScheme)

        let countdownHeader = VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            Text(L10n.Settings.certCountdown)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))

            if settings.isTrollStoreSigning {
                Text(L10n.Settings.certPermanent)
                    .font(Typography.title1)
                    .foregroundStyle(accent)
            } else if settings.isExpired {
                Text(L10n.Settings.certExpired)
                    .font(Typography.title1)
                    .foregroundStyle(red)
            } else if settings.hasProvisionProfile {
                Text(L10n.Settings.certDaysHours(days: settings.remainingDays, hours: settings.remainingHours))
                    .font(Typography.title1)
                    .monospacedDigit()
                    .foregroundStyle(statusColor)
            } else {
                Text(L10n.Settings.certPermanent)
                    .font(Typography.title1)
                    .foregroundStyle(accent)
            }
        }

        let statusPill = HStack(spacing: SpacingTheme.tight) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
                .accessibilityHidden(true)

            Text(settings.statusText)
                .font(Typography.badgeTagMono)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(1)
        }
        .padding(.horizontal, SpacingTheme.standard)
        .padding(.vertical, SpacingTheme.tight)
        .background(Theme.chipBackground(for: colorScheme))
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Theme.chipBorder(for: colorScheme), lineWidth: 0.5)
        )
        .accessibilityElement(children: .combine)

        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.certSectionOverview, icon: settings.signingIconName)

            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                    countdownHeader
                    statusPill
                }
            } else {
                HStack(alignment: .center, spacing: SpacingTheme.standard) {
                    countdownHeader
                    Spacer(minLength: SpacingTheme.compact)
                    statusPill
                }
            }

            // Visual Lifecycle Progress Bar
            if settings.hasProvisionProfile {
                VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                    let safeRatio = settings.progressRatio.isFinite ? min(1.0, max(0.0, settings.progressRatio)) : 0.0
                    BentoCapsuleProgressBar(
                        value: safeRatio,
                        tint: statusColor,
                        height: 6,
                        accessibilityLabel: L10n.Settings.certCountdown,
                        accessibilityValue: settings.statusText
                    )

                    let createdText = "\(L10n.Settings.creationDateLabel): \(settings.creationDate?.formatted(date: .numeric, time: .omitted) ?? L10n.Common.notAvailable)"
                    let expiryText = "\(L10n.Settings.expirationDateLabel): \(settings.expirationDate?.formatted(date: .numeric, time: .omitted) ?? L10n.Settings.permanentLabel)"

                    if dynamicTypeSize.isAccessibilitySize {
                        VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                            Text(createdText)
                                .font(Typography.microAxis)
                                .monospacedDigit()
                                .foregroundStyle(Theme.textTertiary(for: colorScheme))

                            Text(expiryText)
                                .font(Typography.microAxis)
                                .monospacedDigit()
                                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                        }
                    } else {
                        HStack {
                            Text(createdText)
                                .font(Typography.microAxis)
                                .monospacedDigit()
                                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                                .lineLimit(1)
                                .minimumScaleFactor(0.85)

                            Spacer(minLength: SpacingTheme.compact)

                            Text(expiryText)
                                .font(Typography.microAxis)
                                .monospacedDigit()
                                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                                .lineLimit(1)
                                .minimumScaleFactor(0.85)
                        }
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
                    value: settings.certificateSubject.isEmpty ? L10n.Settings.certAppleSystem : settings.certificateSubject,
                    key: "subject"
                )

                if !settings.certificateSha1.isEmpty {
                    blockCopyableRow(title: L10n.Settings.certSha1Fingerprint, value: settings.certificateSha1, key: "sha1", isMono: true)
                }

                if !settings.certificateSha256.isEmpty {
                    blockCopyableRow(title: L10n.Settings.certSha256Fingerprint, value: settings.certificateSha256, key: "sha256", isMono: true)
                }

                if let creation = settings.creationDate, let expiration = settings.expirationDate {
                    let durationDays = max(0, Int((expiration.timeIntervalSince(creation) / 86400.0).rounded()))
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
                    value: settings.profileName.isEmpty ? L10n.Settings.certDefaultProfileName : settings.profileName,
                    key: "profileName"
                )

                if !settings.profileUUID.isEmpty {
                    blockCopyableRow(title: L10n.Settings.certProfileUUID, value: settings.profileUUID, key: "uuid", isMono: true)
                }

                let scopeText: String = {
                    if settings.isTrollStore {
                        return L10n.Settings.certScopeTrollStore
                    } else if settings.provisionsAllDevices {
                        return L10n.Settings.certScopeEnterprise
                    } else if settings.provisionedDevicesCount > 0 {
                        return L10n.Settings.certScopeDevices(count: settings.provisionedDevicesCount)
                    } else {
                        return L10n.Settings.certScopeSandbox
                    }
                }()
                detailRow(
                    title: L10n.Settings.certDeviceCount,
                    value: scopeText,
                    icon: UIDevice.current.userInterfaceIdiom == .pad ? "ipad.gen2" : "iphone.gen3"
                )

                detailRow(
                    title: L10n.Settings.certDebuggable,
                    value: settings.isTaskAllowEnabled ? L10n.Settings.certDebuggableEnabled : L10n.Settings.certDebuggableStripped,
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
                blockCopyableRow(title: L10n.Settings.certAppId, value: settings.appIdentifier, key: "appId", isMono: true)
                detailRow(title: L10n.Settings.certSandboxMode, value: L10n.Settings.certSandboxHardwareDesc, icon: "shippingbox.fill")

                if !settings.keychainAccessGroups.isEmpty {
                    blockCopyableRow(
                        title: L10n.Settings.certKeychainDomain,
                        value: settings.keychainAccessGroups.first ?? L10n.Settings.defaultGroup,
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
                    color: Theme.readableGreen(for: colorScheme),
                    desc: L10n.Settings.certGuideFreeDesc
                )

                BentoHairlineDivider()

                guideItem(
                    tag: L10n.Settings.certGuideTrollTag,
                    color: .purple,
                    desc: L10n.Settings.certGuideTrollDesc
                )

                BentoHairlineDivider()

                guideItem(
                    tag: L10n.Settings.certGuideEnterpriseTag,
                    color: Theme.readableOrange(for: colorScheme),
                    desc: L10n.Settings.certGuideEnterpriseDesc
                )

                BentoHairlineDivider()

                guideItem(
                    tag: L10n.Settings.certGuideDevTag,
                    color: Theme.readableCyan(for: colorScheme),
                    desc: L10n.Settings.certGuideDevDesc
                )
            }
            .padding(SpacingTheme.row)
            .background(Theme.tileBackground(for: colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.5)
            )
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews & Helpers
    @ViewBuilder
    private func guideItem(tag: String, color: Color, desc: String) -> some View {
        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            HStack(spacing: SpacingTheme.compact) {
                Circle()
                    .fill(color)
                    .frame(width: 6, height: 6)
                    .accessibilityHidden(true)

                Text(tag)
                    .font(Typography.calloutBold)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Text(desc)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(3)
        }
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private func detailRow(title: String, value: String, icon: String? = nil) -> some View {
        let accent = readableAccent

        Group {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                    HStack(spacing: SpacingTheme.standard) {
                        if let icon {
                            Image(systemName: icon)
                                .font(IconTheme.badgeInline)
                                .foregroundStyle(accent)
                                .accessibilityHidden(true)
                        }

                        Text(title)
                            .font(Typography.caption)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Text(value)
                        .font(Typography.bodyValue)
                        .monospacedDigit()
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                HStack(alignment: .center, spacing: SpacingTheme.standard) {
                    if let icon {
                        Image(systemName: icon)
                            .font(IconTheme.badgeInline)
                            .foregroundStyle(accent)
                            .accessibilityHidden(true)
                    }

                    Text(title)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    Spacer(minLength: SpacingTheme.standard)

                    Text(value)
                        .font(Typography.bodyValue)
                        .monospacedDigit()
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .multilineTextAlignment(.trailing)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
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
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.5)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityValue(value)
    }

    @ViewBuilder
    private func blockCopyableRow(title: String, value: String, key: String, isMono: Bool = false) -> some View {
        let isCopied = copiedKey == key
        let isHexHash = (key == "sha1" || key == "sha256")
        let displayValue = isHexHash ? value.replacingOccurrences(of: ":", with: ":\u{200B}") : value
        let accent = readableAccent

        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            HStack(alignment: .center, spacing: SpacingTheme.compact) {
                Text(title)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(2)

                Spacer(minLength: SpacingTheme.compact)

                Button {
                    Haptics.tick()
                    UIPasteboard.general.string = value
                    withAnimation(.easeInOut(duration: 0.15)) {
                        copiedKey = key
                    }
                    copyToastTask?.cancel()
                    copyToastTask = Task { @MainActor in
                        try? await Task.sleep(for: .seconds(1.8))
                        guard !Task.isCancelled else { return }
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
                                .foregroundStyle(accent)
                        }

                        ZStack {
                            Image(systemName: "doc.on.doc.fill")
                                .opacity(isCopied ? 0.0 : 1.0)
                                .foregroundStyle(Theme.textTertiary(for: colorScheme))

                            Image(systemName: "checkmark.circle.fill")
                                .opacity(isCopied ? 1.0 : 0.0)
                                .foregroundStyle(accent)
                        }
                        .font(IconTheme.copyIndicator)
                        .frame(minWidth: LayoutTheme.minTapTarget, minHeight: LayoutTheme.minTapTarget)
                        .accessibilityHidden(true)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(BentoCardButtonStyle())
                .accessibilityLabel("\(L10n.Common.copy) \(title)")
            }

            Text(displayValue)
                .font((isHexHash || isMono) ? Typography.bodyValueMono : Typography.bodyValue)
                .foregroundStyle(isCopied ? accent : Theme.textPrimary(for: colorScheme))
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
                .fill(isCopied ? accent.opacity(0.08) : Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(isCopied ? accent.opacity(0.28) : Theme.tileBorder(for: colorScheme), lineWidth: 0.5)
        )
    }
}
