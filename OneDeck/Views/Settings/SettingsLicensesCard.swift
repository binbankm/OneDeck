//
//  SettingsLicensesCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Open Source Licenses & Architecture Stack Card.
//

import SwiftUI

struct SettingsLicensesCard: View {
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @State private var showLicenseSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.licensesSection, icon: "doc.text.fill")

            // 1. MIT License Row
            Button {
                Haptics.selection()
                showLicenseSheet = true
            } label: {
                HStack(spacing: SpacingTheme.rowStandard) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(IconTheme.tileLeading)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(appState.accentColor)

                    VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                        Text(L10n.Settings.licenseTitle)
                            .font(Typography.calloutLabel)
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))

                        Text(L10n.Settings.licenseDesc)
                            .font(Typography.caption)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(IconTheme.copyIndicator)
                        .foregroundStyle(Theme.textTertiary(for: colorScheme))
                }
                .padding(.vertical, SpacingTheme.tight)
            }
            .buttonStyle(.plain)

            Divider().opacity(0.3)

            // 2. Native Apple Frameworks & Tech Stack
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Settings.thirdPartyLicenses)
                    .font(Typography.calloutLabel)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))

                Text(L10n.Settings.frameworksList)
                    .font(Typography.captionMono)
                    .foregroundStyle(appState.accentColor)
                    .padding(.vertical, 2)
            }
            .padding(.vertical, SpacingTheme.tight)
        }
        .bentoCard(accent: appState.accentColor)
        .sheet(isPresented: $showLicenseSheet) {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: SpacingTheme.rowStandard) {
                        Text("MIT License")
                            .font(Typography.title2)
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))

                        Text("Copyright (c) 2026 OneDeck Contributors")
                            .font(Typography.calloutLabel)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))

                        Divider().padding(.vertical, SpacingTheme.tight)

                        Text("""
                        Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

                        The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

                        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                        """)
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineSpacing(4)
                    }
                    .padding(SpacingTheme.cardStack)
                }
                .navigationTitle(L10n.Settings.licensesSection)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("完成") {
                            showLicenseSheet = false
                        }
                        .tint(appState.accentColor)
                    }
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
}

