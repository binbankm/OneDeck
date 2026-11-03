//
//  ToolsMetalDetectorCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Magnetic Flux & Metal Detector Bento Launcher Card.
//

import SwiftUI

struct ToolsMetalDetectorCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: MetalDetectorDetailView()) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                headerRow
                middleGaugeRow
            }
            .bentoCard(accent: tools.metalDetector.deltaMicroTesla > 15.0 ? Color.orange : appState.accentColor)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Header
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.metalDetector,
                icon: "circle.circle.fill",
                subtitle: L10n.Tools.metalDetectorSub
            )

            Spacer()

            Text(String(format: "%.0f µT", tools.metalDetector.totalMicroTesla))
                .font(Typography.headlineValue)
                .fontDesign(.monospaced)
                .foregroundStyle(tools.metalDetector.deltaMicroTesla > 15.0 ? Color.orange : appState.accentColor)
                .lineLimit(1)

            Image(systemName: "chevron.right")
                .font(IconTheme.badgeInline)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
        }
    }

    // MARK: - Middle Gauge Row
    @ViewBuilder
    private var middleGaugeRow: some View {
        VStack(spacing: SpacingTheme.compact) {
            // Signal Strength Progress Bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [appState.accentColor, Color.orange, Color.red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(8, geo.size.width * CGFloat(tools.metalDetector.normalizedSignal)))
                        .animation(.easeOut(duration: 0.15), value: tools.metalDetector.normalizedSignal)
                }
            }
            .frame(height: 6)

            HStack {
                HStack(spacing: SpacingTheme.tight) {
                    Circle()
                        .fill(tools.metalDetector.deltaMicroTesla > 15.0 ? Color.orange : appState.accentColor)
                        .frame(width: 6, height: 6)

                    Text("\(L10n.Tools.deltaLabel): +\(String(format: "%.0f", tools.metalDetector.deltaMicroTesla)) µT")
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                }

                Spacer()

                Text(String(format: "%.0f µT", tools.metalDetector.totalMicroTesla))
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsMetalDetectorCard()
        .padding()
}

