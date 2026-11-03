//
//  SystemModels.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Domain entities and hardware specification data models for system telemetry.
//

import Foundation
import LocalAuthentication

// MARK: - Metric History Data Point
public struct MetricPoint: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let timestamp: Date
    public let value: Double

    public init(id: UUID = UUID(), timestamp: Date = Date(), value: Double) {
        self.id = id
        self.timestamp = timestamp
        self.value = value
    }
}

// MARK: - Core Load Snapshot
public struct CoreLoad: Sendable {
    public var user: UInt32 = 0
    public var system: UInt32 = 0
    public var idle: UInt32 = 0
    public var nice: UInt32 = 0

    public init(user: UInt32 = 0, system: UInt32 = 0, idle: UInt32 = 0, nice: UInt32 = 0) {
        self.user = user
        self.system = system
        self.idle = idle
        self.nice = nice
    }

    public var total: UInt32 {
        user + system + idle + nice
    }
}

// MARK: - Hardware Telemetry Enum Tiers (Reactive to Localization)
public enum DisplayPanelType: Sendable {
    case superRetinaHD // iPhone X, XS, XS Max
    case superRetinaXDROLED // iPhone 11 Pro, 12, 13, 14, 15, 16, 17, 18 standard
    case superRetinaXDRProMotion // ProMotion models
    case ultraRetinaXDR // iPad Pro M4, M5 (Tandem OLED)
    case liquidRetina // iPhone XR, 11, SE, iPad Air
    case retina // Default

    public var localizedName: String {
        switch self {
        case .superRetinaHD: return L10n.Overview.displaySuperRetinaHD
        case .superRetinaXDROLED: return L10n.Overview.displaySuperRetinaXDROLED
        case .superRetinaXDRProMotion: return L10n.Overview.displaySuperRetinaXDRProMotion
        case .ultraRetinaXDR: return L10n.Overview.displayUltraRetinaXDR
        case .liquidRetina: return L10n.Overview.displayLiquidRetina
        case .retina: return L10n.Overview.displayTechDefault
        }
    }
}

public enum IsaArchTier: Sendable {
    case armV82
    case armV83
    case armV84
    case armV85
    case armV86
    case armV90
    case armV92
    case arm64Standard

    public var localizedDescription: String {
        switch self {
        case .armV82: return "ARM64 (v8.2-A)"
        case .armV83: return "ARM64 (v8.3-A)"
        case .armV84: return "ARM64 (v8.4-A)"
        case .armV85: return "ARM64 (v8.5-A)"
        case .armV86: return "ARM64 (v8.6-A)"
        case .armV90: return "ARM64 (v9.0-A)"
        case .armV92: return "ARM64 (v9.2-A)"
        case .arm64Standard: return "ARM64"
        }
    }
}

public enum NeuralEngineTier: Sendable {
    case a11
    case a12
    case a13
    case a14
    case a15
    case a16
    case a17Pro
    case a18Plus
    case appleSiliconM
    case standard

    public var localizedDescription: String {
        switch self {
        case .a11: return L10n.Overview.aneA11
        case .a12: return L10n.Overview.aneA12
        case .a13: return L10n.Overview.aneA13
        case .a14: return L10n.Overview.aneA14
        case .a15: return L10n.Overview.aneA15
        case .a16: return L10n.Overview.aneA16
        case .a17Pro: return L10n.Overview.aneA17Pro
        case .a18Plus: return L10n.Overview.aneA18Plus
        case .appleSiliconM: return L10n.Overview.aneAppleSiliconM
        case .standard: return L10n.Overview.neuralEngineStandard
        }
    }
}

// MARK: - Full Hardware Specs Structure
public struct DetailedHardwareSpecs: Sendable {
    // Display
    public var physicalWidth: Int = 1179
    public var physicalHeight: Int = 2556
    public var maxFps: Int = 60
    public var ppi: Int = 460
    public var scale: Int = 3
    public var panelType: DisplayPanelType = .retina

    // SoC Architecture
    public var processNodeZh: String = "7nm (台积电 FinFET)"
    public var processNodeEn: String = "7nm (TSMC FinFET)"
    public var coreCount: Int = 6
    public var pCores: Int = 2
    public var eCores: Int = 4
    public var l1dKb: Int = 128
    public var l2Mb: Int = 8
    public var isaTier: IsaArchTier = .arm64Standard
    public var aneTier: NeuralEngineTier = .standard

    // GPU Architecture
    public var gpuDeviceName: String = "Apple GPU"
    public var gpuCores: Int = 4
    public var metalFeatureSet: String = "Metal 2 (Apple Family 5)"
    public var supportsRayTracing: Bool = false
    public var supportsMeshShaders: Bool = false

    // Optics & Security & Ports
    public var biometryType: LABiometryType = .faceID
    public var hasLiDAR: Bool = false
    public var isUsbC10G: Bool = false
    public var isUsbC480M: Bool = false
    public var isLightning: Bool = false

    public init() {}

    // Dynamic Localized Computed Properties
    public var physicalResolution: String {
        "\(physicalWidth) × \(physicalHeight)"
    }

    public var maxRefreshRate: String {
        if maxFps >= 120 {
            return L10n.Overview.refreshRate120
        } else {
            return L10n.Overview.refreshRate60
        }
    }

    public var ppiAndScale: String {
        "\(ppi) ppi (@\(scale)x)"
    }

    public var displayTechnology: String {
        panelType.localizedName
    }

    public var processNode: String {
        L10n.tr(zh: processNodeZh, en: processNodeEn, hant: processNodeZh.replacingOccurrences(of: "台积电", with: "台積電").replacingOccurrences(of: "高性能工艺", with: "高效能工藝"))
    }

    public var isaArchitecture: String {
        isaTier.localizedDescription
    }

    public var cpuCluster: String {
        L10n.Overview.cpuClusterText(total: coreCount, p: pCores, e: eCores)
    }

    public var cacheSizes: String {
        "\(l1dKb) KB L1 · \(l2Mb) MB L2"
    }

    public var neuralEngineDetails: String {
        aneTier.localizedDescription
    }

    public var gpuCoresDescription: String {
        L10n.tr(
            zh: "\(gpuCores) 核 GPU",
            en: "\(gpuCores)-Core GPU",
            hant: "\(gpuCores) 核 GPU"
        )
    }

    public var pageSize: String {
        let size = vm_kernel_page_size
        let kb = size / 1024
        return "\(kb) KB (ARM64)"
    }

    public var darwinKernel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let release = withUnsafePointer(to: &systemInfo.release) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in
                String(cString: ptr)
            }
        }
        return "Darwin \(release)"
    }

    public var biometryIconName: String {
        switch biometryType {
        case .faceID: return "faceid"
        case .touchID: return "touchid"
        case .opticID: return "eye.fill"
        default: return "lock.fill"
        }
    }

    public var biometricsType: String {
        switch biometryType {
        case .faceID:
            return L10n.Overview.faceIdTrueDepth
        case .touchID:
            return L10n.Overview.touchIdText
        case .opticID:
            return "Optic ID"
        case .none:
            return L10n.Overview.passcodeText
        @unknown default:
            return L10n.Common.unknown
        }
    }

    public var lidarStatus: String {
        hasLiDAR ? L10n.Overview.lidarEquipped : L10n.Overview.lidarNotEquipped
    }

    public var secureEnclave: String {
        L10n.Overview.sepText
    }

    public var physicalPort: String {
        if isUsbC10G {
            return L10n.Overview.portUsbC10G
        } else if isUsbC480M {
            return L10n.Overview.portUsbC480M
        } else {
            return L10n.Overview.portLightning
        }
    }
}

// MARK: - Hardware Category for Overview Card
public enum HardwareCategory: Int, CaseIterable, Identifiable, Sendable {
    case display = 0
    case soc = 1
    case gpu = 2
    case system = 3

    public var id: Int { rawValue }

    public var title: String {
        switch self {
        case .display: return L10n.Overview.catDisplay
        case .soc: return L10n.Overview.catSoC
        case .gpu: return L10n.Overview.catGPU
        case .system: return L10n.Overview.catSystem
        }
    }

    public var icon: String {
        switch self {
        case .display: return "sparkles.tv.fill"
        case .soc: return "cpu.fill"
        case .gpu: return "gamecontroller.fill"
        case .system: return "gearshape.2.fill"
        }
    }
}
