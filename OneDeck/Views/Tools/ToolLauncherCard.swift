//
//  ToolLauncherCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Standardized instrument launcher card with value-based navigation.
//

import SwiftUI

// MARK: - Hardware Tool Destination Mapping
extension HardwareTool {
    @MainActor
    @ViewBuilder
    public var destinationView: some View {
        switch self {
        case .spiritLevel: SpiritLevelDetailView()
        case .compass: CompassDetailView()
        case .seismometer: SeismometerDetailView()
        case .barometer: BarometerDetailView()
        case .luxMeter: LuxMeterDetailView()
        case .metalDetector: MetalDetectorDetailView()
        case .decibelMeter: DecibelMeterDetailView()
        case .waterEjector: WaterEjectorDetailView()
        case .toneGenerator: ToneGeneratorDetailView()
        case .speakerLab: SpeakerLabDetailView()
        case .screenRuler: ScreenRulerDetailView()
        case .screenQuality: ScreenQualityDetailView()
        case .touchMatrix: TouchMatrixDetailView()
        case .hapticLab: HapticLabDetailView()
        case .precisionTorch: PrecisionTorchDetailView()
        case .pulseMeter: PulseMeterDetailView()
        case .microscope: MicroscopeDetailView()
        case .gnssHub: GnssHubDetailView()
        case .bleRadar: BleRadarDetailView()
        }
    }
}

// MARK: - ToolLauncherCard
struct ToolLauncherCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @ScaledMetric(relativeTo: .subheadline) private var iconSize: CGFloat = 22

    // MARK: - Properties
    let tool: HardwareTool

    // MARK: - Body
    var body: some View {
        let accentFg = Theme.readableAccent(appState.accentColor, for: colorScheme)

        NavigationLink(value: tool) {
            HStack(spacing: SpacingTheme.cardInternal) {
                // Leading Icon - Optically Matched to Global Section Header Standard
                Image(systemName: tool.icon)
                    .font(IconTheme.sectionHeader)
                    .foregroundStyle(accentFg)
                    .frame(width: iconSize, height: iconSize, alignment: .center)
                    .accessibilityHidden(true)

                // Center Title & Auxiliary Description
                VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                    Text(tool.title)
                        .font(Typography.sectionHeader)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(2)
                        .minimumScaleFactor(0.9)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(tool.subtitle)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(3)
                        .lineSpacing(1.5)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)

                Spacer(minLength: SpacingTheme.standard)

                // Trailing Chevron Indicator (Clean, No Capsule)
                Image(systemName: "chevron.right")
                    .font(IconTheme.copyIndicator)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .accessibilityHidden(true)
            }
            .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget, alignment: .leading)
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.card, style: .continuous))
            .bentoCard(
                padding: SpacingTheme.cardInternal,
                cornerRadius: CornerRadiusTheme.card,
                accent: appState.accentColor
            )
        }
        .buttonStyle(BentoCardButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel(tool.title)
        .accessibilityHint(tool.subtitle)
    }
}

// MARK: - Preview
#Preview {
    ToolLauncherCard(tool: .spiritLevel)
        .padding()
}
