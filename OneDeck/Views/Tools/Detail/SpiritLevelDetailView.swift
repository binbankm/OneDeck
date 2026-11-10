//
//  SpiritLevelDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Dual-axis digital spirit level and surface angle inclinometer workspace.
//

import SwiftUI

struct SpiritLevelDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        GeometryReader { geo in
            let reticleSize = max(160, min(260, geo.size.width - 64, geo.size.height * 0.42))

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpacingTheme.cardStack) {
                    if !tools.isMotionAvailable {
                        ToolNoticeBanner(
                            icon: "exclamationmark.triangle.fill",
                            message: L10n.Tools.motionHardwareUnavailable
                        )
                    }

                    // Top Angle Metrics HUD
                    angleMetricsHud

                    Spacer(minLength: SpacingTheme.standard)

                    // Center Bullseye Reticle / Bubble
                    centerBubbleReticle(size: reticleSize)

                    Spacer(minLength: SpacingTheme.standard)

                    // Bottom Controls (Calibrate, Mode, Beep, Lock)
                    bottomControlsBar
                }
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.rowStandard)
                .frame(maxWidth: LayoutTheme.maxContentWidth)
                .frame(maxWidth: .infinity, minHeight: geo.size.height)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        }
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.spiritLevel)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.isSpiritLevelDetailActive = true
            tools.enterDetailView(tool: .spiritLevel)
            tools.startMotionSensors(interval: 1.0 / 60.0)
        }
        .onDisappear {
            tools.isSpiritLevelDetailActive = false
            tools.stopMotionSensors()
            tools.leaveDetailView()
        }
    }

    // MARK: - Subviews
    @ViewBuilder
    private var angleMetricsHud: some View {
        let safeRoll = tools.spiritLevel.rollDegrees.isFinite ? tools.spiritLevel.rollDegrees : 0.0
        let safePitch = tools.spiritLevel.pitchDegrees.isFinite ? tools.spiritLevel.pitchDegrees : 0.0
        let safeSlope = tools.spiritLevel.slopePercent.isFinite ? tools.spiritLevel.slopePercent : 0.0
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: SpacingTheme.compact))
            : AnyLayout(HStackLayout(spacing: SpacingTheme.standard))

        layout {
            angleTile(
                title: L10n.Tools.rollAxis,
                value: String(format: "%+.1f°", safeRoll),
                color: accentFg
            )

            angleTile(
                title: L10n.Tools.pitchAxis,
                value: String(format: "%+.1f°", safePitch),
                color: accentFg
            )

            angleTile(
                title: L10n.Tools.slope,
                value: String(format: "%.1f%%", safeSlope),
                color: tools.spiritLevel.isLevel ? Theme.readableGreen(for: colorScheme) : accentFg
            )
        }
    }

    @ViewBuilder
    private func angleTile(title: String, value: String, color: Color) -> some View {
        VStack(spacing: SpacingTheme.micro) {
            Text(title)
                .font(Typography.badgeTagMono)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)

            Text(value)
                .font(Typography.headlineValue)
                .fontDesign(.monospaced)
                .monospacedDigit()
                .contentTransition(.numericText())
                .foregroundStyle(color)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, SpacingTheme.compact)
        .padding(.horizontal, SpacingTheme.tight)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityValue(value)
    }

    private func computeBubbleOffset(maxRadius: CGFloat) -> (x: CGFloat, y: CGFloat) {
        let isVertical = tools.spiritLevel.orientation == .vertical
        let safeRoll = tools.spiritLevel.rollDegrees.isFinite ? tools.spiritLevel.rollDegrees : 0.0
        let safePitch = tools.spiritLevel.pitchDegrees.isFinite ? tools.spiritLevel.pitchDegrees : 0.0
        let rollClamped = max(-45.0, min(45.0, safeRoll))
        let pitchClamped = max(-45.0, min(45.0, safePitch))

        if isVertical {
            // In vertical ruler wall mode, constrain bubble to the active leveling axis
            if abs(safePitch) > 60.0 {
                // Standing upright on bottom or top edge: roll moves horizontal vial bubble
                return ((rollClamped / 45.0) * maxRadius, 0)
            } else {
                // Standing on side edge: pitch moves vertical vial bubble
                return (0, (pitchClamped / 45.0) * maxRadius)
            }
        } else {
            // Full 2D surface bullseye reticle
            return ((rollClamped / 45.0) * maxRadius, (pitchClamped / 45.0) * maxRadius)
        }
    }

    @ViewBuilder
    private func centerBubbleReticle(size: CGFloat) -> some View {
        let isLevel = tools.spiritLevel.isLevel
        let activeColor = isLevel ? Theme.readableGreen(for: colorScheme) : accentFg
        let maxRadius = size * 0.42
        let bubbleOffset = computeBubbleOffset(maxRadius: maxRadius)
        let safeTilt = tools.spiritLevel.tiltDegrees.isFinite ? tools.spiritLevel.tiltDegrees : 0.0
        let tiltString = String(format: "%.1f°", safeTilt)
        let bubbleTranslation = CGSize(
            width: isLevel ? 0 : bubbleOffset.x,
            height: isLevel ? 0 : bubbleOffset.y
        )

        ZStack {
            // Outer Ring
            Circle()
                .strokeBorder(Theme.tileBorder(for: colorScheme), lineWidth: 2)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .fill(Theme.tileBackground(for: colorScheme))
                )

            // 15-degree Inner Ring
            Circle()
                .strokeBorder(Theme.tileBorder(for: colorScheme), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                .frame(width: size * 0.55, height: size * 0.55)

            // Center Target Crosshair
            Circle()
                .strokeBorder(activeColor.opacity(isLevel ? 1.0 : 0.4), lineWidth: 1.5)
                .frame(width: 48, height: 48)

            Rectangle()
                .fill(activeColor.opacity(0.3))
                .frame(width: size * 0.9, height: 0.8)

            Rectangle()
                .fill(activeColor.opacity(0.3))
                .frame(width: 0.8, height: size * 0.9)

            // Dynamic Moving Spirit Bubble
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                activeColor,
                                activeColor.opacity(0.7)
                            ],
                            center: .center,
                            startRadius: 2,
                            endRadius: 22
                        )
                    )
                    .frame(width: 44, height: 44)
                    .shadow(color: activeColor.opacity(isLevel ? 0.65 : 0.25), radius: isLevel ? 12 : 6)

                Text(tiltString)
                    .font(Typography.badgeTagMono)
                    .fontWeight(.bold)
                    .monospacedDigit()
                    .foregroundStyle(Theme.contrastingForeground(for: activeColor))
            }
            .offset(bubbleTranslation)
            .animation(.spring(response: 0.2, dampingFraction: 0.75), value: bubbleTranslation)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.Tools.spiritLevel)
        .accessibilityValue(isLevel ? "\(L10n.Tools.levelBalanced), \(tiltString)" : tiltString)
    }

    @ViewBuilder
    private var bottomControlsBar: some View {
        let orangeAccent = Theme.readableOrange(for: colorScheme)
        let rowLayout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: SpacingTheme.compact))
            : AnyLayout(HStackLayout(spacing: SpacingTheme.standard))

        VStack(spacing: SpacingTheme.standard) {
            rowLayout {
                // Calibrate / Tare Zero Button
                Button {
                    tools.calibrateSpiritLevel()
                } label: {
                    HStack(spacing: SpacingTheme.tight) {
                        Image(systemName: "scope")
                            .font(IconTheme.actionButton)
                            .accessibilityHidden(true)
                        Text(L10n.Tools.calibrate)
                            .font(Typography.captionBold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                    .foregroundStyle(tools.isSpiritLevelCalibrated ? accentFg : Theme.textPrimary(for: colorScheme))
                    .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
                    .padding(.horizontal, SpacingTheme.tight)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .fill(tools.isSpiritLevelCalibrated ? accentFg.opacity(0.14) : Theme.tileBackground(for: colorScheme))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .stroke(tools.isSpiritLevelCalibrated ? accentFg.opacity(0.45) : Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                }
                .buttonStyle(BentoCardButtonStyle())
                .accessibilityLabel(L10n.Tools.calibrate)
                .accessibilityAddTraits(tools.isSpiritLevelCalibrated ? .isSelected : [])

                if tools.isSpiritLevelCalibrated {
                    Button {
                        tools.resetSpiritLevelCalibration()
                    } label: {
                        HStack(spacing: SpacingTheme.tight) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(IconTheme.actionButton)
                                .accessibilityHidden(true)
                            Text(L10n.Tools.resetTare)
                                .font(Typography.captionBold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.85)
                        }
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
                        .padding(.horizontal, SpacingTheme.tight)
                        .background(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                                .fill(Theme.tileBackground(for: colorScheme))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
                        )
                        .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                    }
                    .buttonStyle(BentoCardButtonStyle())
                    .accessibilityLabel(L10n.Tools.resetTare)
                }
            }

            rowLayout {
                // Mode Switcher
                let modeLabel = tools.spiritLevel.orientation == .flat ? L10n.Tools.flatMode : L10n.Tools.verticalMode
                Button {
                    Haptics.selection()
                    tools.toggleSpiritLevelOrientation()
                } label: {
                    HStack(spacing: SpacingTheme.tight) {
                        Image(systemName: tools.spiritLevel.orientation == .flat ? "table.furniture.fill" : "ruler.fill")
                            .font(IconTheme.actionButton)
                            .accessibilityHidden(true)
                        Text(modeLabel)
                            .font(Typography.captionBold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
                    .padding(.horizontal, SpacingTheme.tight)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .fill(Theme.tileBackground(for: colorScheme))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                }
                .buttonStyle(BentoCardButtonStyle())
                .accessibilityLabel(modeLabel)

                // Beep Sound Toggle
                Button {
                    tools.toggleLevelBeep()
                } label: {
                    HStack(spacing: SpacingTheme.tight) {
                        Image(systemName: tools.spiritLevel.isBeepEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                            .font(IconTheme.actionButton)
                            .accessibilityHidden(true)
                        Text(L10n.Tools.soundBeep)
                            .font(Typography.captionBold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                    .foregroundStyle(tools.spiritLevel.isBeepEnabled ? accentFg : Theme.textSecondary(for: colorScheme))
                    .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
                    .padding(.horizontal, SpacingTheme.tight)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .fill(tools.spiritLevel.isBeepEnabled ? accentFg.opacity(0.14) : Theme.tileBackground(for: colorScheme))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .stroke(tools.spiritLevel.isBeepEnabled ? accentFg.opacity(0.45) : Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                }
                .buttonStyle(BentoCardButtonStyle())
                .accessibilityLabel(L10n.Tools.soundBeep)
                .accessibilityAddTraits(tools.spiritLevel.isBeepEnabled ? .isSelected : [])

                // Lock / Hold Button
                let lockLabel = tools.spiritLevel.isLocked ? L10n.Tools.unlockedAngle : L10n.Tools.lockAngle
                Button {
                    tools.toggleLevelLock()
                } label: {
                    HStack(spacing: SpacingTheme.tight) {
                        Image(systemName: tools.spiritLevel.isLocked ? "lock.fill" : "lock.open.fill")
                            .font(IconTheme.actionButton)
                            .accessibilityHidden(true)
                        Text(lockLabel)
                            .font(Typography.captionBold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                    .foregroundStyle(tools.spiritLevel.isLocked ? orangeAccent : Theme.textPrimary(for: colorScheme))
                    .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
                    .padding(.horizontal, SpacingTheme.tight)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .fill(tools.spiritLevel.isLocked ? orangeAccent.opacity(0.14) : Theme.tileBackground(for: colorScheme))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .stroke(tools.spiritLevel.isLocked ? orangeAccent.opacity(0.45) : Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                }
                .buttonStyle(BentoCardButtonStyle())
                .accessibilityLabel(lockLabel)
                .accessibilityAddTraits(tools.spiritLevel.isLocked ? .isSelected : [])
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        SpiritLevelDetailView()
    }
}
