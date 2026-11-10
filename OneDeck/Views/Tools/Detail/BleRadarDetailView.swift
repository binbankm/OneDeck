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
    @Bindable private var appState = AppState.shared
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
            .padding(.horizontal, SpacingTheme.cardStack)
            .padding(.vertical, SpacingTheme.rowStandard)
        }
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
            VStack(spacing: SpacingTheme.compact) {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "hand.raised.fill")
                        .foregroundStyle(Color.orange)
                    Text(L10n.Tools.bleUnauthorized)
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
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.85))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .stroke(Color.orange.opacity(0.4), lineWidth: 0.8)
            )
        case .poweredOff:
            bleNoticeRow(icon: "bluetooth", message: L10n.Tools.blePoweredOff)
        case .unsupported:
            bleNoticeRow(icon: "exclamationmark.triangle.fill", message: L10n.Tools.bleHardwareUnavailable)
        case .normal:
            EmptyView()
        }
    }

    @ViewBuilder
    private func bleNoticeRow(icon: String, message: String) -> some View {
        HStack(spacing: SpacingTheme.tight) {
            Image(systemName: icon)
                .foregroundStyle(Color.orange)
            Text(message)
                .font(Typography.caption)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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

    // MARK: - Dual Metrics Hero
    @ViewBuilder
    private var dualMetricsHero: some View {
        HStack(spacing: SpacingTheme.standard) {
            // Discovered Count Tile
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.bleScanStatus)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text("\(tools.bleRadar.devices.count)")
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(Theme.readableCyan(for: colorScheme))
                    .lineLimit(1)

                Text(tools.bleRadar.nearestDeviceName.isEmpty ? L10n.Tools.noNearbyDevices : tools.bleRadar.nearestDeviceName)
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(SpacingTheme.rowStandard)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
            )

            // Nearest Proximity Tile
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.nearestDevice)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                let safeDist = tools.bleRadar.estimatedDistanceMeters.isFinite ? tools.bleRadar.estimatedDistanceMeters : 0.0
                Text(tools.bleRadar.devices.isEmpty ? "--" : String(format: "~%.1f m", safeDist))
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(Theme.readableCyan(for: colorScheme))
                    .lineLimit(1)

                Text(tools.bleRadar.devices.isEmpty ? "-- dBm" : "\(tools.bleRadar.nearestDeviceRssi) dBm")
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(SpacingTheme.rowStandard)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
            )
        }
    }

    // MARK: - Circular Proximity Radar Dial
    @ViewBuilder
    private var radarDialView: some View {
        let size: CGFloat = 220
        let cyanAccent = Theme.readableCyan(for: colorScheme)

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
                    .fill(Color.green)
                    .frame(width: 7, height: 7)
                    .shadow(color: Color.green.opacity(0.8), radius: 4)
                    .offset(x: x, y: y)
            }
        }
        .frame(width: size, height: size)
        .padding(.vertical, SpacingTheme.standard)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
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

                if tools.bleRadar.isScanning {
                    ProgressView()
                        .scaleEffect(0.7)
                }
            }

            if tools.bleRadar.devices.isEmpty {
                Text(tools.bleRadar.isScanning ? L10n.Tools.bleScanning : L10n.Tools.blePaused)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, SpacingTheme.rowStandard)
            } else {
                ForEach(tools.bleRadar.devices) { dev in
                    deviceRow(dev: dev)
                    if dev.id != tools.bleRadar.devices.last?.id {
                        Divider()
                            .foregroundStyle(Theme.cardBorder(for: colorScheme))
                    }
                }
            }
        }
        .padding(SpacingTheme.rowStandard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
    }

    @ViewBuilder
    private func deviceRow(dev: BleDeviceItem) -> some View {
        let cyanAccent = Theme.readableCyan(for: colorScheme)
        let safeDist = dev.estimatedDistanceMeters.isFinite ? dev.estimatedDistanceMeters : 0.0
        HStack(spacing: SpacingTheme.standard) {
            Image(systemName: "sensor.tag.radiowaves.forward.fill")
                .font(IconTheme.badgeInline)
                .foregroundStyle(cyanAccent)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                Text(dev.name)
                    .font(Typography.captionBold)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))

                Text(dev.id.uuidString.prefix(18) + "...")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: SpacingTheme.micro) {
                Text(String(format: "~%.1f m", safeDist))
                    .font(Typography.captionMono)
                    .foregroundStyle(cyanAccent)

                Text("\(dev.rssi) dBm")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }
        }
        .padding(.vertical, SpacingTheme.compact)
    }

    // MARK: - Toggle Scan Action Button
    @ViewBuilder
    private var scanActionButton: some View {
        let cyanAccent = Theme.readableCyan(for: colorScheme)
        let buttonBg = tools.bleRadar.isScanning ? Color.red : cyanAccent
        let buttonFg = tools.bleRadar.isScanning ? Color.white : Theme.contrastingForeground(for: cyanAccent)

        Button {
            if tools.bleRadar.isScanning {
                tools.stopBleRadar()
            } else {
                tools.startBleRadar()
            }
        } label: {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: tools.bleRadar.isScanning ? "stop.circle.fill" : "play.circle.fill")
                    .font(IconTheme.actionButton)
                Text(tools.bleRadar.isScanning ? L10n.Tools.stopBleRadarAction : L10n.Tools.startBleRadarAction)
                    .font(Typography.captionBold)
            }
            .foregroundStyle(buttonFg)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(buttonBg)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        BleRadarDetailView()
    }
}
