//
//  ToolsView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Tools Tab: Spirit Level, 1:1 Screen Caliper, 165Hz Water Ejector & Precision Torch.
//

import SwiftUI

struct ToolsView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared

    // MARK: - State
    @State private var isEjectingWater: Bool = false
    @State private var torchLevel: Double = 0.5

    // MARK: - Body
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    cardStack
                        .padding(.horizontal, SpacingTheme.cardStack)
                        .padding(.vertical, SpacingTheme.rowStandard)
                        .frame(width: geometry.size.width)
                }
                .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            }
            .background(Theme.background(for: colorScheme).ignoresSafeArea())
            .navigationTitle(L10n.Tools.title)
        }
    }

    // MARK: - Subviews
    @ViewBuilder
    private var cardStack: some View {
        VStack(spacing: SpacingTheme.cardStack) {
            spiritLevelCard
            screenCaliperCard
            waterEjectorCard
            precisionTorchCard
        }
    }

    // MARK: - Tool Cards
    @ViewBuilder
    private var spiritLevelCard: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(
                title: L10n.Tools.spiritLevel,
                icon: "angle",
                subtitle: L10n.Tools.spiritLevelSub
            )

            // Simulated Spirit Level Bubble
            ZStack {
                Circle()
                    .strokeBorder(Theme.cardBorder(for: colorScheme), lineWidth: 2)
                    .frame(height: 120)

                Circle()
                    .strokeBorder(appState.accentColor.opacity(0.3), lineWidth: 1)
                    .frame(height: 60)

                Circle()
                    .fill(appState.accentColor)
                    .frame(width: 28, height: 28)
                    .shadow(color: appState.accentColor.opacity(0.5), radius: 6)

                Text("0.0°")
                    .font(Typography.captionMono)
                    .foregroundStyle(.black)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, SpacingTheme.standard)
        }
        .bentoCard(accent: appState.accentColor)
    }

    @ViewBuilder
    private var screenCaliperCard: some View {
        HStack(spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(
                title: L10n.Tools.screenRuler,
                icon: "ruler.fill",
                subtitle: L10n.Tools.screenRulerSub
            )
            Spacer()
        }
        .bentoCard(accent: appState.accentColor)
    }

    @ViewBuilder
    private var waterEjectorCard: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.rowStandard) {
            HStack {
                BentoSectionHeader(
                    title: L10n.Tools.waterEjector,
                    icon: "drop.triangle.fill",
                    subtitle: L10n.Tools.waterEjectorSub
                )
                Spacer()
                Button {
                    isEjectingWater.toggle()
                    if isEjectingWater {
                        Haptics.impact(.heavy)
                    }
                } label: {
                    Image(systemName: isEjectingWater ? "stop.circle.fill" : "play.circle.fill")
                        .font(IconTheme.prominentAction)
                        .foregroundStyle(isEjectingWater ? .red : appState.accentColor)
                }
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    @ViewBuilder
    private var precisionTorchCard: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.rowStandard) {
            HStack {
                BentoSectionHeader(title: L10n.Tools.torchLab, icon: "flashlight.on.fill")
                Spacer()
                Text("\(Int(torchLevel * 100))%")
                    .font(Typography.bodyValueMono)
                    .foregroundStyle(appState.accentColor)
            }

            Slider(value: $torchLevel, in: 0.01...1.0)
                .tint(appState.accentColor)
                .onChange(of: torchLevel) { _, _ in
                    Haptics.tick()
                }
        }
        .bentoCard(accent: appState.accentColor)
    }
}

// MARK: - Preview
#Preview {
    ToolsView()
}
