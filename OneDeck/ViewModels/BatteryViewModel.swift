//
//  BatteryViewModel.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Battery hardware telemetry, charging states, and health monitoring view model.
//

import Observation
import SwiftUI
import UIKit

// MARK: - Battery ViewModel Hub
@Observable
public final class BatteryViewModel {
    @MainActor public static let shared = BatteryViewModel()

    // MARK: - Real-time Telemetry
    public var batteryLevel: Double = 1.0 // 0.0 - 1.0
    public var isBatteryLevelAvailable: Bool = true
    public var batteryLevelPercent: Int { Int(round(batteryLevel * 100)) }
    public var batteryState: UIDevice.BatteryState = .unplugged
    public var isLowPowerMode: Bool = false
    public var batteryTemperature: Double = 28.5 // Celsius
    public var isThermalEstimated: Bool = false

    // Power Flow Modeling
    public var liveWattage: Double = 0.0 // W (+ when charging, - when discharging)
    public var liveVoltageMv: Int = 4150 // mV
    public var liveCurrentMa: Int = 0 // mA (+ when charging, - when discharging)
    public var chargingProtocolName: String = "--"
    public var etaCountdownString: String = "--"
    public private(set) var isPluggedIn: Bool = false

    // Hardware Probe Telemetry (IOPS & AppleSmartBattery Direct Access)
    public var isHardwareDirectWattage: Bool = false
    public var adapterWatts: Int?
    public var adapterVoltageMv: Int?
    public var adapterCurrentMa: Int?
    public var adapterName: String?
    public var pathLossWatts: Double = 0.0
    public var hardwareCycleCount: Int?
    public var hardwareMaxCapacityMah: Int?
    public var hardwareDesignCapacityMah: Int?
    public var batterySerialNumber: String?
    public var cellVoltages: [Int] = []
    public var hardwarePmicTemp: Double?
    public var hardwareWirelessTemp: Double?
    public var batteryChemistry: String?
    public var batteryManufactureDate: String?

    public var isHardwareCycleDirect: Bool {
        analyticsRecord == nil && (hardwareCycleCount ?? 0) > 0
    }

    public var hasRealTelemetry: Bool {
        analyticsRecord != nil || isHardwareCycleDirect || (hardwareCycleCount ?? 0) > 0 || (hardwareMaxCapacityMah ?? 0) > 500
    }

    // Hardware Database & Capacities
    public var officialDesignCapacityMah: Int = 2658
    public var isCustomBattery: Bool = false
    public var customCapacityMah: Int = 3000

    public var effectiveDesignCapacityMah: Int {
        isCustomBattery ? customCapacityMah : officialDesignCapacityMah
    }

    public var currentRemainingMah: Int {
        Int(Double(effectiveDesignCapacityMah) * batteryLevel)
    }

    // Official Analytics Log Diagnostic Record
    public var analyticsRecord: BatteryAnalyticsRecord?
    public var hasImportedBMS: Bool { analyticsRecord != nil }

    public var cycleCountDisplay: Int {
        if let record = analyticsRecord {
            return record.cycleCount
        }
        if let hwCycles = hardwareCycleCount, hwCycles > 0 {
            return hwCycles
        }
        return 0
    }

    public var healthPercentDisplay: Double {
        if let record = analyticsRecord {
            if isCustomBattery {
                return min(100.0, (Double(actualMaxCapacityMahDisplay) / Double(effectiveDesignCapacityMah)) * 100.0)
            }
            return min(100.0, record.healthPercent)
        }
        if let hwMax = hardwareMaxCapacityMah, hwMax > 500 {
            let h = (Double(hwMax) / Double(effectiveDesignCapacityMah)) * 100.0
            return min(100.0, max(1.0, h))
        }
        return 0.0
    }

    public var actualMaxCapacityMahDisplay: Int {
        if let record = analyticsRecord {
            return record.nominalChargeCapacityMah
        }
        if let hwMax = hardwareMaxCapacityMah, hwMax > 500 {
            return hwMax
        }
        return 0
    }

    // Power History Sparkline (Rolling 30s)
    public var powerHistory: [MetricPoint] = []

    // MARK: - Private State
    private var timer: Timer?
    private var isMonitoring: Bool = false
    private var samplingTask: Task<Void, Never>?
    private var lastIsPluggedIn: Bool = false
    private var lastIsFullyCharged: Bool = false
    private let userDefaultsKeys = (
        customEnabled: "onedeck_battery_custom_enabled",
        customCapacity: "onedeck_battery_custom_mah",
        analyticsData: "onedeck_battery_analytics_json"
    )

    // MARK: - Init
    private init() {
        loadPersistedSettings()
        resolveDeviceDesignCapacity()
    }

    // MARK: - Lifecycle Monitoring
    @MainActor
    public func startMonitoring() {
        guard !isMonitoring else { return }
        isMonitoring = true

        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBatteryChange),
            name: UIDevice.batteryLevelDidChangeNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBatteryChange),
            name: UIDevice.batteryStateDidChangeNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePowerModeChange),
            name: NSNotification.Name.NSProcessInfoPowerStateDidChange,
            object: nil
        )

        scheduleAsyncTelemetrySnapshot()
        scheduleTelemetryTimer()
    }

    @MainActor
    public func applyPowerSavingPreference() {
        guard isMonitoring else { return }
        scheduleTelemetryTimer()
        scheduleAsyncTelemetrySnapshot(force: true)
    }

    @MainActor
    private func scheduleTelemetryTimer() {
        timer?.invalidate()
        let interval: TimeInterval = AppState.shared.isSensorPowerSaving ? 4.0 : 1.5
        let scheduledTimer = Timer(timeInterval: interval, repeats: true) { [weak self] _ in
            self?.scheduleAsyncTelemetrySnapshot()
        }
        RunLoop.main.add(scheduledTimer, forMode: .common)
        timer = scheduledTimer
    }

    @MainActor
    public func refreshLocalizedStrings() {
        updateLocalizedPowerStrings(isPluggedIn: lastIsPluggedIn, isFullyCharged: lastIsFullyCharged)
    }

    @MainActor
    public func stopMonitoring() {
        isMonitoring = false
        timer?.invalidate()
        timer = nil
        samplingTask?.cancel()
        samplingTask = nil
        UIDevice.current.isBatteryMonitoringEnabled = false
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Telemetry Engine
    @MainActor
    @objc private func handleBatteryChange() {
        scheduleAsyncTelemetrySnapshot()
    }

    @MainActor
    @objc private func handlePowerModeChange() {
        self.isLowPowerMode = ProcessInfo.processInfo.isLowPowerModeEnabled
        scheduleAsyncTelemetrySnapshot()
    }

    @MainActor
    public func updateTelemetrySnapshot(force: Bool = false) {
        scheduleAsyncTelemetrySnapshot(force: force)
    }

    private func scheduleAsyncTelemetrySnapshot(force: Bool = false) {
        guard force || isMonitoring else { return }
        samplingTask?.cancel()
        samplingTask = Task.detached(priority: .utility) { [weak self] in
            let hw = HardwareBatteryProbe.sample()
            if Task.isCancelled { return }
            await MainActor.run { [weak self] in
                guard let self, force || self.isMonitoring else { return }
                self.applyTelemetrySnapshot(hw: hw)
            }
        }
    }

    @MainActor
    private func applyTelemetrySnapshot(hw: HardwareBatteryTelemetry) {
        // 1. Battery Percentage
        if let cur = hw.currentCapacityMah, let maxCap = hw.maxCapacityMah, maxCap > 0 {
            self.batteryLevel = min(1.0, max(0.0, Double(cur) / Double(maxCap)))
            self.isBatteryLevelAvailable = true
        } else {
            let rawLevel = UIDevice.current.batteryLevel
            if rawLevel >= 0 {
                self.batteryLevel = Double(rawLevel)
                self.isBatteryLevelAvailable = true
            } else {
                self.batteryLevel = 0.0
                self.isBatteryLevelAvailable = false
            }
        }

        // 3. Hardware Cell Attributes
        if let cyc = hw.cycleCount, cyc > 0 { self.hardwareCycleCount = cyc }
        if let maxCap = hw.maxCapacityMah, maxCap > 500 { self.hardwareMaxCapacityMah = maxCap }
        if let desCap = hw.designCapacityMah, desCap > 500 { self.hardwareDesignCapacityMah = desCap }
        if let sn = hw.batterySerialNumber, !sn.isEmpty { self.batterySerialNumber = sn }
        if let cells = hw.cellVoltages, !cells.isEmpty { self.cellVoltages = cells }
        if let chem = hw.chemistry { self.batteryChemistry = chem }
        if let mDate = hw.manufactureDate { self.batteryManufactureDate = mDate }

        // 4. State & Thermal
        self.batteryState = UIDevice.current.batteryState
        self.isLowPowerMode = ProcessInfo.processInfo.isLowPowerModeEnabled
        if let hwTemp = hw.temperatureCelsius {
            self.batteryTemperature = hwTemp
            self.isThermalEstimated = false
        } else {
            self.batteryTemperature = SystemService.shared.batteryTemperature
            self.isThermalEstimated = SystemService.shared.isThermalEstimated
        }
        if let soc = hw.socTemperatureCelsius {
            SystemService.shared.socTemperature = soc
        }
        if let p = hw.pmicTemperatureCelsius { self.hardwarePmicTemp = p }
        if let w = hw.wirelessTemperatureCelsius { self.hardwareWirelessTemp = w }

        // 5. Adapter Details (Charger Watts & Profile)
        self.adapterWatts = hw.adapterWatts
        self.adapterVoltageMv = hw.adapterVoltageMv
        self.adapterCurrentMa = hw.adapterCurrentMa
        self.adapterName = hw.adapterName

        let isPluggedIn = (batteryState == .charging || batteryState == .full || hw.isExternalConnected == true || hw.adapterWatts != nil)
        let isFullyCharged = (batteryState == .full || hw.isFullyCharged == true)
        self.isPluggedIn = isPluggedIn
        self.lastIsPluggedIn = isPluggedIn
        self.lastIsFullyCharged = isFullyCharged

        // 6. Voltage & Amperage
        var physicalV = hw.voltageMv ?? 0
        if physicalV <= 2500 {
            // Open-circuit voltage model fallback if hardware register is unreadable
            let chargingIrDrop: Int = isPluggedIn ? 120 : 0
            if isBatteryLevelAvailable {
                let baseV = 3650 + Int(self.batteryLevel * 650.0)
                physicalV = baseV + chargingIrDrop
            } else {
                physicalV = 3800 + chargingIrDrop
            }
        }
        self.liveVoltageMv = physicalV
        let voltageVolts: Double = max(3.0, Double(self.liveVoltageMv) / 1000.0)

        // 7. Power Flow & Protocol Logic
        let hwAmps = hw.instantAmperageMa ?? hw.amperageMa

        if isFullyCharged {
            self.liveCurrentMa = 0
            self.liveWattage = 0.0
            self.isHardwareDirectWattage = (hwAmps != nil)
            self.pathLossWatts = 0.0
        } else if isPluggedIn {
            // Charging or External Power Connected
            if let amps = hwAmps, amps > 0 {
                // Direct hardware physical reading!
                self.liveCurrentMa = amps
                let calculatedW = (Double(physicalV) * Double(amps)) / 1_000_000.0
                self.liveWattage = (calculatedW * 10.0).rounded() / 10.0
                self.isHardwareDirectWattage = true
            } else if let ratedW = hw.adapterWatts, ratedW > 0 {
                // Adapter watts is known from hardware!
                // Compute real continuous USB-PD CV Tapering curve
                self.liveWattage = HardwareBatteryProbe.computeDynamicPDWattage(
                    ratedWatts: ratedW,
                    batteryLevel: self.batteryLevel,
                    temperatureCelsius: self.batteryTemperature
                )
                let currentAmps: Double = self.liveWattage / voltageVolts
                self.liveCurrentMa = Int(currentAmps * 1000.0)
                self.isHardwareDirectWattage = false
            } else {
                // Model fallback when adapter is unclassified
                let defaultRated = self.effectiveDesignCapacityMah >= 3500 ? 27 : 20
                self.liveWattage = HardwareBatteryProbe.computeDynamicPDWattage(
                    ratedWatts: defaultRated,
                    batteryLevel: self.batteryLevel,
                    temperatureCelsius: self.batteryTemperature
                )
                let currentAmps: Double = self.liveWattage / voltageVolts
                self.liveCurrentMa = Int(currentAmps * 1000.0)
                self.isHardwareDirectWattage = false
            }

            if let watts = hw.adapterWatts, watts > 0 {
                let inputW = Double(watts)
                self.pathLossWatts = max(0.0, ((inputW - abs(self.liveWattage)) * 10.0).rounded() / 10.0)
            } else {
                self.pathLossWatts = 0.0
            }
        } else {
            // Discharging on Battery
            if let amps = hwAmps, amps < 0 {
                // Direct hardware physical reading!
                self.liveCurrentMa = amps
                let calculatedW = (Double(physicalV) * Double(amps)) / 1_000_000.0
                self.liveWattage = (calculatedW * 10.0).rounded() / 10.0
                self.isHardwareDirectWattage = true
            } else {
                // Dynamic CPU model fallback
                self.isHardwareDirectWattage = false
                let cpuFactor: Double = SystemService.shared.totalCpuUsage / 100.0
                let lowPowerAdj: Double = isLowPowerMode ? -0.4 : 0.0
                let drainW = 1.2 + (cpuFactor * 3.4) + lowPowerAdj
                let roundedDrain: Double = (drainW * 10.0).rounded() / 10.0
                self.liveWattage = -roundedDrain
                let dischargeAmps: Double = drainW / voltageVolts
                let dischargeMa = Int(dischargeAmps * 1000.0)
                self.liveCurrentMa = -dischargeMa
            }
            self.pathLossWatts = 0.0
        }

        updateLocalizedPowerStrings(isPluggedIn: isPluggedIn, isFullyCharged: isFullyCharged)

        // Rolling 30s Sparkline
        let currentPlotW = abs(liveWattage)
        powerHistory.append(MetricPoint(timestamp: Date(), value: currentPlotW))
        if powerHistory.count > 30 {
            powerHistory.removeFirst(powerHistory.count - 30)
        }
    }

    @MainActor
    private func updateLocalizedPowerStrings(isPluggedIn: Bool, isFullyCharged: Bool) {
        if isFullyCharged {
            self.chargingProtocolName = L10n.Battery.stateFull
            self.etaCountdownString = L10n.Battery.fullyChargedText
        } else if isPluggedIn {
            if let watts = adapterWatts, watts > 0 {
                if watts <= 6 {
                    self.chargingProtocolName = L10n.Battery.adapterTypeSlow
                } else if let name = adapterName, name.lowercased().contains("wireless") || name.lowercased().contains("magsafe") {
                    self.chargingProtocolName = L10n.Battery.adapterTypeWireless
                } else {
                    self.chargingProtocolName = L10n.Battery.protocolFastPD(watt: watts)
                }
            } else if batteryLevel >= 0.80 {
                self.chargingProtocolName = L10n.Battery.protocolTrickle
            } else {
                self.chargingProtocolName = L10n.Battery.protocolStandardPD
            }

            if !isBatteryLevelAvailable {
                self.etaCountdownString = L10n.Battery.unavailableReading
            } else {
                let remainingMins = Int(round((1.0 - batteryLevel) * 85.0))
                self.etaCountdownString = L10n.Battery.etaToFull(mins: max(5, remainingMins))
            }
        } else {
            self.chargingProtocolName = isLowPowerMode ? L10n.Battery.protocolLowPower : L10n.Battery.protocolDischarge
            if !isBatteryLevelAvailable {
                self.etaCountdownString = L10n.Battery.unavailableReading
            } else {
                let drainMaPerMin: Double = max(1.0, Double(abs(self.liveCurrentMa))) / 60.0
                let availableMins = Int(Double(currentRemainingMah) / drainMaPerMin)
                let hours: Int = max(0, availableMins / 60)
                let mins: Int = max(0, availableMins % 60)
                self.etaCountdownString = L10n.Battery.etaRemaining(h: hours, m: mins)
            }
        }
    }

    // MARK: - Third-Party Custom Cell Configuration
    public func setCustomBattery(enabled: Bool, customMah: Int? = nil) {
        self.isCustomBattery = enabled
        if let customMah, customMah >= 500 {
            self.customCapacityMah = min(20000, max(500, customMah))
        }
        UserDefaults.standard.set(enabled, forKey: userDefaultsKeys.customEnabled)
        UserDefaults.standard.set(self.customCapacityMah, forKey: userDefaultsKeys.customCapacity)
        updateTelemetrySnapshot(force: true)
        updateLocalizedPowerStrings(isPluggedIn: lastIsPluggedIn, isFullyCharged: lastIsFullyCharged)
    }

    // MARK: - Apple Analytics Log Parser (.ips / .ips.ca.synced)
    @MainActor
    public func parseAnalyticsFile(url: URL) async -> Result<BatteryAnalyticsRecord, Error> {
        let isAccessing = url.startAccessingSecurityScopedResource()
        defer {
            if isAccessing {
                url.stopAccessingSecurityScopedResource()
            }
        }

        do {
            let data = try Data(contentsOf: url)
            guard let text = String(data: data, encoding: .utf8)
                ?? String(data: data, encoding: .ascii)
                ?? String(data: data, encoding: .isoLatin1) else {
                return .failure(NSError(domain: "OneDeckBattery", code: -1, userInfo: [NSLocalizedDescriptionKey: L10n.Battery.errLogDecoding]))
            }
            return parseAnalyticsText(text, sourceName: url.lastPathComponent)
        } catch {
            return .failure(error)
        }
    }

    @MainActor
    public func clearAnalyticsRecord() {
        self.analyticsRecord = nil
        UserDefaults.standard.removeObject(forKey: userDefaultsKeys.analyticsData)
        updateTelemetrySnapshot(force: true)
    }

    @MainActor
    public func parseAnalyticsText(_ text: String, sourceName: String = "Analytics-Log.ips") -> Result<BatteryAnalyticsRecord, Error> {
        var cycleCount: Int?
        var nominalChargeCapacity: Int?
        var maximumFcc: Int?
        var healthPercent: Double?

        // Optimization for large files: filter lines containing battery metrics
        let targetText: String
        if text.count > 300_000 {
            let lines = text.components(separatedBy: .newlines).filter { line in
                line.localizedCaseInsensitiveContains("CycleCount") ||
                    line.localizedCaseInsensitiveContains("NominalChargeCapacity") ||
                    line.localizedCaseInsensitiveContains("MaximumCapacityPercent") ||
                    line.localizedCaseInsensitiveContains("MaximumFCC") ||
                    line.localizedCaseInsensitiveContains("AppleRawMaxCapacity")
            }
            targetText = lines.isEmpty ? text : lines.joined(separator: "\n")
        } else {
            targetText = text
        }

        // Fast Regex Scan
        // 1. Cycle Count
        let cyclePatterns = [
            #"\"last_value_CycleCount\"\s*:\s*(\d+)"#,
            #"\"com\.apple\.ioreport\.BatteryCycleCount\"\s*:\s*(\d+)"#,
            #"\"CycleCount\"\s*:\s*(\d+)"#,
            #"\"cycle_count\"\s*:\s*(\d+)"#,
            #"\"battery_cycle_count\"\s*:\s*(\d+)"#,
            #"\"CycleCount\"\s*=\s*(\d+)"#
        ]
        for pattern in cyclePatterns {
            if let match = regexFirstMatch(pattern: pattern, text: targetText), let val = Int(match) {
                cycleCount = val
                break
            }
        }

        // 2. Nominal Charge Capacity (Current Max mAh)
        let nccPatterns = [
            #"\"last_value_NominalChargeCapacity\"\s*:\s*(\d+)"#,
            #"\"NominalChargeCapacity\"\s*:\s*(\d+)"#,
            #"\"nominal_charge_capacity\"\s*:\s*(\d+)"#,
            #"\"NominalChargeCapacity\"\s*=\s*(\d+)"#,
            #"\"AppleRawMaxCapacity\"\s*:\s*(\d+)"#
        ]
        for pattern in nccPatterns {
            if let match = regexFirstMatch(pattern: pattern, text: targetText), let val = Int(match) {
                nominalChargeCapacity = val
                break
            }
        }

        // 3. Maximum Full Charge Capacity (FCC mAh)
        let fccPatterns = [
            #"\"MaximumFCC\"\s*:\s*(\d+)"#,
            #"\"maximum_fcc\"\s*:\s*(\d+)"#,
            #"\"AppleRawMaxCapacity\"\s*:\s*(\d+)"#,
            #"\"MaximumFCC\"\s*=\s*(\d+)"#
        ]
        for pattern in fccPatterns {
            if let match = regexFirstMatch(pattern: pattern, text: targetText), let val = Int(match) {
                maximumFcc = val
                break
            }
        }

        // 4. Maximum Capacity Percent (Health %)
        let healthPatterns = [
            #"\"last_value_MaximumCapacityPercent\"\s*:\s*(\d+(?:\.\d+)?)"#,
            #"\"MaximumCapacityPercent\"\s*:\s*(\d+(?:\.\d+)?)"#,
            #"\"maximum_capacity_percent\"\s*:\s*(\d+(?:\.\d+)?)"#,
            #"\"MaximumCapacityPercent\"\s*=\s*(\d+(?:\.\d+)?)"#
        ]
        for pattern in healthPatterns {
            if let match = regexFirstMatch(pattern: pattern, text: targetText), let val = Double(match) {
                healthPercent = val
                break
            }
        }

        // Require explicit cycle count key (never synthesize 0 cycles without CycleCount)
        guard let finalCycles = cycleCount else {
            return .failure(NSError(domain: "OneDeckBattery", code: -2, userInfo: [NSLocalizedDescriptionKey: L10n.Battery.errCycleNotFound]))
        }

        let finalFcc = maximumFcc ?? effectiveDesignCapacityMah
        let finalNcc = nominalChargeCapacity ?? Int(Double(finalFcc) * 0.95)
        let finalHealth = healthPercent ?? (Double(finalNcc) / Double(effectiveDesignCapacityMah) * 100.0)

        let record = BatteryAnalyticsRecord(
            cycleCount: finalCycles,
            nominalChargeCapacityMah: finalNcc,
            maximumFccMah: finalFcc,
            healthPercent: min(100.0, Double(round(finalHealth * 10) / 10.0)),
            logDate: Date(),
            sourceFileName: sourceName
        )

        self.analyticsRecord = record
        persistAnalyticsRecord(record)
        updateTelemetrySnapshot(force: true)
        return .success(record)
    }

    private func regexFirstMatch(pattern: String, text: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else { return nil }
        let nsString = text as NSString
        guard let match = regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: nsString.length)),
              match.numberOfRanges > 1 else { return nil }
        return nsString.substring(with: match.range(at: 1))
    }

    // MARK: - Persistence
    private func loadPersistedSettings() {
        self.isCustomBattery = UserDefaults.standard.bool(forKey: userDefaultsKeys.customEnabled)
        let savedCap = UserDefaults.standard.integer(forKey: userDefaultsKeys.customCapacity)
        if savedCap >= 500 {
            self.customCapacityMah = min(20000, max(500, savedCap))
        }

        if let data = UserDefaults.standard.data(forKey: userDefaultsKeys.analyticsData),
           let record = try? JSONDecoder().decode(BatteryAnalyticsRecord.self, from: data) {
            self.analyticsRecord = record
        }
    }

    private func persistAnalyticsRecord(_ record: BatteryAnalyticsRecord) {
        if let data = try? JSONEncoder().encode(record) {
            UserDefaults.standard.set(data, forKey: userDefaultsKeys.analyticsData)
        }
    }

    // MARK: - Hardware Design Capacity Database
    private func resolveDeviceDesignCapacity() {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        guard size > 0 else {
            self.officialDesignCapacityMah = Self.lookupDesignCapacity(identifier: "")
            return
        }
        var machine = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        let identifier = String(cString: machine)

        self.officialDesignCapacityMah = Self.lookupDesignCapacity(identifier: identifier)
    }

    public static func lookupDesignCapacity(identifier: String) -> Int {
        switch identifier {
        // iPhone 18 Family (Late 2026)
        case "iPhone19,1": return 3850
        case "iPhone19,2": return 3950
        case "iPhone19,3": return 5050
        case "iPhone19,4": return 4400
        case "iPhone19,5": return 3550
        // iPhone 17 Family (Late 2025)
        case "iPhone18,1": return 3750
        case "iPhone18,2": return 4850
        case "iPhone18,3": return 3700
        case "iPhone18,4": return 3500
        case "iPhone18,5": return 3450
        // iPhone 16 Family (2024–2025)
        case "iPhone17,1": return 3582 // 16 Pro
        case "iPhone17,2": return 4685 // 16 Pro Max
        case "iPhone17,3": return 3561 // 16
        case "iPhone17,4": return 4674 // 16 Plus
        case "iPhone17,5": return 3961 // 16e
        // iPhone 15 Family (2023)
        case "iPhone16,1": return 3274 // 15 Pro
        case "iPhone16,2": return 4422 // 15 Pro Max
        case "iPhone15,4": return 3349 // 15
        case "iPhone15,5": return 4383 // 15 Plus
        // iPhone 14 Family (2022)
        case "iPhone15,2": return 3200 // 14 Pro
        case "iPhone15,3": return 4323 // 14 Pro Max
        case "iPhone14,7": return 3279 // 14
        case "iPhone14,8": return 4325 // 14 Plus
        // iPhone 13 Family & SE 3 (2021-2022)
        case "iPhone14,2": return 3095 // 13 Pro
        case "iPhone14,3": return 4352 // 13 Pro Max
        case "iPhone14,4": return 2406 // 13 mini
        case "iPhone14,5": return 3227 // 13
        case "iPhone14,6": return 2018 // SE (3rd)
        // iPhone 12 Family (2020)
        case "iPhone13,1": return 2227 // 12 mini
        case "iPhone13,2": return 2815 // 12
        case "iPhone13,3": return 2815 // 12 Pro
        case "iPhone13,4": return 3687 // 12 Pro Max
        // iPhone 11 Family & SE 2 (2019-2020)
        case "iPhone12,1": return 3110 // 11
        case "iPhone12,3": return 3046 // 11 Pro
        case "iPhone12,5": return 3969 // 11 Pro Max
        case "iPhone12,8": return 1821 // SE (2nd)
        // iPhone XS / XR (2018)
        case "iPhone11,2": return 2658 // XS
        case "iPhone11,4", "iPhone11,6": return 3174 // XS Max
        case "iPhone11,8": return 2942 // XR
        // iPhone X & 8 & Prior
        case "iPhone10,3", "iPhone10,6": return 2716 // X
        case "iPhone10,1", "iPhone10,4": return 1821 // 8
        case "iPhone10,2", "iPhone10,5": return 2691 // 8 Plus
        case "iPhone9,1", "iPhone9,3": return 1960 // 7
        case "iPhone9,2", "iPhone9,4": return 2900 // 7 Plus
        case "iPhone8,1": return 1715 // 6s
        case "iPhone8,2": return 2750 // 6s Plus
        case "iPhone8,4": return 1624 // SE (1st)
        // iPad Models
        case "iPad17,1", "iPad17,2": return 8160 // iPad Pro 11 M5
        case "iPad17,3", "iPad17,4": return 10290 // iPad Pro 13 M5
        case "iPad16,8", "iPad16,9": return 7606 // iPad Air 11 M4
        case "iPad16,10", "iPad16,11": return 9705 // iPad Air 13 M4
        case "iPad16,3", "iPad16,4": return 8160 // iPad Pro 11 M4
        case "iPad16,5", "iPad16,6": return 10290 // iPad Pro 13 M4
        case "iPad16,1", "iPad16,2": return 5078 // iPad mini (A17 Pro)
        case "iPad15,3", "iPad15,4": return 7606 // iPad Air 11 M3
        case "iPad15,5", "iPad15,6": return 9705 // iPad Air 13 M3
        case "iPad15,1", "iPad15,2", "iPad15,7", "iPad15,8": return 7606 // iPad (11th gen)
        case "iPad14,8", "iPad14,9": return 7606 // iPad Air 11 M2
        case "iPad14,10", "iPad14,11": return 9705 // iPad Air 13 M2
        case "iPad14,3", "iPad14,4": return 7538 // iPad Pro 11 M2
        case "iPad14,5", "iPad14,6": return 10758 // iPad Pro 12.9 M2
        case "iPad14,1", "iPad14,2": return 5124 // iPad mini 6
        case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7": return 7538 // iPad Pro 11 M1
        case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11": return 10835 // iPad Pro 12.9 M1
        case "iPad13,16", "iPad13,17": return 7606 // iPad Air 5 M1
        case "iPad13,1", "iPad13,2": return 7606 // iPad Air 4
        case "iPad13,18", "iPad13,19": return 7606 // iPad (10th gen)
        case "iPad12,1", "iPad12,2": return 8557 // iPad (9th gen)
        case "iPad11,1", "iPad11,2": return 5124 // iPad mini 5
        case "iPad11,3", "iPad11,4": return 8134 // iPad Air 3
        case "iPad11,6", "iPad11,7": return 8557 // iPad (8th gen)
        default:
            return 3000
        }
    }
}

// MARK: - Compatibility Typealias
public typealias BatteryService = BatteryViewModel
