//
//  BleScannerProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Bluetooth Low Energy (BLE) RSSI Proximity Radar Hardware Probe.
//

import Foundation
import CoreBluetooth

public final class BleScannerProbe: NSObject, CBCentralManagerDelegate, @unchecked Sendable {
    public static let shared = BleScannerProbe()

    private var centralManager: CBCentralManager?
    private var isScanning: Bool = false
    private let bleQueue = DispatchQueue(label: "com.onedeck.ble.queue")

    private var trackedPeripherals: [UUID: BleDeviceItem] = [:]
    private var onUpdate: ((_ data: BleRadarData) -> Void)?

    private override init() {
        super.init()
    }

    public func startScanning(onUpdate: @escaping (BleRadarData) -> Void) {
        guard !isScanning else { return }
        self.onUpdate = onUpdate
        self.isScanning = true
        self.trackedPeripherals.removeAll()

        if centralManager == nil {
            centralManager = CBCentralManager(delegate: self, queue: bleQueue)
        } else if centralManager?.state == .poweredOn {
            centralManager?.scanForPeripherals(
                withServices: nil,
                options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]
            )
        }
    }

    public func stopScanning() {
        guard isScanning else { return }
        isScanning = false
        centralManager?.stopScan()
        onUpdate = nil
    }

    // MARK: - CBCentralManagerDelegate
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn && isScanning {
            central.scanForPeripherals(
                withServices: nil,
                options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]
            )
        }
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        guard isScanning else { return }

        let rssiVal = RSSI.intValue
        guard rssiVal < 0 && rssiVal > -110 else { return }

        let name = peripheral.name ?? (advertisementData[CBAdvertisementDataLocalNameKey] as? String) ?? "BLE Peripheral"

        // Log-Distance Path Loss Model for Distance Estimation
        // d = 10 ^ ((MeasuredPower - RSSI) / (10 * n))
        // Baseline measured power at 1 meter ≈ -59 dBm, path loss exponent n ≈ 2.2
        let measuredPower = -59.0
        let pathLossExponent = 2.2
        let ratio = (measuredPower - Double(rssiVal)) / (10.0 * pathLossExponent)
        let estimatedDistance = max(0.1, pow(10.0, ratio))

        let item = BleDeviceItem(
            id: peripheral.identifier,
            name: name,
            rssi: rssiVal,
            distanceEstimateM: estimatedDistance,
            lastSeen: Date()
        )

        trackedPeripherals[peripheral.identifier] = item

        // Remove stale devices (> 8s without packets)
        let now = Date()
        trackedPeripherals = trackedPeripherals.filter { now.timeIntervalSince($0.value.lastSeen) < 8.0 }

        let sorted = trackedPeripherals.values.sorted { $0.rssi > $1.rssi }
        let nearest = sorted.first

        let result = BleRadarData(
            discoveredDevices: Array(sorted.prefix(25)),
            isScanning: true,
            nearestDeviceName: nearest?.name ?? "--",
            strongestRssi: nearest?.rssi ?? -100
        )

        Task { @MainActor [weak self] in
            guard let self = self, self.isScanning else { return }
            self.onUpdate?(result)
        }
    }
}

