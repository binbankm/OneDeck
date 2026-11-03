//
//  SettingsSigningDetailSheet.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Deep Certificate & Provisioning Profile Telemetry Sheet (Zero Privacy Leaks, 100% Local Offline).
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
                        .font(Typography.calloutLabel)
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
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                }
                .padding(.horizontal, SpacingTheme.standard)
                .padding(.vertical, SpacingTheme.tight)
                .background(Theme.background(for: colorScheme))
                .clipShape(Capsule())
            }

            // Visual Lifecycle Progress Bar
            if probe.hasProvisionProfile {
                VStack(alignment: .leading, spacing: 6) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Theme.cardBorder(for: colorScheme))
                                .frame(height: 6)

                            Capsule()
                                .fill(statusColor)
                                .frame(width: max(8, geo.size.width * CGFloat(probe.progressRatio)), height: 6)
                        }
                    }
                    .frame(height: 6)

                    HStack {
                        Text("创建签发: \(probe.creationDate?.formatted(date: .numeric, time: .omitted) ?? "N/A")")
                            .font(Typography.microAxis)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))

                        Spacer()

                        Text("截止到期: \(probe.expirationDate?.formatted(date: .numeric, time: .omitted) ?? "长期有效")")
                            .font(Typography.microAxis)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    }
                }
                .padding(.top, 4)
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
                detailRow(
                    title: L10n.Settings.certSubject,
                    value: probe.certificateSubject.isEmpty ? "Apple OS Software Provisioning" : probe.certificateSubject
                )

                if !probe.certificateSha1.isEmpty {
                    copyableRow(title: L10n.Settings.certSha1Fingerprint, value: probe.certificateSha1, key: "sha1")
                }

                if !probe.certificateSha256.isEmpty {
                    copyableRow(title: L10n.Settings.certSha256Fingerprint, value: probe.certificateSha256, key: "sha256")
                }

                if let creation = probe.creationDate, let expiration = probe.expirationDate {
                    let durationDays = Int(expiration.timeIntervalSince(creation) / 86400.0)
                    detailRow(title: L10n.Settings.certValiditySpan, value: "\(durationDays) 天全周期")
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
                detailRow(
                    title: L10n.Settings.certProfileName,
                    value: probe.profileName.isEmpty ? "系统原生内嵌沙盒策略" : probe.profileName
                )

                if !probe.profileUUID.isEmpty {
                    copyableRow(title: L10n.Settings.certProfileUUID, value: probe.profileUUID, key: "uuid")
                }

                // Scope
                let scopeText: String = {
                    if probe.isTrollStore {
                        return "CoreTrust 注入免除设备绑定"
                    } else if probe.provisionsAllDevices {
                        return "企业全量设备 (无需绑定 UDID)"
                    } else if probe.provisionedDevicesCount > 0 {
                        return "受信任设备列表 (\(probe.provisionedDevicesCount) 台)"
                    } else {
                        return "系统沙盒 / 长期有效"
                    }
                }()
                detailRow(title: L10n.Settings.certDeviceCount, value: scopeText)

                detailRow(
                    title: L10n.Settings.certDebuggable,
                    value: probe.isTaskAllowEnabled ? "已启用 (Debuggable 调试)" : "已剥离 (Release 生产运行)"
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
                detailRow(title: L10n.Settings.certAppId, value: probe.appIdentifier)
                detailRow(title: L10n.Settings.certSandboxMode, value: "AppContainer 硬件级沙盒隔离")

                if !probe.keychainAccessGroups.isEmpty {
                    detailRow(title: "Keychain 隔离域", value: probe.keychainAccessGroups.first ?? "Default")
                }

                detailRow(title: L10n.Settings.certValidationMethod, value: L10n.Settings.certValidationLocal)
                detailRow(title: L10n.Settings.certPrivacyGuarantee, value: L10n.Settings.certPrivacyLocalOnly)
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
                    tag: "个人免费自签 (7天)",
                    color: .green,
                    desc: "使用免费 Apple ID 签名的应用拥有严格的 7 天倒计时。到期后 iOS 系统将拒绝启动（应用闪退）。建议在剩余 1~2 天时使用 AltStore、SideStore 或快捷指令续签。"
                )

                Divider().opacity(0.3)

                guideItem(
                    tag: "巨魔 (TrollStore)",
                    color: .purple,
                    desc: "利用 iOS CoreTrust 证书绕过漏洞，完全脱离苹果证书到期机制，永久生效、永不掉签，无需任何证书刷新。"
                )

                Divider().opacity(0.3)

                guideItem(
                    tag: "企业证书 (365天)",
                    color: .orange,
                    desc: "支持全量设备免登记直接安装，有效期 1 年。但受苹果云端吊销证书机制（掉签）影响，若证书被封禁需重新签名打包。"
                )

                Divider().opacity(0.3)

                guideItem(
                    tag: "开发者计划 (1年)",
                    color: .blue,
                    desc: "苹果年费开发者计划签发，最多支持 100 台设备 Ad-Hoc 部署，有效期整整 1 年，运行稳定。"
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
    private func detailRow(title: String, value: String) -> some View {
        HStack(alignment: .center, spacing: SpacingTheme.standard) {
            Text(title)
                .font(Typography.bodyValue.weight(.medium))
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)

            Spacer(minLength: SpacingTheme.standard)

            Text(value)
                .font(Typography.bodyValue)
                .monospacedDigit()
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .multilineTextAlignment(.trailing)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
        )
    }

    @ViewBuilder
    private func copyableRow(title: String, value: String, key: String) -> some View {
        Button {
            Haptics.tick()
            UIPasteboard.general.string = value
            withAnimation {
                copiedKey = key
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if copiedKey == key {
                    copiedKey = nil
                }
            }
        } label: {
            HStack(alignment: .center, spacing: SpacingTheme.standard) {
                Text(title)
                    .font(Typography.bodyValue.weight(.medium))
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Spacer(minLength: SpacingTheme.standard)

                HStack(spacing: 4) {
                    Text(value)
                        .font(Typography.bodyValue)
                        .monospacedDigit()
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .minimumScaleFactor(0.8)

                    Image(systemName: copiedKey == key ? "checkmark.circle.fill" : "doc.on.doc")
                        .font(IconTheme.copyIndicator)
                        .foregroundStyle(copiedKey == key ? appState.accentColor : Theme.textTertiary(for: colorScheme))
                }
            }
            .padding(.horizontal, SpacingTheme.row)
            .padding(.vertical, SpacingTheme.standard)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

