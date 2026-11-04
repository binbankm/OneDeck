//
//  ScreenQualityDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  OLED screen uniformity, color purity, and dead pixel inspection workspace.
//

import SwiftUI

struct ScreenQualityDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared
    @Bindable private var system = SystemViewModel.shared

    // MARK: - State
    @State private var isFullscreenColorActive: Bool = false
    @State private var colorIndex: Int = 0
    @State private var touchHistory: [CGPoint] = []

    private let testColors: [Color] = [
        .black,
        .white,
        Color(white: 0.5), // 50% Gray
        .red,
        .green,
        .blue,
        .yellow
    ]

    private var maxFpsText: String {
        "\(system.hardwareSpecs.maxFps)Hz"
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: SpacingTheme.cardStack) {
            // Section 1: Fullscreen Dead Pixel & Uniformity Test Launcher
            pixelInspectionCard

            // Section 2: 120Hz Multi-Touch Canvas
            touchDigitizerCanvas

            Spacer()
        }
        .padding(.horizontal, SpacingTheme.cardStack)
        .padding(.vertical, SpacingTheme.rowStandard)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.screenQuality)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView(tool: .screenQuality)
            tools.startProximityMonitoring()
        }
        .onDisappear {
            tools.stopProximityMonitoring()
            tools.leaveDetailView()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.proximityStateDidChangeNotification)) { _ in
            tools.updateProximityState()
        }
        .fullScreenCover(isPresented: $isFullscreenColorActive) {
            fullscreenColorCover
        }
    }

    // MARK: - Pixel Inspection Launcher
    @ViewBuilder
    private var pixelInspectionCard: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            HStack {
                BentoSectionHeader(
                    title: L10n.Tools.deadPixelCheck,
                    icon: "tv.fill",
                    subtitle: L10n.Tools.deadPixelCheckSub
                )
                Spacer()
                Text(maxFpsText)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(appState.accentColor)
                    .padding(.horizontal, SpacingTheme.compact)
                    .padding(.vertical, SpacingTheme.micro)
                    .background(appState.accentColor.opacity(0.12))
                    .clipShape(Capsule())
            }

            Button {
                colorIndex = 0
                isFullscreenColorActive = true
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(IconTheme.actionButton)
                    Text(L10n.Tools.startFullscreenInspection)
                        .font(Typography.calloutBold)
                }
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(appState.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
            }
            .buttonStyle(.plain)

            // Optical Proximity Sensor Telemetry
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: "sensor.fill")
                    .font(IconTheme.badgeInline)
                    .foregroundStyle(tools.isProximityNear ? Color.orange : Color.green)
                Text(L10n.Tools.proximitySensor)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                Spacer()
                Text(tools.isProximityNear ? L10n.Tools.proximityNear : L10n.Tools.proximityFar)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(tools.isProximityNear ? Color.orange : Color.green)
            }
            .padding(.horizontal, SpacingTheme.standard)
            .padding(.vertical, SpacingTheme.micro)
            .background((tools.isProximityNear ? Color.orange : Color.green).opacity(0.12))
            .clipShape(Capsule())
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Touch Digitizer Canvas
    @ViewBuilder
    private var touchDigitizerCanvas: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            HStack {
                BentoSectionHeader(
                    title: L10n.Tools.touchGrid,
                    icon: "hand.draw.fill",
                    subtitle: L10n.Tools.touchGridSub
                )

                Spacer()

                if let last = touchHistory.last {
                    Text(String(format: "X:%.0f Y:%.0f", last.x, last.y))
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }

                Button {
                    touchHistory.removeAll()
                    Haptics.tick()
                } label: {
                    Text(L10n.Tools.clearCanvas)
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(appState.accentColor)
                }
            }

            // Interactive Drawing Canvas
            Canvas { context, size in
                // Grid Background
                let step: CGFloat = 30.0
                var gridPath = Path()
                for x in stride(from: 0, through: size.width, by: step) {
                    gridPath.move(to: CGPoint(x: x, y: 0))
                    gridPath.addLine(to: CGPoint(x: x, y: size.height))
                }
                for y in stride(from: 0, through: size.height, by: step) {
                    gridPath.move(to: CGPoint(x: 0, y: y))
                    gridPath.addLine(to: CGPoint(x: size.width, y: y))
                }
                context.stroke(gridPath, with: .color(colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.06)), lineWidth: 0.8)

                // Drawn Points
                for pt in touchHistory {
                    var circle = Path()
                    circle.addEllipse(in: CGRect(x: pt.x - 8, y: pt.y - 8, width: 16, height: 16))
                    context.fill(circle, with: .color(appState.accentColor.opacity(0.7)))
                }
            }
            .frame(height: 180)
            .background(Theme.cardBackground(for: colorScheme).opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        touchHistory.append(value.location)
                        if touchHistory.count > 300 {
                            touchHistory.removeFirst()
                        }
                    }
            )

            Text(L10n.Tools.touchTrajectoryTip)
                .font(Typography.badgeTag)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Fullscreen Color Cover
    @ViewBuilder
    private var fullscreenColorCover: some View {
        ZStack {
            testColors[colorIndex].ignoresSafeArea()

            VStack {
                Spacer()

                HStack {
                    Text(L10n.Tools.screenColorTitle(index: colorIndex))
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(colorIndex == 0 ? Color.white.opacity(0.5) : Color.black.opacity(0.5))
                        .padding(.horizontal, SpacingTheme.standard)
                        .padding(.vertical, SpacingTheme.micro)
                        .background((colorIndex == 0 ? Color.white : Color.black).opacity(0.12))
                        .clipShape(Capsule())

                    Spacer()

                    Text(L10n.Tools.tapToExitFullscreen)
                        .font(Typography.badgeTag)
                        .foregroundStyle(colorIndex == 0 ? Color.white.opacity(0.5) : Color.black.opacity(0.5))
                }
                .padding()
            }
        }
        .onTapGesture(count: 2) {
            isFullscreenColorActive = false
        }
        .onTapGesture(count: 1) {
            colorIndex = (colorIndex + 1) % testColors.count
            Haptics.tick()
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ScreenQualityDetailView()
    }
}
