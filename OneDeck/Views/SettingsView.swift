//
//  SettingsView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Application settings view managing appearance, language, and signing.
//

import SwiftUI

// MARK: - SettingsView
struct SettingsView: View {
    // MARK: - Properties & State
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                cardStack
                    .frame(maxWidth: 680)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, SpacingTheme.cardStack)
                    .padding(.vertical, SpacingTheme.rowStandard)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            .background(Theme.background(for: colorScheme).ignoresSafeArea())
            .navigationTitle(L10n.Settings.title)
        }
    }

    // MARK: - Subviews
    @ViewBuilder
    private var cardStack: some View {
        VStack(spacing: SpacingTheme.cardStack) {
            // 1. Appearance settings
            SettingsAppearanceCard()

            // 2. Language selection
            SettingsLanguageCard()

            // 3. User preferences
            SettingsPreferencesCard()

            // 4. Signing & provisioning
            SettingsSigningCard()

            // 5. Open source licenses
            SettingsLicensesCard()

            // 6. About information
            SettingsAboutCard()
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsView()
}
