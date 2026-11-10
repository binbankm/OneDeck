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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @State private var showLicenseSheet = false

    private var readableAccent: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

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
            LicenseDetailSheetView()
        }
    }

    // MARK: - Subviews
    private var mitLicenseTile: some View {
        let accent = readableAccent

        return Button {
            Haptics.selection()
            showLicenseSheet = true
        } label: {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: "checkmark.seal.fill")
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(accent)
                    .frame(width: 20, height: 20, alignment: .center)
                    .accessibilityHidden(true)

                Text(L10n.Settings.licenseTitle)
                    .font(Typography.bodyMedium)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Spacer(minLength: SpacingTheme.standard)

                HStack(spacing: SpacingTheme.tight) {
                    Text(L10n.Settings.licenseDesc)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textTertiary(for: colorScheme))
                        .lineLimit(1)

                    Image(systemName: "chevron.right")
                        .font(IconTheme.copyIndicator)
                        .foregroundStyle(Theme.textTertiary(for: colorScheme))
                        .accessibilityHidden(true)
                }
            }
            .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
            .padding(.horizontal, SpacingTheme.row)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(Theme.tileBackground(for: colorScheme))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.5)
            )
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
        .accessibilityLabel(L10n.Settings.licenseTitle)
        .accessibilityValue(L10n.Settings.licenseDesc)
    }

    private var nativeFrameworksTile: some View {
        let accent = readableAccent

        return Group {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                    HStack(spacing: SpacingTheme.standard) {
                        Image(systemName: "apple.logo")
                            .font(IconTheme.tileLeading)
                            .foregroundStyle(accent)
                            .frame(width: 20, height: 20, alignment: .center)
                            .accessibilityHidden(true)

                        Text(L10n.Settings.thirdPartyLicenses)
                            .font(Typography.bodyMedium)
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Text(L10n.Settings.frameworksList)
                        .font(Typography.captionMono)
                        .foregroundStyle(accent)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                HStack(spacing: SpacingTheme.standard) {
                    Image(systemName: "apple.logo")
                        .font(IconTheme.tileLeading)
                        .foregroundStyle(accent)
                        .frame(width: 20, height: 20, alignment: .center)
                        .accessibilityHidden(true)

                    Text(L10n.Settings.thirdPartyLicenses)
                        .font(Typography.bodyMedium)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    Spacer(minLength: SpacingTheme.standard)

                    Text(L10n.Settings.frameworksList)
                        .font(Typography.captionMono)
                        .foregroundStyle(accent)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
        }
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
        .accessibilityLabel(L10n.Settings.thirdPartyLicenses)
        .accessibilityValue(L10n.Settings.frameworksList)
    }
}

private struct LicenseDetailSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared

    var body: some View {
        let accent = Theme.readableAccent(appState.accentColor, for: colorScheme)

        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: SpacingTheme.rowStandard) {
                    Text("MIT License")
                        .font(Typography.title2)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .accessibilityAddTraits(.isHeader)

                    Text("Copyright (c) 2026 OneDeck Contributors")
                        .font(Typography.calloutLabel)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))

                    BentoHairlineDivider()

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
                    .fixedSize(horizontal: false, vertical: true)
                }
                .bentoCard(accent: appState.accentColor)
                .frame(maxWidth: LayoutTheme.maxContentWidth)
                .frame(maxWidth: .infinity)
                .padding(SpacingTheme.cardStack)
            }
            .scrollBounceBehavior(.basedOnSize)
            .background(Theme.background(for: colorScheme).ignoresSafeArea())
            .navigationTitle(L10n.Settings.licensesSection)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.Common.done) {
                        dismiss()
                    }
                    .font(Typography.calloutBold)
                    .foregroundStyle(accent)
                }
            }
        }
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Preview
#Preview {
    SettingsLicensesCard()
}
