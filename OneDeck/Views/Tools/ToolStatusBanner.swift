//
//  ToolStatusBanner.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Unified permission-denied and hardware-unavailable banners for diagnostic tools.
//

import SwiftUI

struct ToolPermissionDeniedBanner: View {
    @Environment(\.colorScheme) private var colorScheme

    let icon: String
    let message: String
    var onDarkSurface: Bool = false
    let onOpenSettings: () -> Void

    var body: some View {
        let accentOrange = Theme.readableOrange(for: onDarkSurface ? .dark : colorScheme)

        VStack(spacing: SpacingTheme.standard) {
            HStack(alignment: .top, spacing: SpacingTheme.standard) {
                Image(systemName: icon)
                    .font(IconTheme.sectionHeader)
                    .foregroundStyle(accentOrange)
                    .frame(width: 22, height: 22, alignment: .center)
                    .accessibilityHidden(true)

                Text(message)
                    .font(Typography.caption)
                    .foregroundStyle(onDarkSurface ? Color.white : Theme.textPrimary(for: colorScheme))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Button {
                Haptics.selection()
                onOpenSettings()
            } label: {
                Text(L10n.Tools.openSettings)
                    .font(Typography.captionBold)
                    .foregroundStyle(Theme.contrastingForeground(for: accentOrange))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .padding(.horizontal, SpacingTheme.cardStack)
                    .padding(.vertical, SpacingTheme.row)
                    .frame(minHeight: LayoutTheme.minTapTarget)
                    .background(accentOrange)
                    .clipShape(Capsule())
                    .contentShape(Capsule())
            }
            .buttonStyle(BentoCardButtonStyle())
            .accessibilityHint(message)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(SpacingTheme.cardInternal)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(onDarkSurface ? Color.black.opacity(0.86) : Theme.cardBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(accentOrange.opacity(0.45), lineWidth: 0.8)
        )
    }
}

struct ToolNoticeBanner: View {
    @Environment(\.colorScheme) private var colorScheme

    let icon: String
    let message: String
    var useOrangeTone: Bool = true
    var onDarkSurface: Bool = false

    var body: some View {
        let tint = useOrangeTone
            ? Theme.readableOrange(for: onDarkSurface ? .dark : colorScheme)
            : Theme.textSecondary(for: colorScheme)

        HStack(alignment: .center, spacing: SpacingTheme.standard) {
            Image(systemName: icon)
                .font(IconTheme.sectionHeader)
                .foregroundStyle(tint)
                .frame(width: 22, height: 22, alignment: .center)
                .accessibilityHidden(true)

            Text(message)
                .font(Typography.caption)
                .foregroundStyle(onDarkSurface ? Color.white : Theme.textPrimary(for: colorScheme))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(SpacingTheme.cardInternal)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(onDarkSurface ? Color.black.opacity(0.86) : Theme.cardBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(tint.opacity(0.45), lineWidth: 0.8)
        )
        .accessibilityElement(children: .combine)
    }
}

