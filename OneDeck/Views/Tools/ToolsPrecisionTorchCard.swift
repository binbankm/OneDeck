//
//  ToolsPrecisionTorchCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Precision Torch & Strobe Bento Launcher Card.
//

import SwiftUI

struct ToolsPrecisionTorchCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: PrecisionTorchDetailView()) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                headerRow
                brightnessSliderRow
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

            // Quick Toggle Button
            Button {
                tools.toggleTorch()
            } label: {
                Image(systemName: tools.torch.isTorchOn ? "power.circle.fill" : "power.circle")
                    .font(IconTheme.prominentAction)
                    .foregroundStyle(tools.torch.isTorchOn ? Color.orange : appState.accentColor)
            }
            .buttonStyle(.plain)

            Image(systemName: "chevron.right")
                .font(IconTheme.badgeInline)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
        }
    }

    // MARK: - Brightness Slider Row
    @ViewBuilder
    private var brightnessSliderRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            Image(systemName: "sun.min.fill")
                .font(IconTheme.badgeInline)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))

            Slider(value: Binding(
                get: { Double(tools.torch.brightness) },
                set: { tools.setTorchBrightness(Float($0)) }
            ), in: 0.01...1.0)
            .tint(tools.torch.isTorchOn ? Color.orange : appState.accentColor)

            Image(systemName: "sun.max.fill")
                .font(IconTheme.badgeInline)
                .foregroundStyle(tools.torch.isTorchOn ? Color.orange : Theme.textTertiary(for: colorScheme))

            Text("\(Int(tools.torch.brightness * 100))%")
                .font(Typography.captionMono)
                .foregroundStyle(tools.torch.isTorchOn ? Color.orange : Theme.textPrimary(for: colorScheme))
                .frame(width: 36, alignment: .trailing)
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsPrecisionTorchCard()
        .padding()
}

