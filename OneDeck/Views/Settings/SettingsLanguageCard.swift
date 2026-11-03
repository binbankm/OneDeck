//
//  SettingsLanguageCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Language Selection Card.
//

import SwiftUI

struct SettingsLanguageCard: View {
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.languageSection, icon: "character.bubble.fill")

            HStack(spacing: SpacingTheme.rowStandard) {
                Image(systemName: "globe")
                    .font(IconTheme.tileLeading)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(appState.accentColor)

                Text(L10n.Settings.languageSelect)
                    .font(Typography.calloutLabel)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))

                Spacer()

                Picker(L10n.Settings.languageSection, selection: $appState.language) {
                    ForEach(AppLanguage.allCases) { lang in
                        Text(lang.displayName).tag(lang)
                    }
                }
                .pickerStyle(.menu)
                .tint(appState.accentColor)
                .onChange(of: appState.language) { _, newLang in
                    appState.setLanguage(newLang)
                }
            }
            .padding(.vertical, SpacingTheme.tight)
        }
        .bentoCard(accent: appState.accentColor)
    }
}

