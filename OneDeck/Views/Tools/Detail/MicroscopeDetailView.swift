//
//  MicroscopeDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Macro optical magnifier camera and digital zoom workspace.
//

import SwiftUI

struct MicroscopeDetailView: View {
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
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: SpacingTheme.cardStack) {
                // Viewfinder Surface
                viewfinderContainer

                // Zoom Control Bar
                zoomControlCard

                // Action Toolbar (Filter, Torch, Freeze)
                actionToolbar
            }
            .frame(maxWidth: LayoutTheme.maxContentWidth)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, SpacingTheme.cardStack)
            .padding(.vertical, SpacingTheme.rowStandard)
        }
        .scrollBounceBehavior(.basedOnSize, axes: .vertical)
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
        let darkAccent = Theme.readableAccent(appState.accentColor, for: .dark)
        let safeZoom = tools.microscope.zoomFactor.isFinite ? tools.microscope.zoomFactor : 1.0
        let zoomText = String(format: "%.1fx", safeZoom)
        let viewfinderHeight: CGFloat = dynamicTypeSize.isAccessibilitySize ? 320 : 380

        ZStack {
            // Background Viewfinder Area
            Color.black

            // Macro Optical Camera Hardware Live Feed
            tools.makeMicroscopePreview()
                .clipped()

            // Real-time CoreImage Filtered Frame (Inverted / Sobel Edge) or Frozen Snapshot
            if let processedImage = tools.microscopeProcessedImage {
                Image(uiImage: processedImage)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .allowsHitTesting(false)
            }

            // High-precision Measuring Reticle (Crosshairs & 0.1mm Graticule)
            reticleOverlay
                .allowsHitTesting(false)
                .accessibilityHidden(true)

            // HUD Top Badges
            VStack {
                HStack {
                    // Current Filter Badge
                    HStack(spacing: SpacingTheme.tight) {
                        Circle()
                            .fill(darkAccent)
                            .frame(width: 6, height: 6)
                            .accessibilityHidden(true)
                        Text(tools.microscope.filterMode.title)
                            .font(Typography.captionMono)
                            .foregroundStyle(Color.white)
                    }
                    .padding(.horizontal, SpacingTheme.standard)
                    .padding(.vertical, SpacingTheme.micro)
                    .background(Color.black.opacity(0.65))
                    .clipShape(Capsule())

                    Spacer()

                    // Zoom Badge
                    Text(zoomText)
                        .font(Typography.captionMono)
                        .monospacedDigit()
                        .foregroundStyle(darkAccent)
                        .padding(.horizontal, SpacingTheme.standard)
                        .padding(.vertical, SpacingTheme.micro)
                        .background(Color.black.opacity(0.65))
                        .clipShape(Capsule())
                }
                .padding(SpacingTheme.standard)

                Spacer()

                if tools.microscope.isFrozen {
                    Text(L10n.Tools.frameFrozen)
                        .font(Typography.captionBold)
                        .foregroundStyle(Theme.readableYellow(for: .dark))
                        .padding(.horizontal, SpacingTheme.rowStandard)
                        .padding(.vertical, SpacingTheme.tight)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .padding(.bottom, SpacingTheme.standard)
                }
            }

            if tools.isCameraPermissionDenied || tools.microscopeStatus == .permissionDenied {
                ZStack {
                    Color.black.opacity(0.88)
                    ToolPermissionDeniedBanner(
                        icon: "camera.fill",
                        message: L10n.Tools.cameraPermissionDenied,
                        onDarkSurface: true,
                        onOpenSettings: tools.openAppSettings
                    )
                    .padding(SpacingTheme.cardStack)
                }
            } else if tools.microscopeStatus == .hardwareUnavailable {
                ZStack {
                    Color.black.opacity(0.88)
                    ToolNoticeBanner(
                        icon: "camera.fill",
                        message: L10n.Tools.cameraHardwareUnavailable,
                        onDarkSurface: true
                    )
                    .padding(SpacingTheme.cardStack)
                }
            }
        }
        .frame(height: viewfinderHeight)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel(L10n.Tools.microscope)
        .accessibilityValue("\(tools.microscope.filterMode.title), \(zoomText)\(tools.microscope.isFrozen ? ", \(L10n.Tools.frameFrozen)" : "")")
    }

    // MARK: - Reticle Overlay
    @ViewBuilder
    private var reticleOverlay: some View {
        let darkAccent = Theme.readableAccent(appState.accentColor, for: .dark)

        ZStack {
            // Center Ring
            Circle()
                .stroke(darkAccent.opacity(0.6), lineWidth: 1)
                .frame(width: 80, height: 80)

            // Outer Scope Ring
            Circle()
                .stroke(darkAccent.opacity(0.3), lineWidth: 0.8)
                .frame(width: 180, height: 180)

            // Crosshair Lines
            Rectangle()
                .fill(darkAccent.opacity(0.25))
                .frame(width: 0.6)
                .frame(maxHeight: .infinity)

            Rectangle()
                .fill(darkAccent.opacity(0.25))
                .frame(height: 0.6)
                .frame(maxWidth: .infinity)

            // Graticule Tick Marks
            ForEach(-4 ... 4, id: \.self) { i in
                if i != 0 {
                    let offset = CGFloat(i) * 15.0
                    Rectangle()
                        .fill(darkAccent.opacity(0.5))
                        .frame(width: 1, height: 8)
                        .offset(x: offset, y: 0)

                    Rectangle()
                        .fill(darkAccent.opacity(0.5))
                        .frame(width: 8, height: 1)
                        .offset(x: 0, y: offset)
                }
            }
        }
    }

    // MARK: - Zoom Control Card
    @ViewBuilder
    private var zoomControlCard: some View {
        let safeZoom = tools.microscope.zoomFactor.isFinite ? tools.microscope.zoomFactor : 1.0
        let zoomText = String(format: "%.1fx", safeZoom)
        let columns = Array(
            repeating: GridItem(.flexible(), spacing: SpacingTheme.compact),
            count: dynamicTypeSize.isAccessibilitySize ? 3 : 5
        )

        VStack(spacing: SpacingTheme.standard) {
            HStack {
                Text(L10n.Tools.macroMagnification)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))

                Spacer()

                Text(zoomText)
                    .font(Typography.headlineValue)
                    .fontDesign(.monospaced)
                    .monospacedDigit()
                    .foregroundStyle(accentFg)
            }

            Slider(value: Binding(
                get: { Double(safeZoom) },
                set: { tools.setMicroscopeZoom(CGFloat($0)) }
            ), in: 1.0 ... 15.0, step: 0.1)
                .tint(accentFg)
                .accessibilityLabel(L10n.Tools.macroMagnification)
                .accessibilityValue(zoomText)

            // Preset Zoom Buttons
            LazyVGrid(columns: columns, spacing: SpacingTheme.compact) {
                ForEach([1.0, 3.0, 5.0, 10.0, 15.0], id: \.self) { preset in
                    let isSelected = abs(safeZoom - CGFloat(preset)) < 0.05
                    Button {
                        Haptics.selection()
                        tools.setMicroscopeZoom(CGFloat(preset))
                    } label: {
                        Text("\(Int(preset))x")
                            .font(Typography.captionMono)
                            .foregroundStyle(isSelected ? Theme.contrastingForeground(for: appState.accentColor) : Theme.textPrimary(for: colorScheme))
                            .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
                            .background(isSelected ? appState.accentColor : Theme.chipBackground(for: colorScheme))
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous)
                                    .stroke(isSelected ? appState.accentColor : Theme.chipBorder(for: colorScheme), lineWidth: 0.8)
                            )
                            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous))
                    }
                    .buttonStyle(BentoCardButtonStyle())
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }
        }
        .padding(SpacingTheme.rowStandard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
        )
    }

    // MARK: - Action Toolbar
    @ViewBuilder
    private var actionToolbar: some View {
        let orangeAccent = Theme.readableOrange(for: colorScheme)
        let freezeBg = tools.microscope.isFrozen ? Theme.readableYellow(for: colorScheme) : appState.accentColor

        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: SpacingTheme.standard))
            : AnyLayout(HStackLayout(spacing: SpacingTheme.standard))

        layout {
            // Filter Mode Cycle Button
            Button {
                tools.cycleMicroscopeFilter()
            } label: {
                VStack(spacing: SpacingTheme.micro) {
                    Image(systemName: "camera.filters")
                        .font(IconTheme.actionButton)
                        .accessibilityHidden(true)
                    Text(tools.microscope.filterMode.title)
                        .font(Typography.caption)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .frame(maxWidth: .infinity, minHeight: 54)
                .padding(.horizontal, SpacingTheme.tight)
                .background(Theme.tileBackground(for: colorScheme))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
                )
                .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            }
            .buttonStyle(BentoCardButtonStyle())

            // LED Torch Toggle
            Button {
                tools.toggleMicroscopeTorch()
            } label: {
                VStack(spacing: SpacingTheme.micro) {
                    Image(systemName: tools.microscope.isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                        .font(IconTheme.actionButton)
                        .accessibilityHidden(true)
                    Text(L10n.Tools.macroIllumination)
                        .font(Typography.caption)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .foregroundStyle(tools.microscope.isTorchOn ? orangeAccent : Theme.textPrimary(for: colorScheme))
                .frame(maxWidth: .infinity, minHeight: 54)
                .padding(.horizontal, SpacingTheme.tight)
                .background(tools.microscope.isTorchOn ? orangeAccent.opacity(0.14) : Theme.tileBackground(for: colorScheme))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(tools.microscope.isTorchOn ? orangeAccent : Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
                )
                .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            }
            .buttonStyle(BentoCardButtonStyle())
            .accessibilityAddTraits(tools.microscope.isTorchOn ? .isSelected : [])

            // Freeze Frame Toggle
            Button {
                tools.freezeMicroscopeFrame()
            } label: {
                VStack(spacing: SpacingTheme.micro) {
                    Image(systemName: tools.microscope.isFrozen ? "play.circle.fill" : "pause.circle.fill")
                        .font(IconTheme.actionButton)
                        .accessibilityHidden(true)
                    Text(tools.microscope.isFrozen ? L10n.Tools.resumePreview : L10n.Tools.freezeFrame)
                        .font(Typography.caption)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .foregroundStyle(Theme.contrastingForeground(for: freezeBg))
                .frame(maxWidth: .infinity, minHeight: 54)
                .padding(.horizontal, SpacingTheme.tight)
                .background(freezeBg)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            }
            .buttonStyle(BentoCardButtonStyle())
            .accessibilityAddTraits(tools.microscope.isFrozen ? .isSelected : [])
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        MicroscopeDetailView()
    }
}
