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
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared
    @State private var displayHeading: Double = 0.0

    // MARK: - Body
    var body: some View {
        GeometryReader { geo in
            let dialSize = max(150, min(250, geo.size.width - 64, geo.size.height * 0.44))

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpacingTheme.cardStack) {
                    if !tools.isHeadingHardwareAvailable {
                        hardwareUnavailableBanner
                    } else if tools.isCompassLocationDenied {
                        locationDeniedBanner
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
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.rowStandard)
                .frame(maxWidth: .infinity, minHeight: geo.size.height)
            }
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

    @ViewBuilder
    private var hardwareUnavailableBanner: some View {
        HStack(spacing: SpacingTheme.tight) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(Color.orange)
            Text(L10n.Tools.headingHardwareUnavailable)
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

    @ViewBuilder
    private var locationDeniedBanner: some View {
        VStack(spacing: SpacingTheme.compact) {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: "location.slash.fill")
                    .foregroundStyle(Color.orange)
                Text(L10n.Tools.locationPermissionDenied)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .multilineTextAlignment(.leading)
            }

            Button {
                tools.openAppSettings()
            } label: {
                Text(L10n.Tools.openSettings)
                    .font(Typography.captionBold)
                    .padding(.horizontal, SpacingTheme.standard)
                    .padding(.vertical, SpacingTheme.tight)
                    .background(Color.orange)
                    .foregroundStyle(Color.white)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
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

    // MARK: - Top Heading Hero
    @ViewBuilder
    private var topHeadingHero: some View {
        let safeTrueHeading = tools.compass.trueHeading.isFinite ? tools.compass.trueHeading : 0.0
        let safeMagHeading = tools.compass.magneticHeading.isFinite ? tools.compass.magneticHeading : 0.0
        let safeAccuracy = tools.compass.headingAccuracy.isFinite ? tools.compass.headingAccuracy : 0.0

        VStack(spacing: SpacingTheme.micro) {
            HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.tight) {
                Text(String(format: "%.0f°", safeTrueHeading))
                    .font(Typography.displayHero)
                    .foregroundStyle(appState.accentColor)

                Text(tools.compass.cardinalDirection)
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            HStack(spacing: SpacingTheme.standard) {
                Text(String(format: "%@: %.1f°", L10n.Tools.magneticHeading, safeMagHeading))
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))

                if safeAccuracy > 0 {
                    Text(String(format: "±%.0f°", safeAccuracy))
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(safeAccuracy < 15 ? Color.green : Color.orange)
                }
            }
        }
    }

    // MARK: - Compass Rose Dial
    @ViewBuilder
    private func compassRoseDial(size: CGFloat) -> some View {
        ZStack {
            // Static Outer Compass Rim
            Circle()
                .strokeBorder(Theme.cardBorder(for: colorScheme), lineWidth: 2)
                .frame(width: size, height: size)
                .background(Circle().fill(Theme.cardBackground(for: colorScheme).opacity(0.4)))

            // Fixed Top Heading Lubber Line (Triangle pointing down)
            Image(systemName: "triangle.fill")
                .font(IconTheme.badgeInline)
                .foregroundStyle(Color.red)
                .rotationEffect(.degrees(180))
                .offset(y: -(size / 2) + 12)

            // Dynamic Rotating Compass Rose (rotates by -heading)
            ZStack {
                // Graduation Ticks (every 30 degrees)
                ForEach(0 ..< 12) { i in
                    let angle = Double(i * 30)
                    Rectangle()
                        .fill(angle == 0 ? Color.red : Theme.textTertiary(for: colorScheme))
                        .frame(width: angle == 0 ? 2 : 1, height: (i % 3 == 0) ? 14 : 8)
                        .offset(y: -(size / 2) + 12)
                        .rotationEffect(.degrees(angle))
                }

                // Cardinal Points (N, E, S, W)
                cardinalLabel("N", angle: 0, color: Color.red, size: size)
                cardinalLabel("E", angle: 90, color: Theme.textPrimary(for: colorScheme), size: size)
                cardinalLabel("S", angle: 180, color: Theme.textPrimary(for: colorScheme), size: size)
                cardinalLabel("W", angle: 270, color: Theme.textPrimary(for: colorScheme), size: size)

                // Center Reticle
                Circle()
                    .stroke(appState.accentColor.opacity(0.4), lineWidth: 1)
                    .frame(width: 44, height: 44)
                Circle()
                    .fill(appState.accentColor)
                    .frame(width: 6, height: 6)
            }
            .rotationEffect(.degrees(-displayHeading))
            .animation(.easeOut(duration: 0.15), value: displayHeading)
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.Tools.compass)
        .accessibilityValue("\(Int(tools.compass.trueHeading.isFinite ? tools.compass.trueHeading : 0.0))° \(tools.compass.cardinalDirection)")
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

        HStack(spacing: SpacingTheme.standard) {
            VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                Text(L10n.Tools.gpsPosition)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))

                if safeLat != 0.0 || safeLon != 0.0 {
                    let latDir = safeLat >= 0 ? "N" : "S"
                    let lonDir = safeLon >= 0 ? "E" : "W"
                    Text(String(format: "%.4f° %@  %.4f° %@", abs(safeLat), latDir, abs(safeLon), lonDir))
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                } else {
                    Text(L10n.Tools.standby)
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: SpacingTheme.micro) {
                Text(L10n.Tools.elevation)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))

                Text(String(format: "%.0f m MSL", safeAlt))
                    .font(Typography.captionMono)
                    .foregroundStyle(appState.accentColor)
            }
        }
        .padding(SpacingTheme.rowStandard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        CompassDetailView()
    }
}
