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
    @Bindable private var appState = AppState.shared
    @Bindable private var settings = SettingsViewModel.shared

    @State private var showDetailSheet = false

    private var statusColor: Color {
        if settings.isTrollStoreSigning {
            return appState.accentColor
        }
        if settings.isExpired {
            return .red
        } else if settings.isExpiringSoon {
            return .orange
        } else {
            return appState.accentColor
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
        // 1. Hero Countdown Platter Tile
        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                    Text(L10n.Settings.certCountdown)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textTertiary(for: colorScheme))

                    if settings.isTrollStoreSigning {
                        Text(L10n.Settings.certPermanent)
                            .font(Typography.title2)
                            .foregroundStyle(appState.accentColor)
                    } else if settings.isExpired {
                        Text(L10n.Settings.certExpired)
                            .font(Typography.title2)
                            .foregroundStyle(Color.red)
                    } else if settings.hasProvisionProfile {
                        Text(L10n.Settings.certDaysHours(days: settings.remainingDays, hours: settings.remainingHours))
                            .font(Typography.title2)
                            .foregroundStyle(statusColor)
                    } else {
                        Text(L10n.Settings.certPermanent)
                            .font(Typography.title2)
                            .foregroundStyle(appState.accentColor)
                    }
                }

                Spacer()

                // Status Capsule Pill
                HStack(spacing: SpacingTheme.tight) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 6, height: 6)

                    Text(settings.statusText)
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(statusColor)
                }
                .padding(.horizontal, SpacingTheme.standard)
                .padding(.vertical, SpacingTheme.micro)
                .background(statusColor.opacity(0.12))
                .clipShape(Capsule())
            }

            // Visual Lifecycle Bar (for 7-day or 365-day certificates)
            if settings.hasProvisionProfile {
                let safeRatio = settings.progressRatio.isFinite ? min(1.0, max(0.0, settings.progressRatio)) : 0.0
                ProgressView(value: safeRatio)
                    .tint(statusColor)
                    .scaleEffect(x: 1, y: 1.4, anchor: .center)
                    .padding(.vertical, SpacingTheme.micro)
            }
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
        )
    }

    private var detailActionTile: some View {
        // 2. Action Button Platter (Opens Full Sheet Inspection)
        Button {
            Haptics.selection()
            showDetailSheet = true
        } label: {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: "checkmark.shield.fill")
                    .font(IconTheme.tileLeading)
                    .frame(width: 20, height: 20, alignment: .center)

                Text(L10n.Settings.certViewDetails)
                    .font(Typography.bodyMedium)
                    .lineLimit(1)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(IconTheme.copyIndicator)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, SpacingTheme.row)
            .padding(.vertical, SpacingTheme.standard)
            .background(appState.accentColor.opacity(0.12))
            .foregroundStyle(appState.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(appState.accentColor.opacity(0.3), lineWidth: 0.8)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    SettingsSigningCard()
}
