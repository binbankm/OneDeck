//
//  CompassDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  3D electronic compass and magnetic heading workspace.
//

import SwiftUI

struct CompassDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared
    @State private var displayHeading: Double = 0.0

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        GeometryReader { geo in
            let dialSize = max(150, min(250, geo.size.width - 64, geo.size.height * 0.44))

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpacingTheme.cardStack) {
                    if !tools.isHeadingHardwareAvailable {
                        ToolNoticeBanner(
                            icon: "exclamationmark.triangle.fill",
                            message: L10n.Tools.headingHardwareUnavailable
                        )
                    } else if tools.isCompassLocationDenied {
                        ToolPermissionDeniedBanner(
                            icon: "location.slash.fill",
                            message: L10n.Tools.locationPermissionDenied,
                            onOpenSettings: tools.openAppSettings
                        )
                    }

                    // Top Degree & Direction Readout
                    topHeadingHero

                    Spacer(minLength: 0)

                    // Center Rotating Compass Rose
                    compassRoseDial(size: dialSize)

                    Spacer(minLength: 0)

                    // Bottom Geographic Coordinates HUD
                    geographicLocationCard
                }
                .frame(maxWidth: LayoutTheme.maxContentWidth, minHeight: geo.size.height)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.rowStandard)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        }
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.compass)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            let safeHeading = tools.compass.trueHeading.isFinite ? tools.compass.trueHeading : 0.0
            displayHeading = safeHeading
            tools.enterDetailView(tool: .compass)
            tools.startCompass(enableGpsLocation: true)
        }
        .onChange(of: tools.compass.trueHeading) { _, newValue in
            guard newValue.isFinite else { return }
            var delta = (newValue - displayHeading).truncatingRemainder(dividingBy: 360.0)
            if delta > 180.0 {
                delta -= 360.0
            } else if delta < -180.0 {
                delta += 360.0
            }
            displayHeading += delta
        }
        .onDisappear {
            tools.stopCompass()
            tools.leaveDetailView()
        }
    }

    // MARK: - Top Heading Hero
    @ViewBuilder
    private var topHeadingHero: some View {
        let safeTrueHeading = tools.compass.trueHeading.isFinite ? tools.compass.trueHeading : 0.0
        let safeMagHeading = tools.compass.magneticHeading.isFinite ? tools.compass.magneticHeading : 0.0
        let safeAccuracy = tools.compass.headingAccuracy.isFinite ? tools.compass.headingAccuracy : 0.0
        let trueDegText = String(format: "%.0f°", safeTrueHeading)
        let magHeadingText = String(format: "%@: %.1f°", L10n.Tools.magneticHeading, safeMagHeading)

        VStack(spacing: SpacingTheme.micro) {
            HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.tight) {
                Text(trueDegText)
                    .font(Typography.displayHero)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .foregroundStyle(accentFg)

                Text(tools.compass.cardinalDirection)
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            let metaLayout = dynamicTypeSize.isAccessibilitySize
                ? AnyLayout(VStackLayout(spacing: SpacingTheme.tight))
                : AnyLayout(HStackLayout(spacing: SpacingTheme.standard))

            metaLayout {
                Text(magHeadingText)
                    .font(Typography.badgeTagMono)
                    .monospacedDigit()
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))

                if safeAccuracy > 0 {
                    Text(String(format: "±%.0f°", safeAccuracy))
                        .font(Typography.badgeTagMono)
                        .monospacedDigit()
                        .foregroundStyle(safeAccuracy < 15 ? Theme.readableGreen(for: colorScheme) : Theme.readableOrange(for: colorScheme))
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Tools.trueNorth)
        .accessibilityValue("\(trueDegText) \(tools.compass.cardinalDirection), \(magHeadingText)")
    }

    // MARK: - Compass Rose Dial
    @ViewBuilder
    private func compassRoseDial(size: CGFloat) -> some View {
        let redAccent = Theme.readableRed(for: colorScheme)
        let safeTrueHeading = tools.compass.trueHeading.isFinite ? tools.compass.trueHeading : 0.0

        ZStack {
            // Static Outer Compass Rim
            Circle()
                .strokeBorder(Theme.tileBorder(for: colorScheme), lineWidth: 2)
                .frame(width: size, height: size)
                .background(Circle().fill(Theme.tileBackground(for: colorScheme)))

            // Fixed Top Heading Lubber Line (Triangle pointing down)
            Image(systemName: "triangle.fill")
                .font(IconTheme.badgeInline)
                .foregroundStyle(redAccent)
                .rotationEffect(.degrees(180))
                .offset(y: -(size / 2) + 12)

            // Dynamic Rotating Compass Rose (rotates by -heading)
            ZStack {
                // Graduation Ticks (every 30 degrees)
                ForEach(0 ..< 12, id: \.self) { i in
                    let angle = Double(i * 30)
                    Rectangle()
                        .fill(angle == 0 ? redAccent : Theme.textTertiary(for: colorScheme))
                        .frame(width: angle == 0 ? 2 : 1, height: (i % 3 == 0) ? 14 : 8)
                        .offset(y: -(size / 2) + 12)
                        .rotationEffect(.degrees(angle))
                }

                // Cardinal Points (N, E, S, W)
                cardinalLabel("N", angle: 0, color: redAccent, size: size)
                cardinalLabel("E", angle: 90, color: Theme.textPrimary(for: colorScheme), size: size)
                cardinalLabel("S", angle: 180, color: Theme.textPrimary(for: colorScheme), size: size)
                cardinalLabel("W", angle: 270, color: Theme.textPrimary(for: colorScheme), size: size)

                // Center Reticle
                Circle()
                    .stroke(accentFg.opacity(0.4), lineWidth: 1)
                    .frame(width: 44, height: 44)
                Circle()
                    .fill(accentFg)
                    .frame(width: 6, height: 6)
            }
            .rotationEffect(.degrees(-displayHeading))
            .animation(.easeOut(duration: 0.15), value: displayHeading)
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.Tools.compass)
        .accessibilityValue("\(Int(safeTrueHeading))° \(tools.compass.cardinalDirection)")
    }

    @ViewBuilder
    private func cardinalLabel(_ text: String, angle: Double, color: Color, size: CGFloat) -> some View {
        Text(text)
            .font(Typography.badgeTagMono)
            .foregroundStyle(color)
            .offset(y: -(size / 2) + 28)
            .rotationEffect(.degrees(angle))
    }

    // MARK: - Geographic Location Card
    @ViewBuilder
    private var geographicLocationCard: some View {
        let safeLat = tools.compass.latitude.isFinite ? tools.compass.latitude : 0.0
        let safeLon = tools.compass.longitude.isFinite ? tools.compass.longitude : 0.0
        let safeAlt = tools.compass.altitudeMeters.isFinite ? tools.compass.altitudeMeters : 0.0
        let hasFix = safeLat != 0.0 || safeLon != 0.0
        let coordText: String = {
            guard hasFix else { return L10n.Tools.standby }
            let latDir = safeLat >= 0 ? "N" : "S"
            let lonDir = safeLon >= 0 ? "E" : "W"
            return String(format: "%.4f° %@  %.4f° %@", abs(safeLat), latDir, abs(safeLon), lonDir)
        }()
        let elevText = String(format: "%.0f m MSL", safeAlt)

        Group {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.row) {
                    VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                        Text(L10n.Tools.gpsPosition)
                            .font(Typography.badgeTagMono)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))

                        Text(coordText)
                            .font(Typography.captionMono)
                            .foregroundStyle(hasFix ? Theme.textPrimary(for: colorScheme) : Theme.textSecondary(for: colorScheme))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    BentoHairlineDivider()

                    VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                        Text(L10n.Tools.elevation)
                            .font(Typography.badgeTagMono)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))

                        Text(elevText)
                            .font(Typography.captionMono)
                            .foregroundStyle(accentFg)
                    }
                }
            } else {
                HStack(spacing: SpacingTheme.standard) {
                    VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                        Text(L10n.Tools.gpsPosition)
                            .font(Typography.badgeTagMono)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))

                        Text(coordText)
                            .font(Typography.captionMono)
                            .monospacedDigit()
                            .foregroundStyle(hasFix ? Theme.textPrimary(for: colorScheme) : Theme.textSecondary(for: colorScheme))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }

                    Spacer(minLength: SpacingTheme.compact)

                    VStack(alignment: .trailing, spacing: SpacingTheme.micro) {
                        Text(L10n.Tools.elevation)
                            .font(Typography.badgeTagMono)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))

                        Text(elevText)
                            .font(Typography.captionMono)
                            .monospacedDigit()
                            .foregroundStyle(accentFg)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(SpacingTheme.rowStandard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(L10n.Tools.gpsPosition), \(L10n.Tools.elevation)")
        .accessibilityValue("\(coordText), \(elevText)")
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        CompassDetailView()
    }
}
