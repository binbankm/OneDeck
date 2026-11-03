//
//  SettingsSigningCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Provisioning Profile & Certificate Expiration Card (System shortcuts removed).
//

import SwiftUI

struct SettingsSigningCard: View {
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    private var probe = ProvisioningHardwareProbe.shared

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.signingSection, icon: "person.badge.shield.checkmark.fill")

            // 1. Certificate Expiry Countdown Hero Block
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                    Text(L10n.Settings.certCountdown)
                        .font(Typography.calloutLabel)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))

                    if probe.isExpired {
                        Text("证书已过期")
                            .font(Typography.title2)
                            .foregroundStyle(Color.red)
                    } else if probe.hasProvisionProfile {
                        Text(L10n.Settings.certDaysHours(days: probe.remainingDays, hours: probe.remainingHours))
                            .font(Typography.title2)
                            .foregroundStyle(appState.accentColor)
                    } else {
                        Text("永久生效 · 运行正常")
                            .font(Typography.title2)
                            .foregroundStyle(appState.accentColor)
                    }
                }

                Spacer()

                // Status Capsule Pill
                HStack(spacing: SpacingTheme.tight) {
                    Circle()
                        .fill(probe.isExpired ? Color.red : appState.accentColor)
                        .frame(width: 8, height: 8)

                    Text(probe.signingType.localizedName)
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                }
                .padding(.horizontal, SpacingTheme.standard)
                .padding(.vertical, SpacingTheme.tight)
                .background(Theme.background(for: colorScheme))
                .clipShape(Capsule())
            }
            .padding(.vertical, SpacingTheme.tight)

            Divider().opacity(0.3)

            // 2. Metadata Rows (Clean, Professional Readout)
            VStack(spacing: SpacingTheme.standard) {
                infoRow(title: L10n.Settings.certTeam, value: probe.teamName)
                infoRow(title: L10n.Settings.certTeamId, value: probe.teamIdentifier)
                infoRow(title: L10n.Settings.certBundleId, value: probe.bundleIdentifier)

                if let expDate = probe.expirationDate {
                    let formatted = expDate.formatted(date: .numeric, time: .shortened)
                    infoRow(title: L10n.Settings.certExpiryDate, value: formatted)
                } else {
                    infoRow(title: L10n.Settings.certStatus, value: L10n.Settings.certActive)
                }
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Helper Views
    @ViewBuilder
    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(Typography.calloutLabel)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))

            Spacer()

            Text(value)
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(1)
                .truncationMode(.middle)
        }
    }
}
