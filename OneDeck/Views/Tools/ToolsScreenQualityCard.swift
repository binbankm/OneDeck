//
//  ToolsScreenQualityCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  OLED screen uniformity and display quality launcher card.
//

import SwiftUI

struct ToolsScreenQualityCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: LazyView(ScreenQualityDetailView())) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                headerRow
                colorPalettePreviewRow
            }
            .bentoCard(accent: appState.accentColor)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Header
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.screenQuality,
                icon: "sparkles.tv.fill",
                subtitle: L10n.Tools.screenQualitySub
            )

            Spacer()

            Text("\(SystemViewModel.shared.hardwareSpecs.maxFps)Hz")
                .font(Typography.headlineValue)
                .fontDesign(.monospaced)
                .foregroundStyle(appState.accentColor)
                .lineLimit(1)

            Image(systemName: "chevron.right")
                .font(IconTheme.badgeInline)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
        }
    }

    // MARK: - Color Palette Preview Row
    @ViewBuilder
    private var colorPalettePreviewRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            HStack(spacing: SpacingTheme.tight) {
                ForEach([Color.black, Color.white, Color.red, Color.green, Color.blue, Color.yellow], id: \.self) { c in
                    Circle()
                        .fill(c)
                        .frame(width: 14, height: 14)
                        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 0.5))
                }
            }

            Spacer()

            Text(L10n.Tools.deadPixelCheck)
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsScreenQualityCard()
        .padding()
}
