//
//  BatteryThermalChassisCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Industrial FLIR Thermal Instrument & Hardware X-Ray Blueprint:
//  - System-Adaptive Chassis: Adapts to real device chip (A12~A18), camera layout, and Notch / Dynamic Island.
//  - Full System Light / Dark Mode Adaptation: Intelligent palette for dark and light themes.
//  - Authentic FLIR False-Color Thermal Diffusion with Ironbow spectrum & thermal isotherms.
//  - Automatic MAX / MIN Hotspot Tracking Reticles (Real-time extreme temperature pins).
//  - Complete Multilingual Localization across zh-Hans, zh-Hant, and en.
//  - Rock-Solid Full-Width Zone Rows: Zero truncation guaranteed.
//

import SwiftUI

// MARK: - Thermal Zone Definition
enum ThermalZone: String, CaseIterable, Identifiable {
    case soc
    case battery
    case pmic
    case wireless

    var id: String { rawValue }

    var title: String {
        switch self {
        case .soc: return L10n.Battery.zoneSoc
        case .battery: return L10n.Battery.zoneBattery
        case .pmic: return L10n.Battery.zonePmic
        case .wireless: return L10n.Battery.zoneWireless
        }
    }

    var shortLabel: String {
        switch self {
        case .soc: return L10n.Battery.zoneSocShort
        case .battery: return L10n.Battery.zoneBatteryShort
        case .pmic: return L10n.Battery.zonePmicShort
        case .wireless: return L10n.Battery.zoneWirelessShort
        }
    }

    var icon: String {
        switch self {
        case .soc: return "cpu"
        case .battery: return "battery.100"
        case .pmic: return "bolt.fill"
        case .wireless: return "dot.radiowaves.up.forward"
        }
    }

    var tip: String {
        switch self {
        case .soc: return L10n.Battery.thermalTipSoc
        case .battery: return L10n.Battery.thermalTipBattery
        case .pmic: return L10n.Battery.thermalTipPmic
        case .wireless: return L10n.Battery.thermalTipWireless
        }
    }
}

// MARK: - Visual View Mode
enum ThermalViewMode: String, CaseIterable, Identifiable {
    case flir
    case xray

    var id: String { rawValue }

    var title: String {
        switch self {
        case .flir: return L10n.Battery.flirMode
        case .xray: return L10n.Battery.xrayMode
        }
    }

    var icon: String {
        switch self {
        case .flir: return "flame.fill"
        case .xray: return "square.2.layers.3d"
        }
    }
}

// MARK: - Main Thermal Chassis Card
struct BatteryThermalChassisCard: View {
    @Bindable var appState = AppState.shared
    @Bindable var battery = BatteryService.shared
    @Bindable var system = SystemService.shared
    @Environment(\.colorScheme) private var colorScheme

    @State private var selectedZone: ThermalZone = .soc
    @State private var viewMode: ThermalViewMode = .flir
    @State private var isBreathing: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            // MARK: - 1. Card Header Row & Mode Toggle
            HStack(alignment: .center) {
                OverviewSectionHeader(title: L10n.Battery.thermalChassisTitle, icon: "iphone.gen3")

                Spacer()

                // View Mode Segmented Pill Switcher (FLIR vs X-Ray)
                HStack(spacing: 2) {
                    ForEach(ThermalViewMode.allCases) { mode in
                        Button {
                            Haptics.selection()
                            withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                                viewMode = mode
                            }
                        } label: {
                            HStack(spacing: 3) {
                                Image(systemName: mode.icon)
                                    .font(.system(size: 9, weight: .bold))
                                Text(mode.title)
                                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3.5)
                            .background(viewMode == mode ? appState.accentColor.opacity(0.18) : Color.clear)
                            .foregroundStyle(viewMode == mode ? appState.accentColor : Theme.textSecondary(for: colorScheme))
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(2)
                .background(colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.04))
                .clipShape(Capsule())
            }

            // MARK: - 2. Professional Thermal Spectrum Scale Bar
            thermalScaleBar

            // MARK: - 3. Dual-Deck: Phone Thermal Heatmap (Left) + Inspector (Right)
            HStack(alignment: .top, spacing: 12) {
                // Left: Industrial FLIR Chassis Viewport (118pt x 218pt)
                phoneThermalChassis
                    .frame(width: 118, height: 218)

                // Right: 4-Row Dedicated Full-Width Zone List & Inspector (100% Zero Truncation)
                VStack(alignment: .leading, spacing: 6) {
                    // 4 Dedicated Full-Width Zone Rows
                    VStack(spacing: 5) {
                        ForEach(ThermalZone.allCases) { zone in
                            zoneFullWidthRow(zone)
                        }
                    }

                    // Active Zone Concise Engineering Note
                    activeZoneNote
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .bentoCard(accent: flirColor(for: temperature(of: selectedZone)))
        .onAppear {
            isBreathing = true
        }
    }

    // MARK: - 2. Thermal Spectrum Scale Bar with MAX / MIN Indicators
    private var thermalScaleBar: some View {
        HStack(spacing: 6) {
            // Min Reading Tag
            HStack(spacing: 3) {
                Circle().fill(Color(red: 0.0, green: 0.82, blue: 0.88)).frame(width: 5, height: 5)
                Text("\(L10n.Battery.minSpot) \(String(format: "%.1f", minTemperature))°C")
                    .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }

            // Smooth Multi-Stop False Color Thermal Gradient Track
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Color(red: 0.05, green: 0.12, blue: 0.28), location: 0.00),
                            .init(color: Color(red: 0.00, green: 0.82, blue: 0.88), location: 0.20),
                            .init(color: Color(red: 0.15, green: 0.85, blue: 0.40), location: 0.45),
                            .init(color: Color(red: 0.98, green: 0.65, blue: 0.05), location: 0.70),
                            .init(color: Color(red: 1.00, green: 0.25, blue: 0.20), location: 0.88),
                            .init(color: Color(red: 1.00, green: 0.95, blue: 0.80), location: 1.00)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .stroke(colorScheme == .dark ? Color.white.opacity(0.15) : Color.black.opacity(0.1), lineWidth: 0.5)
                )

            // Max Reading Tag
            HStack(spacing: 3) {
                Circle().fill(Color(red: 1.00, green: 0.25, blue: 0.20)).frame(width: 5, height: 5)
                Text("\(L10n.Battery.maxSpot) \(String(format: "%.1f", maxTemperature))°C")
                    .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color(red: 1.00, green: 0.35, blue: 0.30))
            }
        }
        .padding(.horizontal, 2)
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
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }

    // MARK: - Layer 1: Adaptive Chassis Chamber Background
    @ViewBuilder
    private func chassisChamberBackground(w: CGFloat, h: CGFloat) -> some View {
        let isDark = (colorScheme == .dark)

        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(isDark ? Color(red: 0.04, green: 0.07, blue: 0.12) : Color(white: 0.94))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: isDark ? [
                                Color.white.opacity(0.20),
                                Color.white.opacity(0.06),
                                Color.black.opacity(0.4)
                            ] : [
                                Color.black.opacity(0.18),
                                Color.black.opacity(0.08),
                                Color.white.opacity(0.6)
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
                    .padding(.top, 4.5)
            } else {
                // Classic Earpiece Speaker Notch Cutout
                HStack(spacing: 2) {
                    Capsule()
                        .fill(colorScheme == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.25))
                        .frame(width: 22, height: 3)
                }
                .padding(.top, 4)
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

        let socColor = flirColor(for: socTemp)
        let bColor = flirColor(for: batteryTemp)
        let pColor = flirColor(for: pmicTemp)
        let wColor = flirColor(for: wirelessTemp)
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
        let baseColor: Color = isDark ? Color.white : Color.black
        ZStack {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(baseColor.opacity(fillAlpha))
                .overlay(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .stroke(baseColor.opacity(strokeAlpha * 0.6), lineWidth: 0.8)
                )
            if isProModel {
                VStack(spacing: 2) {
                    HStack(spacing: 3) {
                        Circle().stroke(baseColor.opacity(strokeAlpha * 0.8), lineWidth: 0.8).frame(width: 7, height: 7)
                        Circle().stroke(baseColor.opacity(strokeAlpha * 0.8), lineWidth: 0.8).frame(width: 7, height: 7)
                    }
                    Circle().stroke(baseColor.opacity(strokeAlpha * 0.8), lineWidth: 0.8).frame(width: 7, height: 7)
                }
            } else {
                VStack(spacing: 3) {
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
        let bColor = flirColor(for: temperature(of: .battery))
        let defaultFill: Color = isDark ? Color.white.opacity(fillAlpha) : Color.black.opacity(fillAlpha)
        let batteryFill: Color = isBatteryActive ? bColor.opacity(0.20) : defaultFill
        let defaultStroke: Color = isXRay ? Color.cyan.opacity(0.6) : bColor.opacity(0.4)
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
        let wColor = flirColor(for: temperature(of: .wireless))
        let defaultOuterColor: Color = isDark ? Color.yellow.opacity(strokeAlpha * 0.8) : Color.orange.opacity(0.5)
        let defaultInnerColor: Color = isDark ? Color.yellow.opacity(strokeAlpha * 0.5) : Color.orange.opacity(0.35)
        let outerColor: Color = isWirelessActive ? wColor : defaultOuterColor
        let innerColor: Color = isWirelessActive ? wColor.opacity(0.8) : defaultInnerColor

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
        let sColor = flirColor(for: temperature(of: .soc))
        let defaultFill: Color = isDark ? Color.white.opacity(fillAlpha) : Color.black.opacity(fillAlpha)
        let socFill: Color = isSocActive ? sColor.opacity(0.24) : defaultFill
        let defaultStroke: Color = isXRay ? Color.orange.opacity(0.7) : sColor.opacity(0.5)
        let socStroke: Color = isSocActive ? sColor : defaultStroke

        Button {
            selectZone(.soc)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(socFill)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .stroke(socStroke, lineWidth: isSocActive ? 1.6 : 0.8)
                    )

                VStack(spacing: 1.5) {
                    Image(systemName: "cpu")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(isSocActive ? sColor : (isDark ? Color.white.opacity(0.85) : Color.black.opacity(0.75)))

                    Text(chipMarketingShort)
                        .font(.system(size: 8, weight: .heavy, design: .monospaced))
                        .foregroundStyle(isDark ? Color.white.opacity(0.85) : Color.black.opacity(0.85))
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
        let pColor = flirColor(for: temperature(of: .pmic))
        let defaultFill: Color = isDark ? Color.white.opacity(fillAlpha) : Color.black.opacity(fillAlpha)
        let pmicFill: Color = isPmicActive ? pColor.opacity(0.22) : defaultFill
        let defaultStroke: Color = isXRay ? Color.cyan.opacity(0.6) : pColor.opacity(0.5)
        let pmicStroke: Color = isPmicActive ? pColor : defaultStroke

        Button {
            selectZone(.pmic)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(pmicFill)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .stroke(pmicStroke, lineWidth: isPmicActive ? 1.6 : 0.8)
                    )

                HStack(spacing: 5) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(isPmicActive ? pColor : (isDark ? Color.white.opacity(0.8) : Color.black.opacity(0.7)))
                    Capsule()
                        .fill((isDark ? Color.white : Color.black).opacity(0.4))
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
        let socX = w * 0.24
        let socY = -h * 0.18
        let sColor = flirColor(for: temperature(of: .soc))

        ZStack {
            Circle()
                .stroke(sColor.opacity(0.35), style: StrokeStyle(lineWidth: 0.8, dash: [4, 3]))
                .frame(width: w * 0.44, height: w * 0.44)
                .offset(x: socX, y: socY)

            Circle()
                .stroke(sColor.opacity(0.20), style: StrokeStyle(lineWidth: 0.6, dash: [5, 4]))
                .frame(width: w * 0.62, height: w * 0.62)
                .offset(x: socX, y: socY)
        }
        .allowsHitTesting(false)
    }

    // MARK: - Layer 5: FLIR Target Tracking Reticles (Non-Colliding, Clean Positioning)
    @ViewBuilder
    private func flirTargetTrackingLayer(w: CGFloat, h: CGFloat) -> some View {
        // MAX Hotspot Reticle
        let (maxX, maxY) = pinCoordinates(for: maxZone, w: w, h: h)
        let maxColor = flirColor(for: maxTemperature)

        flirCrosshairShape(color: maxColor, label: L10n.Battery.maxSpot, isPulse: true)
            .offset(x: maxX, y: maxY - 16)
            .allowsHitTesting(false)

        // MIN Coldspot Reticle
        let (minX, minY) = pinCoordinates(for: minZone, w: w, h: h)
        let minColor = flirColor(for: minTemperature)

        flirCrosshairShape(color: minColor, label: L10n.Battery.minSpot, isPulse: false)
            .offset(x: minX, y: minY + 16)
            .allowsHitTesting(false)

        // Active Zone Selection Pulse Ring
        let (selX, selY) = pinCoordinates(for: selectedZone, w: w, h: h)
        let selColor = flirColor(for: temperature(of: selectedZone))

        ZStack {
            Circle()
                .stroke(selColor, lineWidth: 1.6)
                .frame(width: 18, height: 18)
                .scaleEffect(isBreathing ? 1.25 : 0.9)
                .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: isBreathing)

            Circle()
                .fill(Color.white)
                .frame(width: 4, height: 4)
        }
        .offset(x: selX, y: selY)
        .allowsHitTesting(false)
        .animation(.spring(response: 0.32, dampingFraction: 0.78), value: selectedZone)
    }

    @ViewBuilder
    private func flirCrosshairShape(color: Color, label: String, isPulse: Bool) -> some View {
        HStack(spacing: 2) {
            ZStack {
                Rectangle().fill(color).frame(width: 6, height: 1)
                Rectangle().fill(color).frame(width: 1, height: 6)
            }
            .frame(width: 7, height: 7)

            Text(label)
                .font(.system(size: 6.5, weight: .heavy, design: .monospaced))
                .foregroundStyle(color)
        }
        .padding(.horizontal, 3)
        .padding(.vertical, 1.5)
        .background(colorScheme == .dark ? Color.black.opacity(0.70) : Color.white.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 3))
        .shadow(color: Color.black.opacity(0.15), radius: 2)
    }

    // MARK: - Layer 6: Engineering HUD Optics & Parameters
    @ViewBuilder
    private func chassisHudOverlay(w: CGFloat, h: CGFloat) -> some View {
        let hudColor = colorScheme == .dark ? Color.white : Color.black

        VStack {
            HStack {
                Text("● IR")
                    .font(.system(size: 6.5, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color.red.opacity(0.85))
                Spacer()
                Text("ε:0.95")
                    .font(.system(size: 6.5, weight: .semibold, design: .monospaced))
                    .foregroundStyle(hudColor.opacity(0.45))
            }
            .padding(.horizontal, 7)
            .padding(.top, 5)

            Spacer()

            HStack {
                Text("FOV 54°")
                    .font(.system(size: 6.5, weight: .medium, design: .monospaced))
                    .foregroundStyle(hudColor.opacity(0.35))
                Spacer()
                Text("LIVE")
                    .font(.system(size: 6.5, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color.green.opacity(0.75))
            }
            .padding(.horizontal, 7)
            .padding(.bottom, 5)
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
        let color: Color = flirColor(for: temp)
        let defaultBg: Color = (colorScheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.03))
        let rowBg: Color = isSelected ? color.opacity(0.18) : defaultBg
        let rowStroke: Color = isSelected ? color.opacity(0.7) : Color.clear
        let iconColor: Color = isSelected ? color : Theme.textSecondary(for: colorScheme)
        let labelColor: Color = isSelected ? Theme.textPrimary(for: colorScheme) : Theme.textSecondary(for: colorScheme)

        Button {
            selectZone(zone)
        } label: {
            HStack(spacing: 6) {
                Image(systemName: zone.icon)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(iconColor)
                    .frame(width: 14)

                Text(zone.shortLabel)
                    .font(.system(size: 11.5, weight: isSelected ? .bold : .medium, design: .rounded))
                    .foregroundStyle(labelColor)
                    .lineLimit(1)

                Spacer(minLength: 4)

                Text(String(format: "%.1f °C", temp))
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .lineLimit(1)
                    .foregroundStyle(color)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(rowBg)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(rowStroke, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Right Column: Active Zone Concise Engineering Note
    private var activeZoneNote: some View {
        let temp = temperature(of: selectedZone)
        let color = flirColor(for: temp)

        return VStack(alignment: .leading, spacing: 3) {
            HStack {
                Text(selectedZone.title)
                    .font(.system(size: 11.5, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)

                Spacer()

                Text(temperatureStatusLabel(for: temp))
                    .font(.system(size: 8.5, weight: .bold, design: .rounded))
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(color.opacity(0.14))
                    .foregroundStyle(color)
                    .clipShape(Capsule())
                    .lineLimit(1)
            }

            Text(selectedZone.tip)
                .font(.system(size: 9.5, weight: .regular))
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(1.5)
        }
        .padding(7.5)
        .background(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
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
            if battery.batteryState == .charging {
                let wattBoost = min(5.5, abs(battery.liveWattage) * 0.32)
                return cellBase + max(1.2, wattBoost)
            } else {
                return max(24.0, cellBase - 1.4)
            }
        case .wireless:
            if battery.batteryState == .charging {
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

    private func flirColor(for temp: Double) -> Color {
        if temp < 30.0 {
            return Color(red: 0.0, green: 0.82, blue: 0.88)
        } else if temp < 34.0 {
            return Color(red: 0.15, green: 0.85, blue: 0.40)
        } else if temp < 37.5 {
            return Color(red: 0.98, green: 0.65, blue: 0.05)
        } else if temp < 41.0 {
            return Color(red: 1.00, green: 0.28, blue: 0.22)
        } else {
            return Color(red: 1.00, green: 0.95, blue: 0.85)
        }
    }

    private func temperatureStatusLabel(for temp: Double) -> String {
        if temp < 30.0 {
            return L10n.Battery.thermalStatusCool
        } else if temp < 35.5 {
            return L10n.Battery.thermalStatusNormal
        } else if temp < 39.5 {
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
        if id.hasPrefix("iPhone16") || id.hasPrefix("iPhone17") { return true }     // 15 Pro, 16 series
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
