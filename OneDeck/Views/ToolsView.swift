//
//  ToolsView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Tools Tab: Spirit Level, 1:1 Screen Caliper, 165Hz Water Ejector & Precision Torch.
//

import SwiftUI

struct ToolsView: View {
    @Bindable var appState = AppState.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var isEjectingWater: Bool = false
    @State private var torchLevel: Double = 0.5

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 16) {
                    // MARK: - Spirit Level Card
                    VStack(alignment: .leading, spacing: 14) {
                        BentoSectionHeader(title: L10n.Tools.spiritLevel, icon: "angle", subtitle: L10n.Tools.spiritLevelSub)

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
                        .padding(.vertical, 8)
                    }
                    .bentoCard(accent: appState.accentColor)

                    // MARK: - Screen Caliper Card
                    HStack(spacing: 14) {
                        BentoSectionHeader(title: L10n.Tools.screenRuler, icon: "ruler.fill", subtitle: L10n.Tools.screenRulerSub)
                        Spacer()
                    }
                    .bentoCard(accent: appState.accentColor)

                    // MARK: - 165Hz Water Ejector Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            BentoSectionHeader(title: L10n.Tools.waterEjector, icon: "drop.triangle.fill", subtitle: L10n.Tools.waterEjectorSub)
                            Spacer()
                            Button {
                                isEjectingWater.toggle()
                                if isEjectingWater {
                                    Haptics.heavyImpactOccurred()
                                }
                            } label: {
                                Image(systemName: isEjectingWater ? "stop.circle.fill" : "play.circle.fill")
                                    .font(IconTheme.prominentAction)
                                    .foregroundStyle(isEjectingWater ? .red : appState.accentColor)
                            }
                        }
                    }
                    .bentoCard(accent: appState.accentColor)

                    // MARK: - Precision Torch Card
                    VStack(alignment: .leading, spacing: 12) {
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
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(width: geometry.size.width)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        }
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.title)
        }
    }
}

private extension Haptics {
    static func heavyImpactOccurred() {
        impact(.heavy)
    }
}

