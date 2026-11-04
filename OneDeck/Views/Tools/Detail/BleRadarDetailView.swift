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
                    .foregroundStyle(Color.cyan)
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

                Text(tools.bleRadar.devices.isEmpty ? "--" : String(format: "~%.1f m", tools.bleRadar.estimatedDistanceMeters))
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(Color.cyan)
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

        ZStack {
            // Concentric Range Rings (1m, 3m, 5m, 10m)
            ForEach([0.3, 0.55, 0.8, 1.0], id: \.self) { factor in
                Circle()
                    .stroke(Color.cyan.opacity(0.2), lineWidth: 1)
                    .frame(width: size * factor, height: size * factor)
            }

            // Crosshairs
            Path { p in
                p.move(to: CGPoint(x: size / 2, y: 0))
                p.addLine(to: CGPoint(x: size / 2, y: size))
                p.move(to: CGPoint(x: 0, y: size / 2))
                p.addLine(to: CGPoint(x: size, y: size / 2))
            }
            .stroke(Color.cyan.opacity(0.12), lineWidth: 1)
            .frame(width: size, height: size)

            // Radar Rotating Sweep Cone
            if tools.bleRadar.isScanning {
                Circle()
                    .fill(
                        AngularGradient(
                            colors: [Color.cyan.opacity(0.3), Color.cyan.opacity(0.0)],
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
                .fill(Color.cyan)
                .frame(width: 8, height: 8)

            // Device Blips
            ForEach(Array(tools.bleRadar.devices.prefix(8).enumerated()), id: \.element.id) { idx, dev in
                let distNorm = min(1.0, max(0.15, dev.estimatedDistanceMeters / 12.0))
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
        HStack(spacing: SpacingTheme.standard) {
            Image(systemName: "sensor.tag.radiowaves.forward.fill")
                .font(IconTheme.badgeInline)
                .foregroundStyle(Color.cyan)
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
                Text(String(format: "~%.1f m", dev.estimatedDistanceMeters))
                    .font(Typography.captionMono)
                    .foregroundStyle(Color.cyan)

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
            .foregroundStyle(Color.black)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(tools.bleRadar.isScanning ? Color.red : Color.cyan)
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
