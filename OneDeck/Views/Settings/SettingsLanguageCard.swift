//
//  SettingsLanguageCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Application language switcher and localization selection card.
//

import SwiftUI

// MARK: - SettingsLanguageCard
struct SettingsLanguageCard: View {
    // MARK: - Properties & State
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.languageSection, icon: "character.bubble.fill")

            languageTile
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    private var languageTile: some View {
        // Language Selection Platter Tile
        HStack(alignment: .center, spacing: SpacingTheme.standard) {
            Image(systemName: "globe.asia.australia.fill")
                .font(IconTheme.tileLeading)
                .foregroundStyle(appState.accentColor)
                .frame(width: 20, height: 20, alignment: .center)

            Text(L10n.Settings.languageSelect)
                .font(Typography.bodyValue.weight(.medium))
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(1)

            Spacer(minLength: SpacingTheme.standard)

            Menu {
                Picker("", selection: $appState.language) {
                    ForEach(AppLanguage.allCases) { lang in
                        Text(lang.displayName).tag(lang)
                    }
                }
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    Text(appState.language.displayName)
                        .font(Typography.bodyValue)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))

                    Image(systemName: "chevron.up.chevron.down")
                        .font(IconTheme.chevronIndicator)
                        .foregroundStyle(Theme.textTertiary(for: colorScheme))
                }
                .padding(.horizontal, SpacingTheme.standard)
                .padding(.vertical, SpacingTheme.compact)
                .background(
                    colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.05)
                )
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous))
            }
            .onChange(of: appState.language) { _, newLang in
                appState.setLanguage(newLang)
            }
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
        )
    }
}

// MARK: - Preview
#Preview {
    SettingsLanguageCard()
}
