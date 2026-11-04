//
//  CompassDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  3D electronic compass and magnetic heading workspace.
//

import CoreLocation
import SwiftUI

struct CompassDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    private var isHeadingHardwareAvailable: Bool {
        CLLocationManager.headingAvailable()
    }

    private var isLocationDenied: Bool {
        let auth = CLLocationManager().authorizationStatus
        return auth == .denied || auth == .restricted
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: SpacingTheme.cardStack) {
            if !isHeadingHardwareAvailable {
                hardwareUnavailableBanner
            } else if isLocationDenied {
                locationDeniedBanner
            }

            // Top Degree & Direction Readout
            topHeadingHero

            Spacer()

            // Center Rotating Compass Rose
            compassRoseDial(size: 250)

            Spacer()

            // Bottom Geographic Coordinates HUD
            geographicLocationCard
        }
        .padding(.horizontal, SpacingTheme.cardStack)
        .padding(.vertical, SpacingTheme.rowStandard)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.compass)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView(tool: .compass)
            tools.startCompass(enableGpsLocation: true)
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
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text(L10n.Tools.openSettings)
                    .font(Typography.captionBold)
                    .padding(.horizontal, SpacingTheme.standard)
                    .padding(.vertical, SpacingTheme.tight)
                    .background(Color.orange)
                    .foregroundStyle(Color.white)
                    .clipShape(Capsule())
            }
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
        VStack(spacing: SpacingTheme.micro) {
            HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.tight) {
                Text(String(format: "%.0f°", tools.compass.trueHeading))
                    .font(Typography.displayHero)
                    .foregroundStyle(appState.accentColor)

                Text(tools.compass.cardinalDirection)
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            HStack(spacing: SpacingTheme.standard) {
                Text(String(format: "%@: %.1f°", L10n.Tools.magneticHeading, tools.compass.magneticHeading))
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))

                if tools.compass.headingAccuracy > 0 {
                    Text(String(format: "±%.0f°", tools.compass.headingAccuracy))
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(tools.compass.headingAccuracy < 15 ? Color.green : Color.orange)
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
            .rotationEffect(.degrees(-tools.compass.trueHeading))
            .animation(.easeOut(duration: 0.15), value: tools.compass.trueHeading)
        }
        .frame(width: size, height: size)
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
        HStack(spacing: SpacingTheme.standard) {
            VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                Text(L10n.Tools.gpsPosition)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))

                if tools.compass.latitude != 0.0 {
                    Text(String(format: "%.4f° N  %.4f° E", tools.compass.latitude, tools.compass.longitude))
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

                Text(String(format: "%.0f m MSL", tools.compass.altitudeMeters))
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
