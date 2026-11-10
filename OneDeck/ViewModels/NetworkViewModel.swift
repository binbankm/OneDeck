//
//  NetworkViewModel.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Network interfaces, traffic throughput, and connection telemetry view model.
//

import Darwin
import Network
import Observation
import os
import SwiftUI
#if os(iOS)
import CoreTelephony
#endif

// MARK: - Network ViewModel Hub
@Observable
public final class NetworkViewModel: @unchecked Sendable {
    @MainActor public static let shared = NetworkViewModel()

    // MARK: - 1. Link & Interface State
    public var isConnected: Bool = false
    public var isExpensive: Bool = false
    public var isConstrained: Bool = false
    public var linkType: NetworkLinkType = .none

    // Cellular & Wi-Fi Radio Telemetry
    public var cellularGeneration: String = "5G NR"
    public var carrierName: String = ""
    public var wifiHardwareGeneration: String = "Wi-Fi 6"
    public var wifiStandard: String = "802.11ax"
    public var wifiSSID: String?
    public var wifiBSSID: String?
    public var wifiRssiDbm: Int?
    public var wifiChannel: Int?
    public var wifiTxRateMbps: Int?
    public var activeWiredInterface: String = "en0"

    public var activeInterfaceSummary: String {
        switch linkType {
        case .cellular:
            let gen = cellularGeneration.isEmpty ? "5G NR" : cellularGeneration
            return "\(gen) · pdp_ip0"
        case .wifi:
            if let ssid = wifiSSID, !ssid.isEmpty {
                return "\(ssid) · en0"
            }
            return "\(wifiHardwareGeneration) · en0"
        case .wired:
            return "\(L10n.Network.wired) · \(activeWiredInterface)"
        case .none:
            return L10n.Network.disconnected
        }
    }

    public var activeInterfaceDetailed: String {
        switch linkType {
        case .cellular:
            let carrier = carrierName.isEmpty ? L10n.Network.cellular : carrierName
            return "\(carrier) \(cellularGeneration) (pdp_ip0)"
        case .wifi:
            let ssidStr: String
            if let ssid = wifiSSID, !ssid.isEmpty {
                ssidStr = "\(ssid) · "
            } else {
                ssidStr = ""
            }
            return "\(ssidStr)\(wifiHardwareGeneration) · \(wifiStandard) (en0)"
        case .wired:
            return "\(L10n.Network.wired) (\(activeWiredInterface))"
        case .none:
            return L10n.Network.disconnected
        }
    }

    public var localIPv4: String = "--"
    public var subnetMask: String = "--"
    public var gatewayIPv4: String = "--"
    public var broadcastIPv4: String = "--"
    public var dnsServers: [String] = []
    public var interfaceMtu: Int = 1500
    public var interfaceBaudrateMbps: Double = 300.0
    public var subnetRange: String = "--"

    // MARK: - 2. Public IP & Geolocation
    public var publicIP: String = "--"
    public var publicIPv6: String = ""
    public var ispName: String = "--"
    public var geoCity: String = "--"
    public var geoCountry: String = "--"
    public var proxyExitIP: String = ""
    public var proxyExitLocation: String = ""
    public var isQueryingPublicIP: Bool = false

    // MARK: - 3. Ping Latency & Jitter Monitor
    public var selectedTarget: PingTargetNode = .cloudflare
    public var currentLatencyMs: Double = 0.0
    public var jitterMs: Double = 0.0
    public var packetLossPercent: Double = 0.0
    public var isPinging: Bool = false
    public var latencyHistory: [MetricPoint] = []

    // MARK: - 4. Live Bandwidth & Throughput Waveform
    public var downloadSpeedBps: Double = 0.0
    public var uploadSpeedBps: Double = 0.0
    public var totalBytesIn: UInt64 = 0
    public var totalBytesOut: UInt64 = 0
    public var trafficHistory: [TrafficDataPoint] = []

    // MARK: - 5. LAN Discovery (Bonjour / mDNS & Kernel ARP)
    public var discoveredDevices: [DiscoveredDevice] = []
    public var isScanningLan: Bool = false

    // MARK: - 6. DNS Multi-Node Benchmark
    public var dnsBenchmarkResults: [DnsBenchmarkResult] = [
        DnsBenchmarkResult(id: "alidns", name: "AliDNS", host: "223.5.5.5", latencyMs: 0.0, isFastest: false),
        DnsBenchmarkResult(id: "dnspod", name: "DNSPod", host: "119.29.29.29", latencyMs: 0.0, isFastest: false),
        DnsBenchmarkResult(id: "cloudflare", name: "Cloudflare", host: "1.1.1.1", latencyMs: 0.0, isFastest: false),
        DnsBenchmarkResult(id: "google", name: "Google", host: "8.8.8.8", latencyMs: 0.0, isFastest: false),
        DnsBenchmarkResult(id: "baidu", name: "Baidu DNS", host: "180.76.76.76", latencyMs: 0.0, isFastest: false)
    ]
    public var isBenchmarkingDns: Bool = false

    // MARK: - 7. Common Port Scanner
    public var portScanResults: [PortScanItem] = [
        PortScanItem(port: 22, serviceName: "SSH", isOpen: false, latencyMs: 0),
        PortScanItem(port: 53, serviceName: "DNS", isOpen: false, latencyMs: 0),
        PortScanItem(port: 80, serviceName: "HTTP Web", isOpen: false, latencyMs: 0),
        PortScanItem(port: 443, serviceName: "HTTPS", isOpen: false, latencyMs: 0),
        PortScanItem(port: 445, serviceName: "SMB / NAS", isOpen: false, latencyMs: 0),
        PortScanItem(port: 3389, serviceName: "RDP", isOpen: false, latencyMs: 0),
        PortScanItem(port: 5000, serviceName: "DSM", isOpen: false, latencyMs: 0),
        PortScanItem(port: 8080, serviceName: "HTTP Alt", isOpen: false, latencyMs: 0)
    ]
    public var isScanningPorts: Bool = false
    public var hasScannedPorts: Bool = false
    public var portScanError: String?

    // MARK: - 8. Active Bandwidth Speed Test Engine
    public var speedTestStage: SpeedTestStage = .idle
    public var isRunningSpeedTest: Bool {
        switch speedTestStage {
        case .ping, .download, .upload: return true
        case .idle, .completed: return false
        }
    }
    public var speedTestProgress: Double = 0.0 // 0.0 to 1.0 overall
    public var speedTestCurrentMbps: Double = 0.0
    public var speedTestDownloadMbps: Double = 0.0
    public var speedTestDownloadPeakMbps: Double = 0.0
    public var speedTestUploadMbps: Double = 0.0
    public var speedTestUploadPeakMbps: Double = 0.0
    public var speedTestPingMs: Double = 0.0
    public var speedTestJitterMs: Double = 0.0
    public var speedTestRating: String = ""
    public var speedTestServerName: String = "Cloudflare Edge Anycast"
    public var speedTestError: String?
    public var isSpeedTestUploadAvailable: Bool = true
    public var speedTestHistory: [SpeedTestRecord] = []
    public var latestSpeedTestRecord: SpeedTestRecord? {
        speedTestHistory.first
    }

    // MARK: - Internal Workers
    private struct TrafficByteSnapshot: Sendable {
        var hasSample: Bool = false
        var lastIn: [String: UInt32] = [:]
        var lastOut: [String: UInt32] = [:]
        var sessionIn: UInt64 = 0
        var sessionOut: UInt64 = 0
        var lastTimestamp: Date = .init()
    }

    private var speedTestTask: Task<Void, Never>?
    #if os(iOS)
    private let telephonyInfo = CTTelephonyNetworkInfo()
    #endif
    private var pathMonitor: NWPathMonitor?
    private var isTabMonitoring: Bool = false
    private let monitorQueue = DispatchQueue(label: "com.onedeck.network.monitor", qos: .utility)
    private let workerQueue = DispatchQueue(label: "com.onedeck.network.worker", qos: .utility, attributes: .concurrent)
    private var pingTimer: Timer?
    private var trafficTimer: Timer?
    private var nwPathGatewayIPv4: String?
    private var pingGeneration: UInt64 = 0
    private var dnsBenchmarkGeneration: UInt64 = 0
    private var portScanGeneration: UInt64 = 0
    private var interfaceRefreshGeneration: UInt64 = 0
    private var publicIPGeneration: UInt64 = 0
    private var lanBrowsers: [NWBrowser] = []
    private var lanScanGeneration: UUID = .init()
    private var lanScanTimeoutWorkItem: DispatchWorkItem?
    private nonisolated let lanScanActiveLock = OSAllocatedUnfairLock(initialState: false)
    private nonisolated let trafficLock = OSAllocatedUnfairLock(initialState: TrafficByteSnapshot())
    private var pingHistorySamples: [Double] = []

    public init() {
        loadSpeedTestHistory()
        refreshRadioTechnologyInfo()
        refreshInterfaceAddresses()
    }

    // MARK: - Life Cycle Control
    public func startPathMonitoring() {
        guard pathMonitor == nil else { return }

        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.handlePathUpdate(path)
            }
        }
        monitor.start(queue: monitorQueue)
        self.pathMonitor = monitor
    }

    public func stopPathMonitoring() {
        pathMonitor?.cancel()
        pathMonitor = nil
    }

    public func startMonitoring() {
        isTabMonitoring = true
        startPathMonitoring()
        refreshRadioTechnologyInfo()
        refreshInterfaceAddresses()

        if trafficTimer == nil {
            startTrafficSampling()
        }
        if pingTimer == nil {
            startContinuousPing()
        }
        if publicIP == "--" && isConnected && !isQueryingPublicIP {
            fetchPublicIPInfo()
        }
    }

    @MainActor
    public func applyPowerSavingPreference() {
        guard isTabMonitoring else { return }
        startTrafficSampling()
        startContinuousPing()
    }

    @MainActor
    public func selectPingTarget(_ target: PingTargetNode) {
        guard selectedTarget != target else { return }
        selectedTarget = target
        pingGeneration &+= 1
        pingHistorySamples.removeAll()
        latencyHistory.removeAll()
        currentLatencyMs = 0.0
        jitterMs = 0.0
        packetLossPercent = 0.0
        if isTabMonitoring {
            pingCurrentTarget()
        }
    }

    public func stopMonitoring() {
        isTabMonitoring = false
        publicIPGeneration &+= 1
        publicIPTask?.cancel()
        publicIPTask = nil
        isQueryingPublicIP = false
        pingGeneration &+= 1
        dnsBenchmarkGeneration &+= 1
        portScanGeneration &+= 1
        pingTimer?.invalidate()
        pingTimer = nil
        trafficTimer?.invalidate()
        trafficTimer = nil
        stopLanScan()
        stopSpeedTest()
        isScanningPorts = false
        isBenchmarkingDns = false
        trafficLock.withLock { state in
            state.hasSample = false
            state.lastIn.removeAll()
            state.lastOut.removeAll()
        }
    }

    public func refreshLocalizedStrings() {
        if speedTestStage == .completed && speedTestDownloadMbps > 0 {
            speedTestRating = L10n.Network.speedTestRatingText(for: speedTestDownloadMbps)
        }
        dnsBenchmarkResults = dnsBenchmarkResults.map { item in
            guard item.id == "gateway" else { return item }
            return DnsBenchmarkResult(
                id: item.id,
                name: L10n.Network.gatewayShort,
                host: item.host,
                latencyMs: item.latencyMs,
                isFastest: item.isFastest
            )
        }
    }

    // MARK: - Path & Interface Resolver
    @MainActor
    private func handlePathUpdate(_ path: NWPath) {
        let prevConnected = self.isConnected
        let prevLink = self.linkType

        self.isConnected = (path.status == .satisfied)
        self.isExpensive = path.isExpensive
        self.isConstrained = path.isConstrained

        if path.usesInterfaceType(.wifi) {
            self.linkType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            self.linkType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            self.linkType = .wired
        } else {
            self.linkType = isConnected ? .wifi : .none
        }

        // Extract IPv4 Gateway from NWPath if available (never place IPv6 literal into gatewayIPv4)
        var parsedIpv4Gateway: String?
        for endpoint in path.gateways {
            if case let .hostPort(host, _) = endpoint, case let .ipv4(ipv4) = host {
                let octets = [UInt8](ipv4.rawValue)
                if octets.count == 4 {
                    parsedIpv4Gateway = octets.map(String.init).joined(separator: ".")
                    break
                }
            }
        }
        self.nwPathGatewayIPv4 = parsedIpv4Gateway
        if let gw = parsedIpv4Gateway, !gw.isEmpty {
            self.gatewayIPv4 = gw
        }

        if !self.isConnected {
            publicIPGeneration &+= 1
            publicIPTask?.cancel()
            publicIPTask = nil
            isQueryingPublicIP = false
            nwPathGatewayIPv4 = nil
            gatewayIPv4 = "--"
            localIPv4 = "--"
            subnetMask = "--"
            broadcastIPv4 = "--"
            subnetRange = "--"
            dnsServers = []
            publicIP = "--"
            publicIPv6 = ""
            ispName = "--"
            geoCity = "--"
            geoCountry = "--"
            proxyExitIP = ""
            proxyExitLocation = ""
            wifiSSID = nil
            wifiBSSID = nil
            wifiRssiDbm = nil
            wifiChannel = nil
            wifiTxRateMbps = nil
            downloadSpeedBps = 0.0
            uploadSpeedBps = 0.0
        }

        refreshRadioTechnologyInfo()
        refreshInterfaceAddresses()

        // Auto-refresh Public IP only when Network tab is active and link reconnects or switches
        if isTabMonitoring && ((self.isConnected && !prevConnected) || (self.linkType != prevLink && self.isConnected)) {
            fetchPublicIPInfo(force: true)
        }
    }

    // MARK: - Wi-Fi & Cellular Hardware / Radio Discovery
    public static func detectWifiHardwareInfo() -> (generation: String, standard: String) {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: max(1, size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        let model = String(cString: machine)

        return NetworkKernelProbe.detectWifiHardware(machine: model)
    }

    #if os(iOS)
    private func queryLegacyCarrierName() -> String {
        guard let providers = (telephonyInfo as AnyObject).value(forKey: "serviceSubscriberCellularProviders") as? [String: AnyObject] else {
            return ""
        }
        for (_, provider) in providers {
            if let name = provider.value(forKey: "carrierName") as? String, !name.isEmpty, name != "--" {
                return name
            }
        }
        return ""
    }
    #endif

    @MainActor
    public func refreshRadioTechnologyInfo() {
        let (wifiGen, wifiStd) = Self.detectWifiHardwareInfo()
        self.wifiHardwareGeneration = wifiGen
        self.wifiStandard = wifiStd

        // Real IEEE 802.11 Telemetry (Apple80211 / MobileWiFi)
        if isConnected && linkType == .wifi, let wifi = NetworkKernelProbe.queryWifiTelemetry() {
            self.wifiSSID = wifi.ssid.flatMap { $0.isEmpty ? nil : $0 }
            self.wifiBSSID = wifi.bssid.flatMap { $0.isEmpty ? nil : $0 }
            self.wifiRssiDbm = wifi.rssiDbm
            self.wifiChannel = wifi.channel
            self.wifiTxRateMbps = wifi.txRateMbps
        } else {
            self.wifiSSID = nil
            self.wifiBSSID = nil
            self.wifiRssiDbm = nil
            self.wifiChannel = nil
            self.wifiTxRateMbps = nil
        }

        #if os(iOS)
        var carrier = queryLegacyCarrierName()
        if carrier.isEmpty && linkType == .cellular && !ispName.isEmpty && ispName != "--" {
            carrier = ispName
        }
        self.carrierName = carrier

        var gen = "5G NR"
        if let currentTechs = telephonyInfo.serviceCurrentRadioAccessTechnology {
            for (_, tech) in currentTechs {
                switch tech {
                case CTRadioAccessTechnologyNR, CTRadioAccessTechnologyNRNSA:
                    gen = "5G NR"
                case CTRadioAccessTechnologyLTE:
                    gen = "4G LTE"
                case CTRadioAccessTechnologyWCDMA,
                     CTRadioAccessTechnologyHSDPA,
                     CTRadioAccessTechnologyHSUPA,
                     CTRadioAccessTechnologyCDMAEVDORev0,
                     CTRadioAccessTechnologyCDMAEVDORevA,
                     CTRadioAccessTechnologyCDMAEVDORevB,
                     CTRadioAccessTechnologyeHRPD:
                    gen = "3G"
                case CTRadioAccessTechnologyEdge,
                     CTRadioAccessTechnologyGPRS,
                     CTRadioAccessTechnologyCDMA1x:
                    gen = "2G"
                default:
                    break
                }
            }
        }
        self.cellularGeneration = gen
        #else
        self.cellularGeneration = "5G NR"
        self.carrierName = ""
        #endif
    }

    // MARK: - POSIX Network Interface Address Extraction (getifaddrs)
    public func refreshInterfaceAddresses() {
        interfaceRefreshGeneration &+= 1
        let gen = interfaceRefreshGeneration
        workerQueue.async { [weak self] in
            guard let self else { return }
            var ifaddr: UnsafeMutablePointer<ifaddrs>?
            guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else { return }
            defer { freeifaddrs(ifaddr) }

            var lanIP = ""
            var lanMask = ""
            var lanBroadcast = ""
            var lanInterfaceName = "en0"
            var hasWifiEn0 = false
            var cellularIP = ""
            var mtu = 1500
            var baudrate = 300.0

            var ptr: UnsafeMutablePointer<ifaddrs>? = firstAddr
            while ptr != nil {
                guard let interface = ptr?.pointee else { break }
                guard let ifaAddr = interface.ifa_addr else {
                    ptr = interface.ifa_next
                    continue
                }
                let name = String(cString: interface.ifa_name)
                let flags = Int32(interface.ifa_flags)

                if (flags & (IFF_UP | IFF_RUNNING)) == (IFF_UP | IFF_RUNNING) && (flags & IFF_LOOPBACK) == 0 {
                    if ifaAddr.pointee.sa_family == UInt8(AF_INET) {
                        var host = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if getnameinfo(ifaAddr, socklen_t(ifaAddr.pointee.sa_len),
                                       &host, socklen_t(host.count), nil, 0, NI_NUMERICHOST) == 0 {
                            let ip = String(cString: host)

                            if name == "en0" || (name.hasPrefix("en") && !hasWifiEn0) {
                                if name == "en0" { hasWifiEn0 = true }
                                lanIP = ip
                                lanInterfaceName = name

                                if let netmask = interface.ifa_netmask {
                                    var maskBuf = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                                    if getnameinfo(netmask, socklen_t(netmask.pointee.sa_len),
                                                   &maskBuf, socklen_t(maskBuf.count), nil, 0, NI_NUMERICHOST) == 0 {
                                        lanMask = String(cString: maskBuf)
                                    }
                                }

                                if let dst = interface.ifa_dstaddr {
                                    var bcBuf = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                                    if getnameinfo(dst, socklen_t(dst.pointee.sa_len),
                                                   &bcBuf, socklen_t(bcBuf.count), nil, 0, NI_NUMERICHOST) == 0 {
                                        lanBroadcast = String(cString: bcBuf)
                                    }
                                }
                            } else if name.hasPrefix("pdp_ip") && cellularIP.isEmpty {
                                cellularIP = ip
                            }
                        }
                    }

                    if (name == lanInterfaceName || name.hasPrefix("pdp_ip")) && interface.ifa_data != nil {
                        let ifData = interface.ifa_data.assumingMemoryBound(to: if_data.self).pointee
                        if ifData.ifi_mtu > 0 {
                            mtu = Int(ifData.ifi_mtu)
                        }
                        if ifData.ifi_baudrate > 0 {
                            baudrate = Double(ifData.ifi_baudrate) / 1_000_000.0
                        }
                    }
                }
                ptr = interface.ifa_next
            }

            let realGateway = NetworkKernelProbe.queryDefaultGateway()
            let realDns = NetworkKernelProbe.queryDnsServers()
            let fallbackDns = Self.fetchResolvDnsServers()
            let wifiTelemetry = NetworkKernelProbe.queryWifiTelemetry()

            let finalMtu = mtu
            let finalBaudrate = baudrate
            let finalLanIP = lanIP
            let finalLanMask = lanMask
            let finalLanBroadcast = lanBroadcast
            let finalLanIface = lanInterfaceName
            let finalCellularIP = cellularIP

            Task { @MainActor [weak self] in
                guard let self, self.interfaceRefreshGeneration == gen else { return }
                self.interfaceMtu = finalMtu
                self.interfaceBaudrateMbps = finalBaudrate
                self.activeWiredInterface = finalLanIface

                if self.linkType == .wifi || self.linkType == .wired || self.linkType == .none {
                    self.localIPv4 = finalLanIP.isEmpty ? "--" : finalLanIP
                    self.subnetMask = finalLanMask.isEmpty ? (finalLanIP.isEmpty ? "--" : "255.255.255.0") : finalLanMask
                    self.broadcastIPv4 = finalLanBroadcast.isEmpty
                        ? Self.deriveBroadcast(ip: finalLanIP, mask: self.subnetMask)
                        : finalLanBroadcast
                    self.gatewayIPv4 = realGateway ?? self.nwPathGatewayIPv4 ?? Self.deriveDefaultGateway(from: finalLanIP)
                    if !finalLanIP.isEmpty && finalLanIP != "--" {
                        let comps = finalLanIP.components(separatedBy: ".")
                        if comps.count == 4 {
                            self.subnetRange = "\(comps[0]).\(comps[1]).\(comps[2]).1~254"
                        }
                    } else {
                        self.subnetRange = "--"
                    }
                    self.dnsServers = !realDns.isEmpty ? realDns : (!fallbackDns.isEmpty ? fallbackDns : (self.gatewayIPv4 != "--" ? [self.gatewayIPv4] : []))

                    if self.isConnected && self.linkType == .wifi, let wt = wifiTelemetry {
                        self.wifiSSID = wt.ssid.flatMap { $0.isEmpty ? nil : $0 }
                        self.wifiBSSID = wt.bssid.flatMap { $0.isEmpty ? nil : $0 }
                        self.wifiRssiDbm = wt.rssiDbm
                        self.wifiChannel = wt.channel
                        self.wifiTxRateMbps = wt.txRateMbps
                    } else {
                        self.wifiSSID = nil
                        self.wifiBSSID = nil
                        self.wifiRssiDbm = nil
                        self.wifiChannel = nil
                        self.wifiTxRateMbps = nil
                    }
                } else {
                    self.localIPv4 = finalCellularIP.isEmpty ? "--" : finalCellularIP
                    self.subnetMask = "255.255.255.255"
                    self.broadcastIPv4 = "--"
                    self.gatewayIPv4 = "--"
                    self.subnetRange = "--"
                    self.dnsServers = !realDns.isEmpty ? realDns : fallbackDns
                    self.wifiSSID = nil
                    self.wifiBSSID = nil
                    self.wifiRssiDbm = nil
                    self.wifiChannel = nil
                    self.wifiTxRateMbps = nil
                }
            }
        }
    }

    internal nonisolated static func deriveDefaultGateway(from ip: String) -> String {
        guard !ip.isEmpty, ip != "--" else { return "--" }
        let comps = ip.components(separatedBy: ".")
        guard comps.count == 4 else { return "--" }
        return "\(comps[0]).\(comps[1]).\(comps[2]).1"
    }

    internal nonisolated static func deriveBroadcast(ip: String, mask: String) -> String {
        guard !ip.isEmpty, ip != "--" else { return "--" }
        var ipAddr = in_addr()
        var maskAddr = in_addr()
        if inet_pton(AF_INET, ip, &ipAddr) == 1 && inet_pton(AF_INET, mask, &maskAddr) == 1 {
            let bcastRaw = ipAddr.s_addr | (~maskAddr.s_addr)
            var bcastAddr = in_addr(s_addr: bcastRaw)
            var buf = [CChar](repeating: 0, count: Int(INET_ADDRSTRLEN))
            if inet_ntop(AF_INET, &bcastAddr, &buf, socklen_t(buf.count)) != nil {
                return String(cString: buf)
            }
        }
        let comps = ip.components(separatedBy: ".")
        guard comps.count == 4 else { return "--" }
        return "\(comps[0]).\(comps[1]).\(comps[2]).255"
    }

    private nonisolated static func fetchResolvDnsServers() -> [String] {
        guard let content = try? String(contentsOfFile: "/etc/resolv.conf", encoding: .utf8) else {
            return []
        }
        let lines = content.components(separatedBy: .newlines)
        return lines.compactMap { line -> String? in
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.hasPrefix("nameserver ") {
                let s = trimmed.replacingOccurrences(of: "nameserver ", with: "").trimmingCharacters(in: .whitespaces)
                return s.isEmpty ? nil : s
            }
            return nil
        }
    }

    // MARK: - Public IP & GeoIP Asynchronous Fetcher
    private var publicIPTask: Task<Void, Never>?

    private nonisolated static func makeEphemeralSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.urlCache = nil
        config.timeoutIntervalForRequest = 2.5
        config.timeoutIntervalForResource = 3.5
        return URLSession(configuration: config)
    }

    private nonisolated static func cleanIspName(_ name: String) -> String {
        var s = name
        s = s.replacingOccurrences(of: "PRIVATE LIMITED", with: "Pvt Ltd", options: .caseInsensitive)
        s = s.replacingOccurrences(of: "LIMITED", with: "Ltd", options: .caseInsensitive)
        s = s.replacingOccurrences(of: "CORPORATION", with: "Corp", options: .caseInsensitive)
        return s.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private nonisolated static func isIPv6Address(_ ip: String) -> Bool {
        return ip.contains(":")
    }

    private nonisolated static func isChinaRegion(_ country: String) -> Bool {
        let c = country.trimmingCharacters(in: .whitespaces).uppercased()
        return c == "CN" || c.contains("CHINA") || c.contains("中国") || c.contains("中國")
    }

    public func fetchPublicIPInfo(force: Bool = false) {
        if force {
            publicIPTask?.cancel()
            publicIPTask = nil
        } else if isQueryingPublicIP {
            return
        }
        publicIPGeneration &+= 1
        let gen = publicIPGeneration
        isQueryingPublicIP = true

        publicIPTask = Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            let session = Self.makeEphemeralSession()
            defer { session.finishTasksAndInvalidate() }

            // Concurrently query direct domestic IP and foreign/edge resolver in parallel
            async let directQuery = Self.queryDirectDomesticIP(session: session)
            async let foreignQuery = Self.queryForeignEdgeIP(session: session)

            let (directResult, foreignResult) = await (directQuery, foreignQuery)
            let finalForeign = foreignResult
            guard !Task.isCancelled else {
                await MainActor.run { [weak self] in
                    guard let self, self.publicIPGeneration == gen else { return }
                    self.isQueryingPublicIP = false
                }
                return
            }

            await MainActor.run { [weak self] in
                guard let self, self.publicIPGeneration == gen else { return }
                guard !Task.isCancelled else {
                    self.isQueryingPublicIP = false
                    return
                }
                if let direct = directResult {
                    let directIsV6 = Self.isIPv6Address(direct.ip)
                    let foreignIsV6 = finalForeign.map { !$0.ip.isEmpty && Self.isIPv6Address($0.ip) } ?? false

                    var finalIsp = direct.isp
                    if finalIsp == "中国移动" { finalIsp = L10n.tr(zh: "中国移动", en: "China Mobile", hant: "中國移動") }
                    else if finalIsp == "中国电信" { finalIsp = L10n.tr(zh: "中国电信", en: "China Telecom", hant: "中國電信") }
                    else if finalIsp == "中国联通" { finalIsp = L10n.tr(zh: "中国联通", en: "China Unicom", hant: "中國聯通") }
                    else if finalIsp == "中国广电" { finalIsp = L10n.tr(zh: "中国广电", en: "China Broadnet", hant: "中國廣電") }
                    self.ispName = finalIsp

                    var directCountry = direct.country
                    if directCountry == "中国" { directCountry = L10n.tr(zh: "中国", en: "China", hant: "中國") }

                    if let f = finalForeign, !f.ip.isEmpty {
                        let foreignIsChina = Self.isChinaRegion(f.country)
                        let directIsChina = Self.isChinaRegion(direct.country)

                        if directIsV6 != foreignIsV6 {
                            // Dual stack: One is IPv4, one is IPv6 -> Physical carrier dual stack!
                            if directIsV6 {
                                self.publicIPv6 = direct.ip
                                self.publicIP = f.ip
                            } else {
                                self.publicIP = direct.ip
                                self.publicIPv6 = f.ip
                            }

                            // Only mark as proxy exit if foreign node is definitely overseas while direct is China,
                            // or foreign country explicitly differs from direct country and is not China
                            let isOverseasProxy = !f.country.isEmpty && !foreignIsChina && (directIsChina || direct.country.isEmpty)
                            if isOverseasProxy {
                                self.proxyExitIP = f.ip
                                self.proxyExitLocation = f.city.isEmpty ? f.country : "\(f.city), \(f.country)"
                            } else {
                                self.proxyExitIP = ""
                                self.proxyExitLocation = ""
                            }
                        } else if f.ip != direct.ip {
                            // Same address family (both IPv4 or both IPv6) but DIFFERENT IPs.
                            // Only a proxy if foreign is overseas or different region!
                            let isDifferentRegion = !foreignIsChina || !directIsChina
                            if isDifferentRegion {
                                self.proxyExitIP = f.ip
                                self.proxyExitLocation = f.city.isEmpty ? f.country : "\(f.city), \(f.country)"
                            } else {
                                self.proxyExitIP = ""
                                self.proxyExitLocation = ""
                            }
                            if directIsV6 {
                                self.publicIPv6 = direct.ip
                            } else {
                                self.publicIP = direct.ip
                            }
                        } else {
                            // Same IP -> No proxy
                            self.proxyExitIP = ""
                            self.proxyExitLocation = ""
                            if directIsV6 {
                                self.publicIPv6 = direct.ip
                            } else {
                                self.publicIP = direct.ip
                            }
                        }

                        // Strict guard: Proxy exit must not equal either public IP address
                        if self.proxyExitIP == self.publicIP || self.proxyExitIP == self.publicIPv6 {
                            self.proxyExitIP = ""
                            self.proxyExitLocation = ""
                        }
                    } else {
                        // Foreign query returned nil
                        self.proxyExitIP = ""
                        self.proxyExitLocation = ""
                        if directIsV6 {
                            self.publicIPv6 = direct.ip
                        } else {
                            self.publicIP = direct.ip
                        }
                    }

                    if L10n.isEnglish, self.proxyExitIP.isEmpty, let f = finalForeign, !f.city.isEmpty {
                        self.geoCity = f.city
                        self.geoCountry = f.country
                    } else {
                        self.geoCity = direct.city
                        self.geoCountry = directCountry
                    }
                } else if let f = finalForeign {
                    // Fallback to foreign resolver if direct query was unavailable
                    if Self.isIPv6Address(f.ip) {
                        self.publicIPv6 = f.ip
                    } else {
                        self.publicIP = f.ip
                    }
                    self.ispName = f.isp
                    self.geoCity = f.city
                    self.geoCountry = f.country
                    self.proxyExitIP = ""
                    self.proxyExitLocation = ""
                } else {
                    // If offline, display clean placeholder without any fake dummy IP
                    if self.publicIP.isEmpty {
                        self.publicIP = "--"
                    }
                    self.proxyExitIP = ""
                    self.proxyExitLocation = ""
                }
                self.isQueryingPublicIP = false
            }
        }
    }

    // MARK: - Direct Domestic IP Resolution (IPIP.net & IP.sb fallback)
    private nonisolated static func queryDirectDomesticIP(session: URLSession) async -> (ip: String, isp: String, city: String, country: String)? {
        guard let url = URL(string: "https://myip.ipip.net") else { return nil }
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 2.5
        request.setValue("curl/8.7.1", forHTTPHeaderField: "User-Agent")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")

        guard let (data, response) = try? await session.data(for: request),
              let http = response as? HTTPURLResponse, http.statusCode == 200,
              let text = String(data: data, encoding: .utf8) else {
            return nil
        }

        // Expected upstream payload: IP address and location summary
        let parts = text.components(separatedBy: "来自于")
        guard parts.count >= 2 else { return nil }

        let ip = parts[0]
            .replacingOccurrences(of: "当前 IP：", with: "")
            .replacingOccurrences(of: "当前 IP:", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !ip.isEmpty else { return nil }

        let locPart = parts[1]
            .replacingOccurrences(of: "：", with: "")
            .replacingOccurrences(of: ":", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let words = locPart.split(separator: " ").map { String($0) }
        let country = words.first ?? "中国"
        var isp = words.last ?? ""
        if isp == "移动" { isp = "中国移动" }
        else if isp == "电信" { isp = "中国电信" }
        else if isp == "联通" { isp = "中国联通" }
        else if isp == "广电" { isp = "中国广电" }

        var city = ""
        if words.count > 2 {
            city = words[1 ..< words.count - 1].joined(separator: " ")
        } else if words.count == 2 {
            city = words[1]
        }

        return (ip, isp, city, country)
    }

    // MARK: - Foreign / Edge IP Resolution (100% HTTPS, ATS-Compliant)
    private nonisolated static func queryForeignEdgeIP(session: URLSession) async -> (ip: String, isp: String, city: String, country: String)? {
        // Attempt 1: IPInfo.io (HTTPS)
        if let res = await queryIPInfoHttps(session: session) {
            return res
        }
        // Attempt 2: IP.sb (HTTPS, Cloudflare Anycast, worldwide fast)
        if let res = await queryIpSbHttps(session: session) {
            return res
        }
        // Attempt 3: Ipify (HTTPS fallback)
        if let ip = await queryIpifyHttps(session: session) {
            return (ip, "Global Transit", "", "")
        }
        return nil
    }

    private nonisolated static func queryIPInfoHttps(session: URLSession) async -> (ip: String, isp: String, city: String, country: String)? {
        guard let url = URL(string: "https://ipinfo.io/json") else { return nil }
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 2.5
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X)", forHTTPHeaderField: "User-Agent")

        guard let (data, response) = try? await session.data(for: request),
              let http = response as? HTTPURLResponse, http.statusCode == 200,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let ip = json["ip"] as? String else {
            return nil
        }

        let rawOrg = json["org"] as? String ?? ""
        let org = rawOrg.isEmpty ? "Global Transit" : cleanIspName(rawOrg)
        let city = json["city"] as? String ?? ""
        var country = json["country"] as? String ?? ""
        if country == "United States" { country = "US" }

        return (ip, org, city, country)
    }

    private nonisolated static func queryIpSbHttps(session: URLSession) async -> (ip: String, isp: String, city: String, country: String)? {
        guard let url = URL(string: "https://api.ip.sb/geoip") else { return nil }
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 2.5
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X)", forHTTPHeaderField: "User-Agent")

        guard let (data, response) = try? await session.data(for: request),
              let http = response as? HTTPURLResponse, http.statusCode == 200,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let ip = json["ip"] as? String else {
            return nil
        }

        let isp = cleanIspName(json["isp"] as? String ?? (json["organization"] as? String ?? ""))
        let city = json["city"] as? String ?? ""
        var countryCode = json["country_code"] as? String ?? (json["country"] as? String ?? "")
        if countryCode == "United States" { countryCode = "US" }

        return (ip, isp.isEmpty ? "Global Transit" : isp, city, countryCode)
    }

    private nonisolated static func queryIpifyHttps(session: URLSession) async -> String? {
        guard let url = URL(string: "https://api.ipify.org?format=json") else { return nil }
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 2.5

        guard let (data, response) = try? await session.data(for: request),
              let http = response as? HTTPURLResponse, http.statusCode == 200,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let ip = json["ip"] as? String else {
            return nil
        }
        return ip
    }

    // MARK: - POSIX TCP RTT Ping Latency Engine
    public func startContinuousPing() {
        pingTimer?.invalidate()
        let interval: TimeInterval = AppState.shared.isSensorPowerSaving ? 5.0 : 2.0
        let scheduledTimer = Timer(timeInterval: interval, repeats: true) { [weak self] _ in
            self?.pingCurrentTarget()
        }
        RunLoop.main.add(scheduledTimer, forMode: .common)
        pingTimer = scheduledTimer
        pingCurrentTarget()
    }

    public func pingCurrentTarget() {
        guard isConnected else {
            self.currentLatencyMs = 0.0
            self.jitterMs = 0.0
            self.packetLossPercent = 100.0
            return
        }

        let target = self.selectedTarget
        let host: String
        let port = target.defaultPort

        switch target {
        case .cloudflare: host = "1.1.1.1"
        case .alibaba: host = "223.5.5.5"
        case .google: host = "8.8.8.8"
        case .gateway:
            host = (self.gatewayIPv4 != "--" && !self.gatewayIPv4.isEmpty) ? self.gatewayIPv4 : "192.168.1.1"
        }

        let gen = pingGeneration
        workerQueue.async { [weak self] in
            guard let self else { return }
            let latency = Self.measureTcpConnectRTT(host: host, port: port, timeoutSec: 0.8)

            Task { @MainActor [weak self] in
                guard let self, self.isTabMonitoring, self.pingGeneration == gen else { return }
                let now = Date()

                if let rtt = latency {
                    self.currentLatencyMs = rtt
                    self.packetLossPercent = max(0.0, self.packetLossPercent * 0.8)

                    // Jitter Calculation: Mean deviation between consecutive ping packets
                    if let last = self.pingHistorySamples.last {
                        let diff = abs(rtt - last)
                        self.jitterMs = self.jitterMs == 0 ? diff : (self.jitterMs * 0.7 + diff * 0.3)
                    }
                    self.pingHistorySamples.append(rtt)
                    if self.pingHistorySamples.count > 20 {
                        self.pingHistorySamples.removeFirst()
                    }

                    // Rolling Latency History for Swift Charts
                    self.latencyHistory.append(MetricPoint(timestamp: now, value: rtt))
                    if self.latencyHistory.count > 25 {
                        self.latencyHistory.removeFirst()
                    }
                } else {
                    // Packet Lost
                    self.packetLossPercent = min(100.0, self.packetLossPercent + 20.0)
                }
            }
        }
    }

    private nonisolated static func measureTcpConnectRTT(host: String, port: UInt16, timeoutSec: Double) -> Double? {
        var hints = addrinfo()
        hints.ai_family = AF_UNSPEC
        hints.ai_socktype = SOCK_STREAM
        hints.ai_protocol = IPPROTO_TCP

        var res: UnsafeMutablePointer<addrinfo>?
        guard getaddrinfo(host, "\(port)", &hints, &res) == 0, let firstAddr = res else {
            return nil
        }
        defer { freeaddrinfo(res) }

        let timeoutMs = Int32(max(1.0, timeoutSec * 1000.0))
        var ptr: UnsafeMutablePointer<addrinfo>? = firstAddr

        while let info = ptr {
            let sock = socket(info.pointee.ai_family, info.pointee.ai_socktype, info.pointee.ai_protocol)
            if sock >= 0 {
                defer { close(sock) }
                let flags = fcntl(sock, F_GETFL, 0)
                _ = fcntl(sock, F_SETFL, flags | O_NONBLOCK)

                let start = DispatchTime.now().uptimeNanoseconds
                let connRes = connect(sock, info.pointee.ai_addr, info.pointee.ai_addrlen)
                if connRes == 0 {
                    let elapsed = Double(DispatchTime.now().uptimeNanoseconds - start) / 1_000_000.0
                    return max(1.0, elapsed)
                }

                var pfd = pollfd(fd: sock, events: Int16(POLLOUT), revents: 0)
                let pollRes = poll(&pfd, 1, timeoutMs)
                if pollRes > 0 && (pfd.revents & Int16(POLLOUT)) != 0 {
                    var err: Int32 = 0
                    var len = socklen_t(MemoryLayout<Int32>.size)
                    getsockopt(sock, SOL_SOCKET, SO_ERROR, &err, &len)
                    if err == 0 {
                        let elapsed = Double(DispatchTime.now().uptimeNanoseconds - start) / 1_000_000.0
                        return max(1.0, elapsed)
                    }
                }
            }
            ptr = info.pointee.ai_next
        }
        return nil
    }

    // MARK: - Live Bandwidth Throughput Sampler
    private func startTrafficSampling() {
        trafficTimer?.invalidate()
        let interval: TimeInterval = AppState.shared.isSensorPowerSaving ? 3.5 : 1.5
        let scheduledTimer = Timer(timeInterval: interval, repeats: true) { [weak self] _ in
            self?.workerQueue.async {
                self?.sampleTrafficThroughput()
            }
        }
        RunLoop.main.add(scheduledTimer, forMode: .common)
        trafficTimer = scheduledTimer
    }

    private nonisolated func sampleTrafficThroughput() {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else { return }
        defer { freeifaddrs(ifaddr) }

        var currentCounters: [String: (inBytes: UInt32, outBytes: UInt32)] = [:]

        var ptr: UnsafeMutablePointer<ifaddrs>? = firstAddr
        while ptr != nil {
            guard let interface = ptr?.pointee else { break }
            let flags = Int32(interface.ifa_flags)
            if let ifaAddr = interface.ifa_addr,
               ifaAddr.pointee.sa_family == UInt8(AF_LINK),
               (flags & (IFF_UP | IFF_RUNNING)) == (IFF_UP | IFF_RUNNING),
               (flags & IFF_LOOPBACK) == 0 {
                let name = String(cString: interface.ifa_name)
                if (name.hasPrefix("en") || name.hasPrefix("pdp_ip")) && interface.ifa_data != nil {
                    let data = interface.ifa_data.assumingMemoryBound(to: if_data.self).pointee
                    currentCounters[name] = (data.ifi_ibytes, data.ifi_obytes)
                }
            }
            ptr = interface.ifa_next
        }

        let now = Date()
        let countersSnapshot = currentCounters
        let result: (shouldEmit: Bool, downRate: Double, upRate: Double, sessionIn: UInt64, sessionOut: UInt64) = trafficLock.withLock { state in
            let timeDelta = max(0.5, now.timeIntervalSince(state.lastTimestamp))
            var deltaIn: UInt64 = 0
            var deltaOut: UInt64 = 0
            let hadSample = state.hasSample

            if hadSample {
                for (ifaceName, cur) in countersSnapshot {
                    if let prevIn = state.lastIn[ifaceName] {
                        deltaIn += SystemViewModel.computeCounterDelta(current: cur.inBytes, previous: prevIn)
                    }
                    if let prevOut = state.lastOut[ifaceName] {
                        deltaOut += SystemViewModel.computeCounterDelta(current: cur.outBytes, previous: prevOut)
                    }
                }
                state.sessionIn += deltaIn
                state.sessionOut += deltaOut
            }

            state.lastIn = countersSnapshot.mapValues(\.inBytes)
            state.lastOut = countersSnapshot.mapValues(\.outBytes)
            state.hasSample = !countersSnapshot.isEmpty
            state.lastTimestamp = now

            return (
                hadSample,
                Double(deltaIn) / timeDelta,
                Double(deltaOut) / timeDelta,
                state.sessionIn,
                state.sessionOut
            )
        }

        guard result.shouldEmit else { return }

        Task { @MainActor [weak self] in
            guard let self else { return }
            self.downloadSpeedBps = result.downRate
            self.uploadSpeedBps = result.upRate
            self.totalBytesIn = result.sessionIn
            self.totalBytesOut = result.sessionOut

            let pointId = "traffic-\(Int(now.timeIntervalSince1970 * 1000))"
            self.trafficHistory.append(TrafficDataPoint(id: pointId, timestamp: now, downBps: result.downRate, upBps: result.upRate))
            if self.trafficHistory.count > 25 {
                self.trafficHistory.removeFirst()
            }
        }
    }

    private nonisolated static func ipv4SortKey(_ ip: String) -> UInt32 {
        var addr = in_addr()
        guard inet_pton(AF_INET, ip, &addr) == 1 else { return UInt32.max }
        return UInt32(bigEndian: addr.s_addr)
    }

    // MARK: - LAN Device Discovery via Kernel ARP Table & Bonjour mDNS
    @MainActor
    public func startLanScan() {
        guard !isScanningLan else { return }
        lanScanTimeoutWorkItem?.cancel()
        lanScanTimeoutWorkItem = nil
        let generation = UUID()
        self.lanScanGeneration = generation
        self.isScanningLan = true
        self.lanScanActiveLock.withLock { $0 = true }
        self.discoveredDevices.removeAll()
        self.lanBrowsers.forEach { $0.cancel() }
        self.lanBrowsers.removeAll()

        let currentGateway = self.gatewayIPv4
        let gatewayLabel = L10n.Network.deviceGateway
        let gatewayTitle = L10n.Network.gateway
        let lanHostTitle = L10n.Network.lanHostLabel
        let randomVendor = L10n.Network.vendorText(key: "random")
        let bonjourVendor = L10n.Network.deviceBonjour

        // 1. Start Bonjour / mDNS Service Discovery immediately without waiting for ARP probes
        let serviceTypes = ["_http._tcp", "_airplay._tcp", "_smb._tcp", "_raop._tcp", "_googlecast._tcp", "_printer._tcp"]
        for type in serviceTypes {
            let descriptor = NWBrowser.Descriptor.bonjour(type: type, domain: nil)
            let params = NWParameters()
            params.includePeerToPeer = true
            let browser = NWBrowser(for: descriptor, using: params)

            browser.browseResultsChangedHandler = { [weak self] results, _ in
                guard let self else { return }
                for res in results {
                    if case let .service(name, serviceType, _, iface) = res.endpoint {
                        Task { @MainActor [weak self] in
                            guard let self, self.lanScanGeneration == generation, self.isScanningLan else { return }
                            let key = "bonjour-\(name)-\(serviceType)"
                            if !self.discoveredDevices.contains(where: { $0.name == name }) {
                                let dev = DiscoveredDevice(
                                    id: key,
                                    name: name,
                                    serviceType: serviceType,
                                    interfaceName: iface?.name ?? "en0",
                                    ipAddress: "--",
                                    macAddress: nil,
                                    vendorName: bonjourVendor,
                                    latencyMs: nil
                                )
                                self.discoveredDevices.append(dev)
                            }
                        }
                    }
                }
            }

            browser.start(queue: self.monitorQueue)
            self.lanBrowsers.append(browser)
        }

        // 2. Concurrent Darwin Kernel ARP Cache + TCP latency probing
        workerQueue.async { [weak self] in
            guard let self else { return }

            let arpDevices = NetworkKernelProbe.queryArpTable()
            let probeLock = NSLock()
            let probeGroup = DispatchGroup()
            var deviceMap: [String: DiscoveredDevice] = [:]

            for arp in arpDevices {
                guard self.lanScanActiveLock.withLock({ $0 }) else { break }
                probeGroup.enter()
                self.workerQueue.async { [weak self] in
                    defer { probeGroup.leave() }
                    guard let self, self.lanScanActiveLock.withLock({ $0 }) else { return }
                    let isGw = (arp.ip == currentGateway)
                    let localizedVendor: String
                    if arp.vendor == "Private MAC" {
                        localizedVendor = randomVendor
                    } else if arp.vendor == "LAN Host" {
                        localizedVendor = lanHostTitle
                    } else {
                        localizedVendor = arp.vendor
                    }
                    let name = isGw ? gatewayLabel : localizedVendor
                    let latency = Self.measureTcpConnectRTT(host: arp.ip, port: isGw ? 80 : 53, timeoutSec: 0.3)
                        ?? Self.measureTcpConnectRTT(host: arp.ip, port: 443, timeoutSec: 0.2)

                    let dev = DiscoveredDevice(
                        id: "arp-\(arp.ip)",
                        name: name,
                        serviceType: isGw ? gatewayTitle : lanHostTitle,
                        interfaceName: "en0",
                        ipAddress: arp.ip,
                        macAddress: arp.mac,
                        vendorName: localizedVendor,
                        latencyMs: latency
                    )
                    probeLock.lock()
                    deviceMap[arp.ip] = dev
                    probeLock.unlock()
                }
            }

            probeGroup.wait()

            let finalArpDevices = Array(deviceMap.values).sorted {
                Self.ipv4SortKey($0.ipAddress) < Self.ipv4SortKey($1.ipAddress)
            }
            Task { @MainActor [weak self] in
                guard let self, self.lanScanGeneration == generation, self.isScanningLan else { return }
                let existingBonjour = self.discoveredDevices.filter { $0.id.hasPrefix("bonjour-") }
                var merged = finalArpDevices
                for item in existingBonjour where !merged.contains(where: { $0.name == item.name }) {
                    merged.append(item)
                }
                self.discoveredDevices = merged
            }
        }

        // Auto-stop scan after 5 seconds for the matching scan generation
        let timeoutWork = DispatchWorkItem { [weak self] in
            guard let self, self.lanScanGeneration == generation else { return }
            self.stopLanScan()
        }
        lanScanTimeoutWorkItem = timeoutWork
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: timeoutWork)
    }

    @MainActor
    public func stopLanScan() {
        lanScanTimeoutWorkItem?.cancel()
        lanScanTimeoutWorkItem = nil
        lanScanGeneration = UUID()
        lanScanActiveLock.withLock { $0 = false }
        lanBrowsers.forEach { $0.cancel() }
        lanBrowsers.removeAll()
        isScanningLan = false
    }

    // MARK: - POSIX UDP Wake-on-LAN (WOL) Magic Packet Dispatcher
    public func sendWakeOnLan(macAddress: String) -> (success: Bool, message: String) {
        // Sanitize MAC Address
        let clean = macAddress.replacingOccurrences(of: ":", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")
            .uppercased()

        guard clean.count == 12 else {
            return (false, L10n.Network.wolInvalidMac)
        }

        var macBytes = [UInt8]()
        for i in stride(from: 0, to: 12, by: 2) {
            let start = clean.index(clean.startIndex, offsetBy: i)
            let end = clean.index(start, offsetBy: 2)
            guard let b = UInt8(clean[start ..< end], radix: 16) else {
                return (false, L10n.Network.wolInvalidMac)
            }
            macBytes.append(b)
        }

        // Construct 102-Byte Magic Packet: 6x 0xFF + 16x MAC
        var packet = [UInt8](repeating: 0xFF, count: 6)
        for _ in 0 ..< 16 {
            packet.append(contentsOf: macBytes)
        }

        let sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
        guard sock >= 0 else {
            return (false, L10n.Network.wolSocketFailed)
        }
        defer { close(sock) }

        var broadcastEnable: Int32 = 1
        setsockopt(sock, SOL_SOCKET, SO_BROADCAST, &broadcastEnable, socklen_t(MemoryLayout<Int32>.size))

        let targetBroadcast = (broadcastIPv4 != "--" && !broadcastIPv4.isEmpty) ? broadcastIPv4 : "255.255.255.255"

        var addr = sockaddr_in()
        addr.sin_family = sa_family_t(AF_INET)
        addr.sin_port = in_port_t(9).bigEndian
        guard inet_pton(AF_INET, targetBroadcast, &addr.sin_addr) == 1 else {
            return (false, L10n.Network.wolInvalidBroadcast)
        }

        let sent = withUnsafePointer(to: &addr) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { sa in
                sendto(sock, packet, packet.count, 0, sa, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }

        if sent == packet.count {
            Haptics.success()
            return (true, L10n.Network.wolSuccess)
        } else {
            return (false, L10n.Network.wolDispatchError)
        }
    }

    internal nonisolated static func normalizeLookupHost(_ input: String) -> String {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "" }
        if trimmed.contains("://"), let url = URL(string: trimmed), let host = url.host, !host.isEmpty {
            return host
        }
        var stripped = trimmed
        if let schemeRange = stripped.range(of: "://") {
            stripped = String(stripped[schemeRange.upperBound...])
        }
        if let slashIdx = stripped.firstIndex(of: "/") {
            stripped = String(stripped[..<slashIdx])
        }
        if let queryIdx = stripped.firstIndex(of: "?") {
            stripped = String(stripped[..<queryIdx])
        }
        if let fragIdx = stripped.firstIndex(of: "#") {
            stripped = String(stripped[..<fragIdx])
        }
        if stripped.hasPrefix("["), let closeBracket = stripped.firstIndex(of: "]") {
            return String(stripped[stripped.index(after: stripped.startIndex) ..< closeBracket])
        }
        let colonCount = stripped.filter { $0 == ":" }.count
        if colonCount == 1, let colonIdx = stripped.firstIndex(of: ":") {
            return String(stripped[..<colonIdx])
        }
        return stripped
    }

    // MARK: - POSIX DNS Dig & Domain Resolver (Non-blocking Background Thread)
    public nonisolated func resolveDomainName(domain: String) async -> DnsDigResult? {
        let clean = Self.normalizeLookupHost(domain)
        guard !clean.isEmpty else { return nil }

        return await withCheckedContinuation { continuation in
            workerQueue.async {
                let start = DispatchTime.now().uptimeNanoseconds
                var hints = addrinfo()
                hints.ai_family = AF_UNSPEC
                hints.ai_socktype = SOCK_STREAM

                var res: UnsafeMutablePointer<addrinfo>?
                let status = getaddrinfo(clean, nil, &hints, &res)
                let elapsed = Double(DispatchTime.now().uptimeNanoseconds - start) / 1_000_000.0

                guard status == 0, let first = res else {
                    continuation.resume(returning: nil)
                    return
                }
                defer { freeaddrinfo(res) }

                var ipv4List: [String] = []
                var ipv6List: [String] = []

                var ptr: UnsafeMutablePointer<addrinfo>? = first
                while let p = ptr {
                    var host = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if getnameinfo(p.pointee.ai_addr, p.pointee.ai_addrlen, &host, socklen_t(host.count), nil, 0, NI_NUMERICHOST) == 0 {
                        let ipStr = String(cString: host)
                        if p.pointee.ai_family == AF_INET {
                            if !ipv4List.contains(ipStr) { ipv4List.append(ipStr) }
                        } else if p.pointee.ai_family == AF_INET6 {
                            if !ipv6List.contains(ipStr) { ipv6List.append(ipStr) }
                        }
                    }
                    ptr = p.pointee.ai_next
                }

                continuation.resume(returning: DnsDigResult(domain: clean, ipv4List: ipv4List, ipv6List: ipv6List, queryTimeMs: max(1.0, elapsed)))
            }
        }
    }

    // MARK: - Multi-Node Concurrent DNS Benchmark
    @MainActor
    public func runDnsBenchmark() {
        guard !isBenchmarkingDns else { return }
        dnsBenchmarkGeneration &+= 1
        let gen = dnsBenchmarkGeneration
        isBenchmarkingDns = true

        let gatewayHost = self.gatewayIPv4 != "--" ? self.gatewayIPv4 : "192.168.1.1"
        let gatewayTitle = L10n.Network.gatewayShort
        let targets: [(id: String, name: String, host: String)] = [
            ("alidns", "AliDNS", "223.5.5.5"),
            ("dnspod", "DNSPod", "119.29.29.29"),
            ("cloudflare", "Cloudflare", "1.1.1.1"),
            ("google", "Google", "8.8.8.8"),
            ("baidu", "Baidu DNS", "180.76.76.76"),
            ("gateway", gatewayTitle, gatewayHost)
        ]

        workerQueue.async { [weak self] in
            guard let self else { return }
            let group = DispatchGroup()
            let lock = NSLock()
            var results: [DnsBenchmarkResult] = []

            for t in targets {
                group.enter()
                self.workerQueue.async {
                    let rtt = Self.measureTcpConnectRTT(host: t.host, port: 53, timeoutSec: 1.0) ?? 999.0
                    let item = DnsBenchmarkResult(id: t.id, name: t.name, host: t.host, latencyMs: rtt, isFastest: false)
                    lock.lock()
                    results.append(item)
                    lock.unlock()
                    group.leave()
                }
            }

            group.wait()

            let valid = results.filter { $0.latencyMs < 900.0 }
            if let minNode = valid.min(by: { $0.latencyMs < $1.latencyMs }) {
                for i in 0 ..< results.count {
                    if results[i].id == minNode.id {
                        results[i].isFastest = true
                    }
                }
            }

            let sortedResults = results.sorted(by: { $0.latencyMs < $1.latencyMs })
            Task { @MainActor [weak self] in
                guard let self, self.dnsBenchmarkGeneration == gen, self.isBenchmarkingDns else { return }
                self.dnsBenchmarkResults = sortedResults
                self.isBenchmarkingDns = false
                Haptics.tick()
            }
        }
    }

    // MARK: - Common Service Port Scanner (Concurrent Non-blocking)
    @MainActor
    public func scanCommonPorts(targetHost: String? = nil) {
        guard !isScanningPorts else { return }
        portScanGeneration &+= 1
        let gen = portScanGeneration
        isScanningPorts = true
        portScanError = nil

        let cleanedProvided = targetHost.map { Self.normalizeLookupHost($0) }
        let host: String
        if let provided = cleanedProvided, !provided.isEmpty {
            host = provided
        } else if self.gatewayIPv4 != "--" {
            host = self.gatewayIPv4
        } else {
            host = "192.168.1.1"
        }
        let commonList: [(port: UInt16, name: String)] = [
            (22, "SSH"),
            (53, "DNS"),
            (80, "HTTP Web"),
            (443, "HTTPS"),
            (445, "SMB / NAS"),
            (3389, "RDP"),
            (5000, "DSM"),
            (8080, "HTTP Alt")
        ]

        workerQueue.async { [weak self] in
            guard let self else { return }

            var hints = addrinfo()
            hints.ai_family = AF_UNSPEC
            hints.ai_socktype = SOCK_STREAM
            var resolved: UnsafeMutablePointer<addrinfo>?
            let resolveStatus = getaddrinfo(host, nil, &hints, &resolved)
            if let resolved {
                freeaddrinfo(resolved)
            }
            guard resolveStatus == 0 else {
                Task { @MainActor [weak self] in
                    guard let self, self.portScanGeneration == gen, self.isScanningPorts else { return }
                    self.portScanError = L10n.Network.portHostResolveFailed
                    self.isScanningPorts = false
                    Haptics.error()
                }
                return
            }

            let group = DispatchGroup()
            let lock = NSLock()
            var results: [PortScanItem] = []

            for item in commonList {
                group.enter()
                self.workerQueue.async {
                    let rtt = Self.measureTcpConnectRTT(host: host, port: item.port, timeoutSec: 0.5)
                    let isOpen = (rtt != nil)
                    let scanItem = PortScanItem(port: item.port, serviceName: item.name, isOpen: isOpen, latencyMs: rtt ?? 0.0)
                    lock.lock()
                    results.append(scanItem)
                    lock.unlock()
                    group.leave()
                }
            }

            group.wait()
            results.sort { $0.port < $1.port }
            let finalScanResults = results
            Task { @MainActor [weak self] in
                guard let self, self.portScanGeneration == gen, self.isScanningPorts else { return }
                self.portScanResults = finalScanResults
                self.hasScannedPorts = true
                self.portScanError = nil
                self.isScanningPorts = false
                Haptics.tick()
            }
        }
    }

    // MARK: - Active Bandwidth Speed Test Streaming Delegate
    private final class SpeedTestStreamingDelegate: NSObject, URLSessionDataDelegate, @unchecked Sendable {
        private struct Counters {
            var totalBytesTransferred: Double = 0.0
            var windowBytes: Double = 0.0
            var lastWindowTime: Date = .init()
            var rateSamples: [Double] = []
            var didFinish: Bool = false
            var didCompleteWithError: Bool = false
            var httpStatusCode: Int?
        }

        private let stateLock = OSAllocatedUnfairLock(initialState: Counters())
        private let onSample: (@Sendable (_ currentRateMbps: Double, _ avgRateMbps: Double, _ totalBytes: Double) -> Void)

        init(onSample: @escaping @Sendable (_ currentRateMbps: Double, _ avgRateMbps: Double, _ totalBytes: Double) -> Void) {
            self.onSample = onSample
            super.init()
        }

        func currentTotalBytes() -> Double {
            stateLock.withLock { $0.totalBytesTransferred }
        }

        func isFinished() -> Bool {
            stateLock.withLock { $0.didFinish }
        }

        func isHTTP200Success() -> Bool {
            stateLock.withLock { $0.didFinish && !$0.didCompleteWithError && $0.httpStatusCode == 200 }
        }

        private func recordChunk(chunkBytes: Double) {
            let now = Date()
            let emit: (currentRate: Double, avgRate: Double, totalBytes: Double)? = stateLock.withLock { state in
                state.totalBytesTransferred += chunkBytes
                state.windowBytes += chunkBytes
                let delta = now.timeIntervalSince(state.lastWindowTime)
                guard delta >= 0.12 else { return nil }
                let currentRateMbps = (state.windowBytes * 8.0) / (delta * 1_000_000.0)
                state.rateSamples.append(currentRateMbps)
                if state.rateSamples.count > 10 {
                    state.rateSamples.removeFirst(state.rateSamples.count - 10)
                }
                let avgRate = state.rateSamples.reduce(0, +) / Double(max(1, state.rateSamples.count))
                state.windowBytes = 0.0
                state.lastWindowTime = now
                return (currentRateMbps, avgRate, state.totalBytesTransferred)
            }

            if let emit {
                onSample(emit.currentRate, emit.avgRate, emit.totalBytes)
            }
        }

        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
            recordChunk(chunkBytes: Double(data.count))
        }

        func urlSession(
            _ session: URLSession,
            task: URLSessionTask,
            didSendBodyData bytesSent: Int64,
            totalBytesSent: Int64,
            totalBytesExpectedToSend: Int64
        ) {
            recordChunk(chunkBytes: Double(bytesSent))
        }

        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            let statusCode = (task.response as? HTTPURLResponse)?.statusCode
            stateLock.withLock { state in
                state.didFinish = true
                state.httpStatusCode = statusCode
                if error != nil {
                    state.didCompleteWithError = true
                }
            }
        }
    }

    // MARK: - Active Bandwidth Speed Test Engine (Ping, Download, Upload, Scorecard)
    @MainActor
    public func startSpeedTest() {
        guard !isRunningSpeedTest else { return }
        speedTestTask?.cancel()

        speedTestStage = .ping
        speedTestProgress = 0.05
        speedTestCurrentMbps = 0.0
        speedTestDownloadMbps = 0.0
        speedTestDownloadPeakMbps = 0.0
        speedTestUploadMbps = 0.0
        speedTestUploadPeakMbps = 0.0
        speedTestPingMs = 0.0
        speedTestJitterMs = 0.0
        speedTestRating = ""
        speedTestError = nil
        isSpeedTestUploadAvailable = true

        speedTestTask = Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else { return }

            // STEP 1: Ping & Jitter measurement (4 probes on background thread)
            var pings: [Double] = []
            for _ in 0 ..< 4 {
                if Task.isCancelled { return }
                if let rtt = Self.measureTcpConnectRTT(host: "1.1.1.1", port: 53, timeoutSec: 0.8) {
                    pings.append(rtt)
                }
                try? await Task.sleep(nanoseconds: 80_000_000)
            }

            let avgPing: Double
            let finalJitter: Double
            if pings.isEmpty {
                avgPing = 0.0
                finalJitter = 0.0
            } else {
                avgPing = pings.reduce(0, +) / Double(pings.count)
                var jitterSum = 0.0
                if pings.count > 1 {
                    for i in 1 ..< pings.count {
                        jitterSum += abs(pings[i] - pings[i - 1])
                    }
                    jitterSum /= Double(pings.count - 1)
                }
                finalJitter = jitterSum
            }

            await MainActor.run {
                guard !Task.isCancelled else { return }
                self.speedTestPingMs = avgPing
                self.speedTestJitterMs = finalJitter
                self.speedTestProgress = 0.15
                self.speedTestStage = .download
                Haptics.tick()
            }

            // STEP 2: High-Throughput Kernel-Buffered HTTP Stream Download
            var downloadSucceeded = false
            var uploadSucceeded = false

            let downloadUrlStr = "https://speed.cloudflare.com/__down?bytes=50000000"
            if let url = URL(string: downloadUrlStr) {
                var request = URLRequest(url: url)
                request.timeoutInterval = 8.0
                request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")

                let delegate = SpeedTestStreamingDelegate { [weak self] currentRateMbps, avgRate, totalBytesReceived in
                    let overallProg = min(0.65, 0.15 + (0.50 * (totalBytesReceived / 50_000_000.0)))
                    Task { @MainActor [weak self] in
                        guard let self, self.speedTestStage == .download else { return }
                        self.speedTestCurrentMbps = currentRateMbps
                        self.speedTestDownloadPeakMbps = max(self.speedTestDownloadPeakMbps, currentRateMbps)
                        self.speedTestDownloadMbps = avgRate
                        self.speedTestProgress = overallProg
                    }
                }
                let config = URLSessionConfiguration.ephemeral
                config.timeoutIntervalForRequest = 8.0
                config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
                let testSession = URLSession(configuration: config, delegate: delegate, delegateQueue: nil)

                let testStartTime = Date()
                let task = testSession.dataTask(with: request)
                task.resume()

                // Run download for up to 6.0 seconds, stopping early when stream completes
                for _ in 0 ..< 60 {
                    if Task.isCancelled || delegate.isFinished() || delegate.currentTotalBytes() >= 50_000_000.0 { break }
                    try? await Task.sleep(nanoseconds: 100_000_000)
                }
                task.cancel()
                testSession.invalidateAndCancel()
                if Task.isCancelled { return }

                let totalBytesReceived = delegate.currentTotalBytes()
                if totalBytesReceived > 0 {
                    downloadSucceeded = true
                    let totalTime = max(0.5, Date().timeIntervalSince(testStartTime))
                    let finalAvg = (totalBytesReceived * 8.0) / (totalTime * 1_000_000.0)
                    await MainActor.run {
                        guard !Task.isCancelled else { return }
                        self.speedTestDownloadMbps = max(self.speedTestDownloadMbps, finalAvg)
                        self.speedTestDownloadPeakMbps = max(self.speedTestDownloadPeakMbps, self.speedTestDownloadMbps)
                    }
                }
            }

            if Task.isCancelled { return }

            await MainActor.run {
                guard !Task.isCancelled else { return }
                self.speedTestStage = .upload
                self.speedTestProgress = 0.65
                self.speedTestCurrentMbps = 0.0
                Haptics.tick()
            }

            // STEP 3: Real Streaming HTTP Payload Upload (Delegate-tracked chunks, no synthetic peak multiplier)
            let uploadUrlStr = "https://speed.cloudflare.com/__up"
            if let uploadUrl = URL(string: uploadUrlStr) {
                let payloadSize = 8_000_000
                let testData = Data(repeating: 0x5A, count: payloadSize)
                var request = URLRequest(url: uploadUrl)
                request.httpMethod = "POST"
                request.timeoutInterval = 8.0
                request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")

                let uploadDelegate = SpeedTestStreamingDelegate { [weak self] currentRateMbps, avgRate, totalBytesSent in
                    let overallProg = min(0.98, 0.65 + (0.33 * (totalBytesSent / Double(payloadSize))))
                    Task { @MainActor [weak self] in
                        guard let self, self.speedTestStage == .upload else { return }
                        self.speedTestCurrentMbps = currentRateMbps
                        self.speedTestUploadPeakMbps = max(self.speedTestUploadPeakMbps, currentRateMbps)
                        self.speedTestUploadMbps = avgRate
                        self.speedTestProgress = overallProg
                    }
                }

                let uploadConfig = URLSessionConfiguration.ephemeral
                uploadConfig.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
                uploadConfig.timeoutIntervalForRequest = 8.0
                let uploadSession = URLSession(configuration: uploadConfig, delegate: uploadDelegate, delegateQueue: nil)

                let upStart = Date()
                let uploadTask = uploadSession.uploadTask(with: request, from: testData)
                uploadTask.resume()

                for _ in 0 ..< 80 {
                    if Task.isCancelled || uploadDelegate.isFinished() { break }
                    try? await Task.sleep(nanoseconds: 100_000_000)
                }

                if Task.isCancelled {
                    uploadTask.cancel()
                    uploadSession.invalidateAndCancel()
                    return
                }

                if !uploadDelegate.isFinished() {
                    uploadTask.cancel()
                }
                uploadSession.invalidateAndCancel()

                let uploadedBytes = uploadDelegate.currentTotalBytes()
                if uploadDelegate.isHTTP200Success() {
                    uploadSucceeded = true
                    let totalElapsed = max(0.5, Date().timeIntervalSince(upStart))
                    let effectiveBytes = uploadedBytes > 0 ? uploadedBytes : Double(payloadSize)
                    let finalUploadRate = (effectiveBytes * 8.0) / (totalElapsed * 1_000_000.0)

                    await MainActor.run {
                        guard !Task.isCancelled else { return }
                        self.isSpeedTestUploadAvailable = true
                        self.speedTestUploadMbps = max(self.speedTestUploadMbps, finalUploadRate)
                        self.speedTestUploadPeakMbps = max(self.speedTestUploadPeakMbps, self.speedTestUploadMbps)
                        self.speedTestCurrentMbps = self.speedTestUploadMbps
                        self.speedTestProgress = 0.98
                    }
                } else {
                    await MainActor.run {
                        guard !Task.isCancelled else { return }
                        self.isSpeedTestUploadAvailable = false
                        self.speedTestUploadMbps = 0.0
                        self.speedTestUploadPeakMbps = 0.0
                    }
                }
            }

            if Task.isCancelled { return }

            // STEP 4: Completed & Scorecard (or honest failure if offline / unreachable)
            let didDownload = downloadSucceeded
            let didUpload = uploadSucceeded
            await MainActor.run {
                guard !Task.isCancelled else { return }
                if !didDownload && !didUpload {
                    self.speedTestError = L10n.Network.speedTestFailed
                    self.speedTestStage = .idle
                    self.speedTestProgress = 0.0
                    self.speedTestCurrentMbps = 0.0
                    Haptics.error()
                    return
                }

                self.speedTestProgress = 1.0
                self.speedTestCurrentMbps = self.speedTestDownloadMbps
                self.speedTestStage = .completed

                let down = self.speedTestDownloadMbps
                let rating = L10n.Network.speedTestRatingText(for: down)
                self.speedTestRating = rating

                let record = SpeedTestRecord(
                    downloadMbps: self.speedTestDownloadMbps,
                    uploadMbps: self.speedTestUploadMbps,
                    pingMs: self.speedTestPingMs,
                    jitterMs: self.speedTestJitterMs,
                    rating: rating,
                    serverName: self.speedTestServerName
                )
                self.saveSpeedTestRecord(record)

                Haptics.success()
            }
        }
    }

    @MainActor
    public func stopSpeedTest() {
        speedTestTask?.cancel()
        speedTestTask = nil
        speedTestError = nil
        if speedTestStage != .completed {
            speedTestStage = .idle
            speedTestProgress = 0.0
            speedTestCurrentMbps = 0.0
        }
    }

    @MainActor
    public func resetSpeedTest() {
        stopSpeedTest()
        speedTestStage = .idle
        speedTestProgress = 0.0
        speedTestCurrentMbps = 0.0
        speedTestDownloadMbps = 0.0
        speedTestDownloadPeakMbps = 0.0
        speedTestUploadMbps = 0.0
        speedTestUploadPeakMbps = 0.0
        speedTestPingMs = 0.0
        speedTestJitterMs = 0.0
        speedTestRating = ""
        speedTestError = nil
        isSpeedTestUploadAvailable = true
        Haptics.selection()
    }

    @MainActor
    public func clearSpeedTestHistory() {
        speedTestHistory.removeAll()
        UserDefaults.standard.removeObject(forKey: "onedeck_speedtest_history_v1")
        Haptics.warning()
    }

    @MainActor
    public func clearSpeedTest() {
        resetSpeedTest()
        clearSpeedTestHistory()
    }

    // MARK: - Speed Test History Persistence
    private func loadSpeedTestHistory() {
        if let data = UserDefaults.standard.data(forKey: "onedeck_speedtest_history_v1"),
           let decoded = try? JSONDecoder().decode([SpeedTestRecord].self, from: data) {
            self.speedTestHistory = decoded
        }
    }

    private func saveSpeedTestRecord(_ record: SpeedTestRecord) {
        var updated = speedTestHistory
        updated.insert(record, at: 0)
        if updated.count > 10 {
            updated = Array(updated.prefix(10))
        }
        self.speedTestHistory = updated
        if let data = try? JSONEncoder().encode(updated) {
            UserDefaults.standard.set(data, forKey: "onedeck_speedtest_history_v1")
        }
    }
}

// MARK: - Compatibility Typealias
public typealias NetworkService = NetworkViewModel
