//
//  NetworkModels.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Domain entities and data models for Network telemetry, LAN scanning, DNS & Speed test.
//

import Foundation

// MARK: - Network Link Type
public enum NetworkLinkType: Sendable {
    case wifi
    case cellular
    case wired
    case none

    public var localizedName: String {
        switch self {
        case .wifi: return L10n.Network.wifi
        case .cellular: return L10n.Network.cellular
        case .wired: return L10n.Network.wired
        case .none: return L10n.Network.disconnected
        }
    }

    public var iconName: String {
        switch self {
        case .wifi: return "wifi"
        case .cellular: return "antenna.radiowaves.left.and.right.circle.fill"
        case .wired: return "cable.connector"
        case .none: return "bolt.horizontal.circle.fill"
        }
    }
}

// MARK: - Speed Test Stage
public enum SpeedTestStage: String, Sendable {
    case idle
    case ping
    case download
    case upload
    case completed
}

// MARK: - Speed Test History Record
public struct SpeedTestRecord: Codable, Identifiable, Sendable {
    public var id: UUID
    public let date: Date
    public let downloadMbps: Double
    public let uploadMbps: Double
    public let pingMs: Double
    public let jitterMs: Double
    public let rating: String
    public let serverName: String

    public init(
        id: UUID = UUID(),
        date: Date = Date(),
        downloadMbps: Double,
        uploadMbps: Double,
        pingMs: Double,
        jitterMs: Double,
        rating: String,
        serverName: String
    ) {
        self.id = id
        self.date = date
        self.downloadMbps = downloadMbps
        self.uploadMbps = uploadMbps
        self.pingMs = pingMs
        self.jitterMs = jitterMs
        self.rating = rating
        self.serverName = serverName
    }
}

// MARK: - Ping Target Node
public enum PingTargetNode: String, CaseIterable, Identifiable, Sendable {
    case cloudflare = "1.1.1.1"
    case alibaba = "223.5.5.5"
    case google = "8.8.8.8"
    case gateway = "gateway"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .cloudflare: return "Cloudflare (1.1.1.1)"
        case .alibaba: return "AliDNS (223.5.5.5)"
        case .google: return "Google (8.8.8.8)"
        case .gateway: return "Gateway Router"
        }
    }

    public var shortName: String {
        switch self {
        case .cloudflare: return "Cloudflare"
        case .alibaba: return "AliDNS"
        case .google: return "Google"
        case .gateway: return L10n.Network.gatewayShort
        }
    }

    public var defaultPort: UInt16 {
        switch self {
        case .cloudflare, .alibaba, .google: return 53
        case .gateway: return 80
        }
    }
}

// MARK: - Discovered LAN Device Model
public struct DiscoveredDevice: Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let serviceType: String
    public let interfaceName: String
    public let ipAddress: String
    public var macAddress: String?
    public var vendorName: String?
    public var latencyMs: Double?

    public init(
        id: String,
        name: String,
        serviceType: String,
        interfaceName: String,
        ipAddress: String,
        macAddress: String? = nil,
        vendorName: String? = nil,
        latencyMs: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.serviceType = serviceType
        self.interfaceName = interfaceName
        self.ipAddress = ipAddress
        self.macAddress = macAddress
        self.vendorName = vendorName
        self.latencyMs = latencyMs
    }

    public var iconName: String {
        let lower = name.lowercased() + serviceType.lowercased() + (vendorName?.lowercased() ?? "")
        if lower.contains("mac") || lower.contains("book") || lower.contains("imac") {
            return "laptopcomputer"
        } else if lower.contains("iphone") || lower.contains("phone") {
            return "iphone"
        } else if lower.contains("ipad") {
            return "ipad"
        } else if lower.contains("tv") || lower.contains("apple-tv") {
            return "appletv.fill"
        } else if lower.contains("router") || lower.contains("gateway") || lower.contains("路由") {
            return "wifi.router.fill"
        } else if lower.contains("nas") || lower.contains("synology") || lower.contains("smb") {
            return "externaldrive.connected.to.line.below.fill"
        } else if lower.contains("print") {
            return "printer.fill"
        } else if lower.contains("iot") || lower.contains("智能") || lower.contains("esp") {
            return "sensor.fill"
        } else {
            return "desktopcomputer"
        }
    }
}

/// Backward compatibility alias for LAN scanner
public typealias LanDevice = DiscoveredDevice

// MARK: - Traffic Point for Swift Charts
public struct TrafficDataPoint: Identifiable, Sendable {
    public let id: String
    public let timestamp: Date
    public let downBps: Double
    public let upBps: Double

    public init(id: String = UUID().uuidString, timestamp: Date, downBps: Double, upBps: Double) {
        self.id = id
        self.timestamp = timestamp
        self.downBps = downBps
        self.upBps = upBps
    }
}

// MARK: - DNS Benchmark Result
public struct DnsBenchmarkResult: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let host: String
    public var latencyMs: Double
    public var isFastest: Bool

    public init(id: String, name: String, host: String, latencyMs: Double, isFastest: Bool) {
        self.id = id
        self.name = name
        self.host = host
        self.latencyMs = latencyMs
        self.isFastest = isFastest
    }
}

// MARK: - Common Port Scan Item
public struct PortScanItem: Identifiable, Sendable {
    public var id: UInt16 { port }
    public let port: UInt16
    public let serviceName: String
    public var isOpen: Bool
    public var latencyMs: Double

    public init(port: UInt16, serviceName: String, isOpen: Bool, latencyMs: Double) {
        self.port = port
        self.serviceName = serviceName
        self.isOpen = isOpen
        self.latencyMs = latencyMs
    }
}

// MARK: - DNS Record Dig Result
public struct DnsDigResult: Sendable {
    public let domain: String
    public let ipv4List: [String]
    public let ipv6List: [String]
    public let queryTimeMs: Double

    public init(domain: String, ipv4List: [String], ipv6List: [String], queryTimeMs: Double) {
        self.domain = domain
        self.ipv4List = ipv4List
        self.ipv6List = ipv6List
        self.queryTimeMs = queryTimeMs
    }
}

// MARK: - Latency Card Segment Mode
public enum LatencyCardMode: Int, CaseIterable, Identifiable, Sendable {
    case live
    case benchmark

    public var id: Int { rawValue }

    public var title: String {
        switch self {
        case .live: return L10n.Network.latencyLive
        case .benchmark: return L10n.Network.latencyBenchmark
        }
    }
}

