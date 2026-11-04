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
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared
    @Bindable private var system = SystemViewModel.shared

    // MARK: - State
    @State private var jawTopY: CGFloat = 0.0
    @State private var jawBottomY: CGFloat = 160.0
    @State private var isTopAnchored: Bool = true
    @State private var isMeasurementLocked: Bool = false
    @State private var showHistorySheet: Bool = false
    @State private var hasInitializedPositions: Bool = false

    // Benchmark Objects
    private var benchmarks: [CaliperBenchmark] {
        [
            CaliperBenchmark(id: "c1", name: L10n.Tools.benchmark1YuanCoin, sizeMm: 25.0),
            CaliperBenchmark(id: "c5", name: L10n.Tools.benchmark5JiaoCoin, sizeMm: 20.5),
            CaliperBenchmark(id: "sim", name: "Nano SIM", sizeMm: 12.3),
            CaliperBenchmark(id: "typec", name: "Type-C", sizeMm: 8.3),
            CaliperBenchmark(id: "card", name: L10n.Tools.benchmarkCreditCard, sizeMm: 85.6)
        ]
    }

    // Hardware Scale Math (1:1 Physical PPI)
    private var pointsPerMm: CGFloat {
        let ppi = CGFloat(max(326, system.hardwareSpecs.ppi))
        let scale = CGFloat(max(2, system.hardwareSpecs.scale))
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
        switch tools.caliperUnit {
        case .mm:
            return String(format: "%.1f mm", measuredMm)
        case .cm:
            return String(format: "%.2f cm", measuredMm / 10.0)
        case .inch:
            return String(format: "%.3f in", measuredMm / 25.4)
        }
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: SpacingTheme.none) {
            // Top Digital Caliper LCD Console
            digitalLcdConsole
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.top, SpacingTheme.compact)
                .padding(.bottom, SpacingTheme.tight)

            // Dedicated Caliper Measurement Stage
            GeometryReader { geo in
                let stageHeight = max(100, geo.size.height)
                let stageWidth = max(100, geo.size.width)

                ZStack(alignment: .topLeading) {
                    // Dual-Side Laser-Etched Scales (Metric Left & Imperial Right)
                    dualRulerBeamCanvas(width: stageWidth, height: stageHeight)

                    // Dimension Span & Leader Lines
                    measurementDimensionOverlay(width: stageWidth)

                    // Anvil Top Jaw (Fixed 0mm or Floating)
                    caliperTopJaw(stageWidth: stageWidth)

                    // Slider Bottom Jaw with Knurled Thumb Grip
                    caliperBottomJaw(stageHeight: stageHeight, stageWidth: stageWidth)
                }
                .frame(width: stageWidth, height: stageHeight)
                .clipped()
                .onAppear {
                    if !hasInitializedPositions {
                        jawTopY = 0.0
                        jawBottomY = min(stageHeight - 24.0, pointsPerMm * 45.0)
                        hasInitializedPositions = true
                        tools.setCaliperMm(measuredMm)
                    }
                }
            }
            .layoutPriority(1)

            // Reference Object Benchmarks Row
            benchmarkChipsRow
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.tight)

            // Pinned Bottom Industrial Action Bar
            bottomControlsBar
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.top, SpacingTheme.micro)
                .padding(.bottom, SpacingTheme.row)
        }
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
        VStack(spacing: SpacingTheme.standard) {
            // Main LCD Digital Readout Row
            HStack(alignment: .center, spacing: SpacingTheme.standard) {
                VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                    HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.compact) {
                        Text(measuredDisplay)
                            .font(Typography.heroSubValueMono)
                            .foregroundStyle(isMeasurementLocked ? Color.orange : appState.accentColor)
                            .monospacedDigit()
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)

                        if isMeasurementLocked {
                            Image(systemName: "lock.fill")
                                .font(IconTheme.badgeInline)
                                .foregroundStyle(Color.orange)
                        }
                    }

                    HStack(spacing: SpacingTheme.standard) {
                        Text(String(format: "1:1 PPI: %d", Int(system.hardwareSpecs.ppi)))
                            .font(Typography.microAxis)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))

                        if tools.caliperTareOffsetMm > 0 {
                            Text("\(L10n.Tools.tare): \(String(format: "%.1f mm", tools.caliperTareOffsetMm))")
                                .font(Typography.microAxis)
                                .foregroundStyle(Color.orange)
                        }
                    }
                }

                Spacer()

                // Unit Selector (mm | cm | in)
                Picker("", selection: $tools.caliperUnit) {
                    ForEach(ScreenCaliperUnit.allCases) { u in
                        Text(u.title).tag(u)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 130)
            }

            // Sub-Millimeter Stepper Controls & Jaw Mode Toggle
            HStack(spacing: SpacingTheme.compact) {
                // Top Jaw Mode Switch (Anchor 0mm vs Dual Jaws)
                Button {
                    Haptics.selection()
                    isTopAnchored.toggle()
                    if isTopAnchored {
                        jawTopY = 0.0
                        tools.setCaliperMm(measuredMm)
                    }
                } label: {
                    HStack(spacing: SpacingTheme.tight) {
                        Image(systemName: isTopAnchored ? "pin.fill" : "arrow.up.and.down.circle.fill")
                            .font(IconTheme.badgeInline)
                        Text(isTopAnchored ? L10n.Tools.anchorTopJaw : L10n.Tools.dualFloatingJaws)
                            .font(Typography.badgeTagMono)
                    }
                    .foregroundStyle(isTopAnchored ? appState.accentColor : Theme.textPrimary(for: colorScheme))
                    .padding(.horizontal, SpacingTheme.standard)
                    .padding(.vertical, SpacingTheme.compact)
                    .background(isTopAnchored ? appState.accentColor.opacity(0.14) : Theme.cardBackground(for: colorScheme).opacity(0.6))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(isTopAnchored ? appState.accentColor.opacity(0.5) : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                    )
                }
                .buttonStyle(.plain)

                Spacer()

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
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.95))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(appState.accentColor.opacity(0.35), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.12), radius: 6, y: 3)
    }

    @ViewBuilder
    private func stepperButton(label: String, deltaMm: Double) -> some View {
        Button {
            Haptics.tick()
            guard !isMeasurementLocked else { return }
            let deltaPoints = CGFloat(deltaMm) * pointsPerMm
            jawBottomY = max(jawTopY + 2.0, jawBottomY + deltaPoints)
            tools.setCaliperMm(measuredMm)
        } label: {
            Text(label)
                .font(Typography.badgeTagMono)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .padding(.horizontal, SpacingTheme.compact)
                .padding(.vertical, SpacingTheme.compact)
                .background(Theme.cardBackground(for: colorScheme).opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous)
                        .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - 2. Dual-Side Laser-Etched Ruler Beam Canvas
    @ViewBuilder
    private func dualRulerBeamCanvas(width: CGFloat, height: CGFloat) -> some View {
        let ppm = pointsPerMm
        let totalMm = Int(height / ppm)
        let pointsPerInch = ppm * 25.4
        let totalInches = Int(height / pointsPerInch)

        Canvas { context, size in
            let tickColor = colorScheme == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.25)
            let majorColor = colorScheme == .dark ? Color.white.opacity(0.75) : Color.black.opacity(0.7)

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

            // --- Right Edge: Imperial Inch Scale (1/10" & 1/16") ---
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
    }

    // MARK: - 3. Measurement Dimension Overlay with Crosshairs
    @ViewBuilder
    private func measurementDimensionOverlay(width: CGFloat) -> some View {
        let top = min(jawTopY, jawBottomY)
        let span = max(0, abs(jawBottomY - jawTopY))

        ZStack {
            // Workpiece Shading
            Rectangle()
                .fill(appState.accentColor.opacity(0.07))
                .frame(width: max(0, width - 96), height: span)
                .position(x: width / 2, y: top + span / 2)

            // Center Dimension Leader Line with Arrows
            if span > 24 {
                VStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "arrow.up")
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(appState.accentColor)

                    Text(measuredDisplay)
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(appState.accentColor)
                        .padding(.horizontal, SpacingTheme.compact)
                        .padding(.vertical, SpacingTheme.micro)
                        .background(Theme.cardBackground(for: colorScheme).opacity(0.85))
                        .clipShape(Capsule())

                    Image(systemName: "arrow.down")
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(appState.accentColor)
                }
                .position(x: width / 2, y: top + span / 2)
            }
        }
        .allowsHitTesting(false)
    }

    // MARK: - 4. Precision Top Jaw (Anvil Reference)
    @ViewBuilder
    private func caliperTopJaw(stageWidth: CGFloat) -> some View {
        ZStack(alignment: .top) {
            // Stainless Precision Ground Blade Line
            Rectangle()
                .fill(appState.accentColor)
                .frame(width: stageWidth, height: 2.5)

            // Jaw Handle / Reference Pill
            HStack(spacing: SpacingTheme.tight) {
                if isTopAnchored {
                    Image(systemName: "lock.fill")
                        .font(IconTheme.badgeInline)
                    Text(L10n.Tools.zeroMmBenchmark)
                        .font(Typography.badgeTagMono)
                } else {
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(IconTheme.badgeInline)
                    Text(L10n.Tools.jawA)
                        .font(Typography.badgeTagMono)
                }
            }
            .foregroundStyle(Color.black)
            .padding(.horizontal, SpacingTheme.standard)
            .padding(.vertical, SpacingTheme.micro)
            .background(appState.accentColor)
            .clipShape(Capsule())
            .offset(y: 4)
        }
        .frame(width: stageWidth)
        .position(x: stageWidth / 2, y: jawTopY)
        .gesture(
            DragGesture()
                .onChanged { value in
                    guard !isTopAnchored && !isMeasurementLocked else { return }
                    jawTopY = max(0, min(jawBottomY - 14, value.location.y))
                    tools.setCaliperMm(measuredMm)
                }
        )
    }

    // MARK: - 5. Precision Bottom Jaw (Slider with Knurled Grip)
    @ViewBuilder
    private func caliperBottomJaw(stageHeight: CGFloat, stageWidth: CGFloat) -> some View {
        ZStack(alignment: .bottom) {
            // Horizontal Measuring Blade
            Rectangle()
                .fill(appState.accentColor)
                .frame(width: stageWidth, height: 2.5)

            // Slider Body with Knurled Thumb Grip Lines
            VStack(spacing: SpacingTheme.micro) {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "arrowtriangle.up.fill")
                        .font(IconTheme.badgeInline)
                    Text(L10n.Tools.jawB)
                        .font(Typography.badgeTagMono)
                }

                // Knurled grip grooves (3 tactile visual ribs)
                HStack(spacing: SpacingTheme.micro) {
                    ForEach(0 ..< 4) { _ in
                        Rectangle()
                            .fill(Color.black.opacity(0.4))
                            .frame(width: 1.5, height: 6)
                    }
                }
            }
            .foregroundStyle(Color.black)
            .padding(.horizontal, SpacingTheme.rowStandard)
            .padding(.vertical, SpacingTheme.micro)
            .background(appState.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
            .offset(y: -4)
        }
        .frame(width: stageWidth)
        .position(x: stageWidth / 2, y: jawBottomY)
        .gesture(
            DragGesture()
                .onChanged { value in
                    guard !isMeasurementLocked else { return }
                    jawBottomY = max(jawTopY + 14, min(stageHeight, value.location.y))
                    tools.setCaliperMm(measuredMm)
                }
        )
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
                            jawBottomY = targetPoints
                        } else {
                            jawBottomY = jawTopY + targetPoints
                        }
                        tools.setCaliperMm(measuredMm)
                    } label: {
                        Text("\(bm.name) (\(String(format: "%.1f", bm.sizeMm))mm)")
                            .font(Typography.microAxis)
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))
                            .padding(.horizontal, SpacingTheme.compact)
                            .padding(.vertical, SpacingTheme.tight)
                            .background(Theme.cardBackground(for: colorScheme).opacity(0.6))
                            .clipShape(Capsule())
                            .overlay(
                                Capsule().stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.6)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - 7. Pinned Bottom Action Bar
    @ViewBuilder
    private var bottomControlsBar: some View {
        HStack(spacing: SpacingTheme.standard) {
            // Tare / Zero Reset Button
            Button {
                Haptics.selection()
                if tools.caliperTareOffsetMm > 0 {
                    tools.resetTare()
                } else {
                    tools.tareCaliper()
                }
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                        .font(IconTheme.actionButton)
                    Text(tools.caliperTareOffsetMm > 0 ? L10n.Tools.resetTare : L10n.Tools.tare)
                        .font(Typography.captionBold)
                }
                .foregroundStyle(tools.caliperTareOffsetMm > 0 ? Color.orange : Theme.textPrimary(for: colorScheme))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .fill(Theme.cardBackground(for: colorScheme).opacity(0.95))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                )
            }
            .buttonStyle(.plain)

            // Hold / Lock Measurement Button
            Button {
                Haptics.selection()
                isMeasurementLocked.toggle()
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: isMeasurementLocked ? "lock.fill" : "lock.open.fill")
                        .font(IconTheme.actionButton)
                    Text(isMeasurementLocked ? L10n.Tools.unlockedAngle : L10n.Tools.lockAngle)
                        .font(Typography.captionBold)
                }
                .foregroundStyle(isMeasurementLocked ? Color.orange : Theme.textPrimary(for: colorScheme))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .fill(isMeasurementLocked ? Color.orange.opacity(0.15) : Theme.cardBackground(for: colorScheme).opacity(0.95))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(isMeasurementLocked ? Color.orange.opacity(0.5) : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                )
            }
            .buttonStyle(.plain)

            // Save Record Button
            Button {
                tools.saveCurrentCaliperMeasurement()
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "tray.and.arrow.down.fill")
                        .font(IconTheme.actionButton)
                    Text(L10n.Tools.saveRecord)
                        .font(Typography.captionBold)
                }
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .fill(appState.accentColor)
                )
            }
            .buttonStyle(.plain)

            // History Sheet Button
            Button {
                Haptics.selection()
                showHistorySheet = true
            } label: {
                Image(systemName: "list.bullet.circle.fill")
                    .font(IconTheme.actionButton)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .fill(Theme.cardBackground(for: colorScheme).opacity(0.95))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                    )
            }
            .buttonStyle(.plain)
        }
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
                                    .foregroundStyle(appState.accentColor)
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
            .navigationTitle(L10n.Tools.historyRecords)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.Common.done) {
                        showHistorySheet = false
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ScreenRulerDetailView()
    }
}
