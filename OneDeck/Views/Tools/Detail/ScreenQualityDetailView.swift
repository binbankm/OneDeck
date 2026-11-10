//
//  ScreenQualityDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  OLED screen uniformity, color purity, and dead pixel inspection workspace.
//

import SwiftUI
import UIKit

struct ScreenQualityDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
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

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    private var maxFpsText: String {
        "\(system.hardwareSpecs.maxFps)Hz"
    }

    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: SpacingTheme.cardStack) {
                // Section 1: Fullscreen Dead Pixel & Uniformity Test Launcher
                pixelInspectionCard

                // Section 2: 120Hz Multi-Touch Canvas
                touchDigitizerCanvas
            }
            .frame(maxWidth: LayoutTheme.maxContentWidth)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, SpacingTheme.cardStack)
            .padding(.vertical, SpacingTheme.rowStandard)
        }
        .scrollBounceBehavior(.basedOnSize, axes: .vertical)
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
        let proximityColor = tools.isProximityNear ? Theme.readableOrange(for: colorScheme) : Theme.readableGreen(for: colorScheme)

        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            let headerLayout = dynamicTypeSize.isAccessibilitySize
                ? AnyLayout(VStackLayout(alignment: .leading, spacing: SpacingTheme.compact))
                : AnyLayout(HStackLayout(alignment: .top, spacing: SpacingTheme.standard))

            headerLayout {
                BentoSectionHeader(
                    title: L10n.Tools.deadPixelCheck,
                    icon: "tv.fill",
                    subtitle: L10n.Tools.deadPixelCheckSub
                )

                if !dynamicTypeSize.isAccessibilitySize {
                    Spacer(minLength: 0)
                }

                Text(maxFpsText)
                    .font(Typography.badgeTagMono)
                    .monospacedDigit()
                    .foregroundStyle(accentFg)
                    .padding(.horizontal, SpacingTheme.compact)
                    .padding(.vertical, SpacingTheme.micro)
                    .background(accentFg.opacity(0.14))
                    .clipShape(Capsule())
            }

            Button {
                Haptics.selection()
                colorIndex = 0
                isFullscreenColorActive = true
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(IconTheme.actionButton)
                        .accessibilityHidden(true)
                    Text(L10n.Tools.startFullscreenInspection)
                        .font(Typography.calloutBold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
                .foregroundStyle(Theme.contrastingForeground(for: appState.accentColor))
                .frame(maxWidth: .infinity, minHeight: 46)
                .background(appState.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
            }
            .buttonStyle(BentoCardButtonStyle())

            // Optical Proximity Sensor Telemetry
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: "sensor.fill")
                    .font(IconTheme.badgeInline)
                    .foregroundStyle(proximityColor)
                    .accessibilityHidden(true)
                Text(L10n.Tools.proximitySensor)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                Spacer(minLength: SpacingTheme.compact)
                Text(tools.isProximityNear ? L10n.Tools.proximityNear : L10n.Tools.proximityFar)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(proximityColor)
            }
            .padding(.horizontal, SpacingTheme.standard)
            .padding(.vertical, SpacingTheme.compact)
            .background(proximityColor.opacity(0.12))
            .clipShape(Capsule())
            .accessibilityElement(children: .combine)
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Touch Digitizer Canvas
    @ViewBuilder
    private var touchDigitizerCanvas: some View {
        let coordText: String? = {
            guard let last = touchHistory.last, last.x.isFinite, last.y.isFinite else { return nil }
            return String(format: "X:%.0f Y:%.0f", last.x, last.y)
        }()

        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            let headerLayout = dynamicTypeSize.isAccessibilitySize
                ? AnyLayout(VStackLayout(alignment: .leading, spacing: SpacingTheme.compact))
                : AnyLayout(HStackLayout(alignment: .center, spacing: SpacingTheme.standard))

            headerLayout {
                BentoSectionHeader(
                    title: L10n.Tools.touchGrid,
                    icon: "hand.draw.fill",
                    subtitle: L10n.Tools.touchGridSub
                )

                if !dynamicTypeSize.isAccessibilitySize {
                    Spacer(minLength: 0)
                }

                HStack(spacing: SpacingTheme.standard) {
                    if let coordText {
                        Text(coordText)
                            .font(Typography.badgeTagMono)
                            .monospacedDigit()
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    }

                    Button {
                        touchHistory.removeAll()
                        Haptics.tick()
                    } label: {
                        Text(L10n.Tools.clearCanvas)
                            .font(Typography.badgeTagMono)
                            .foregroundStyle(accentFg)
                            .padding(.horizontal, SpacingTheme.row)
                            .frame(minWidth: LayoutTheme.minTapTarget, minHeight: LayoutTheme.minTapTarget)
                            .background(Theme.chipBackground(for: colorScheme))
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(Theme.chipBorder(for: colorScheme), lineWidth: 0.6)
                            )
                            .contentShape(Capsule())
                    }
                    .buttonStyle(BentoCardButtonStyle())
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
                    context.fill(circle, with: .color(accentFg.opacity(0.75)))
                }
            }
            .frame(height: 180)
            .background(Theme.tileBackground(for: colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
            )
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let loc = value.location
                        guard loc.x.isFinite, loc.y.isFinite else { return }
                        touchHistory.append(loc)
                        if touchHistory.count > 300 {
                            touchHistory.removeFirst()
                        }
                    }
            )
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(L10n.Tools.touchGrid)
            .accessibilityValue(coordText ?? L10n.Tools.touchTrajectoryTip)

            Text(L10n.Tools.touchTrajectoryTip)
                .font(Typography.badgeTag)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                .fixedSize(horizontal: false, vertical: true)
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Fullscreen Color Cover
    @ViewBuilder
    private var fullscreenColorCover: some View {
        let activeFill = testColors.indices.contains(colorIndex) ? testColors[colorIndex] : .black
        let overlayFg = Theme.contrastingForeground(for: activeFill)
        let scrimBg = overlayFg == .white ? Color.black.opacity(0.45) : Color.white.opacity(0.65)

        ZStack {
            activeFill.ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Button {
                        Haptics.selection()
                        isFullscreenColorActive = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(Typography.title1)
                            .foregroundStyle(overlayFg)
                            .frame(minWidth: LayoutTheme.minTapTarget, minHeight: LayoutTheme.minTapTarget)
                            .background(scrimBg)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(overlayFg.opacity(0.25), lineWidth: 0.8)
                            )
                            .contentShape(Circle())
                    }
                    .buttonStyle(BentoCardButtonStyle())
                    .accessibilityLabel(L10n.Common.close)
                    .padding(SpacingTheme.cardStack)
                }

                Spacer()

                HStack(spacing: SpacingTheme.standard) {
                    Text(L10n.Tools.screenColorTitle(index: colorIndex))
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(overlayFg)
                        .padding(.horizontal, SpacingTheme.standard)
                        .padding(.vertical, SpacingTheme.tight)
                        .background(scrimBg)
                        .clipShape(Capsule())

                    Spacer()

                    Text(L10n.Tools.tapToExitFullscreen)
                        .font(Typography.badgeTag)
                        .foregroundStyle(overlayFg)
                        .padding(.horizontal, SpacingTheme.standard)
                        .padding(.vertical, SpacingTheme.tight)
                        .background(scrimBg)
                        .clipShape(Capsule())
                }
                .padding(SpacingTheme.cardStack)
            }
        }
        .onTapGesture(count: 2) {
            Haptics.selection()
            isFullscreenColorActive = false
        }
        .onTapGesture(count: 1) {
            colorIndex = (colorIndex + 1) % testColors.count
            Haptics.tick()
        }
        .accessibilityAction(.escape) {
            Haptics.selection()
            isFullscreenColorActive = false
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ScreenQualityDetailView()
    }
}
