//
//  SystemViewModel.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Mach kernel hardware telemetry, CPU, memory, and device specs view model.
//

import AVFoundation
import Darwin
import LocalAuthentication
import MachO
import Metal
import Observation
import SwiftUI

// MARK: - Telemetry Snapshot Container
public struct SystemTelemetrySnapshot: Sendable {
    public let coreUsages: [Double]
    public let coreCount: Int
    public let totalCpuUsage: Double
    public let downloadSpeedBytes: UInt64
    public let uploadSpeedBytes: UInt64
    public let downloadSpeedFormatted: String
    public let uploadSpeedFormatted: String
    public let activeInterfaceRaw: String
    public let sessionInDelta: UInt64
    public let sessionOutDelta: UInt64
    public let hasNetworkDelta: Bool
    public let activeMemory: UInt64
    public let inactiveMemory: UInt64
    public let wiredMemory: UInt64
    public let compressedMemory: UInt64
    public let freeMemory: UInt64
    public let diskSpace: (total: Int64, available: Int64, purgeable: Int64)?
    public let bootDate: Date?
    public let uptimeFormatted: String
    public let thermalState: ProcessInfo.ThermalState
    public let batteryTemperature: Double
    public let socTemperature: Double
    public let thermalPressurePercent: Int
    public let isThermalEstimated: Bool
    public let sampleTimestamp: Date

    public init(
        coreUsages: [Double],
        coreCount: Int,
        totalCpuUsage: Double,
        downloadSpeedBytes: UInt64,
        uploadSpeedBytes: UInt64,
        downloadSpeedFormatted: String,
        uploadSpeedFormatted: String,
        activeInterfaceRaw: String,
        sessionInDelta: UInt64,
        sessionOutDelta: UInt64,
        hasNetworkDelta: Bool,
        activeMemory: UInt64,
        inactiveMemory: UInt64,
        wiredMemory: UInt64,
        compressedMemory: UInt64,
        freeMemory: UInt64,
        diskSpace: (total: Int64, available: Int64, purgeable: Int64)?,
        bootDate: Date?,
        uptimeFormatted: String,
        thermalState: ProcessInfo.ThermalState,
        batteryTemperature: Double,
        socTemperature: Double,
        thermalPressurePercent: Int,
        isThermalEstimated: Bool,
        sampleTimestamp: Date
    ) {
        self.coreUsages = coreUsages
        self.coreCount = coreCount
        self.totalCpuUsage = totalCpuUsage
        self.downloadSpeedBytes = downloadSpeedBytes
        self.uploadSpeedBytes = uploadSpeedBytes
        self.downloadSpeedFormatted = downloadSpeedFormatted
        self.uploadSpeedFormatted = uploadSpeedFormatted
        self.activeInterfaceRaw = activeInterfaceRaw
        self.sessionInDelta = sessionInDelta
        self.sessionOutDelta = sessionOutDelta
        self.hasNetworkDelta = hasNetworkDelta
        self.activeMemory = activeMemory
        self.inactiveMemory = inactiveMemory
        self.wiredMemory = wiredMemory
        self.compressedMemory = compressedMemory
        self.freeMemory = freeMemory
        self.diskSpace = diskSpace
        self.bootDate = bootDate
        self.uptimeFormatted = uptimeFormatted
        self.thermalState = thermalState
        self.batteryTemperature = batteryTemperature
        self.socTemperature = socTemperature
        self.thermalPressurePercent = thermalPressurePercent
        self.isThermalEstimated = isThermalEstimated
        self.sampleTimestamp = sampleTimestamp
    }
}

// MARK: - System ViewModel Hub
@Observable
public final class SystemViewModel {
    @MainActor public static let shared = SystemViewModel()

    // MARK: - CPU Telemetry
    public var totalCpuUsage: Double = 0.0
    public var coreUsages: [Double] = []
    public var coreCount: Int = 0
    public var cpuHistory: [MetricPoint] = []

    // MARK: - Real-Time Network Bandwidth
    public var downloadSpeedBytes: UInt64 = 0
    public var uploadSpeedBytes: UInt64 = 0
    public var downloadSpeedFormatted: String = "0 KB/s"
    public var uploadSpeedFormatted: String = "0 KB/s"

    public var downloadRate: (value: String, unit: String) {
        Self.formatSpeedRate(bytesPerSec: downloadSpeedBytes)
    }

    public var uploadRate: (value: String, unit: String) {
        Self.formatSpeedRate(bytesPerSec: uploadSpeedBytes)
    }
    public var activeInterfaceRaw: String = "en0"
    public var downloadHistory: [MetricPoint] = []
    public var uploadHistory: [MetricPoint] = []
    public var sessionTotalInBytes: UInt64 = 0
    public var sessionTotalOutBytes: UInt64 = 0

    public var sessionDownloadTotalFormatted: String {
        sessionTotalInBytes.formattedBytes
    }
    public var sessionUploadTotalFormatted: String {
        sessionTotalOutBytes.formattedBytes
    }

    // Dynamic localized interface name from NWPathMonitor and CoreTelephony
    public var activeInterfaceName: String {
        NetworkService.shared.activeInterfaceSummary
    }

    // MARK: - Memory (Bytes)
    public var totalPhysicalMemory: UInt64 = 0
    public var activeMemory: UInt64 = 0
    public var inactiveMemory: UInt64 = 0
    public var wiredMemory: UInt64 = 0
    public var compressedMemory: UInt64 = 0
    public var freeMemory: UInt64 = 0

    // MARK: - Storage (Bytes)
    public var totalDiskSpace: Int64 = 0
    public var availableDiskSpace: Int64 = 0
    public var purgeableDiskSpace: Int64 = 0

    public var usedDiskSpace: Int64 {
        max(0, totalDiskSpace - availableDiskSpace)
    }

    // MARK: - Device Identity & Full Specs
    public var machineIdentifier: String = "Unknown"
    public var marketingName: String = "iPhone"
    public var chipName: String = "Apple Silicon"
    public var chipNameClean: String {
        chipName.replacingOccurrences(of: "Apple ", with: "")
    }
    public var boardId: String = "N/A"
    public var serialNumber: String = "N/A"
    public var modelNumber: String = "N/A"
    public var regulatoryModel: String = "N/A"
    public var regionCode: String = "N/A"
    public var osBuildNumber: String = ""
    public var salesTypeZh: String = ""
    public var salesTypeEn: String = ""
    public var salesTypeHant: String = ""
    public var uptimeFormatted: String = "0h 0m"
    public var bootDate: Date?

    private static let bootDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    public var bootTimeFormatted: String {
        guard let date = bootDate else { return L10n.Common.unknown }
        return Self.bootDateFormatter.string(from: date)
    }

    public var thermalState: ProcessInfo.ThermalState = .nominal
    public var thermalStateText: String {
        switch thermalState {
        case .nominal: return L10n.Battery.thermalStatusNormal
        case .fair: return L10n.Battery.thermalStatusWarm
        case .serious: return "\(L10n.Battery.thermalStatusWarm) (\(L10n.Battery.thermalThrottling))"
        case .critical: return "\(L10n.Battery.thermalStatusHot) (\(L10n.Battery.thermalShutdownProtection))"
        @unknown default: return L10n.Battery.thermalStatusNormal
        }
    }
    public var isCleaningCache: Bool = false
    public var lastCachePurgedAt: Date?
    public var hardwareSpecs: DetailedHardwareSpecs = .init()

    // MARK: - Thermal & Real-Time Temperature Telemetry
    public var batteryTemperature: Double = 31.5
    public var socTemperature: Double = 34.2
    public var thermalPressurePercent: Int = 12
    public var isThermalEstimated: Bool = false

    public var batteryTemperatureFormatted: String {
        String(format: "%.1f °C", batteryTemperature)
    }

    public var socTemperatureFormatted: String {
        String(format: "%.1f °C", socTemperature)
    }

    public var primaryTemperatureFormatted: String {
        String(format: "%.1f °C", socTemperature)
    }

    public var osVersion: String {
        #if canImport(UIKit)
        let prefix = UIDevice.current.userInterfaceIdiom == .pad ? "iPadOS " : "iOS "
        return prefix + UIDevice.current.systemVersion
        #else
        return "Darwin"
        #endif
    }

    public var osVersionWithBuild: String {
        if !osBuildNumber.isEmpty {
            return "\(osVersion) (\(osBuildNumber))"
        }
        return osVersion
    }

    public var salesTypeDescription: String {
        if !salesTypeZh.isEmpty {
            return L10n.tr(zh: salesTypeZh, en: salesTypeEn.isEmpty ? salesTypeZh : salesTypeEn, hant: salesTypeHant.isEmpty ? salesTypeZh : salesTypeHant)
        }
        return L10n.Overview.retailOriginal
    }

    // MARK: - Private State & Telemetry Sampler (Managed on workerQueue)
    private let workerQueue = DispatchQueue(label: "com.onedeck.system.telemetry", qos: .utility)
    private var isSamplingInProgress: Bool = false
    private var previousCoreLoads: [CoreLoad] = []
    private var previousInterfaceCounters: [String: (inBytes: UInt32, outBytes: UInt32)] = [:]
    private var hasPreviousNetworkSample: Bool = false
    private var previousNetworkTime: Date = .init()
    private var lastSampledBatteryTemp: Double = 31.5
    private var lastSampledSocTemp: Double = 34.2
    private var timer: Timer?
    private var isMonitoring: Bool = false
    private var tickCount: Int = 0
    private let maxHistoryPoints: Int = 30

    // MARK: - Init
    public init() {
        self.coreCount = ProcessInfo.processInfo.activeProcessorCount
        self.coreUsages = Array(repeating: 0.0, count: coreCount)
        self.totalPhysicalMemory = ProcessInfo.processInfo.physicalMemory

        let (initialCounters, iface) = Self.readNetworkInterfaceCounters()
        self.previousInterfaceCounters = initialCounters
        self.hasPreviousNetworkSample = !initialCounters.isEmpty
        self.previousNetworkTime = Date()
        self.activeInterfaceRaw = iface

        resolveDeviceIdentity()
        resolveHardwareInventory()
        refreshAll(forceStorage: true)
    }

    // MARK: - Lifecycle Controls
    public func startMonitoring() {
        guard !isMonitoring else { return }
        isMonitoring = true
        tickCount = 0
        scheduleAsyncTelemetrySnapshot(forceStorage: true)
        scheduleMonitoringTimer()
    }

    public func applyPowerSavingPreference() {
        guard isMonitoring else { return }
        scheduleMonitoringTimer()
    }

    private func scheduleMonitoringTimer() {
        timer?.invalidate()
        let interval: TimeInterval = AppState.shared.isSensorPowerSaving ? 3.0 : 1.0
        let scheduledTimer = Timer(timeInterval: interval, repeats: true) { [weak self] _ in
            self?.tick()
        }
        RunLoop.main.add(scheduledTimer, forMode: .common)
        timer = scheduledTimer
    }

    @MainActor
    public func refreshLocalizedStrings() {
        let sample = sampleUptime()
        self.bootDate = sample.bootDate
        self.uptimeFormatted = sample.uptimeFormatted
    }

    public func refreshDisplaySpecs() {
        var updated = hardwareSpecs
        populateDisplaySpecs(into: &updated)
        hardwareSpecs = updated
    }

    public func stopMonitoring() {
        isMonitoring = false
        timer?.invalidate()
        timer = nil
        workerQueue.async { [weak self] in
            guard let self else { return }
            self.previousCoreLoads = []
            self.previousInterfaceCounters = [:]
            self.hasPreviousNetworkSample = false
            self.isSamplingInProgress = false
        }
    }

    private func tick() {
        guard isMonitoring else { return }
        tickCount += 1
        let shouldRefreshStorage = (tickCount % 30 == 0)
        scheduleAsyncTelemetrySnapshot(forceStorage: shouldRefreshStorage)
    }

    private func scheduleAsyncTelemetrySnapshot(forceStorage: Bool = false) {
        guard isMonitoring else { return }
        workerQueue.async { [weak self] in
            guard let self, self.isMonitoring else { return }
            guard !self.isSamplingInProgress else { return }
            self.isSamplingInProgress = true
            defer { self.isSamplingInProgress = false }

            let snapshot = self.sampleTelemetry(forceStorage: forceStorage)
            DispatchQueue.main.async { [weak self] in
                guard let self, self.isMonitoring else { return }
                self.applyTelemetrySnapshot(snapshot)
            }
        }
    }

    // MARK: - Refresh Trigger (Synchronous Baseline)
    @MainActor
    public func refreshAll(forceStorage: Bool = true) {
        let snapshot = sampleTelemetry(forceStorage: forceStorage)
        applyTelemetrySnapshot(snapshot)
    }

    @MainActor
    private func applyTelemetrySnapshot(_ snapshot: SystemTelemetrySnapshot) {
        self.coreUsages = snapshot.coreUsages
        self.coreCount = snapshot.coreCount
        self.totalCpuUsage = snapshot.totalCpuUsage

        let cpuPoint = MetricPoint(timestamp: snapshot.sampleTimestamp, value: snapshot.totalCpuUsage)
        self.cpuHistory.append(cpuPoint)
        if self.cpuHistory.count > maxHistoryPoints {
            self.cpuHistory.removeFirst(self.cpuHistory.count - maxHistoryPoints)
        }

        self.downloadSpeedBytes = snapshot.downloadSpeedBytes
        self.uploadSpeedBytes = snapshot.uploadSpeedBytes
        self.downloadSpeedFormatted = snapshot.downloadSpeedFormatted
        self.uploadSpeedFormatted = snapshot.uploadSpeedFormatted
        self.activeInterfaceRaw = snapshot.activeInterfaceRaw
        self.sessionTotalInBytes += snapshot.sessionInDelta
        self.sessionTotalOutBytes += snapshot.sessionOutDelta

        if snapshot.hasNetworkDelta {
            let downPoint = MetricPoint(timestamp: snapshot.sampleTimestamp, value: Double(snapshot.downloadSpeedBytes) / 1024.0)
            self.downloadHistory.append(downPoint)
            if self.downloadHistory.count > maxHistoryPoints {
                self.downloadHistory.removeFirst(self.downloadHistory.count - maxHistoryPoints)
            }

            let upPoint = MetricPoint(timestamp: snapshot.sampleTimestamp, value: Double(snapshot.uploadSpeedBytes) / 1024.0)
            self.uploadHistory.append(upPoint)
            if self.uploadHistory.count > maxHistoryPoints {
                self.uploadHistory.removeFirst(self.uploadHistory.count - maxHistoryPoints)
            }
        }

        self.activeMemory = snapshot.activeMemory
        self.inactiveMemory = snapshot.inactiveMemory
        self.wiredMemory = snapshot.wiredMemory
        self.compressedMemory = snapshot.compressedMemory
        self.freeMemory = snapshot.freeMemory

        if let disk = snapshot.diskSpace {
            self.totalDiskSpace = disk.total
            self.availableDiskSpace = disk.available
            self.purgeableDiskSpace = disk.purgeable
        }

        if let boot = snapshot.bootDate {
            self.bootDate = boot
        }
        self.uptimeFormatted = snapshot.uptimeFormatted

        self.thermalState = snapshot.thermalState
        self.batteryTemperature = snapshot.batteryTemperature
        self.socTemperature = snapshot.socTemperature
        self.thermalPressurePercent = snapshot.thermalPressurePercent
        self.isThermalEstimated = snapshot.isThermalEstimated
    }

    // MARK: - Background Sampling Pipeline (workerQueue)
    private func sampleTelemetry(forceStorage: Bool) -> SystemTelemetrySnapshot {
        let now = Date()

        let (cpuUsages, totalCpu, count) = sampleCpuUsage()
        let netSample = sampleNetworkBandwidth(now: now)
        let memSample = sampleMemoryUsage()
        let diskSample: (total: Int64, available: Int64, purgeable: Int64)? = forceStorage ? sampleStorageUsage() : nil
        let uptimeSample = sampleUptime()
        let thermalSample = sampleThermals(totalCpu: totalCpu)

        return SystemTelemetrySnapshot(
            coreUsages: cpuUsages,
            coreCount: count,
            totalCpuUsage: totalCpu,
            downloadSpeedBytes: netSample.downloadBytes,
            uploadSpeedBytes: netSample.uploadBytes,
            downloadSpeedFormatted: netSample.downloadFormatted,
            uploadSpeedFormatted: netSample.uploadFormatted,
            activeInterfaceRaw: netSample.activeInterface,
            sessionInDelta: netSample.deltaIn,
            sessionOutDelta: netSample.deltaOut,
            hasNetworkDelta: netSample.hasDelta,
            activeMemory: memSample.active,
            inactiveMemory: memSample.inactive,
            wiredMemory: memSample.wired,
            compressedMemory: memSample.compressed,
            freeMemory: memSample.free,
            diskSpace: diskSample,
            bootDate: uptimeSample.bootDate,
            uptimeFormatted: uptimeSample.uptimeFormatted,
            thermalState: thermalSample.state,
            batteryTemperature: thermalSample.batteryTemp,
            socTemperature: thermalSample.socTemp,
            thermalPressurePercent: thermalSample.pressure,
            isThermalEstimated: thermalSample.isEstimated,
            sampleTimestamp: now
        )
    }

    // MARK: - 1. CPU Mach Kernel Telemetry
    private func sampleCpuUsage() -> ([Double], Double, Int) {
        var processorCount: natural_t = 0
        var processorInfo: processor_info_array_t?
        var processorInfoCount: mach_msg_type_number_t = 0

        let host = mach_host_self()
        defer { mach_port_deallocate(mach_task_self_, host) }

        let result = host_processor_info(
            host,
            PROCESSOR_CPU_LOAD_INFO,
            &processorCount,
            &processorInfo,
            &processorInfoCount
        )

        guard result == KERN_SUCCESS, let info = processorInfo else {
            return (previousCoreLoads.map { _ in 0.0 }, 0.0, coreCount)
        }
        defer {
            vm_deallocate(
                mach_task_self_,
                vm_address_t(bitPattern: info),
                vm_size_t(processorInfoCount) * vm_size_t(MemoryLayout<integer_t>.stride)
            )
        }

        let count = Int(processorCount)
        var newUsages: [Double] = []
        var totalActiveTicks: UInt64 = 0
        var totalAllTicks: UInt64 = 0

        for i in 0 ..< count {
            let offset = Int(CPU_STATE_MAX) * i
            let user = UInt32(bitPattern: info[offset + Int(CPU_STATE_USER)])
            let system = UInt32(bitPattern: info[offset + Int(CPU_STATE_SYSTEM)])
            let idle = UInt32(bitPattern: info[offset + Int(CPU_STATE_IDLE)])
            let nice = UInt32(bitPattern: info[offset + Int(CPU_STATE_NICE)])

            let currentLoad = CoreLoad(user: user, system: system, idle: idle, nice: nice)

            if previousCoreLoads.count > i {
                let prev = previousCoreLoads[i]
                let userDiff = Self.computeCounterDelta(current: user, previous: prev.user)
                let systemDiff = Self.computeCounterDelta(current: system, previous: prev.system)
                let idleDiff = Self.computeCounterDelta(current: idle, previous: prev.idle)
                let niceDiff = Self.computeCounterDelta(current: nice, previous: prev.nice)

                let totalDiff = userDiff + systemDiff + idleDiff + niceDiff
                let activeDiff = userDiff + systemDiff + niceDiff

                if totalDiff > 0 {
                    let usage = Double(activeDiff) / Double(totalDiff) * 100.0
                    newUsages.append(min(max(usage, 0.0), 100.0))
                    totalActiveTicks += activeDiff
                    totalAllTicks += totalDiff
                } else {
                    newUsages.append(0.0)
                }
            } else {
                newUsages.append(0.0)
            }

            if previousCoreLoads.count > i {
                previousCoreLoads[i] = currentLoad
            } else {
                previousCoreLoads.append(currentLoad)
            }
        }

        let clampedTotal: Double
        if totalAllTicks > 0 {
            let calculatedTotal = Double(totalActiveTicks) / Double(totalAllTicks) * 100.0
            clampedTotal = min(100.0, max(0.0, calculatedTotal.isFinite ? calculatedTotal : 0.0))
        } else {
            clampedTotal = 0.0
        }

        return (newUsages, clampedTotal, count)
    }

    // MARK: - 2. Real-Time Network Bandwidth (getifaddrs)
    public nonisolated static func computeCounterDelta(current: UInt32, previous: UInt32) -> UInt64 {
        if current >= previous {
            return UInt64(current - previous)
        }
        let wrappedDelta = (UInt64(UInt32.max) - UInt64(previous)) + 1 + UInt64(current)
        // Treat wraparound <= 2 GiB as 32-bit unsigned rollover; larger drops indicate counter reset
        return wrappedDelta <= 2_147_483_648 ? wrappedDelta : UInt64(current)
    }

    private func sampleNetworkBandwidth(now: Date) -> (downloadBytes: UInt64, uploadBytes: UInt64, downloadFormatted: String, uploadFormatted: String, activeInterface: String, deltaIn: UInt64, deltaOut: UInt64, hasDelta: Bool) {
        let (currentCounters, iface) = Self.readNetworkInterfaceCounters()
        let timeDelta = max(0.5, now.timeIntervalSince(previousNetworkTime))
        var speedDown: UInt64 = 0
        var speedUp: UInt64 = 0
        var deltaIn: UInt64 = 0
        var deltaOut: UInt64 = 0
        let hasDelta = hasPreviousNetworkSample

        if hasPreviousNetworkSample {
            for (name, cur) in currentCounters {
                if let prev = previousInterfaceCounters[name] {
                    deltaIn += Self.computeCounterDelta(current: cur.inBytes, previous: prev.inBytes)
                    deltaOut += Self.computeCounterDelta(current: cur.outBytes, previous: prev.outBytes)
                }
            }
            speedDown = UInt64(Double(deltaIn) / timeDelta)
            speedUp = UInt64(Double(deltaOut) / timeDelta)
        }

        self.previousInterfaceCounters = currentCounters
        self.hasPreviousNetworkSample = !currentCounters.isEmpty
        self.previousNetworkTime = now

        return (
            downloadBytes: speedDown,
            uploadBytes: speedUp,
            downloadFormatted: Self.formatSpeed(bytesPerSec: speedDown),
            uploadFormatted: Self.formatSpeed(bytesPerSec: speedUp),
            activeInterface: iface,
            deltaIn: deltaIn,
            deltaOut: deltaOut,
            hasDelta: hasDelta
        )
    }

    private static func readNetworkInterfaceCounters() -> ([String: (inBytes: UInt32, outBytes: UInt32)], String) {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else {
            return ([:], "en0")
        }
        defer { freeifaddrs(ifaddr) }

        var counters: [String: (inBytes: UInt32, outBytes: UInt32)] = [:]
        var detectedInterface = "en0"
        var hasPreferredEn = false

        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            guard let addrPtr = ptr.pointee.ifa_addr else { continue }
            let flags = Int32(ptr.pointee.ifa_flags)
            guard (flags & IFF_UP) != 0, (flags & IFF_LOOPBACK) == 0 else { continue }

            let addr = addrPtr.pointee
            if addr.sa_family == UInt8(AF_LINK) {
                let name = String(cString: ptr.pointee.ifa_name)
                if name.hasPrefix("en") || name.hasPrefix("pdp_ip") {
                    if let data = ptr.pointee.ifa_data {
                        let networkData = data.assumingMemoryBound(to: if_data.self)
                        counters[name] = (networkData.pointee.ifi_ibytes, networkData.pointee.ifi_obytes)
                        if (flags & IFF_RUNNING) != 0 {
                            if name == "en0" {
                                detectedInterface = name
                                hasPreferredEn = true
                            } else if name.hasPrefix("en") && !hasPreferredEn {
                                detectedInterface = name
                                hasPreferredEn = true
                            } else if !hasPreferredEn && name.hasPrefix("pdp_ip") {
                                detectedInterface = name
                            }
                        }
                    }
                }
            }
        }
        return (counters, detectedInterface)
    }

    public static func formatSpeed(bytesPerSec: UInt64) -> String {
        let kb = Double(bytesPerSec) / 1024.0
        if kb < 1024.0 {
            return String(format: "%.1f KB/s", kb)
        } else {
            let mb = kb / 1024.0
            return String(format: "%.2f MB/s", mb)
        }
    }

    public static func formatSpeedRate(bytesPerSec: UInt64) -> (value: String, unit: String) {
        let kb = Double(bytesPerSec) / 1024.0
        if kb < 1024.0 {
            return (String(format: "%.1f", kb), "KB/s")
        } else {
            let mb = kb / 1024.0
            return (String(format: "%.2f", mb), "MB/s")
        }
    }

    // MARK: - 3. Memory Mach Kernel Telemetry
    private func sampleMemoryUsage() -> (active: UInt64, inactive: UInt64, wired: UInt64, compressed: UInt64, free: UInt64) {
        var vmStats = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size)

        let host = mach_host_self()
        defer { mach_port_deallocate(mach_task_self_, host) }

        let result = withUnsafeMutablePointer(to: &vmStats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(host, HOST_VM_INFO64, $0, &count)
            }
        }

        guard result == KERN_SUCCESS else {
            return (activeMemory, inactiveMemory, wiredMemory, compressedMemory, freeMemory)
        }

        let pageSize = UInt64(vm_kernel_page_size)
        return (
            active: UInt64(vmStats.active_count) * pageSize,
            inactive: UInt64(vmStats.inactive_count) * pageSize,
            wired: UInt64(vmStats.wire_count) * pageSize,
            compressed: UInt64(vmStats.compressor_page_count) * pageSize,
            free: UInt64(vmStats.free_count) * pageSize
        )
    }

    // MARK: - 4. Storage Telemetry
    private func sampleStorageUsage() -> (total: Int64, available: Int64, purgeable: Int64) {
        let homeURL = URL(fileURLWithPath: NSHomeDirectory() as String)
        do {
            let values = try homeURL.resourceValues(forKeys: [
                .volumeTotalCapacityKey,
                .volumeAvailableCapacityForImportantUsageKey,
                .volumeAvailableCapacityForOpportunisticUsageKey
            ])
            let total = values.volumeTotalCapacity.map { Int64($0) } ?? self.totalDiskSpace
            let available = values.volumeAvailableCapacityForImportantUsage ?? self.availableDiskSpace
            var purgeable: Int64 = 0
            if let opportunistic = values.volumeAvailableCapacityForOpportunisticUsage,
               let important = values.volumeAvailableCapacityForImportantUsage {
                purgeable = max(0, opportunistic - important)
            }
            return (total: total, available: available, purgeable: purgeable)
        } catch {
            var stats = statfs()
            if statfs(homeURL.path, &stats) == 0 {
                let total = Int64(stats.f_blocks) * Int64(stats.f_bsize)
                let available = Int64(stats.f_bavail) * Int64(stats.f_bsize)
                return (total: total, available: available, purgeable: 0)
            }
            return (total: self.totalDiskSpace, available: self.availableDiskSpace, purgeable: self.purgeableDiskSpace)
        }
    }

    // MARK: - 5. System Uptime via sysctl
    private func sampleUptime() -> (bootDate: Date?, uptimeFormatted: String) {
        var bootTime = timeval()
        var size = MemoryLayout<timeval>.stride
        var mib = [CTL_KERN, KERN_BOOTTIME]
        let result = sysctl(&mib, u_int(mib.count), &bootTime, &size, nil, 0)
        guard result == 0 else {
            return (self.bootDate, self.uptimeFormatted)
        }

        let bootDate = Date(timeIntervalSince1970: TimeInterval(bootTime.tv_sec))
        let uptimeSeconds = max(0, Int(Date().timeIntervalSince(bootDate)))

        let days = uptimeSeconds / 86400
        let hours = (uptimeSeconds % 86400) / 3600
        let minutes = (uptimeSeconds % 3600) / 60

        return (bootDate: bootDate, uptimeFormatted: L10n.Overview.uptimeText(days: days, hours: hours, minutes: minutes))
    }

    // MARK: - 6. Device Identification & Full Specs
    private func resolveDeviceIdentity() {
        var size = 0
        if sysctlbyname("hw.machine", nil, &size, nil, 0) == 0 && size > 0 {
            var machine = [CChar](repeating: 0, count: size)
            if sysctlbyname("hw.machine", &machine, &size, nil, 0) == 0 {
                self.machineIdentifier = String(cString: machine)
            }
        }
        let identifier = self.machineIdentifier

        var modelSize = 0
        if sysctlbyname("hw.model", nil, &modelSize, nil, 0) == 0 && modelSize > 0 {
            var modelChars = [CChar](repeating: 0, count: modelSize)
            if sysctlbyname("hw.model", &modelChars, &modelSize, nil, 0) == 0 {
                self.boardId = String(cString: modelChars)
            }
        }

        let (marketing, chip) = Self.lookupDevice(identifier: identifier)
        self.marketingName = marketing
        self.chipName = chip

        // Deep Hardware Telemetry Probe (IOPlatformExpertDevice, MobileGestalt, Sysctl)
        let probe = DeviceHardwareProbe.sample()
        if let sn = probe.serialNumber, !sn.isEmpty {
            self.serialNumber = sn
        }
        if let bid = probe.boardId, !bid.isEmpty {
            self.boardId = bid
        }
        if let mn = probe.modelNumber, !mn.isEmpty {
            self.modelNumber = mn
        }
        if let rm = probe.regulatoryModel, !rm.isEmpty {
            self.regulatoryModel = rm
        }
        if let rc = probe.regionCode, !rc.isEmpty {
            self.regionCode = rc
        }
        if let b = probe.osBuildNumber, !b.isEmpty {
            self.osBuildNumber = b
        }
        if let sz = probe.salesTypeZh {
            self.salesTypeZh = sz
        }
        if let se = probe.salesTypeEn {
            self.salesTypeEn = se
        }
        if let sh = probe.salesTypeHant {
            self.salesTypeHant = sh
        }
    }

    #if canImport(UIKit)
    public static func activeDisplayScreen() -> UIScreen? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.activationState == .foregroundActive })?.screen
            ?? UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.screen
    }
    #endif

    private func populateDisplaySpecs(into specs: inout DetailedHardwareSpecs) {
        #if canImport(UIKit)
        if let screen = Self.activeDisplayScreen() {
            let nativeBounds = screen.nativeBounds
            if nativeBounds.width > 0 && nativeBounds.height > 0 {
                specs.physicalWidth = Int(nativeBounds.width)
                specs.physicalHeight = Int(nativeBounds.height)
            } else {
                let bounds = screen.bounds
                let scale = screen.scale
                specs.physicalWidth = Int(bounds.width * scale)
                specs.physicalHeight = Int(bounds.height * scale)
            }
            let rawScale = screen.nativeScale > 0 ? screen.nativeScale : screen.scale
            specs.scale = Int(round(rawScale))
            specs.nativeScaleValue = Double(rawScale)
            specs.maxFps = screen.maximumFramesPerSecond
        }
        if machineIdentifier.hasPrefix("iPad16,3") || machineIdentifier.hasPrefix("iPad16,4") ||
            machineIdentifier.hasPrefix("iPad16,5") || machineIdentifier.hasPrefix("iPad16,6") ||
            machineIdentifier.hasPrefix("iPad17,") {
            specs.ppi = 264
            specs.panelType = .ultraRetinaXDR
        } else if machineIdentifier.hasPrefix("iPad14,1") || machineIdentifier.hasPrefix("iPad14,2") ||
            machineIdentifier.hasPrefix("iPad16,1") || machineIdentifier.hasPrefix("iPad16,2") ||
            machineIdentifier.hasPrefix("iPad11,1") || machineIdentifier.hasPrefix("iPad11,2") {
            specs.ppi = 326
            specs.panelType = .liquidRetina
        } else if machineIdentifier.hasPrefix("iPad") {
            specs.ppi = 264
            specs.panelType = .liquidRetina
        } else if machineIdentifier.hasPrefix("iPhone11,2") || machineIdentifier.hasPrefix("iPhone11,4") ||
            machineIdentifier.hasPrefix("iPhone11,6") || machineIdentifier.hasPrefix("iPhone10,3") ||
            machineIdentifier.hasPrefix("iPhone10,6") {
            specs.ppi = 458
            specs.panelType = .superRetinaHD
        } else if machineIdentifier.hasPrefix("iPhone14,4") || machineIdentifier.hasPrefix("iPhone13,1") {
            specs.ppi = 476
            specs.panelType = .superRetinaXDROLED
        } else if machineIdentifier.hasPrefix("iPhone11,8") || machineIdentifier.hasPrefix("iPhone12,1") ||
            machineIdentifier.hasPrefix("iPhone12,8") || machineIdentifier.hasPrefix("iPhone14,6") ||
            machineIdentifier.hasPrefix("iPhone10,1") || machineIdentifier.hasPrefix("iPhone10,4") ||
            machineIdentifier.hasPrefix("iPhone9,1") || machineIdentifier.hasPrefix("iPhone9,3") ||
            machineIdentifier.hasPrefix("iPhone8,1") || machineIdentifier.hasPrefix("iPhone8,4") {
            specs.ppi = 326
            specs.panelType = .liquidRetina
        } else if machineIdentifier.hasPrefix("iPhone10,2") || machineIdentifier.hasPrefix("iPhone10,5") ||
            machineIdentifier.hasPrefix("iPhone9,2") || machineIdentifier.hasPrefix("iPhone9,4") ||
            machineIdentifier.hasPrefix("iPhone8,2") {
            specs.ppi = 401
            specs.panelType = .retina
        } else if machineIdentifier == "arm64" || machineIdentifier == "x86_64" {
            let isPad = UIDevice.current.userInterfaceIdiom == .pad
            specs.ppi = isPad ? 264 : 460
            specs.panelType = isPad ? .liquidRetina : (specs.maxFps >= 120 ? .superRetinaXDRProMotion : .superRetinaXDROLED)
        } else if specs.maxFps >= 120 {
            specs.ppi = 460
            specs.panelType = .superRetinaXDRProMotion
        } else {
            specs.ppi = 460
            specs.panelType = .superRetinaXDROLED
        }
        #endif
    }

    private func resolveHardwareInventory() {
        var specs = DetailedHardwareSpecs()

        // 1. Display Hardware
        populateDisplaySpecs(into: &specs)

        // 2. SoC Microarchitecture & Neural Engine (Direct Sysctl Telemetry)
        let probe = DeviceHardwareProbe.sample()
        specs.coreCount = coreCount
        if let p = probe.pCores, let e = probe.eCores, p > 0 && e > 0 {
            specs.pCores = p
            specs.eCores = e
        } else {
            specs.pCores = 2
            specs.eCores = max(1, coreCount - 2)
        }
        if let l1 = probe.l1dKb, l1 > 0 {
            specs.l1dKb = l1
        }
        if let l2 = probe.l2Mb, l2 > 0 {
            specs.l2Mb = l2
        }

        if chipName.contains("A11") {
            specs.processNodeZh = "10nm (台积电 FinFET)"
            specs.processNodeEn = "10nm (TSMC FinFET)"
            specs.isaTier = .armV82
            specs.aneTier = .a11
            specs.gpuCores = 3
            specs.metalFeatureSet = "Metal 2 (Family 4)"
            if probe.l1dKb == nil { specs.l1dKb = 64 }
            if probe.l2Mb == nil { specs.l2Mb = 8 }
        } else if chipName.contains("A12") {
            specs.processNodeZh = "7nm (台积电 FinFET)"
            specs.processNodeEn = "7nm (TSMC FinFET)"
            specs.isaTier = .armV83
            specs.aneTier = .a12
            specs.gpuCores = chipName.contains("X") || chipName.contains("Z") ? 8 : 4
            specs.metalFeatureSet = "Metal 2 (Family 5)"
            if probe.l1dKb == nil { specs.l1dKb = 128 }
            if probe.l2Mb == nil { specs.l2Mb = 8 }
        } else if chipName.contains("A13") {
            specs.processNodeZh = "7nm (台积电 N7P)"
            specs.processNodeEn = "7nm (TSMC N7P)"
            specs.isaTier = .armV84
            specs.aneTier = .a13
            specs.gpuCores = 4
            specs.metalFeatureSet = "Metal 2 (Family 6)"
            if probe.l1dKb == nil { specs.l1dKb = 128 }
            if probe.l2Mb == nil { specs.l2Mb = 8 }
        } else if chipName.contains("A14") {
            specs.processNodeZh = "5nm (台积电 N5)"
            specs.processNodeEn = "5nm (TSMC N5)"
            specs.isaTier = .armV85
            specs.aneTier = .a14
            specs.gpuCores = 4
            specs.metalFeatureSet = "Metal 3 (Family 7)"
            if probe.l1dKb == nil { specs.l1dKb = 128 }
            if probe.l2Mb == nil { specs.l2Mb = 16 }
        } else if chipName.contains("A15") {
            specs.processNodeZh = "5nm (台积电 N5P)"
            specs.processNodeEn = "5nm (TSMC N5P)"
            specs.isaTier = .armV86
            specs.aneTier = .a15
            specs.gpuCores = machineIdentifier.contains("iPhone14,2") || machineIdentifier.contains("iPhone14,3") ||
                machineIdentifier.contains("iPhone14,7") || machineIdentifier.contains("iPhone14,8") ||
                machineIdentifier.contains("iPad14,1") || machineIdentifier.contains("iPad14,2") ? 5 : 4
            specs.metalFeatureSet = "Metal 3 (Family 8)"
            if probe.l1dKb == nil { specs.l1dKb = 128 }
            if probe.l2Mb == nil { specs.l2Mb = 12 }
        } else if chipName.contains("A16") {
            specs.processNodeZh = "4nm (台积电 N4P)"
            specs.processNodeEn = "4nm (TSMC N4P)"
            specs.isaTier = .armV90
            specs.aneTier = .a16
            specs.gpuCores = 5
            specs.metalFeatureSet = "Metal 3 (Family 8)"
            if probe.l1dKb == nil { specs.l1dKb = 128 }
            if probe.l2Mb == nil { specs.l2Mb = 16 }
        } else if chipName.contains("A17") {
            specs.processNodeZh = "3nm (台积电 N3B)"
            specs.processNodeEn = "3nm (TSMC N3B)"
            specs.isaTier = .armV92
            specs.aneTier = .a17Pro
            specs.gpuCores = 6
            specs.metalFeatureSet = "Metal 3 (Family 9)"
            if probe.l1dKb == nil { specs.l1dKb = 128 }
            if probe.l2Mb == nil { specs.l2Mb = 16 }
        } else if chipName.contains("A18") {
            specs.processNodeZh = "3nm (台积电 N3E)"
            specs.processNodeEn = "3nm (TSMC N3E)"
            specs.isaTier = .armV92
            specs.aneTier = .a18Plus
            specs.gpuCores = machineIdentifier == "iPhone17,5" ? 4 : (chipName.contains("Pro") ? 6 : 5)
            specs.metalFeatureSet = "Metal 3 (Family 9)"
            if probe.l1dKb == nil { specs.l1dKb = 128 }
            if probe.l2Mb == nil { specs.l2Mb = 16 }
        } else if chipName.contains("A19") || chipName.contains("A20") {
            specs.processNodeZh = chipName.contains("A20") ? "2nm (台积电 N2)" : "3nm (台积电 N3P)"
            specs.processNodeEn = chipName.contains("A20") ? "2nm (TSMC N2)" : "3nm (TSMC N3P)"
            specs.isaTier = .armV92
            specs.aneTier = .a18Plus
            specs.gpuCores = 6
            specs.metalFeatureSet = "Metal 3 (Family 10)"
            if probe.l1dKb == nil { specs.l1dKb = 128 }
            if probe.l2Mb == nil { specs.l2Mb = 24 }
        } else if chipName.contains("M") {
            specs.processNodeZh = "Apple Silicon 高性能工艺"
            specs.processNodeEn = "Apple Silicon Process"
            specs.isaTier = .armV85
            specs.aneTier = .appleSiliconM
            if chipName.contains("M1") {
                specs.gpuCores = 8
            } else if chipName.contains("M2") {
                specs.gpuCores = machineIdentifier.hasPrefix("iPad14,8") || machineIdentifier.hasPrefix("iPad14,9") ||
                    machineIdentifier.hasPrefix("iPad14,10") || machineIdentifier.hasPrefix("iPad14,11") ? 9 : 10
            } else if chipName.contains("M3") {
                specs.gpuCores = 9
            } else if chipName.contains("M4") {
                specs.gpuCores = machineIdentifier.hasPrefix("iPad16,8") || machineIdentifier.hasPrefix("iPad16,9") ||
                    machineIdentifier.hasPrefix("iPad16,10") || machineIdentifier.hasPrefix("iPad16,11") ? 9 : 10
            } else if chipName.contains("M5") {
                specs.gpuCores = 10
            } else {
                specs.gpuCores = 8
            }
            specs.metalFeatureSet = "Metal 3 (Family 8)"
            if probe.l1dKb == nil { specs.l1dKb = 128 }
            if probe.l2Mb == nil { specs.l2Mb = 16 }
        } else {
            specs.processNodeZh = "台积电先进半导体制程"
            specs.processNodeEn = "Advanced TSMC Process"
            specs.isaTier = .arm64Standard
            specs.aneTier = .standard
            specs.gpuCores = 4
            specs.metalFeatureSet = "Metal 2"
            if probe.l1dKb == nil { specs.l1dKb = 128 }
            if probe.l2Mb == nil { specs.l2Mb = 8 }
        }

        // 3. Metal GPU Graphics
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            specs.gpuDeviceName = metalDevice.name
            specs.supportsRayTracing = metalDevice.supportsRaytracing
            specs.supportsMeshShaders = metalDevice.supportsFamily(.metal3)
        }

        // 4. Biometrics
        let laContext = LAContext()
        var error: NSError?
        _ = laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        specs.biometryType = laContext.biometryType

        // 5. Optics (LiDAR)
        let discovery = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInLiDARDepthCamera],
            mediaType: .video,
            position: .unspecified
        )
        specs.hasLiDAR = discovery.devices.contains { $0.deviceType == .builtInLiDARDepthCamera }

        // 6. Physical Port
        if machineIdentifier == "arm64" || machineIdentifier == "x86_64" ||
            (!machineIdentifier.hasPrefix("iPhone") && !machineIdentifier.hasPrefix("iPad")) {
            // Simulator or unknown host architecture: leave port flags unset -> "--"
        } else if machineIdentifier.hasPrefix("iPhone15,2") || machineIdentifier.hasPrefix("iPhone15,3") ||
            machineIdentifier.hasPrefix("iPad12,") || machineIdentifier.hasPrefix("iPad11,") ||
            machineIdentifier.hasPrefix("iPad7,") {
            specs.isLightning = true
        } else if machineIdentifier.hasPrefix("iPhone16,1") || machineIdentifier.hasPrefix("iPhone16,2") ||
            machineIdentifier.hasPrefix("iPhone17,1") || machineIdentifier.hasPrefix("iPhone17,2") ||
            machineIdentifier.hasPrefix("iPhone18,1") || machineIdentifier.hasPrefix("iPhone18,2") ||
            machineIdentifier.hasPrefix("iPhone19,2") || machineIdentifier.hasPrefix("iPhone19,3") ||
            machineIdentifier.hasPrefix("iPhone19,4") || machineIdentifier.hasPrefix("iPad16") ||
            machineIdentifier.hasPrefix("iPad17") || machineIdentifier.hasPrefix("iPad14") ||
            machineIdentifier.hasPrefix("iPad15,3") || machineIdentifier.hasPrefix("iPad15,4") ||
            machineIdentifier.hasPrefix("iPad15,5") || machineIdentifier.hasPrefix("iPad15,6") ||
            (machineIdentifier.hasPrefix("iPad13") && !machineIdentifier.hasPrefix("iPad13,18") && !machineIdentifier.hasPrefix("iPad13,19")) {
            specs.isUsbC10G = true
        } else if machineIdentifier.hasPrefix("iPhone15,4") || machineIdentifier.hasPrefix("iPhone15,5") ||
            machineIdentifier.hasPrefix("iPhone17") || machineIdentifier.hasPrefix("iPhone18") ||
            machineIdentifier.hasPrefix("iPhone19") || machineIdentifier.hasPrefix("iPad13,18") ||
            machineIdentifier.hasPrefix("iPad13,19") || machineIdentifier.hasPrefix("iPad15") {
            specs.isUsbC480M = true
        } else {
            specs.isLightning = true
        }

        self.hardwareSpecs = specs
    }

    // MARK: - 7. Cache Clean (Purged Trigger)
    @MainActor
    public func cleanSystemCache() async {
        guard !isCleaningCache else { return }
        isCleaningCache = true
        Haptics.impact(.medium)

        URLCache.shared.removeAllCachedResponses()

        await Task.detached(priority: .userInitiated) {
            let fm = FileManager.default
            let tempDir = fm.temporaryDirectory
            if let children = try? fm.contentsOfDirectory(at: tempDir, includingPropertiesForKeys: nil) {
                for child in children {
                    try? fm.removeItem(at: child)
                }
            }
            try? await Task.sleep(nanoseconds: 250_000_000)
        }.value

        let disk = sampleStorageUsage()
        let mem = sampleMemoryUsage()
        self.totalDiskSpace = disk.total
        self.availableDiskSpace = disk.available
        self.purgeableDiskSpace = disk.purgeable
        self.activeMemory = mem.active
        self.inactiveMemory = mem.inactive
        self.wiredMemory = mem.wired
        self.compressedMemory = mem.compressed
        self.freeMemory = mem.free
        lastCachePurgedAt = Date()
        isCleaningCache = false
        Haptics.success()
    }

    // MARK: - 8. Thermal & Temperature Telemetry
    private func sampleThermals(totalCpu: Double) -> (state: ProcessInfo.ThermalState, batteryTemp: Double, socTemp: Double, pressure: Int, isEstimated: Bool) {
        let state = ProcessInfo.processInfo.thermalState
        let hw = HardwareBatteryProbe.sample()

        let baseTemp: Double
        let pressure: Int
        switch state {
        case .nominal:
            baseTemp = 30.5
            pressure = 10
        case .fair:
            baseTemp = 36.0
            pressure = 45
        case .serious:
            baseTemp = 41.5
            pressure = 80
        case .critical:
            baseTemp = 46.0
            pressure = 98
        @unknown default:
            baseTemp = 31.0
            pressure = 15
        }

        var estimated = false
        let battTemp: Double
        if let bTemp = hw.temperatureCelsius {
            battTemp = bTemp
        } else {
            estimated = true
            let target = baseTemp + (Double(totalCpu) / 100.0) * 2.5
            battTemp = lastSampledBatteryTemp * 0.85 + target * 0.15
        }
        lastSampledBatteryTemp = battTemp

        let socTemp: Double
        if let sTemp = hw.socTemperatureCelsius {
            socTemp = sTemp
        } else {
            estimated = true
            let socTarget = battTemp + 2.0 + (Double(totalCpu) / 100.0) * 8.5
            socTemp = lastSampledSocTemp * 0.8 + socTarget * 0.2
        }
        lastSampledSocTemp = socTemp

        let thermalPressure = min(100, max(5, pressure + Int(totalCpu * 0.2)))
        return (state: state, batteryTemp: battTemp, socTemp: socTemp, pressure: thermalPressure, isEstimated: estimated)
    }

    // MARK: - Device Database Lookup
    public static func lookupDevice(identifier: String) -> (String, String) {
        switch identifier {
        // iPhone 18 Family (Late 2026)
        case "iPhone19,1": return ("iPhone 18", "Apple A20")
        case "iPhone19,2": return ("iPhone 18 Pro", "Apple A20 Pro")
        case "iPhone19,3": return ("iPhone 18 Pro Max", "Apple A20 Pro")
        case "iPhone19,4": return ("iPhone Fold", "Apple A20 Pro")
        case "iPhone19,5": return ("iPhone 18 Air", "Apple A20")
        // iPhone 17 Family (Late 2025)
        case "iPhone18,1": return ("iPhone 17 Pro", "Apple A19 Pro")
        case "iPhone18,2": return ("iPhone 17 Pro Max", "Apple A19 Pro")
        case "iPhone18,3": return ("iPhone 17", "Apple A19")
        case "iPhone18,4": return ("iPhone Air", "Apple A19")
        case "iPhone18,5": return ("iPhone 17e", "Apple A19")
        // iPhone 16 Family (2024–2025)
        case "iPhone17,1": return ("iPhone 16 Pro", "Apple A18 Pro")
        case "iPhone17,2": return ("iPhone 16 Pro Max", "Apple A18 Pro")
        case "iPhone17,3": return ("iPhone 16", "Apple A18")
        case "iPhone17,4": return ("iPhone 16 Plus", "Apple A18")
        case "iPhone17,5": return ("iPhone 16e", "Apple A18")
        // iPhone 15 Family (2023)
        case "iPhone16,1": return ("iPhone 15 Pro", "Apple A17 Pro")
        case "iPhone16,2": return ("iPhone 15 Pro Max", "Apple A17 Pro")
        case "iPhone15,4": return ("iPhone 15", "Apple A16 Bionic")
        case "iPhone15,5": return ("iPhone 15 Plus", "Apple A16 Bionic")
        // iPhone 14 Family (2022)
        case "iPhone15,2": return ("iPhone 14 Pro", "Apple A16 Bionic")
        case "iPhone15,3": return ("iPhone 14 Pro Max", "Apple A16 Bionic")
        case "iPhone14,7": return ("iPhone 14", "Apple A15 Bionic")
        case "iPhone14,8": return ("iPhone 14 Plus", "Apple A15 Bionic")
        // iPhone 13 Family & SE 3 (2021-2022)
        case "iPhone14,2": return ("iPhone 13 Pro", "Apple A15 Bionic")
        case "iPhone14,3": return ("iPhone 13 Pro Max", "Apple A15 Bionic")
        case "iPhone14,4": return ("iPhone 13 mini", "Apple A15 Bionic")
        case "iPhone14,5": return ("iPhone 13", "Apple A15 Bionic")
        case "iPhone14,6": return ("iPhone SE (3rd gen)", "Apple A15 Bionic")
        // iPhone 12 Family (2020)
        case "iPhone13,1": return ("iPhone 12 mini", "Apple A14 Bionic")
        case "iPhone13,2": return ("iPhone 12", "Apple A14 Bionic")
        case "iPhone13,3": return ("iPhone 12 Pro", "Apple A14 Bionic")
        case "iPhone13,4": return ("iPhone 12 Pro Max", "Apple A14 Bionic")
        // iPhone 11 Family & SE 2 (2019-2020)
        case "iPhone12,8": return ("iPhone SE (2nd gen)", "Apple A13 Bionic")
        case "iPhone12,5": return ("iPhone 11 Pro Max", "Apple A13 Bionic")
        case "iPhone12,3": return ("iPhone 11 Pro", "Apple A13 Bionic")
        case "iPhone12,1": return ("iPhone 11", "Apple A13 Bionic")
        // iPhone XS / XR (2018)
        case "iPhone11,8": return ("iPhone XR", "Apple A12 Bionic")
        case "iPhone11,6", "iPhone11,4": return ("iPhone XS Max", "Apple A12 Bionic")
        case "iPhone11,2": return ("iPhone XS", "Apple A12 Bionic")
        // iPhone X & 8 (2017)
        case "iPhone10,6", "iPhone10,3": return ("iPhone X", "Apple A11 Bionic")
        case "iPhone10,5", "iPhone10,2": return ("iPhone 8 Plus", "Apple A11 Bionic")
        case "iPhone10,4", "iPhone10,1": return ("iPhone 8", "Apple A11 Bionic")
        // iPhone 7 & Prior
        case "iPhone9,4", "iPhone9,2": return ("iPhone 7 Plus", "Apple A10 Fusion")
        case "iPhone9,3", "iPhone9,1": return ("iPhone 7", "Apple A10 Fusion")
        case "iPhone8,4": return ("iPhone SE (1st gen)", "Apple A9")
        case "iPhone8,2": return ("iPhone 6s Plus", "Apple A9")
        case "iPhone8,1": return ("iPhone 6s", "Apple A9")
        // iPad Pro M5 (2025-2026)
        case "iPad17,1", "iPad17,2": return ("iPad Pro 11-inch (M5)", "Apple M5")
        case "iPad17,3", "iPad17,4": return ("iPad Pro 13-inch (M5)", "Apple M5")
        // iPad Air M4 (2025)
        case "iPad16,8", "iPad16,9": return ("iPad Air 11-inch (M4)", "Apple M4")
        case "iPad16,10", "iPad16,11": return ("iPad Air 13-inch (M4)", "Apple M4")
        // iPad Pro M4 (2024)
        case "iPad16,3", "iPad16,4": return ("iPad Pro 11-inch (M4)", "Apple M4")
        case "iPad16,5", "iPad16,6": return ("iPad Pro 13-inch (M4)", "Apple M4")
        // iPad mini 7 (2024)
        case "iPad16,1", "iPad16,2": return ("iPad mini (A17 Pro)", "Apple A17 Pro")
        // iPad Pro M2 & M1
        case "iPad14,3", "iPad14,4": return ("iPad Pro 11-inch (4th gen)", "Apple M2")
        case "iPad14,5", "iPad14,6": return ("iPad Pro 12.9-inch (6th gen)", "Apple M2")
        case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7": return ("iPad Pro 11-inch (3rd gen)", "Apple M1")
        case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11": return ("iPad Pro 12.9-inch (5th gen)", "Apple M1")
        // iPad Air M2 & M1
        case "iPad14,8", "iPad14,9": return ("iPad Air 11-inch (M2)", "Apple M2")
        case "iPad14,10", "iPad14,11": return ("iPad Air 13-inch (M2)", "Apple M2")
        case "iPad13,16", "iPad13,17": return ("iPad Air (5th gen)", "Apple M1")
        case "iPad13,1", "iPad13,2": return ("iPad Air (4th gen)", "Apple A14 Bionic")
        // iPad mini 6/5 & Base iPads & iPad Air M3
        case "iPad14,1", "iPad14,2": return ("iPad mini (6th gen)", "Apple A15 Bionic")
        case "iPad11,1", "iPad11,2": return ("iPad mini (5th gen)", "Apple A12 Bionic")
        case "iPad11,3", "iPad11,4": return ("iPad Air (3rd gen)", "Apple A12 Bionic")
        case "iPad15,3", "iPad15,4": return ("iPad Air 11-inch (M3)", "Apple M3")
        case "iPad15,5", "iPad15,6": return ("iPad Air 13-inch (M3)", "Apple M3")
        case "iPad15,1", "iPad15,2", "iPad15,7", "iPad15,8": return ("iPad (11th gen)", "Apple A16 Bionic")
        case "iPad13,18", "iPad13,19": return ("iPad (10th gen)", "Apple A14 Bionic")
        case "iPad12,1", "iPad12,2": return ("iPad (9th gen)", "Apple A13 Bionic")
        case "iPad11,6", "iPad11,7": return ("iPad (8th gen)", "Apple A12 Bionic")
        case "arm64", "x86_64":
            return ("Apple Silicon Simulator", "Apple Silicon Host")
        default:
            if identifier.hasPrefix("iPhone") {
                return ("iPhone (\(identifier))", "Apple Silicon")
            } else if identifier.hasPrefix("iPad") {
                return ("iPad (\(identifier))", "Apple Silicon")
            }
            return (identifier, "Apple Silicon")
        }
    }
}

// MARK: - Byte Formatter Helpers
public extension Int64 {
    var formattedBytes: String {
        ByteCountFormatter.string(fromByteCount: self, countStyle: .file)
    }
}

public extension UInt64 {
    var formattedBytes: String {
        ByteCountFormatter.string(fromByteCount: Int64(self), countStyle: .memory)
    }
}

// MARK: - Compatibility Typealias
public typealias SystemService = SystemViewModel
