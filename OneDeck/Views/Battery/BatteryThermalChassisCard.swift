//
//  BatteryThermalChassisCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Hardware thermal heatmap model and chassis blueprint card.
//

import SwiftUI

// MARK: - Main Thermal Chassis Card
struct BatteryThermalChassisCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var battery = BatteryViewModel.shared
    @Bindable private var system = SystemViewModel.shared

    // MARK: - State
    @State private var selectedZone: ThermalZone = .soc
    @State private var viewMode: ThermalViewMode = .flir
    @State private var isBreathing: Bool = false

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            // MARK: - 1. Card Header Row & Mode Toggle
            HStack(alignment: .center) {
                OverviewSectionHeader(title: L10n.Battery.thermalChassisTitle, icon: "thermometer.sun.fill")

                Spacer()

                // View Mode Segmented Pill Switcher (FLIR vs X-Ray)
                HStack(spacing: SpacingTheme.micro) {
                    ForEach(ThermalViewMode.allCases) { mode in
                        Button {
                            Haptics.selection()
                            withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                                viewMode = mode
                            }
                        } label: {
                            HStack(spacing: SpacingTheme.tight) {
                                Image(systemName: mode.icon)
                                    .font(IconTheme.badgeInline)
                                Text(mode.title)
                                    .font(Typography.badgeTag)
                            }
                            .padding(.horizontal, SpacingTheme.standard)
                            .padding(.vertical, SpacingTheme.micro)
                            .background(viewMode == mode ? appState.accentColor.opacity(0.18) : Color.clear)
                            .foregroundStyle(viewMode == mode ? appState.accentColor : Theme.textSecondary(for: colorScheme))
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(SpacingTheme.micro)
                .background(colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.04))
                .clipShape(Capsule())
            }

            // MARK: - 2. Professional Thermal Spectrum Scale Bar
            thermalScaleBar

            // MARK: - 3. Dual-Deck: Phone Thermal Heatmap (Left) + Inspector (Right)
            HStack(alignment: .top, spacing: SpacingTheme.rowStandard) {
                // Left: Industrial FLIR Chassis Viewport (118pt x 218pt)
                phoneThermalChassis
                    .frame(width: 118, height: 218)

                // Right: 4-Row Dedicated Full-Width Zone List & Inspector (100% Zero Truncation)
                VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                    // 4 Dedicated Full-Width Zone Rows
                    VStack(spacing: SpacingTheme.tight) {
                        ForEach(ThermalZone.allCases) { zone in
                            zoneFullWidthRow(zone)
                        }
                    }

                    // Active Zone Concise Engineering Note (pinned to match 218pt viewport)
                    activeZoneNote
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 218)
            }
        }
        .bentoCard(accent: thermalColor(for: temperature(of: selectedZone)))
        .onAppear {
            isBreathing = true
        }
    }

    // MARK: - 2. Thermal Spectrum Scale Bar with MAX / MIN Indicators
    private var thermalScaleBar: some View {
        let isDark = (colorScheme == .dark)
        let minC = thermalColor(for: minTemperature)
        let maxC = thermalColor(for: maxTemperature)

        return HStack(spacing: SpacingTheme.compact) {
            // Min Reading Tag
            HStack(spacing: SpacingTheme.tight) {
                Circle().fill(minC).frame(width: 5, height: 5)
                Text("\(L10n.Battery.minSpot) \(String(format: "%.1f", minTemperature))°C")
                    .font(Typography.microAxis)
                    .foregroundStyle(minC)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
            }

            // Smooth Multi-Stop False Color Thermal Gradient Track
            Capsule()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Color(red: 0.05, green: 0.12, blue: 0.28), location: 0.00),
                            .init(color: Color(red: 0.00, green: 0.82, blue: 0.88), location: 0.20),
                            .init(color: Color(red: 0.15, green: 0.85, blue: 0.40), location: 0.45),
                            .init(color: Color(red: 0.98, green: 0.65, blue: 0.05), location: 0.70),
                            .init(color: Color(red: 1.00, green: 0.25, blue: 0.20), location: 0.88),
                            .init(color: Color(red: 0.75, green: 0.06, blue: 0.14), location: 1.00)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 4)
                .overlay(
                    Capsule()
                        .stroke(isDark ? Color.white.opacity(0.15) : Color.black.opacity(0.12), lineWidth: 0.5)
                )

            // Max Reading Tag
            HStack(spacing: SpacingTheme.tight) {
                Circle().fill(maxC).frame(width: 5, height: 5)
                Text("\(L10n.Battery.maxSpot) \(String(format: "%.1f", maxTemperature))°C")
                    .font(Typography.microAxis)
                    .foregroundStyle(maxC)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
        .padding(.horizontal, SpacingTheme.micro)
    }

    // MARK: - 3. Phone Thermal Chassis Viewport (Follows System Appearance & Real Device)
    private var phoneThermalChassis: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Layer 1: Chassis Background (Adapts dynamically to system Light / Dark mode)
                chassisChamberBackground(w: w, h: h)

                // Layer 2: FLIR Infrared Heat Cloud Dispersion (In FLIR Mode)
                if viewMode == .flir {
                    flirThermalFieldLayer(w: w, h: h)
                }

                // Layer 3: Hardware X-Ray Blueprint Overlay (Camera, PCB, L-Battery, Coil)
                hardwareXRayBlueprint(w: w, h: h)

                // Layer 4: Thermal Isotherms
                if viewMode == .flir {
                    thermalIsothermsLayer(w: w, h: h)
                }

                // Layer 5: FLIR Target Tracking Reticles (MAX spot, MIN spot, & Active Zone Selection)
                flirTargetTrackingLayer(w: w, h: h)

                // Layer 6: Engineering HUD Optics & Parameters
                chassisHudOverlay(w: w, h: h)

                // Layer 7: Screen Cutout (Dynamic Island for 14 Pro/15/16, Notch for X/XS/11/12/13/14)
                deviceScreenCutout(w: w, h: h)
            }
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.card, style: .continuous))
        }
    }

    // MARK: - Layer 1: Adaptive Chassis Chamber Background
    @ViewBuilder
    private func chassisChamberBackground(w: CGFloat, h: CGFloat) -> some View {
        let isDark = (colorScheme == .dark)

        RoundedRectangle(cornerRadius: CornerRadiusTheme.card, style: .continuous)
            .fill(isDark ? Color(red: 0.04, green: 0.07, blue: 0.12) : Color(hex: "#ECEEF2"))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.card, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: isDark ? [
                                Color.white.opacity(0.20),
                                Color.white.opacity(0.06),
                                Color.black.opacity(0.4)
                            ] : [
                                Color.black.opacity(0.20),
                                Color.black.opacity(0.08),
                                Color.white.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.2
                    )
            )
            .shadow(color: Color.black.opacity(isDark ? 0.45 : 0.08), radius: 6, x: 0, y: 3)
    }

    // MARK: - Layer 7: Screen Cutout (Follows Real Device: Dynamic Island vs Notch)
    @ViewBuilder
    private func deviceScreenCutout(w: CGFloat, h: CGFloat) -> some View {
        VStack {
            if hasDynamicIsland {
                // Sleek Pill Cutout for Dynamic Island
                Capsule()
                    .fill(colorScheme == .dark ? Color.black : Color(white: 0.15))
                    .frame(width: 28, height: 7)
                    .padding(.top, SpacingTheme.tight)
            } else {
                // Classic Earpiece Speaker Notch Cutout
                HStack(spacing: SpacingTheme.micro) {
                    Capsule()
                        .fill(colorScheme == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.25))
                        .frame(width: 22, height: 3)
                }
                .padding(.top, SpacingTheme.tight)
            }
            Spacer()
        }
        .allowsHitTesting(false)
    }

    // MARK: - Layer 2: True FLIR Infrared Heat Cloud Field
    @ViewBuilder
    private func flirThermalFieldLayer(w: CGFloat, h: CGFloat) -> some View {
        let socTemp = temperature(of: .soc)
        let batteryTemp = temperature(of: .battery)
        let pmicTemp = temperature(of: .pmic)
        let wirelessTemp = temperature(of: .wireless)

        let socColor = thermalColor(for: socTemp)
        let bColor = thermalColor(for: batteryTemp)
        let pColor = thermalColor(for: pmicTemp)
        let wColor = thermalColor(for: wirelessTemp)
        let isDark = (colorScheme == .dark)

        ZStack {
            // Ambient Thermal Heat Baseline
            RadialGradient(
                colors: isDark ? [
                    Color(red: 0.05, green: 0.15, blue: 0.32).opacity(0.85),
                    Color(red: 0.02, green: 0.05, blue: 0.12).opacity(0.95)
                ] : [
                    Color(red: 0.12, green: 0.28, blue: 0.48).opacity(0.25),
                    Color(white: 0.90).opacity(0.40)
                ],
                center: .center,
                startRadius: 10,
                endRadius: h * 0.55
            )

            // Battery Thermal Dispersion
            RadialGradient(
                colors: [
                    bColor.opacity(isDark ? 0.70 : 0.55),
                    bColor.opacity(isDark ? 0.35 : 0.20),
                    Color.clear
                ],
                center: .center,
                startRadius: 5,
                endRadius: w * 0.48
            )
            .frame(width: w * 0.75, height: h * 0.65)
            .offset(x: -w * 0.15, y: -h * 0.03)
            .blur(radius: 8)

            // SoC Hotspot Thermal Radiation
            RadialGradient(
                stops: [
                    .init(color: Color.white.opacity(0.85), location: 0.0),
                    .init(color: socColor.opacity(isDark ? 0.85 : 0.75), location: 0.25),
                    .init(color: socColor.opacity(isDark ? 0.45 : 0.30), location: 0.55),
                    .init(color: Color.clear, location: 1.0)
                ],
                center: .center,
                startRadius: 2,
                endRadius: w * 0.40
            )
            .frame(width: w * 0.75, height: h * 0.48)
            .offset(x: w * 0.23, y: -h * 0.18)
            .blur(radius: 7)

            // Wireless Induction Coil Thermal Center
            RadialGradient(
                colors: [
                    wColor.opacity(isDark ? 0.50 : 0.35),
                    wColor.opacity(isDark ? 0.18 : 0.10),
                    Color.clear
                ],
                center: .center,
                startRadius: 6,
                endRadius: w * 0.28
            )
            .frame(width: w * 0.55, height: w * 0.55)
            .offset(x: 0, y: -h * 0.02)
            .blur(radius: 6)

            // PMIC & Charging Dock Thermal Plume
            RadialGradient(
                colors: [
                    pColor.opacity(isDark ? 0.75 : 0.60),
                    pColor.opacity(isDark ? 0.30 : 0.18),
                    Color.clear
                ],
                center: .center,
                startRadius: 3,
                endRadius: w * 0.42
            )
            .frame(width: w * 0.85, height: h * 0.28)
            .offset(x: 0, y: h * 0.35)
            .blur(radius: 7)
        }
        .allowsHitTesting(false)
    }

    // MARK: - Layer 3: Hardware X-Ray Blueprint (Modularized to Prevent Type-Checker Stalls)
    @ViewBuilder
    private func hardwareXRayBlueprint(w: CGFloat, h: CGFloat) -> some View {
        let isXRay = (viewMode == .xray)
        let isDark = (colorScheme == .dark)
        let strokeAlpha = isXRay ? 0.75 : 0.35
        let fillAlpha = isXRay ? (isDark ? 0.14 : 0.08) : (isDark ? 0.05 : 0.03)

        cameraModuleBlueprint(w: w, h: h, isDark: isDark, fillAlpha: fillAlpha, strokeAlpha: strokeAlpha)
        batteryPackBlueprint(w: w, h: h, isDark: isDark, fillAlpha: fillAlpha, isXRay: isXRay)
        wirelessCoilBlueprint(w: w, h: h, isDark: isDark, strokeAlpha: strokeAlpha)
        socMotherboardBlueprint(w: w, h: h, isDark: isDark, fillAlpha: fillAlpha, isXRay: isXRay)
        pmicDockBlueprint(w: w, h: h, isDark: isDark, fillAlpha: fillAlpha, isXRay: isXRay)
    }

    @ViewBuilder
    private func cameraModuleBlueprint(w: CGFloat, h: CGFloat, isDark: Bool, fillAlpha: Double, strokeAlpha: Double) -> some View {
        let baseColor: Color = isDark ? Color.white : Color(hex: "#1E1E24")
        ZStack {
            RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous)
                .fill(baseColor.opacity(fillAlpha))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous)
                        .stroke(baseColor.opacity(strokeAlpha * 0.6), lineWidth: 0.8)
                )
            if isProModel {
                VStack(spacing: SpacingTheme.micro) {
                    HStack(spacing: SpacingTheme.tight) {
                        Circle().stroke(baseColor.opacity(strokeAlpha * 0.8), lineWidth: 0.8).frame(width: 7, height: 7)
                        Circle().stroke(baseColor.opacity(strokeAlpha * 0.8), lineWidth: 0.8).frame(width: 7, height: 7)
                    }
                    Circle().stroke(baseColor.opacity(strokeAlpha * 0.8), lineWidth: 0.8).frame(width: 7, height: 7)
                }
            } else {
                VStack(spacing: SpacingTheme.tight) {
                    Circle().stroke(baseColor.opacity(strokeAlpha * 0.8), lineWidth: 0.8).frame(width: 8, height: 8)
                    Circle().stroke(baseColor.opacity(strokeAlpha * 0.8), lineWidth: 0.8).frame(width: 8, height: 8)
                }
            }
        }
        .frame(width: w * 0.23, height: h * 0.18)
        .offset(x: -w * 0.24, y: -h * 0.34)
    }

    @ViewBuilder
    private func batteryPackBlueprint(w: CGFloat, h: CGFloat, isDark: Bool, fillAlpha: Double, isXRay: Bool) -> some View {
        let isBatteryActive = (selectedZone == .battery)
        let bColor = thermalColor(for: temperature(of: .battery))
        let defaultFill: Color = isDark ? Color.white.opacity(fillAlpha) : Color.black.opacity(fillAlpha)
        let batteryFill: Color = isBatteryActive ? bColor.opacity(isDark ? 0.20 : 0.12) : defaultFill
        let defaultStroke: Color = isXRay ? (isDark ? Color.cyan.opacity(0.6) : Color(hex: "#0284C7").opacity(0.6)) : bColor.opacity(isDark ? 0.4 : 0.35)
        let batteryStroke: Color = isBatteryActive ? bColor : defaultStroke

        Button {
            selectZone(.battery)
        } label: {
            LShapedBatteryShape()
                .fill(batteryFill)
                .overlay(
                    LShapedBatteryShape()
                        .stroke(batteryStroke, lineWidth: isBatteryActive ? 1.6 : 0.8)
                )
                .frame(width: w * 0.74, height: h * 0.63)
                .offset(x: -w * 0.02, y: -h * 0.03)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func wirelessCoilBlueprint(w: CGFloat, h: CGFloat, isDark: Bool, strokeAlpha: Double) -> some View {
        let isWirelessActive = (selectedZone == .wireless)
        let wColor = thermalColor(for: temperature(of: .wireless))
        let defaultOuterColor: Color = isDark ? Color.yellow.opacity(strokeAlpha * 0.8) : Color(hex: "#C25E00").opacity(0.55)
        let defaultInnerColor: Color = isDark ? Color.yellow.opacity(strokeAlpha * 0.5) : Color(hex: "#C25E00").opacity(0.38)
        let outerColor: Color = isWirelessActive ? wColor : defaultOuterColor
        let innerColor: Color = isWirelessActive ? wColor.opacity(0.85) : defaultInnerColor

        Button {
            selectZone(.wireless)
        } label: {
            ZStack {
                Circle()
                    .strokeBorder(
                        outerColor,
                        style: StrokeStyle(lineWidth: isWirelessActive ? 1.5 : 0.9, dash: [3.5, 2.0])
                    )
                Circle()
                    .strokeBorder(
                        innerColor,
                        style: StrokeStyle(lineWidth: 0.8, dash: [2.5, 2.0])
                    )
                    .frame(width: w * 0.28, height: w * 0.28)
            }
            .frame(width: w * 0.44, height: w * 0.44)
            .offset(x: 0, y: -h * 0.02)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func socMotherboardBlueprint(w: CGFloat, h: CGFloat, isDark: Bool, fillAlpha: Double, isXRay: Bool) -> some View {
        let isSocActive = (selectedZone == .soc)
        let sColor = thermalColor(for: temperature(of: .soc))
        let defaultFill: Color = isDark ? Color.white.opacity(fillAlpha) : Color.black.opacity(fillAlpha)
        let socFill: Color = isSocActive ? sColor.opacity(isDark ? 0.24 : 0.14) : defaultFill
        let defaultStroke: Color = isXRay ? (isDark ? Color.orange.opacity(0.7) : Color(hex: "#C25E00").opacity(0.65)) : sColor.opacity(isDark ? 0.5 : 0.4)
        let socStroke: Color = isSocActive ? sColor : defaultStroke

        Button {
            selectZone(.soc)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous)
                    .fill(socFill)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous)
                            .stroke(socStroke, lineWidth: isSocActive ? 1.6 : 0.8)
                    )

                VStack(spacing: SpacingTheme.micro) {
                    Image(systemName: "cpu.fill")
                        .font(IconTheme.tileLeading)
                        .foregroundStyle(isSocActive ? sColor : (isDark ? Color.white.opacity(0.85) : Color(hex: "#1E1E24").opacity(0.75)))

                    Text(chipMarketingShort)
                        .font(Typography.microAxis)
                        .foregroundStyle(isDark ? Color.white.opacity(0.85) : Color(hex: "#1E1E24").opacity(0.85))
                        .lineLimit(1)
                }
            }
            .frame(width: w * 0.36, height: h * 0.29)
            .offset(x: w * 0.24, y: -h * 0.18)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func pmicDockBlueprint(w: CGFloat, h: CGFloat, isDark: Bool, fillAlpha: Double, isXRay: Bool) -> some View {
        let isPmicActive = (selectedZone == .pmic)
        let pColor = thermalColor(for: temperature(of: .pmic))
        let defaultFill: Color = isDark ? Color.white.opacity(fillAlpha) : Color.black.opacity(fillAlpha)
        let pmicFill: Color = isPmicActive ? pColor.opacity(isDark ? 0.22 : 0.14) : defaultFill
        let defaultStroke: Color = isXRay ? (isDark ? Color.cyan.opacity(0.6) : Color(hex: "#0284C7").opacity(0.6)) : pColor.opacity(isDark ? 0.5 : 0.4)
        let pmicStroke: Color = isPmicActive ? pColor : defaultStroke

        Button {
            selectZone(.pmic)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous)
                    .fill(pmicFill)
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous)
                            .stroke(pmicStroke, lineWidth: isPmicActive ? 1.6 : 0.8)
                    )

                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "bolt.fill")
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(isPmicActive ? pColor : (isDark ? Color.white.opacity(0.8) : Color(hex: "#1E1E24").opacity(0.7)))
                    Capsule()
                        .fill((isDark ? Color.white : Color(hex: "#1E1E24")).opacity(0.4))
                        .frame(width: 14, height: 3)
                }
            }
            .frame(width: w * 0.74, height: h * 0.14)
            .offset(x: 0, y: h * 0.36)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Layer 4: Thermal Isotherms
    @ViewBuilder
    private func thermalIsothermsLayer(w: CGFloat, h: CGFloat) -> some View {
        let isDark = (colorScheme == .dark)
        let socX = w * 0.24
        let socY = -h * 0.18
        let sColor = thermalColor(for: temperature(of: .soc))

        ZStack {
            Circle()
                .stroke(sColor.opacity(isDark ? 0.35 : 0.40), style: StrokeStyle(lineWidth: 0.8, dash: [4, 3]))
                .frame(width: w * 0.44, height: w * 0.44)
                .offset(x: socX, y: socY)

            Circle()
                .stroke(sColor.opacity(isDark ? 0.20 : 0.25), style: StrokeStyle(lineWidth: 0.6, dash: [5, 4]))
                .frame(width: w * 0.62, height: w * 0.62)
                .offset(x: socX, y: socY)
        }
        .allowsHitTesting(false)
    }

    // MARK: - Layer 5: FLIR Target Tracking Reticles (Non-Colliding, Clean Positioning)
    @ViewBuilder
    private func flirTargetTrackingLayer(w: CGFloat, h: CGFloat) -> some View {
        let isDark = (colorScheme == .dark)

        // MAX Hotspot Reticle
        let (maxX, maxY) = pinCoordinates(for: maxZone, w: w, h: h)
        let maxColor = thermalColor(for: maxTemperature)

        flirCrosshairShape(color: maxColor, label: L10n.Battery.maxSpot, isPulse: true)
            .offset(x: maxX, y: maxY - 16)
            .allowsHitTesting(false)

        // MIN Coldspot Reticle
        let (minX, minY) = pinCoordinates(for: minZone, w: w, h: h)
        let minColor = thermalColor(for: minTemperature)

        flirCrosshairShape(color: minColor, label: L10n.Battery.minSpot, isPulse: false)
            .offset(x: minX, y: minY + 16)
            .allowsHitTesting(false)

        // Active Zone Selection Pulse Ring
        let (selX, selY) = pinCoordinates(for: selectedZone, w: w, h: h)
        let selColor = thermalColor(for: temperature(of: selectedZone))
        let centerPipColor = isDark ? Color.white : Theme.textPrimary(for: colorScheme)

        ZStack {
            Circle()
                .stroke(selColor, lineWidth: 1.6)
                .frame(width: 18, height: 18)
                .scaleEffect(isBreathing ? 1.25 : 0.9)
                .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: isBreathing)

            Circle()
                .fill(centerPipColor)
                .frame(width: 4, height: 4)
                .shadow(color: isDark ? Color.black.opacity(0.6) : Color.white.opacity(0.8), radius: 1)
        }
        .offset(x: selX, y: selY)
        .allowsHitTesting(false)
        .animation(.spring(response: 0.32, dampingFraction: 0.78), value: selectedZone)
    }

    @ViewBuilder
    private func flirCrosshairShape(color: Color, label: String, isPulse: Bool) -> some View {
        let isDark = (colorScheme == .dark)

        HStack(spacing: SpacingTheme.tight) {
            ZStack {
                Rectangle().fill(isDark ? color : Color.white).frame(width: 6, height: 1.2)
                Rectangle().fill(isDark ? color : Color.white).frame(width: 1.2, height: 6)
            }
            .frame(width: 7, height: 7)

            Text(label)
                .font(Typography.microAxis)
                .foregroundStyle(isDark ? color : Color.white)
        }
        .padding(.horizontal, SpacingTheme.compact)
        .padding(.vertical, SpacingTheme.micro)
        .background(
            isDark
                ? Color.black.opacity(0.82)
                : color
        )
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.micro, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.micro, style: .continuous)
                .stroke(isDark ? color.opacity(0.40) : Color.white.opacity(0.40), lineWidth: 0.8)
        )
        .shadow(color: Color.black.opacity(isDark ? 0.35 : 0.18), radius: 2.5, x: 0, y: 1)
    }

    // MARK: - Layer 6: Engineering HUD Optics & Parameters
    @ViewBuilder
    private func chassisHudOverlay(w: CGFloat, h: CGFloat) -> some View {
        let isDark = (colorScheme == .dark)
        let hudColor = isDark ? Color.white : Color(hex: "#1E1E24")

        VStack {
            HStack {
                Text("● IR")
                    .font(Typography.microAxis)
                    .foregroundStyle(isDark ? Color.red.opacity(0.85) : Color(hex: "#DC2626"))
                Spacer()
                Text("ε:0.95")
                    .font(Typography.microAxis)
                    .foregroundStyle(hudColor.opacity(isDark ? 0.45 : 0.65))
            }
            .padding(.horizontal, SpacingTheme.standard)
            .padding(.top, SpacingTheme.compact)

            Spacer()

            HStack {
                Text("FOV 54°")
                    .font(Typography.microAxis)
                    .foregroundStyle(hudColor.opacity(isDark ? 0.35 : 0.55))
                Spacer()
                Text("LIVE")
                    .font(Typography.microAxis)
                    .foregroundStyle(isDark ? Color.green.opacity(0.85) : Color(hex: "#15803D"))
            }
            .padding(.horizontal, SpacingTheme.standard)
            .padding(.bottom, SpacingTheme.compact)
        }
        .allowsHitTesting(false)
    }

    private func pinCoordinates(for zone: ThermalZone, w: CGFloat, h: CGFloat) -> (CGFloat, CGFloat) {
        switch zone {
        case .soc:
            return (w * 0.24, -h * 0.18)
        case .battery:
            return (-w * 0.16, -h * 0.04)
        case .pmic:
            return (0, h * 0.36)
        case .wireless:
            return (0, -h * 0.02)
        }
    }

    // MARK: - Right Column: 4-Row Dedicated Full-Width Zone List (100% Zero Truncation)
    @ViewBuilder
    private func zoneFullWidthRow(_ zone: ThermalZone) -> some View {
        let isSelected: Bool = (selectedZone == zone)
        let temp: Double = temperature(of: zone)
        let color: Color = thermalColor(for: temp)
        let isDark: Bool = (colorScheme == .dark)

        let defaultBg: Color = isDark ? Color.white.opacity(0.04) : Color.black.opacity(0.03)
        let rowBg: Color = isSelected ? color.opacity(isDark ? 0.18 : 0.12) : defaultBg
        let rowStroke: Color = isSelected
            ? color.opacity(isDark ? 0.75 : 0.65)
            : (isDark ? Color.white.opacity(0.04) : Color.black.opacity(0.06))
        let iconColor: Color = isSelected ? color : Theme.textSecondary(for: colorScheme)
        let labelColor: Color = isSelected ? Theme.textPrimary(for: colorScheme) : Theme.textSecondary(for: colorScheme)

        Button {
            selectZone(zone)
        } label: {
            HStack(spacing: SpacingTheme.compact) {
                Image(systemName: zone.icon)
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(iconColor)
                    .frame(width: 14)

                Text(zone.shortLabel)
                    .font(isSelected ? Typography.calloutBold : Typography.calloutLabel)
                    .foregroundStyle(labelColor)
                    .lineLimit(1)

                Spacer(minLength: 4)

                Text(String(format: "%.1f °C", temp))
                    .font(Typography.calloutBold)
                    .monospacedDigit()
                    .lineLimit(1)
                    .foregroundStyle(color)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, SpacingTheme.standard)
            .padding(.vertical, SpacingTheme.compact)
            .background(rowBg)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .stroke(rowStroke, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Right Column: Active Zone Concise Engineering Note
    private var activeZoneNote: some View {
        let temp = temperature(of: selectedZone)
        let color = thermalColor(for: temp)
        let isDark = (colorScheme == .dark)

        return VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            HStack {
                Text(selectedZone.title)
                    .font(Typography.calloutBold)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)

                Spacer()

                Text(temperatureStatusLabel(for: temp))
                    .font(Typography.badgeTag)
                    .padding(.horizontal, SpacingTheme.compact)
                    .padding(.vertical, SpacingTheme.micro)
                    .background(color.opacity(isDark ? 0.16 : 0.12))
                    .foregroundStyle(color)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(color.opacity(isDark ? 0.35 : 0.28), lineWidth: 0.6)
                    )
                    .lineLimit(1)
            }

            Text(selectedZone.tip)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(1.5)

            Spacer(minLength: 0)

            HStack {
                Text(String(format: "%.1f °C", temp))
                    .font(Typography.captionMono)
                    .fontWeight(.bold)
                    .foregroundStyle(color)

                Spacer()

                let delta = max(0.0, temp - minTemperature)
                Text(String(format: "Δ +%.1f °C", delta))
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(SpacingTheme.standard)
        .background(isDark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                .stroke(isDark ? Color.white.opacity(0.05) : Color.black.opacity(0.05), lineWidth: 0.6)
        )
    }

    // MARK: - Actions & Thermal Computations
    private func selectZone(_ zone: ThermalZone) {
        guard selectedZone != zone else { return }
        Haptics.selection()
        withAnimation(.spring(response: 0.30, dampingFraction: 0.78)) {
            selectedZone = zone
        }
    }

    private func temperature(of zone: ThermalZone) -> Double {
        let cellBase = battery.batteryTemperature

        switch zone {
        case .battery:
            return cellBase
        case .soc:
            return system.socTemperature
        case .pmic:
            if let p = battery.hardwarePmicTemp {
                return p
            } else if battery.batteryState == .charging {
                let wattBoost = min(5.5, abs(battery.liveWattage) * 0.32)
                return cellBase + max(1.2, wattBoost)
            } else {
                return max(24.0, cellBase - 1.4)
            }
        case .wireless:
            if let w = battery.hardwareWirelessTemp {
                return w
            } else if battery.batteryState == .charging {
                return cellBase + 0.6
            } else {
                return max(24.0, cellBase - 0.8)
            }
        }
    }

    private var maxZone: ThermalZone {
        ThermalZone.allCases.max(by: { temperature(of: $0) < temperature(of: $1) }) ?? .soc
    }

    private var minZone: ThermalZone {
        ThermalZone.allCases.min(by: { temperature(of: $0) < temperature(of: $1) }) ?? .pmic
    }

    private var maxTemperature: Double {
        temperature(of: maxZone)
    }

    private var minTemperature: Double {
        temperature(of: minZone)
    }

    // MARK: - Adaptive Thermal Color Engine
    /// Computes high-contrast thermal palette colors, fully adapted to Light & Dark appearance.
    private func thermalColor(for temp: Double) -> Color {
        let isDark = (colorScheme == .dark)
        if temp < 30.0 {
            // Cool (< 30°C): Electric Cyan in Dark, Ocean/Sapphire Blue in Light
            return isDark ? Color(red: 0.00, green: 0.85, blue: 0.92) : Color(hex: "#0284C7")
        } else if temp < 35.0 {
            // Normal / Comfortable (30 ~ 35°C): Vivid Emerald in Dark, Forest Green in Light
            return isDark ? Color(red: 0.15, green: 0.85, blue: 0.40) : Color(hex: "#15803D")
        } else if temp < 39.0 {
            // Warm (35 ~ 39°C): Titanium Gold/Amber in Dark, Rich Dark Amber in Light
            return isDark ? Color(red: 1.00, green: 0.70, blue: 0.10) : Color(hex: "#C25E00")
        } else if temp < 43.0 {
            // Hot (39 ~ 43°C): Fiery Orange-Red in Dark, Vivid Crimson in Light
            return isDark ? Color(red: 1.00, green: 0.32, blue: 0.18) : Color(hex: "#DC2626")
        } else {
            // Extreme (>= 43°C): High-Intensity Searing Red in Dark, Deep Burgundy Ruby in Light
            return isDark ? Color(red: 1.00, green: 0.15, blue: 0.30) : Color(hex: "#B91C1C")
        }
    }

    private func temperatureStatusLabel(for temp: Double) -> String {
        if temp < 30.0 {
            return L10n.Battery.thermalStatusCool
        } else if temp < 35.0 {
            return L10n.Battery.thermalStatusNormal
        } else if temp < 39.0 {
            return L10n.Battery.thermalStatusWarm
        } else {
            return L10n.Battery.thermalStatusHot
        }
    }

    // MARK: - Hardware Device Adaptation Helpers
    private var hasDynamicIsland: Bool {
        let id = system.machineIdentifier
        if id.hasPrefix("iPhone15,2") || id.hasPrefix("iPhone15,3") { return true } // 14 Pro
        if id.hasPrefix("iPhone15,4") || id.hasPrefix("iPhone15,5") { return true } // 15
        if id.hasPrefix("iPhone16") || id.hasPrefix("iPhone17") { return true } // 15 Pro, 16 series
        return false
    }

    private var isProModel: Bool {
        let id = system.machineIdentifier
        return id.contains("Pro") || system.marketingName.contains("Pro")
    }

    private var chipMarketingShort: String {
        let clean = system.chipNameClean
            .replacingOccurrences(of: "Apple ", with: "")
            .replacingOccurrences(of: " Bionic", with: "")
        return clean.isEmpty ? "SoC" : clean
    }
}

// MARK: - Authentic L-Shaped iPhone Battery Shape
struct LShapedBatteryShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let corner: CGFloat = 5.0

        let cutX = w * 0.58
        let cutY = h * 0.48

        path.move(to: CGPoint(x: corner, y: 0))
        path.addLine(to: CGPoint(x: cutX - corner, y: 0))
        path.addQuadCurve(to: CGPoint(x: cutX, y: corner), control: CGPoint(x: cutX, y: 0))

        path.addLine(to: CGPoint(x: cutX, y: cutY - corner))
        path.addQuadCurve(to: CGPoint(x: cutX + corner, y: cutY), control: CGPoint(x: cutX, y: cutY))

        path.addLine(to: CGPoint(x: w - corner, y: cutY))
        path.addQuadCurve(to: CGPoint(x: w, y: cutY + corner), control: CGPoint(x: w, y: cutY))

        path.addLine(to: CGPoint(x: w, y: h - corner))
        path.addQuadCurve(to: CGPoint(x: w - corner, y: h), control: CGPoint(x: w, y: h))

        path.addLine(to: CGPoint(x: corner, y: h))
        path.addQuadCurve(to: CGPoint(x: 0, y: h - corner), control: CGPoint(x: 0, y: h))

        path.addLine(to: CGPoint(x: 0, y: corner))
        path.addQuadCurve(to: CGPoint(x: corner, y: 0), control: CGPoint(x: 0, y: 0))

        path.closeSubpath()
        return path
    }
}

// MARK: - Preview
#Preview {
    BatteryThermalChassisCard()
        .padding()
}
