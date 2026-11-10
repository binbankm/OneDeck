//
//  BleScannerProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Bluetooth Low Energy (BLE) proximity and RSSI scanning probe.
//

import CoreBluetooth
import Foundation
import os

public final class BleScannerProbe: NSObject, CBCentralManagerDelegate, @unchecked Sendable {
    public static let shared = BleScannerProbe()

    private struct ScannerState: Sendable {
        var isScanning: Bool = false
        var isPowerSaving: Bool = false
        var bluetoothState: CBManagerState = .unknown
        var trackedPeripherals: [UUID: BleDeviceItem] = [:]
        var lastDispatchTime: Date = .distantPast
        var onUpdate: (@MainActor @Sendable (_ data: BleRadarData) -> Void)?
    }

    private let stateLock = OSAllocatedUnfairLock(initialState: ScannerState())
    private let bleQueue = DispatchQueue(label: "com.onedeck.ble.queue")
    private nonisolated(unsafe) var centralManager: CBCentralManager?
    private nonisolated(unsafe) var pruneTimer: DispatchSourceTimer?

    public nonisolated var isScanning: Bool {
        stateLock.withLock { $0.isScanning }
    }

    public nonisolated func setPowerSaving(_ isPowerSaving: Bool) {
        stateLock.withLock { $0.isPowerSaving = isPowerSaving }
    }

    override private init() {
        super.init()
    }

    public nonisolated func startScanning(
        isPowerSaving: Bool = false,
        onUpdate: @escaping @MainActor @Sendable (BleRadarData) -> Void
    ) {
        let shouldStart: Bool = stateLock.withLock { state in
            state.onUpdate = onUpdate
            state.isPowerSaving = isPowerSaving
            if state.isScanning { return false }
            state.isScanning = true
            state.lastDispatchTime = .distantPast
            state.trackedPeripherals.removeAll()
            return true
        }
        guard shouldStart else { return }

        bleQueue.async { [weak self] in
            guard let self else { return }
            self.startPruneTimer()
            if self.centralManager == nil {
                self.centralManager = CBCentralManager(delegate: self, queue: self.bleQueue)
            } else if let central = self.centralManager {
                let btState = central.state
                self.stateLock.withLock { $0.bluetoothState = btState }
                if btState == .poweredOn {
                    central.scanForPeripherals(
                        withServices: nil,
                        options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]
                    )
                    self.emitSnapshot(force: true)
                } else {
                    self.emitSnapshot(force: true)
                }
            }
        }
    }

    public nonisolated func stopScanning() {
        let wasScanning: Bool = stateLock.withLock { state in
            let prev = state.isScanning
            state.isScanning = false
            state.onUpdate = nil
            state.trackedPeripherals.removeAll()
            return prev
        }
        guard wasScanning else { return }

        bleQueue.async { [weak self] in
            guard let self else { return }
            self.pruneTimer?.cancel()
            self.pruneTimer = nil
            if self.centralManager?.state == .poweredOn {
                self.centralManager?.stopScan()
            }
        }
    }

    // MARK: - CBCentralManagerDelegate
    public nonisolated func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let btState = central.state
        let isScanning = stateLock.withLock { state -> Bool in
            state.bluetoothState = btState
            if btState == .poweredOff || btState == .unauthorized || btState == .unsupported {
                state.trackedPeripherals.removeAll()
            }
            return state.isScanning
        }

        if btState == .poweredOn && isScanning {
            central.scanForPeripherals(
                withServices: nil,
                options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]
            )
        }

        emitSnapshot(force: true)
    }

    public nonisolated func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi RSSI: NSNumber
    ) {
        let rssiVal = RSSI.intValue
        guard rssiVal < 0 && rssiVal > -110 else { return }

        let name = peripheral.name ?? (advertisementData[CBAdvertisementDataLocalNameKey] as? String) ?? ""

        // Log-Distance Path Loss Model (Baseline @ 1m ≈ -59 dBm, n = 2.2)
        let measuredPower = -59.0
        let pathLossExponent = 2.2
        let ratio = (measuredPower - Double(rssiVal)) / (10.0 * pathLossExponent)
        let estimatedDistance = max(0.1, pow(10.0, ratio))

        let now = Date()
        let item = BleDeviceItem(
            id: peripheral.identifier,
            name: name,
            rssi: rssiVal,
            distanceEstimateM: estimatedDistance,
            lastSeen: now
        )

        let payload: (BleRadarData, (@MainActor @Sendable (BleRadarData) -> Void)?)? = stateLock.withLock { state in
            guard state.isScanning else { return nil }
            state.trackedPeripherals[peripheral.identifier] = item

            let minInterval = state.isPowerSaving ? 0.30 : 0.12
            guard now.timeIntervalSince(state.lastDispatchTime) >= minInterval else { return nil }
            state.lastDispatchTime = now

            // Prune stale peripherals not seen in the last 2.0 seconds
            state.trackedPeripherals = state.trackedPeripherals.filter { now.timeIntervalSince($0.value.lastSeen) < 2.0 }

            let sorted = state.trackedPeripherals.values.sorted { $0.rssi > $1.rssi }
            let nearest = sorted.first
            let data = BleRadarData(
                discoveredDevices: Array(sorted.prefix(25)),
                isScanning: state.bluetoothState == .poweredOn,
                nearestDeviceName: nearest?.name ?? "--",
                strongestRssi: nearest?.rssi ?? -100,
                bluetoothState: state.bluetoothState
            )
            return (data, state.onUpdate)
        }

        if let (result, callback) = payload {
            Task { @MainActor [weak self] in
                guard let self, self.stateLock.withLock({ $0.isScanning }) else { return }
                callback?(result)
            }
        }
    }

    private nonisolated func startPruneTimer() {
        pruneTimer?.cancel()
        let timer = DispatchSource.makeTimerSource(queue: bleQueue)
        timer.schedule(deadline: .now() + 2.0, repeating: 1.5)
        timer.setEventHandler { [weak self] in
            guard let self else { return }
            let now = Date()
            let didPrune: Bool = self.stateLock.withLock { state in
                guard state.isScanning else { return false }
                let beforeCount = state.trackedPeripherals.count
                state.trackedPeripherals = state.trackedPeripherals.filter { now.timeIntervalSince($0.value.lastSeen) < 2.0 }
                return state.trackedPeripherals.count != beforeCount
            }
            if didPrune {
                self.emitSnapshot(force: true)
            }
        }
        timer.resume()
        pruneTimer = timer
    }

    private nonisolated func emitSnapshot(force: Bool) {
        let payload: (BleRadarData, (@MainActor @Sendable (BleRadarData) -> Void)?)? = stateLock.withLock { state in
            guard let callback = state.onUpdate else { return nil }
            let sorted = state.trackedPeripherals.values.sorted { $0.rssi > $1.rssi }
            let nearest = sorted.first
            let activeScanning = state.isScanning && state.bluetoothState == .poweredOn
            let data = BleRadarData(
                discoveredDevices: Array(sorted.prefix(25)),
                isScanning: activeScanning,
                nearestDeviceName: nearest?.name ?? "--",
                strongestRssi: nearest?.rssi ?? -100,
                bluetoothState: state.bluetoothState
            )
            if force {
                state.lastDispatchTime = Date()
            }
            return (data, callback)
        }

        if let (result, callback) = payload {
            Task { @MainActor [weak self] in
                guard let self, self.stateLock.withLock({ $0.isScanning }) else { return }
                callback?(result)
            }
        }
    }
}
