//
//  SettingsLicensesCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Open-source software licenses and attribution card.
//

import SwiftUI

// MARK: - SettingsLicensesCard
struct SettingsLicensesCard: View {
    // MARK: - Properties & State
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @State private var showLicenseSheet = false

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.licensesSection, icon: "doc.text.fill")

            VStack(spacing: SpacingTheme.standard) {
                mitLicenseTile
                nativeFrameworksTile
            }
        }
        .bentoCard(accent: appState.accentColor)
        .sheet(isPresented: $showLicenseSheet) {
            licenseDetailSheet
        }
    }

    // MARK: - Subviews
    private var mitLicenseTile: some View {
        // 1. MIT License Platter Button
        Button {
            Haptics.selection()
            showLicenseSheet = true
        } label: {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: "checkmark.seal.fill")
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(appState.accentColor)
                    .frame(width: 20, height: 20, alignment: .center)

                Text(L10n.Settings.licenseTitle)
                    .font(Typography.bodyValue.weight(.medium))
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)

                Spacer(minLength: SpacingTheme.standard)

                HStack(spacing: SpacingTheme.tight) {
                    Text(L10n.Settings.licenseDesc)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textTertiary(for: colorScheme))

                    Image(systemName: "chevron.right")
                        .font(IconTheme.copyIndicator)
                        .foregroundStyle(Theme.textTertiary(for: colorScheme))
                }
            }
            .padding(.horizontal, SpacingTheme.row)
            .padding(.vertical, SpacingTheme.standard)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
            )
        }
        .buttonStyle(.plain)
    }

    private var nativeFrameworksTile: some View {
        // 2. Native Apple Frameworks Platter Tile
        HStack(spacing: SpacingTheme.standard) {
            Image(systemName: "apple.logo")
                .font(IconTheme.tileLeading)
                .foregroundStyle(appState.accentColor)
                .frame(width: 20, height: 20, alignment: .center)

            Text(L10n.Settings.thirdPartyLicenses)
                .font(Typography.bodyValue.weight(.medium))
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(1)

            Spacer(minLength: SpacingTheme.standard)

            Text(L10n.Settings.frameworksList)
                .font(Typography.captionMono)
                .foregroundStyle(appState.accentColor)
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

    private var licenseDetailSheet: some View {
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
                    Permission is hereby granted, free of charge, to any person obtaining a copy \
                    of this software and associated documentation files (the "Software"), to deal \
                    in the Software without restriction, including without limitation the rights \
                    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell \
                    copies of the Software, and to permit persons to whom the Software is \
                    furnished to do so, subject to the following conditions:

                    The above copyright notice and this permission notice shall be included in all \
                    copies or substantial portions of the Software.

                    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR \
                    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, \
                    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE \
                    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER \
                    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, \
                    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE \
                    SOFTWARE.
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
                    Button(L10n.Common.done) {
                        showLicenseSheet = false
                    }
                    .font(Typography.calloutBold)
                    .foregroundStyle(appState.accentColor)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsLicensesCard()
}
