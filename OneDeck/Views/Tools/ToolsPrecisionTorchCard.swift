//
//  ToolsPrecisionTorchCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Micro-brightness torch and strobe frequency launcher card.
//

import SwiftUI

struct ToolsPrecisionTorchCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: LazyView(PrecisionTorchDetailView())) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                headerRow
                middleStatusRow
            }
            .bentoCard(accent: tools.torch.isTorchOn ? Color.orange : appState.accentColor)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Header
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.torchLab,
                icon: tools.torch.isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill",
                subtitle: L10n.Tools.torchLabSub
            )

            Spacer()

            Text(tools.torch.isTorchOn ? "\(Int(tools.torch.brightness * 100))%" : "OFF")
                .font(Typography.headlineValue)
                .fontDesign(.monospaced)
                .foregroundStyle(tools.torch.isTorchOn ? Color.orange : Theme.textSecondary(for: colorScheme))
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
                    .fill(tools.torch.isTorchOn ? Color.orange : Theme.textTertiary(for: colorScheme))
                    .frame(width: 6, height: 6)

                Text(tools.torch.isTorchOn ? "LED ON" : L10n.Tools.ready)
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            Spacer()

            Text(tools.torch.currentMode == .continuous ? L10n.Tools.dimMode : "\(Int(tools.torch.strobeFrequencyHz)) Hz")
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsPrecisionTorchCard()
        .padding()
}
