//
//  BatteryModels.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Domain entities and telemetry data models for battery subsystem.
//

import Foundation

// MARK: - Battery Analytics Record (Apple Sysdiagnose IPS)
public struct BatteryAnalyticsRecord: Codable, Sendable {
    public let cycleCount: Int
    public let nominalChargeCapacityMah: Int
    public let maximumFccMah: Int
    public let healthPercent: Double
    public let logDate: Date
    public let sourceFileName: String

    public init(
        cycleCount: Int,
        nominalChargeCapacityMah: Int,
        maximumFccMah: Int,
        healthPercent: Double,
        logDate: Date = Date(),
        sourceFileName: String = "Analytics.ips"
    ) {
        self.cycleCount = cycleCount
        self.nominalChargeCapacityMah = nominalChargeCapacityMah
        self.maximumFccMah = maximumFccMah
        self.healthPercent = healthPercent
        self.logDate = logDate
        self.sourceFileName = sourceFileName
    }
}

// MARK: - Thermal Zone Definition
public enum ThermalZone: String, CaseIterable, Identifiable, Sendable {
    case soc
    case battery
    case pmic
    case wireless

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .soc: return L10n.Battery.zoneSoc
        case .battery: return L10n.Battery.zoneBattery
        case .pmic: return L10n.Battery.zonePmic
        case .wireless: return L10n.Battery.zoneWireless
        }
    }

    public var shortLabel: String {
        switch self {
        case .soc: return L10n.Battery.zoneSocShort
        case .battery: return L10n.Battery.zoneBatteryShort
        case .pmic: return L10n.Battery.zonePmicShort
        case .wireless: return L10n.Battery.zoneWirelessShort
        }
    }

    public var icon: String {
        switch self {
        case .soc: return "cpu.fill"
        case .battery: return "battery.100.bolt"
        case .pmic: return "bolt.fill"
        case .wireless: return "antenna.radiowaves.left.and.right.circle.fill"
        }
    }

    public var tip: String {
        switch self {
        case .soc: return L10n.Battery.thermalTipSoc
        case .battery: return L10n.Battery.thermalTipBattery
        case .pmic: return L10n.Battery.thermalTipPmic
        case .wireless: return L10n.Battery.thermalTipWireless
        }
    }
}

// MARK: - Visual Thermal View Mode
public enum ThermalViewMode: String, CaseIterable, Identifiable, Sendable {
    case flir
    case xray

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .flir: return L10n.Battery.flirMode
        case .xray: return L10n.Battery.xrayMode
        }
    }

    public var icon: String {
        switch self {
        case .flir: return "flame.fill"
        case .xray: return "square.2.layers.3d.fill"
        }
    }
}

// MARK: - Battery Degradation Curve Data Point
public struct DegradationPoint: Identifiable, Sendable {
    public let id: String
    public let cycle: Double
    public let health: Double

    public init(id: String, cycle: Double, health: Double) {
        self.id = id
        self.cycle = cycle
        self.health = health
    }
}
