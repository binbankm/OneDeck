//
//  ToolsMicroscopeCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Industrial Microscope & Macro Camera Bento Launcher Card.
//

import SwiftUI

struct ToolsMicroscopeCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: MicroscopeDetailView()) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                headerRow
                middleStatusRow
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
                title: L10n.Tools.microscope,
                icon: "viewfinder.circle.fill",
                subtitle: L10n.Tools.microscopeSub
            )

            Spacer()

            Text(String(format: "%.1fx", tools.microscope.zoomFactor))
                .font(Typography.headlineValue)
                .fontDesign(.monospaced)
                .foregroundStyle(appState.accentColor)
                .lineLimit(1)

            Image(systemName: "chevron.right")
                .font(IconTheme.badgeInline)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
        }
    }

    // MARK: - Middle Status Row
    @ViewBuilder
    private var middleStatusRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            HStack(spacing: SpacingTheme.tight) {
                Circle()
                    .fill(tools.microscope.isTorchOn ? Color.yellow : Theme.textTertiary(for: colorScheme))
                    .frame(width: 6, height: 6)

                Text(tools.microscope.filterMode.title)
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            Spacer()

            Text(tools.microscope.isTorchOn ? "LED ON · 15x" : "LED OFF · 15x")
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsMicroscopeCard()
        .padding()
}
