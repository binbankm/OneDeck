//
//  MicroscopeDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Macro optical magnifier camera and digital zoom workspace.
//

import AVFoundation
import SwiftUI

struct MicroscopeDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        VStack(spacing: SpacingTheme.cardStack) {
            // Viewfinder Surface
            viewfinderContainer

            // Zoom Control Bar
            zoomControlCard

            // Action Toolbar (Filter, Torch, Freeze)
            actionToolbar
        }
        .padding(.horizontal, SpacingTheme.cardStack)
        .padding(.vertical, SpacingTheme.rowStandard)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.microscope)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView(tool: .microscope)
            tools.startMicroscope()
        }
        .onDisappear {
            tools.stopMicroscope()
            tools.leaveDetailView()
        }
    }

    // MARK: - Viewfinder Container
    @ViewBuilder
    private var viewfinderContainer: some View {
        GeometryReader { geo in
            ZStack {
                // Background Viewfinder Area
                Color.black

                // Macro Optical Camera Hardware Live Feed
                CameraPreviewRepresentable(session: MicroscopeCameraProbe.shared.captureSession)
                    .clipped()

                // High-precision Measuring Reticle (Crosshairs & 0.1mm Graticule)
                reticleOverlay(size: geo.size)

                // Filter Overlay Visual Effect
                if tools.microscope.filterMode == .inverted {
                    Color.white.opacity(0.1)
                        .blendMode(.difference)
                } else if tools.microscope.filterMode == .edgeDetection {
                    Color.cyan.opacity(0.12)
                }

                // HUD Top Badges
                VStack {
                    HStack {
                        // Current Filter Badge
                        HStack(spacing: SpacingTheme.tight) {
                            Circle()
                                .fill(appState.accentColor)
                                .frame(width: 6, height: 6)
                            Text(tools.microscope.filterMode.title)
                                .font(Typography.captionMono)
                                .foregroundStyle(Color.white)
                        }
                        .padding(.horizontal, SpacingTheme.standard)
                        .padding(.vertical, SpacingTheme.micro)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Capsule())

                        Spacer()

                        // Zoom Badge
                        Text(String(format: "%.1fx", tools.microscope.zoomFactor))
                            .font(Typography.captionMono)
                            .foregroundStyle(appState.accentColor)
                            .padding(.horizontal, SpacingTheme.standard)
                            .padding(.vertical, SpacingTheme.micro)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Capsule())
                    }
                    .padding(SpacingTheme.standard)

                    Spacer()

                    if tools.microscope.isFrozen {
                        Text("\(L10n.Tools.frameFrozen) (HOLD)")
                            .font(Typography.captionBold)
                            .foregroundStyle(Color.yellow)
                            .padding(.horizontal, SpacingTheme.rowStandard)
                            .padding(.vertical, SpacingTheme.tight)
                            .background(Color.black.opacity(0.75))
                            .clipShape(Capsule())
                            .padding(.bottom, SpacingTheme.standard)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
            )
        }
    }

    // MARK: - Reticle Overlay
    @ViewBuilder
    private func reticleOverlay(size: CGSize) -> some View {
        ZStack {
            // Center Ring
            Circle()
                .stroke(appState.accentColor.opacity(0.6), lineWidth: 1)
                .frame(width: 80, height: 80)

            // Outer Scope Ring
            Circle()
                .stroke(appState.accentColor.opacity(0.3), lineWidth: 0.8)
                .frame(width: 180, height: 180)

            // Crosshair Lines
            Path { p in
                p.move(to: CGPoint(x: size.width / 2, y: 0))
                p.addLine(to: CGPoint(x: size.width / 2, y: size.height))
                p.move(to: CGPoint(x: 0, y: size.height / 2))
                p.addLine(to: CGPoint(x: size.width, y: size.height / 2))
            }
            .stroke(appState.accentColor.opacity(0.25), lineWidth: 0.6)

            // Graticule Tick Marks
            ForEach(-4 ... 4, id: \.self) { i in
                if i != 0 {
                    let offset = CGFloat(i) * 15.0
                    Rectangle()
                        .fill(appState.accentColor.opacity(0.5))
                        .frame(width: 1, height: 8)
                        .offset(x: offset, y: 0)

                    Rectangle()
                        .fill(appState.accentColor.opacity(0.5))
                        .frame(width: 8, height: 1)
                        .offset(x: 0, y: offset)
                }
            }
        }
    }

    // MARK: - Zoom Control Card
    @ViewBuilder
    private var zoomControlCard: some View {
        VStack(spacing: SpacingTheme.tight) {
            HStack {
                Text(L10n.Tools.macroMagnification)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))

                Spacer()

                Text(String(format: "%.1fx", tools.microscope.zoomFactor))
                    .font(Typography.headlineValue)
                    .fontDesign(.monospaced)
                    .foregroundStyle(appState.accentColor)
            }

            Slider(value: Binding(
                get: { Double(tools.microscope.zoomFactor) },
                set: { tools.setMicroscopeZoom(CGFloat($0)) }
            ), in: 1.0 ... 15.0, step: 0.1)
                .tint(appState.accentColor)

            // Preset Zoom Buttons
            HStack(spacing: SpacingTheme.compact) {
                ForEach([1.0, 3.0, 5.0, 10.0, 15.0], id: \.self) { preset in
                    Button {
                        tools.setMicroscopeZoom(CGFloat(preset))
                    } label: {
                        Text("\(Int(preset))x")
                            .font(Typography.captionMono)
                            .foregroundStyle(tools.microscope.zoomFactor == CGFloat(preset) ? Color.black : Theme.textPrimary(for: colorScheme))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, SpacingTheme.micro)
                            .background(tools.microscope.zoomFactor == CGFloat(preset) ? appState.accentColor : Theme.cardBackground(for: colorScheme))
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(SpacingTheme.rowStandard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
    }

    // MARK: - Action Toolbar
    @ViewBuilder
    private var actionToolbar: some View {
        HStack(spacing: SpacingTheme.standard) {
            // Filter Mode Cycle Button
            Button {
                tools.cycleMicroscopeFilter()
            } label: {
                VStack(spacing: SpacingTheme.micro) {
                    Image(systemName: "camera.filters")
                        .font(IconTheme.actionButton)
                    Text(tools.microscope.filterMode.title)
                        .font(Typography.caption)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Theme.cardBackground(for: colorScheme))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                )
            }
            .buttonStyle(.plain)

            // LED Torch Toggle
            Button {
                tools.toggleMicroscopeTorch()
            } label: {
                VStack(spacing: SpacingTheme.micro) {
                    Image(systemName: tools.microscope.isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                        .font(IconTheme.actionButton)
                    Text(L10n.Tools.macroIllumination)
                        .font(Typography.caption)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .foregroundStyle(tools.microscope.isTorchOn ? Color.orange : Theme.textPrimary(for: colorScheme))
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Theme.cardBackground(for: colorScheme))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(tools.microscope.isTorchOn ? Color.orange : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                )
            }
            .buttonStyle(.plain)

            // Freeze Frame Toggle
            Button {
                tools.freezeMicroscopeFrame()
            } label: {
                VStack(spacing: SpacingTheme.micro) {
                    Image(systemName: tools.microscope.isFrozen ? "play.circle.fill" : "pause.circle.fill")
                        .font(IconTheme.actionButton)
                    Text(tools.microscope.isFrozen ? L10n.Tools.resumePreview : L10n.Tools.freezeFrame)
                        .font(Typography.caption)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(tools.microscope.isFrozen ? Color.yellow : appState.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        MicroscopeDetailView()
    }
}
