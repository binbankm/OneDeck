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
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        GeometryReader { geo in
            let reticleSize = max(160, min(260, geo.size.width - 64, geo.size.height * 0.42))

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpacingTheme.cardStack) {
                    if !tools.isMotionAvailable {
                        HStack(spacing: SpacingTheme.tight) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(Color.orange)
                            Text(L10n.Tools.motionHardwareUnavailable)
                                .font(Typography.caption)
                                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                                .multilineTextAlignment(.leading)
                        }
                        .padding(SpacingTheme.cardInternal)
                        .background(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                .fill(Theme.cardBackground(for: colorScheme).opacity(0.85))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                .stroke(Color.orange.opacity(0.4), lineWidth: 0.8)
                        )
                    }

                    // Top Angle Metrics HUD
                    angleMetricsHud

                    Spacer(minLength: 0)

                    // Center Bullseye Reticle / Bubble
                    centerBubbleReticle(size: reticleSize)

                    Spacer(minLength: 0)

                    // Bottom Controls (Calibrate, Mode, Beep, Lock)
                    bottomControlsBar
                }
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.rowStandard)
                .frame(maxWidth: .infinity, minHeight: geo.size.height)
            }
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

        HStack(spacing: SpacingTheme.standard) {
            angleTile(
                title: L10n.Tools.rollAxis,
                value: String(format: "%+.1f°", safeRoll),
                color: appState.accentColor
            )

            angleTile(
                title: L10n.Tools.pitchAxis,
                value: String(format: "%+.1f°", safePitch),
                color: appState.accentColor
            )

            angleTile(
                title: L10n.Tools.slope,
                value: String(format: "%.1f%%", safeSlope),
                color: tools.spiritLevel.isLevel ? Color.green : appState.accentColor
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
                .foregroundStyle(color)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, SpacingTheme.compact)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
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
        let activeColor = isLevel ? Color.green : appState.accentColor
        let maxRadius = size * 0.42
        let bubbleOffset = computeBubbleOffset(maxRadius: maxRadius)
        let safeTilt = tools.spiritLevel.tiltDegrees.isFinite ? tools.spiritLevel.tiltDegrees : 0.0

        ZStack {
            // Outer Ring
            Circle()
                .strokeBorder(Theme.cardBorder(for: colorScheme), lineWidth: 2)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .fill(Theme.cardBackground(for: colorScheme).opacity(0.4))
                )

            // 15-degree Inner Ring
            Circle()
                .strokeBorder(Theme.cardBorder(for: colorScheme).opacity(0.6), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
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
                    .shadow(color: activeColor.opacity(isLevel ? 0.7 : 0.3), radius: isLevel ? 12 : 6)

                Text(String(format: "%.1f°", safeTilt))
                    .font(Typography.badgeTagMono)
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.contrastingForeground(for: activeColor))
            }
            .offset(x: isLevel ? 0 : bubbleOffset.x, y: isLevel ? 0 : bubbleOffset.y)
            .animation(.spring(response: 0.2, dampingFraction: 0.75), value: safeTilt)
        }
    }

    @ViewBuilder
    private var bottomControlsBar: some View {
        VStack(spacing: SpacingTheme.standard) {
            HStack(spacing: SpacingTheme.standard) {
                // Calibrate / Tare Zero Button
                Button {
                    tools.calibrateSpiritLevel()
                } label: {
                    HStack(spacing: SpacingTheme.tight) {
                        Image(systemName: "scope")
                            .font(IconTheme.actionButton)
                        Text(L10n.Tools.calibrate)
                            .font(Typography.captionBold)
                            .lineLimit(1)
                    }
                    .foregroundStyle(tools.isSpiritLevelCalibrated ? appState.accentColor : Theme.textPrimary(for: colorScheme))
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .fill(tools.isSpiritLevelCalibrated ? appState.accentColor.opacity(0.12) : Theme.cardBackground(for: colorScheme).opacity(0.6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .stroke(tools.isSpiritLevelCalibrated ? appState.accentColor.opacity(0.4) : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(L10n.Tools.calibrate)

                if tools.isSpiritLevelCalibrated {
                    Button {
                        tools.resetSpiritLevelCalibration()
                    } label: {
                        HStack(spacing: SpacingTheme.tight) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(IconTheme.actionButton)
                            Text(L10n.Tools.resetTare)
                                .font(Typography.captionBold)
                                .lineLimit(1)
                        }
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(L10n.Tools.resetTare)
                }
            }

            HStack(spacing: SpacingTheme.standard) {
                // Mode Switcher
                Button {
                    Haptics.selection()
                    tools.toggleSpiritLevelOrientation()
                } label: {
                    HStack(spacing: SpacingTheme.tight) {
                        Image(systemName: tools.spiritLevel.orientation == .flat ? "table.furniture.fill" : "ruler.fill")
                            .font(IconTheme.actionButton)
                        Text(tools.spiritLevel.orientation == .flat ? L10n.Tools.flatMode : L10n.Tools.verticalMode)
                            .font(Typography.captionBold)
                            .lineLimit(1)
                    }
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(tools.spiritLevel.orientation == .flat ? L10n.Tools.flatMode : L10n.Tools.verticalMode)

                // Beep Sound Toggle
                Button {
                    tools.toggleLevelBeep()
                } label: {
                    HStack(spacing: SpacingTheme.tight) {
                        Image(systemName: tools.spiritLevel.isBeepEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                            .font(IconTheme.actionButton)
                        Text(L10n.Tools.soundBeep)
                            .font(Typography.captionBold)
                            .lineLimit(1)
                    }
                    .foregroundStyle(tools.spiritLevel.isBeepEnabled ? appState.accentColor : Theme.textSecondary(for: colorScheme))
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .fill(tools.spiritLevel.isBeepEnabled ? appState.accentColor.opacity(0.12) : Theme.cardBackground(for: colorScheme).opacity(0.6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .stroke(tools.spiritLevel.isBeepEnabled ? appState.accentColor.opacity(0.4) : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(L10n.Tools.soundBeep)

                // Lock / Hold Button
                Button {
                    tools.toggleLevelLock()
                } label: {
                    HStack(spacing: SpacingTheme.tight) {
                        Image(systemName: tools.spiritLevel.isLocked ? "lock.fill" : "lock.open.fill")
                            .font(IconTheme.actionButton)
                        Text(tools.spiritLevel.isLocked ? L10n.Tools.unlockedAngle : L10n.Tools.lockAngle)
                            .font(Typography.captionBold)
                            .lineLimit(1)
                    }
                    .foregroundStyle(tools.spiritLevel.isLocked ? Color.orange : Theme.textPrimary(for: colorScheme))
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .fill(tools.spiritLevel.isLocked ? Color.orange.opacity(0.14) : Theme.cardBackground(for: colorScheme).opacity(0.6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .stroke(tools.spiritLevel.isLocked ? Color.orange.opacity(0.4) : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(tools.spiritLevel.isLocked ? L10n.Tools.unlockedAngle : L10n.Tools.lockAngle)
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
