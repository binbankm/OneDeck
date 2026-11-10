//
//  BleRadarDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Bluetooth Low Energy (BLE) proximity and RSSI radar workspace.
//

import SwiftUI

struct BleRadarDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var tools = ToolsViewModel.shared

    @State private var radarSweepAngle: Double = 0.0

    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: SpacingTheme.cardStack) {
                bleStatusBanner

                // Dual KPI Hero Cards
                dualMetricsHero

                // Circular Proximity Radar Dial
                radarDialView

                // Discovered Devices List
                devicesListCard

                // Toggle Scan Action Button
                scanActionButton
            }
            .frame(maxWidth: LayoutTheme.maxContentWidth)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, SpacingTheme.cardStack)
            .padding(.vertical, SpacingTheme.rowStandard)
        }
        .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.bleRadar)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView(tool: .bleRadar)
            tools.startBleRadar()
        }
        .onChange(of: tools.bleRadar.isScanning) { _, scanning in
            if !scanning {
                var transaction = Transaction(animation: nil)
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    radarSweepAngle = 0.0
                }
            }
        }
        .onDisappear {
            var transaction = Transaction(animation: nil)
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                radarSweepAngle = 0.0
            }
            tools.stopBleRadar()
            tools.leaveDetailView()
        }
    }

    // MARK: - Bluetooth Authorization & Hardware Status
    @ViewBuilder
    private var bleStatusBanner: some View {
        switch tools.bleBannerStatus {
        case .unauthorized:
            ToolPermissionDeniedBanner(
                icon: "hand.raised.fill",
                message: L10n.Tools.bleUnauthorized,
                onOpenSettings: tools.openAppSettings
            )
        case .poweredOff:
            ToolNoticeBanner(icon: "bluetooth", message: L10n.Tools.blePoweredOff)
        case .unsupported:
            ToolNoticeBanner(icon: "exclamationmark.triangle.fill", message: L10n.Tools.bleHardwareUnavailable)
        case .normal:
            EmptyView()
        }
    }

    // MARK: - Dual Metrics Hero
    @ViewBuilder
    private var dualMetricsHero: some View {
        let cyanAccent = Theme.readableCyan(for: colorScheme)
        let nearestName = tools.bleRadar.nearestDeviceName.isEmpty ? L10n.Tools.noNearbyDevices : tools.bleRadar.nearestDeviceName
        let safeDist = tools.bleRadar.estimatedDistanceMeters.isFinite ? tools.bleRadar.estimatedDistanceMeters : 0.0
        let distText = tools.bleRadar.devices.isEmpty ? "--" : String(format: "~%.1f m", safeDist)
        let rssiText = tools.bleRadar.devices.isEmpty ? "-- dBm" : "\(tools.bleRadar.nearestDeviceRssi) dBm"

        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: SpacingTheme.standard))
            : AnyLayout(HStackLayout(spacing: SpacingTheme.standard))

        layout {
            // Discovered Count Tile
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.bleScanStatus)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text("\(tools.bleRadar.devices.count)")
                    .font(Typography.heroSubValueMono)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .foregroundStyle(cyanAccent)
                    .lineLimit(1)

                Text(nearestName)
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
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
            .accessibilityLabel(L10n.Tools.bleScanStatus)
            .accessibilityValue("\(tools.bleRadar.devices.count), \(nearestName)")

            // Nearest Proximity Tile
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.nearestDevice)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(distText)
                    .font(Typography.heroSubValueMono)
                    .monospacedDigit()
                    .foregroundStyle(cyanAccent)
                    .lineLimit(1)

                Text(rssiText)
                    .font(Typography.captionMono)
                    .monospacedDigit()
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
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
            .accessibilityLabel(L10n.Tools.nearestDevice)
            .accessibilityValue("\(distText), \(rssiText)")
        }
    }

    // MARK: - Circular Proximity Radar Dial
    @ViewBuilder
    private var radarDialView: some View {
        let size: CGFloat = 220
        let cyanAccent = Theme.readableCyan(for: colorScheme)
        let greenAccent = Theme.readableGreen(for: colorScheme)
        let nearestName = tools.bleRadar.nearestDeviceName.isEmpty ? L10n.Tools.noNearbyDevices : tools.bleRadar.nearestDeviceName

        ZStack {
            // Concentric Range Rings (1m, 3m, 5m, 10m)
            ForEach([0.3, 0.55, 0.8, 1.0], id: \.self) { factor in
                Circle()
                    .stroke(cyanAccent.opacity(0.22), lineWidth: 1)
                    .frame(width: size * factor, height: size * factor)
            }

            // Crosshairs
            Path { p in
                p.move(to: CGPoint(x: size / 2, y: 0))
                p.addLine(to: CGPoint(x: size / 2, y: size))
                p.move(to: CGPoint(x: 0, y: size / 2))
                p.addLine(to: CGPoint(x: size, y: size / 2))
            }
            .stroke(cyanAccent.opacity(0.14), lineWidth: 1)
            .frame(width: size, height: size)

            // Radar Rotating Sweep Cone
            if tools.bleRadar.isScanning {
                Circle()
                    .fill(
                        AngularGradient(
                            colors: [cyanAccent.opacity(0.32), cyanAccent.opacity(0.0)],
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(75)
                        )
                    )
                    .frame(width: size, height: size)
                    .rotationEffect(.degrees(radarSweepAngle))
                    .onAppear {
                        withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                            radarSweepAngle = 360.0
                        }
                    }
            }

            // Center Origin (This Device)
            Circle()
                .fill(cyanAccent)
                .frame(width: 8, height: 8)

            // Device Blips
            ForEach(Array(tools.bleRadar.devices.prefix(8).enumerated()), id: \.element.id) { idx, dev in
                let safeDistance = dev.estimatedDistanceMeters.isFinite ? dev.estimatedDistanceMeters : 12.0
                let distNorm = min(1.0, max(0.15, safeDistance / 12.0))
                let angle = Double(idx) * (360.0 / Double(max(1, min(8, tools.bleRadar.devices.count))))
                let radius = (size / 2.0) * distNorm * 0.9
                let rad = angle * .pi / 180.0
                let x = radius * cos(rad)
                let y = radius * sin(rad)

                Circle()
                    .fill(greenAccent)
                    .frame(width: 7, height: 7)
                    .shadow(color: greenAccent.opacity(0.8), radius: 4)
                    .offset(x: x, y: y)
            }
        }
        .frame(width: size, height: size)
        .padding(.vertical, SpacingTheme.standard)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.Tools.bleRadar)
        .accessibilityValue("\(tools.bleRadar.devices.count), \(nearestName)")
    }

    // MARK: - Discovered Devices List
    @ViewBuilder
    private var devicesListCard: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            HStack {
                Text("\(L10n.Tools.blePeripheralsList) (\(tools.bleRadar.devices.count))")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))

                Spacer()

                if tools.bleRadar.isScanning && !tools.bleRadar.devices.isEmpty {
                    ProgressView()
                        .controlSize(.small)
                        .tint(Theme.readableCyan(for: colorScheme))
                }
            }

            if tools.bleRadar.devices.isEmpty {
                BentoEmptyStateView(
                    icon: "antenna.radiowaves.left.and.right",
                    message: tools.bleRadar.isScanning ? L10n.Tools.bleScanning : L10n.Tools.blePaused,
                    showsProgress: tools.bleRadar.isScanning,
                    height: 100
                )
            } else {
                ForEach(tools.bleRadar.devices) { dev in
                    deviceRow(dev: dev)
                    if dev.id != tools.bleRadar.devices.last?.id {
                        BentoHairlineDivider()
                    }
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

    @ViewBuilder
    private func deviceRow(dev: BleDeviceItem) -> some View {
        let cyanAccent = Theme.readableCyan(for: colorScheme)
        let safeDist = dev.estimatedDistanceMeters.isFinite ? dev.estimatedDistanceMeters : 0.0
        let distString = String(format: "~%.1f m", safeDist)
        let rssiString = "\(dev.rssi) dBm"

        Group {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                    Text(dev.name)
                        .font(Typography.captionBold)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .fixedSize(horizontal: false, vertical: true)

                    Text("\(distString) · \(rssiString)")
                        .font(Typography.captionMono)
                        .foregroundStyle(cyanAccent)

                    Text(dev.id.uuidString.prefix(18) + "...")
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(Theme.textTertiary(for: colorScheme))
                }
            } else {
                HStack(spacing: SpacingTheme.standard) {
                    Image(systemName: "sensor.tag.radiowaves.forward.fill")
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(cyanAccent)
                        .frame(width: 22)
                        .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                        Text(dev.name)
                            .font(Typography.captionBold)
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)

                        Text(dev.id.uuidString.prefix(18) + "...")
                            .font(Typography.badgeTagMono)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    }

                    Spacer(minLength: SpacingTheme.compact)

                    VStack(alignment: .trailing, spacing: SpacingTheme.micro) {
                        Text(distString)
                            .font(Typography.captionMono)
                            .monospacedDigit()
                            .foregroundStyle(cyanAccent)

                        Text(rssiString)
                            .font(Typography.badgeTagMono)
                            .monospacedDigit()
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget, alignment: .leading)
        .padding(.vertical, SpacingTheme.tight)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(dev.name)
        .accessibilityValue("\(distString), \(rssiString)")
    }

    // MARK: - Toggle Scan Action Button
    @ViewBuilder
    private var scanActionButton: some View {
        let cyanAccent = Theme.readableCyan(for: colorScheme)
        let redAccent = Theme.readableRed(for: colorScheme)
        let buttonBg = tools.bleRadar.isScanning ? redAccent : cyanAccent
        let buttonFg = Theme.contrastingForeground(for: buttonBg)

        Button {
            Haptics.selection()
            if tools.bleRadar.isScanning {
                tools.stopBleRadar()
            } else {
                tools.startBleRadar()
            }
        } label: {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: tools.bleRadar.isScanning ? "stop.circle.fill" : "play.circle.fill")
                    .font(IconTheme.actionButton)
                    .accessibilityHidden(true)
                Text(tools.bleRadar.isScanning ? L10n.Tools.stopBleRadarAction : L10n.Tools.startBleRadarAction)
                    .font(Typography.captionBold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .foregroundStyle(buttonFg)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(buttonBg)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        BleRadarDetailView()
    }
}
