//
//  SpiritLevelDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Precision 360-Degree Dual-Axis Spirit Level & Inclinometer Fullscreen Workspace.
//

import SwiftUI

struct SpiritLevelDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: SpacingTheme.cardStack) {
                // Top Angle Metrics HUD
                angleMetricsHud

                Spacer()

                // Center Bullseye Reticle / Bubble
                centerBubbleReticle(size: max(120, min(geometry.size.width - 48, 280)))

                Spacer()

                // Bottom Controls (Lock, Beep, Orientation Mode)
                bottomControlsBar
            }
            .padding(.horizontal, SpacingTheme.cardStack)
            .padding(.vertical, SpacingTheme.rowStandard)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.spiritLevel)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView()
            tools.startMotionSensors(interval: 1.0 / 60.0)
        }
        .onDisappear {
            tools.leaveDetailView()
            tools.startMotionSensors(interval: 1.0 / 12.0)
        }
    }

    // MARK: - Subviews
    @ViewBuilder
    private var angleMetricsHud: some View {
        HStack(spacing: SpacingTheme.standard) {
            angleTile(
                title: L10n.Tools.rollAxis,
                value: String(format: "%+.1f°", tools.spiritLevel.rollDegrees),
                color: appState.accentColor
            )

            angleTile(
                title: L10n.Tools.pitchAxis,
                value: String(format: "%+.1f°", tools.spiritLevel.pitchDegrees),
                color: appState.accentColor
            )

            angleTile(
                title: L10n.Tools.slope,
                value: String(format: "%.1f%%", tools.spiritLevel.slopePercent),
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
    }

    @ViewBuilder
    private func centerBubbleReticle(size: CGFloat) -> some View {
        let isLevel = tools.spiritLevel.isLevel
        let activeColor = isLevel ? Color.green : appState.accentColor
        let maxRadius = size * 0.42

        // Convert roll & pitch degrees to 2D pixel offset
        let rollClamped = max(-45.0, min(45.0, tools.spiritLevel.rollDegrees))
        let pitchClamped = max(-45.0, min(45.0, tools.spiritLevel.pitchDegrees))

        let offsetX = (rollClamped / 45.0) * maxRadius
        let offsetY = (pitchClamped / 45.0) * maxRadius

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

                Text(String(format: "%.1f°", tools.spiritLevel.tiltDegrees))
                    .font(Typography.badgeTagMono)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.black)
            }
            .offset(x: isLevel ? 0 : offsetX, y: isLevel ? 0 : offsetY)
            .animation(.spring(response: 0.2, dampingFraction: 0.75), value: tools.spiritLevel.tiltDegrees)
        }
    }

    @ViewBuilder
    private var bottomControlsBar: some View {
        HStack(spacing: SpacingTheme.standard) {
            // Mode Indicator
            Button {
                Haptics.selection()
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: tools.spiritLevel.orientation == .flat ? "table.furniture" : "ruler")
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

            // Lock / Hold Button
            Button {
                tools.toggleLevelLock()
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: tools.spiritLevel.isLocked ? "lock.fill" : "lock.open")
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
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        SpiritLevelDetailView()
    }
}

