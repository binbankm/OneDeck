//
//  SettingsSigningCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Certificate validity countdown and profile telemetry card.
//

import SwiftUI

// MARK: - SettingsSigningCard
struct SettingsSigningCard: View {
    // MARK: - Properties & State
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var settings = SettingsViewModel.shared

    @State private var showDetailSheet = false

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

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.signingSection, icon: "person.badge.shield.checkmark.fill")

            VStack(spacing: SpacingTheme.standard) {
                heroCountdownTile
                detailActionTile
            }
        }
        .bentoCard(accent: appState.accentColor)
        .sheet(isPresented: $showDetailSheet) {
            SettingsSigningDetailSheet()
        }
    }

    // MARK: - Subviews
    private var heroCountdownTile: some View {
        let accent = readableAccent
        let red = Theme.readableRed(for: colorScheme)

        let countdownBlock = VStack(alignment: .leading, spacing: SpacingTheme.micro) {
            Text(L10n.Settings.certCountdown)
                .font(Typography.caption)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))

            if settings.isTrollStoreSigning {
                Text(L10n.Settings.certPermanent)
                    .font(Typography.title2)
                    .foregroundStyle(accent)
            } else if settings.isExpired {
                Text(L10n.Settings.certExpired)
                    .font(Typography.title2)
                    .foregroundStyle(red)
            } else if settings.hasProvisionProfile {
                Text(L10n.Settings.certDaysHours(days: settings.remainingDays, hours: settings.remainingHours))
                    .font(Typography.title2)
                    .monospacedDigit()
                    .foregroundStyle(statusColor)
            } else {
                Text(L10n.Settings.certPermanent)
                    .font(Typography.title2)
                    .foregroundStyle(accent)
            }
        }

        let statusPill = HStack(spacing: SpacingTheme.tight) {
            Circle()
                .fill(statusColor)
                .frame(width: 6, height: 6)
                .accessibilityHidden(true)

            Text(settings.statusText)
                .font(Typography.badgeTagMono)
                .foregroundStyle(statusColor)
                .lineLimit(1)
        }
        .padding(.horizontal, SpacingTheme.standard)
        .padding(.vertical, SpacingTheme.micro)
        .background(statusColor.opacity(0.12))
        .clipShape(Capsule())
        .accessibilityElement(children: .combine)

        return VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                    countdownBlock
                    statusPill
                }
            } else {
                HStack(alignment: .center, spacing: SpacingTheme.standard) {
                    countdownBlock
                    Spacer(minLength: SpacingTheme.compact)
                    statusPill
                }
            }

            if settings.hasProvisionProfile {
                let safeRatio = settings.progressRatio.isFinite ? min(1.0, max(0.0, settings.progressRatio)) : 0.0
                BentoCapsuleProgressBar(
                    value: safeRatio,
                    tint: statusColor,
                    height: 6,
                    accessibilityLabel: L10n.Settings.certCountdown,
                    accessibilityValue: settings.statusText
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
    }

    private var detailActionTile: some View {
        let accent = readableAccent

        return Button {
            Haptics.selection()
            showDetailSheet = true
        } label: {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: "checkmark.shield.fill")
                    .font(IconTheme.tileLeading)
                    .frame(width: 20, height: 20, alignment: .center)
                    .accessibilityHidden(true)

                Text(L10n.Settings.certViewDetails)
                    .font(Typography.bodyMedium)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Spacer(minLength: SpacingTheme.compact)

                Image(systemName: "chevron.right")
                    .font(IconTheme.copyIndicator)
                    .accessibilityHidden(true)
            }
            .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
            .padding(.horizontal, SpacingTheme.row)
            .background(accent.opacity(0.12))
            .foregroundStyle(accent)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(accent.opacity(0.3), lineWidth: 0.8)
            )
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    SettingsSigningCard()
}
