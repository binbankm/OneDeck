//
//  ScreenRulerDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Screen digital vernier caliper and physical millimeter measurement workspace.
//

import SwiftUI

// MARK: - Standard Reference Benchmark Object
struct CaliperBenchmark: Identifiable {
    let id: String
    let name: String
    let sizeMm: Double
}

struct ScreenRulerDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared
    @Bindable private var system = SystemViewModel.shared

    // MARK: - State
    @State private var jawTopY: CGFloat = 0.0
    @State private var jawBottomY: CGFloat = 160.0
    @State private var stageHeight: CGFloat = 400.0
    @State private var isTopAnchored: Bool = true
    @State private var isMeasurementLocked: Bool = false
    @State private var showHistorySheet: Bool = false
    @State private var hasInitializedPositions: Bool = false

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // Benchmark Objects
    private var benchmarks: [CaliperBenchmark] {
        [
            CaliperBenchmark(id: "c1", name: L10n.Tools.benchmark1YuanCoin, sizeMm: 25.0),
            CaliperBenchmark(id: "c5", name: L10n.Tools.benchmark5JiaoCoin, sizeMm: 20.5),
            CaliperBenchmark(id: "sim", name: L10n.Tools.rulerNanoSim, sizeMm: 12.3),
            CaliperBenchmark(id: "typec", name: L10n.Tools.rulerTypeC, sizeMm: 8.3),
            CaliperBenchmark(id: "card", name: L10n.Tools.benchmarkCreditCard, sizeMm: 85.6)
        ]
    }

    // Hardware Scale Math (1:1 Physical PPI)
    private var pointsPerMm: CGFloat {
        let ppi = CGFloat(system.hardwareSpecs.ppi > 0 ? system.hardwareSpecs.ppi : 326)
        let scale = CGFloat(system.hardwareSpecs.nativeScaleValue > 0 ? system.hardwareSpecs.nativeScaleValue : 2.0)
        return ppi / (scale * 25.4)
    }

    private var rawSpanMm: Double {
        let pixelSpan = abs(jawBottomY - jawTopY)
        return Double(pixelSpan / pointsPerMm)
    }

    private var measuredMm: Double {
        let tare = tools.caliperTareOffsetMm
        return max(0.0, rawSpanMm - tare)
    }

    private var measuredDisplay: String {
        ToolsViewModel.formatCaliperMeasurement(mm: measuredMm, unit: tools.caliperUnit)
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: SpacingTheme.none) {
            // Top Digital Caliper LCD Console
            digitalLcdConsole
                .frame(maxWidth: LayoutTheme.maxContentWidth)
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.top, SpacingTheme.compact)
                .padding(.bottom, SpacingTheme.tight)

            // Dedicated Caliper Measurement Stage
            GeometryReader { geo in
                let currentStageHeight = max(100, geo.size.height)
                let stageWidth = max(100, geo.size.width)

                ZStack(alignment: .topLeading) {
                    // Dual-Side Laser-Etched Scales (Metric Left & Imperial Right)
                    dualRulerBeamCanvas(width: stageWidth, height: currentStageHeight)

                    // Dimension Span & Leader Lines
                    measurementDimensionOverlay(width: stageWidth)

                    // Anvil Top Jaw (Fixed 0mm or Floating)
                    caliperTopJaw(stageHeight: currentStageHeight, stageWidth: stageWidth)

                    // Slider Bottom Jaw with Knurled Thumb Grip
                    caliperBottomJaw(stageHeight: currentStageHeight, stageWidth: stageWidth)
                }
                .frame(width: stageWidth, height: currentStageHeight)
                .coordinateSpace(name: "caliperStage")
                .clipped()
                .onAppear {
                    stageHeight = currentStageHeight
                    if !hasInitializedPositions {
                        jawTopY = 0.0
                        jawBottomY = max(jawTopY + 14.0, min(currentStageHeight - 24.0, pointsPerMm * 45.0))
                        hasInitializedPositions = true
                        tools.setCaliperRawMm(rawSpanMm)
                    }
                }
                .onChange(of: geo.size.height) { _, newHeight in
                    let clampedHeight = max(100, newHeight)
                    stageHeight = clampedHeight
                    if jawBottomY > clampedHeight {
                        jawBottomY = max(jawTopY + 14.0, clampedHeight)
                        tools.setCaliperRawMm(rawSpanMm)
                    }
                }
            }
            .frame(maxWidth: LayoutTheme.maxContentWidth)
            .layoutPriority(1)

            // Reference Object Benchmarks Row
            benchmarkChipsRow
                .frame(maxWidth: LayoutTheme.maxContentWidth)
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.tight)

            // Pinned Bottom Industrial Action Bar
            bottomControlsBar
                .frame(maxWidth: LayoutTheme.maxContentWidth)
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.top, SpacingTheme.micro)
                .padding(.bottom, SpacingTheme.row)
        }
        .frame(maxWidth: .infinity)
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.screenRuler)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView(tool: .screenRuler)
        }
        .onDisappear {
            tools.leaveDetailView()
        }
        .sheet(isPresented: $showHistorySheet) {
            caliperHistorySheet
        }
    }

    // MARK: - 1. Digital Caliper LCD Console
    @ViewBuilder
    private var digitalLcdConsole: some View {
        let orangeAccent = Theme.readableOrange(for: colorScheme)
        let headerLayout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: SpacingTheme.compact))
            : AnyLayout(HStackLayout(alignment: .center, spacing: SpacingTheme.standard))
        let controlsLayout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: SpacingTheme.compact))
            : AnyLayout(HStackLayout(spacing: SpacingTheme.compact))

        VStack(spacing: SpacingTheme.standard) {
            // Main LCD Digital Readout Row
            headerLayout {
                VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                    HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.compact) {
                        Text(measuredDisplay)
                            .font(Typography.heroSubValueMono)
                            .foregroundStyle(isMeasurementLocked ? orangeAccent : accentFg)
                            .monospacedDigit()
                            .contentTransition(.numericText())
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)

                        if isMeasurementLocked {
                            Image(systemName: "lock.fill")
                                .font(IconTheme.badgeInline)
                                .foregroundStyle(orangeAccent)
                                .accessibilityHidden(true)
                        }
                    }

                    HStack(spacing: SpacingTheme.standard) {
                        Text(L10n.Tools.rulerPpiBadge(Int(system.hardwareSpecs.ppi)))
                            .font(Typography.microAxis)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))

                        if tools.caliperTareOffsetMm > 0 {
                            Text("\(L10n.Tools.tare): \(String(format: "%.1f mm", tools.caliperTareOffsetMm))")
                                .font(Typography.microAxis)
                                .monospacedDigit()
                                .foregroundStyle(orangeAccent)
                        }
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(L10n.Tools.screenRuler)
                .accessibilityValue(measuredDisplay)

                if !dynamicTypeSize.isAccessibilitySize {
                    Spacer(minLength: 0)
                }

                // Unit Selector (mm | cm | in)
                Picker(L10n.Tools.screenRuler, selection: $tools.caliperUnit) {
                    ForEach(ScreenCaliperUnit.allCases) { unit in
                        Text(unit.title).tag(unit)
                    }
                }
                .pickerStyle(.segmented)
                .accessibilityLabel(L10n.Tools.screenRuler)
                .frame(maxWidth: dynamicTypeSize.isAccessibilitySize ? .infinity : 140)
                .onChange(of: tools.caliperUnit) { _, _ in
                    Haptics.selection()
                }
            }

            // Sub-Millimeter Stepper Controls & Jaw Mode Toggle
            controlsLayout {
                // Top Jaw Mode Switch (Anchor 0mm vs Dual Jaws)
                Button {
                    Haptics.selection()
                    isTopAnchored.toggle()
                    if isTopAnchored {
                        jawTopY = 0.0
                        tools.setCaliperRawMm(rawSpanMm)
                    }
                } label: {
                    HStack(spacing: SpacingTheme.tight) {
                        Image(systemName: isTopAnchored ? "pin.fill" : "arrow.up.and.down.circle.fill")
                            .font(IconTheme.badgeInline)
                            .accessibilityHidden(true)
                        Text(isTopAnchored ? L10n.Tools.anchorTopJaw : L10n.Tools.dualFloatingJaws)
                            .font(Typography.badgeTagMono)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                    .foregroundStyle(isTopAnchored ? accentFg : Theme.textPrimary(for: colorScheme))
                    .padding(.horizontal, SpacingTheme.standard)
                    .frame(minHeight: LayoutTheme.minTapTarget)
                    .frame(maxWidth: dynamicTypeSize.isAccessibilitySize ? .infinity : nil)
                    .background(isTopAnchored ? accentFg.opacity(0.14) : Theme.chipBackground(for: colorScheme))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(isTopAnchored ? accentFg.opacity(0.5) : Theme.chipBorder(for: colorScheme), lineWidth: 0.8)
                    )
                    .contentShape(Capsule())
                }
                .buttonStyle(BentoCardButtonStyle())
                .accessibilityAddTraits(isTopAnchored ? .isSelected : [])

                if !dynamicTypeSize.isAccessibilitySize {
                    Spacer(minLength: 0)
                }

                // Fine-Tuning Step Buttons (±0.1mm & ±1.0mm)
                HStack(spacing: SpacingTheme.tight) {
                    stepperButton(label: "-1.0", deltaMm: -1.0)
                    stepperButton(label: "-0.1", deltaMm: -0.1)
                    stepperButton(label: "+0.1", deltaMm: 0.1)
                    stepperButton(label: "+1.0", deltaMm: 1.0)
                }
            }
        }
        .padding(.horizontal, SpacingTheme.rowStandard)
        .padding(.vertical, SpacingTheme.standard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(accentFg.opacity(0.35), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.25 : 0.06), radius: 6, y: 3)
    }

    @ViewBuilder
    private func stepperButton(label: String, deltaMm: Double) -> some View {
        Button {
            Haptics.tick()
            guard !isMeasurementLocked else { return }
            let deltaPoints = CGFloat(deltaMm) * pointsPerMm
            jawBottomY = min(stageHeight, max(jawTopY + 14.0, jawBottomY + deltaPoints))
            tools.setCaliperRawMm(rawSpanMm)
        } label: {
            Text(label)
                .font(Typography.badgeTagMono)
                .monospacedDigit()
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .frame(minWidth: dynamicTypeSize.isAccessibilitySize ? 0 : 40, minHeight: LayoutTheme.minTapTarget)
                .frame(maxWidth: dynamicTypeSize.isAccessibilitySize ? .infinity : nil)
                .padding(.horizontal, SpacingTheme.tight)
                .background(Theme.chipBackground(for: colorScheme))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous)
                        .stroke(Theme.chipBorder(for: colorScheme), lineWidth: 0.8)
                )
                .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
        .disabled(isMeasurementLocked)
        .opacity(isMeasurementLocked ? 0.45 : 1.0)
        .accessibilityLabel("\(L10n.Tools.fineTuneStep) \(label) mm")
    }

    // MARK: - 2. Dual-Side Laser-Etched Ruler Beam Canvas
    @ViewBuilder
    private func dualRulerBeamCanvas(width: CGFloat, height: CGFloat) -> some View {
        let ppm = pointsPerMm

        Canvas { context, size in
            guard size.width > 0, size.height > 0, ppm > 0 else { return }
            let totalMm = max(0, Int(size.height / ppm))
            let pointsPerInch = ppm * 25.4
            let totalInches = max(0, Int(size.height / pointsPerInch))
            let tickColor = colorScheme == .dark ? Color.white.opacity(0.32) : Color.black.opacity(0.28)
            let majorColor = colorScheme == .dark ? Color.white.opacity(0.8) : Color.black.opacity(0.75)

            // --- Left Edge: Metric Millimeter & Centimeter Scale ---
            for mm in 0 ... totalMm {
                let y = CGFloat(mm) * ppm
                let isMajor = (mm % 10 == 0)
                let isMid = (mm % 5 == 0)

                let tickWidth: CGFloat = isMajor ? 28 : (isMid ? 18 : 10)
                let strokeColor = isMajor ? majorColor : tickColor

                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: tickWidth, y: y))
                context.stroke(path, with: .color(strokeColor), lineWidth: isMajor ? 1.2 : 0.8)

                if isMajor && mm > 0 {
                    let cm = mm / 10
                    let text = Text("\(cm)")
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(majorColor)
                    context.draw(text, at: CGPoint(x: 38, y: y))
                }
            }

            // --- Right Edge: Imperial Inch Scale (1/10") ---
            for inchTenth in 0 ... (totalInches * 10 + 10) {
                let y = CGFloat(inchTenth) * (pointsPerInch / 10.0)
                guard y <= size.height else { break }

                let isMajorInch = (inchTenth % 10 == 0)
                let isMidInch = (inchTenth % 5 == 0)

                let tickWidth: CGFloat = isMajorInch ? 28 : (isMidInch ? 18 : 10)
                let strokeColor = isMajorInch ? majorColor : tickColor

                var path = Path()
                path.move(to: CGPoint(x: size.width, y: y))
                path.addLine(to: CGPoint(x: size.width - tickWidth, y: y))
                context.stroke(path, with: .color(strokeColor), lineWidth: isMajorInch ? 1.2 : 0.8)

                if isMajorInch && inchTenth > 0 {
                    let inch = inchTenth / 10
                    let text = Text("\(inch)\"")
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(majorColor)
                    context.draw(text, at: CGPoint(x: size.width - 38, y: y))
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    // MARK: - 3. Measurement Dimension Overlay with Crosshairs
    @ViewBuilder
    private func measurementDimensionOverlay(width: CGFloat) -> some View {
        let top = min(jawTopY, jawBottomY)
        let span = max(0, abs(jawBottomY - jawTopY))

        ZStack {
            // Workpiece Shading
            Rectangle()
                .fill(accentFg.opacity(0.08))
                .frame(width: max(0, width - 96), height: span)
                .position(x: width / 2, y: top + span / 2)

            // Center Dimension Leader Line with Arrows
            if span > 36 {
                VStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "arrow.up")
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(accentFg)

                    Text(measuredDisplay)
                        .font(Typography.badgeTagMono)
                        .monospacedDigit()
                        .foregroundStyle(accentFg)
                        .padding(.horizontal, SpacingTheme.compact)
                        .padding(.vertical, SpacingTheme.micro)
                        .background(Theme.cardBackground(for: colorScheme).opacity(0.92))
                        .clipShape(Capsule())

                    Image(systemName: "arrow.down")
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(accentFg)
                }
                .position(x: width / 2, y: top + span / 2)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    // MARK: - 4. Precision Top Jaw (Anvil Reference)
    @ViewBuilder
    private func caliperTopJaw(stageHeight: CGFloat, stageWidth: CGFloat) -> some View {
        let bladeY = min(max(0, jawTopY), max(0, stageHeight - 2.5))
        let pillTopY = min(max(4, jawTopY + 4), max(4, stageHeight - 28))

        ZStack(alignment: .topLeading) {
            // Stainless Precision Ground Blade Line (exact top measuring edge at jawTopY)
            Rectangle()
                .fill(accentFg)
                .frame(width: stageWidth, height: 2.5)
                .offset(y: bladeY)

            // Jaw Handle / Reference Pill + generous 44pt drag strip
            HStack(spacing: SpacingTheme.tight) {
                if isTopAnchored {
                    Image(systemName: "lock.fill")
                        .font(IconTheme.badgeInline)
                        .accessibilityHidden(true)
                    Text(L10n.Tools.zeroMmBenchmark)
                        .font(Typography.badgeTagMono)
                } else {
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(IconTheme.badgeInline)
                        .accessibilityHidden(true)
                    Text(L10n.Tools.jawA)
                        .font(Typography.badgeTagMono)
                }
            }
            .foregroundStyle(Theme.contrastingForeground(for: accentFg))
            .padding(.horizontal, SpacingTheme.standard)
            .padding(.vertical, SpacingTheme.tight)
            .background(accentFg)
            .clipShape(Capsule())
            .frame(maxWidth: stageWidth, minHeight: LayoutTheme.minTapTarget, alignment: .top)
            .offset(y: pillTopY)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .named("caliperStage"))
                    .onChanged { value in
                        guard !isTopAnchored && !isMeasurementLocked else { return }
                        jawTopY = max(0, min(jawBottomY - 14, value.location.y))
                        tools.setCaliperRawMm(rawSpanMm)
                    }
            )
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(L10n.Tools.jawA)
            .accessibilityValue(isTopAnchored ? L10n.Tools.zeroMmBenchmark : measuredDisplay)
            .accessibilityAdjustableAction { direction in
                guard !isTopAnchored && !isMeasurementLocked else { return }
                let step = pointsPerMm
                switch direction {
                case .increment:
                    jawTopY = max(0, min(jawBottomY - 14, jawTopY - step))
                case .decrement:
                    jawTopY = max(0, min(jawBottomY - 14, jawTopY + step))
                @unknown default:
                    break
                }
                tools.setCaliperRawMm(rawSpanMm)
            }
        }
    }

    // MARK: - 5. Precision Bottom Jaw (Slider with Knurled Grip)
    @ViewBuilder
    private func caliperBottomJaw(stageHeight: CGFloat, stageWidth: CGFloat) -> some View {
        let jawForeground = Theme.contrastingForeground(for: accentFg)
        let bladeY = max(0, min(stageHeight - 2.5, jawBottomY - 2.5))
        let gripHeight: CGFloat = 36
        let gripTopY = jawBottomY + 2 <= stageHeight - gripHeight
            ? jawBottomY + 2
            : max(0, jawBottomY - gripHeight - 4)

        ZStack(alignment: .topLeading) {
            // Horizontal Measuring Blade (exact measuring edge at jawBottomY)
            Rectangle()
                .fill(accentFg)
                .frame(width: stageWidth, height: 2.5)
                .offset(y: bladeY)

            // Slider Body with Knurled Thumb Grip Lines
            VStack(spacing: SpacingTheme.micro) {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "arrowtriangle.up.fill")
                        .font(IconTheme.badgeInline)
                        .accessibilityHidden(true)
                    Text(L10n.Tools.jawB)
                        .font(Typography.badgeTagMono)
                }

                // Knurled grip grooves (4 tactile visual ribs)
                HStack(spacing: SpacingTheme.micro) {
                    ForEach(0 ..< 4, id: \.self) { _ in
                        Rectangle()
                            .fill(jawForeground.opacity(0.45))
                            .frame(width: 1.5, height: 6)
                    }
                }
            }
            .foregroundStyle(jawForeground)
            .padding(.horizontal, SpacingTheme.rowStandard)
            .padding(.vertical, SpacingTheme.tight)
            .background(accentFg)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
            .frame(maxWidth: stageWidth, minHeight: LayoutTheme.minTapTarget, alignment: .top)
            .offset(y: gripTopY)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .named("caliperStage"))
                    .onChanged { value in
                        guard !isMeasurementLocked else { return }
                        jawBottomY = max(jawTopY + 14, min(stageHeight, value.location.y))
                        tools.setCaliperRawMm(rawSpanMm)
                    }
            )
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(L10n.Tools.jawB)
            .accessibilityValue(measuredDisplay)
            .accessibilityAdjustableAction { direction in
                guard !isMeasurementLocked else { return }
                let step = pointsPerMm
                switch direction {
                case .increment:
                    jawBottomY = max(jawTopY + 14, min(stageHeight, jawBottomY + step))
                case .decrement:
                    jawBottomY = max(jawTopY + 14, min(stageHeight, jawBottomY - step))
                @unknown default:
                    break
                }
                tools.setCaliperRawMm(rawSpanMm)
            }
        }
    }

    // MARK: - 6. Benchmark Chips Row
    @ViewBuilder
    private var benchmarkChipsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: SpacingTheme.compact) {
                Text(L10n.Tools.referenceObjects + ":")
                    .font(Typography.microAxis)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))

                ForEach(benchmarks) { bm in
                    Button {
                        Haptics.tick()
                        guard !isMeasurementLocked else { return }
                        let targetPoints = CGFloat(bm.sizeMm) * pointsPerMm
                        if isTopAnchored {
                            jawTopY = 0.0
                            jawBottomY = min(stageHeight, max(14.0, targetPoints))
                        } else {
                            let maxTop = max(0.0, stageHeight - max(14.0, targetPoints))
                            jawTopY = min(jawTopY, maxTop)
                            jawBottomY = min(stageHeight, max(jawTopY + 14.0, jawTopY + targetPoints))
                        }
                        tools.setCaliperRawMm(rawSpanMm)
                    } label: {
                        Text("\(bm.name) (\(String(format: "%.1f", bm.sizeMm))mm)")
                            .font(Typography.microAxis)
                            .monospacedDigit()
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))
                            .padding(.horizontal, SpacingTheme.row)
                            .frame(minHeight: LayoutTheme.minTapTarget)
                            .background(Theme.chipBackground(for: colorScheme))
                            .clipShape(Capsule())
                            .overlay(
                                Capsule().stroke(Theme.chipBorder(for: colorScheme), lineWidth: 0.8)
                            )
                            .contentShape(Capsule())
                    }
                    .buttonStyle(BentoCardButtonStyle())
                    .disabled(isMeasurementLocked)
                    .opacity(isMeasurementLocked ? 0.5 : 1.0)
                }
            }
        }
    }

    // MARK: - 7. Pinned Bottom Action Bar
    @ViewBuilder
    private var bottomControlsBar: some View {
        let orangeAccent = Theme.readableOrange(for: colorScheme)
        let isTared = tools.caliperTareOffsetMm > 0

        if dynamicTypeSize.isAccessibilitySize {
            VStack(spacing: SpacingTheme.compact) {
                HStack(spacing: SpacingTheme.compact) {
                    tareButton(orangeAccent: orangeAccent, isTared: isTared)
                    lockButton(orangeAccent: orangeAccent)
                }
                HStack(spacing: SpacingTheme.compact) {
                    saveButton
                    historyButton
                }
            }
        } else {
            HStack(spacing: SpacingTheme.standard) {
                tareButton(orangeAccent: orangeAccent, isTared: isTared)
                lockButton(orangeAccent: orangeAccent)
                saveButton
                historyButton
            }
        }
    }

    @ViewBuilder
    private func tareButton(orangeAccent: Color, isTared: Bool) -> some View {
        Button {
            Haptics.selection()
            if isTared {
                tools.resetTare()
            } else {
                tools.tareCaliper()
            }
        } label: {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .font(IconTheme.actionButton)
                    .accessibilityHidden(true)
                Text(isTared ? L10n.Tools.resetTare : L10n.Tools.tare)
                    .font(Typography.captionBold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .foregroundStyle(isTared ? orangeAccent : Theme.textPrimary(for: colorScheme))
            .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(isTared ? orangeAccent.opacity(0.14) : Theme.cardBackground(for: colorScheme))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(isTared ? orangeAccent.opacity(0.5) : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
            )
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
        .accessibilityAddTraits(isTared ? .isSelected : [])
    }

    @ViewBuilder
    private func lockButton(orangeAccent: Color) -> some View {
        Button {
            Haptics.selection()
            isMeasurementLocked.toggle()
        } label: {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: isMeasurementLocked ? "lock.fill" : "lock.open.fill")
                    .font(IconTheme.actionButton)
                    .accessibilityHidden(true)
                Text(isMeasurementLocked ? L10n.Tools.unlockedAngle : L10n.Tools.lockAngle)
                    .font(Typography.captionBold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .foregroundStyle(isMeasurementLocked ? orangeAccent : Theme.textPrimary(for: colorScheme))
            .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(isMeasurementLocked ? orangeAccent.opacity(0.14) : Theme.cardBackground(for: colorScheme))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(isMeasurementLocked ? orangeAccent.opacity(0.5) : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
            )
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
        .accessibilityAddTraits(isMeasurementLocked ? .isSelected : [])
    }

    @ViewBuilder
    private var saveButton: some View {
        Button {
            tools.saveCurrentCaliperMeasurement()
        } label: {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: "tray.and.arrow.down.fill")
                    .font(IconTheme.actionButton)
                    .accessibilityHidden(true)
                Text(L10n.Tools.saveRecord)
                    .font(Typography.captionBold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .foregroundStyle(Theme.contrastingForeground(for: appState.accentColor))
            .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(appState.accentColor)
            )
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
    }

    @ViewBuilder
    private var historyButton: some View {
        Button {
            Haptics.selection()
            showHistorySheet = true
        } label: {
            Image(systemName: "list.bullet.circle.fill")
                .font(IconTheme.actionButton)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .frame(minWidth: LayoutTheme.minTapTarget, minHeight: LayoutTheme.minTapTarget)
                .frame(maxWidth: dynamicTypeSize.isAccessibilitySize ? .infinity : nil)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .fill(Theme.cardBackground(for: colorScheme))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                )
                .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
        .accessibilityLabel(L10n.Tools.historyRecords)
    }

    // MARK: - 8. History Records Sheet
    @ViewBuilder
    private var caliperHistorySheet: some View {
        NavigationStack {
            List {
                if tools.caliperRecords.isEmpty {
                    Text(L10n.Tools.noRecords)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textTertiary(for: colorScheme))
                } else {
                    ForEach(tools.caliperRecords) { record in
                        HStack {
                            VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                                Text(record.note)
                                    .font(Typography.bodyValueMono)
                                    .monospacedDigit()
                                    .foregroundStyle(accentFg)
                                Text(record.timestamp.formatted(date: .numeric, time: .shortened))
                                    .font(Typography.caption)
                                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                            }
                            Spacer()
                        }
                    }
                    .onDelete { offsets in
                        tools.deleteCaliperRecord(at: offsets)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.background(for: colorScheme).ignoresSafeArea())
            .navigationTitle(L10n.Tools.historyRecords)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.Common.done) {
                        Haptics.selection()
                        showHistorySheet = false
                    }
                }
            }
        }
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ScreenRulerDetailView()
    }
}
