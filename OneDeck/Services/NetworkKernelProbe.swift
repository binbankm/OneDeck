//
//  NetworkKernelProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Deep Darwin Kernel & Private Telemetry Probes for Network Subsystem:
//  - Routing Table Default Gateway Extraction (PF_ROUTE sysctl)
//  - System Dynamic Resolver DNS Servers (res_9_init / _res)
//  - Kernel ARP Cache Table Discovery (RTF_LLINFO)
//  - IEEE 802.11 Private Wi-Fi Telemetry (Apple80211 / MobileWiFi: SSID, BSSID, RSSI, Channel, TxRate)
//  - Comprehensive Apple Silicon / iOS Radio & Wi-Fi Generation Topology
//

import Foundation
import Darwin
import CoreFoundation

// MARK: - Darwin BSD Routing Socket & Header Constants (iOS SDK Private Mapping)
private nonisolated let RTAX_DST: Int = 0
private nonisolated let RTAX_GATEWAY: Int = 1
private nonisolated let RTAX_MAX: Int = 8
private nonisolated let RTF_LLINFO: Int32 = 0x400

private struct DarwinRtMsgHdr {
    var rtm_msglen: UInt16
    var rtm_version: UInt8
    var rtm_type: UInt8
    var rtm_index: UInt16
    var _pad: (UInt8, UInt8) = (0, 0)
    var rtm_flags: Int32
    var rtm_addrs: Int32
    var rtm_pid: pid_t
    var rtm_seq: Int32
    var rtm_errno: Int32
    var rtm_use: Int32
    var rtm_inits: UInt32
    var rtm_rmx: (UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64) = (0, 0, 0, 0, 0, 0, 0)
}

// MARK: - Darwin Resolv.h Dynamic Function Binding
private typealias DarwinResInitFn = @convention(c) () -> Int32

// MARK: - Network Kernel Telemetry Data Models
public struct KernelArpDevice: Sendable, Hashable {
    public let ip: String
    public let mac: String
    public let vendor: String

    nonisolated public init(ip: String, mac: String, vendor: String) {
        self.ip = ip
        self.mac = mac
        self.vendor = vendor
    }
}

public struct WifiHardwareTelemetry: Sendable {
    public var ssid: String?
    public var bssid: String?
    public var rssiDbm: Int?
    public var channel: Int?
    public var txRateMbps: Int?
    public var noiseDbm: Int?

    nonisolated public init() {}
}

// MARK: - Network Kernel Probe Engine
public enum NetworkKernelProbe {

    // MARK: - 1. Real Default Gateway via Darwin Routing Socket (PF_ROUTE sysctl)
    nonisolated public static func queryDefaultGateway() -> String? {
        var mib: [Int32] = [CTL_NET, PF_ROUTE, 0, AF_INET, NET_RT_DUMP, 0]
        var len: Int = 0
        guard sysctl(&mib, 6, nil, &len, nil, 0) == 0, len > 0 else { return nil }

        let buf = UnsafeMutablePointer<UInt8>.allocate(capacity: len)
        defer { buf.deallocate() }

        guard sysctl(&mib, 6, buf, &len, nil, 0) == 0 else { return nil }

        var ptr = buf
        let end = buf.advanced(by: len)

        while ptr < end {
            guard ptr.distance(to: end) >= MemoryLayout<DarwinRtMsgHdr>.size else { break }
            let rawPtr = UnsafeRawPointer(ptr)
            let rtm = rawPtr.loadUnaligned(as: DarwinRtMsgHdr.self)
            let msgLen = Int(rtm.rtm_msglen)
            guard msgLen > 0 else { break }

            var saPtr = rawPtr.advanced(by: MemoryLayout<DarwinRtMsgHdr>.size)
            var dstAddr: sockaddr_in? = nil
            var gwAddr: sockaddr_in? = nil

            for i in 0..<RTAX_MAX {
                if (Int32(rtm.rtm_addrs) & (1 << i)) != 0 {
                    guard saPtr < UnsafeRawPointer(end) else { break }
                    let sa = saPtr.loadUnaligned(as: sockaddr.self)
                    let saLen = sa.sa_len > 0 ? Int((Int(sa.sa_len) + 3) & ~3) : 4

                    if i == RTAX_DST && sa.sa_family == UInt8(AF_INET) {
                        dstAddr = saPtr.loadUnaligned(as: sockaddr_in.self)
                    }
                    if i == RTAX_GATEWAY && sa.sa_family == UInt8(AF_INET) {
                        gwAddr = saPtr.loadUnaligned(as: sockaddr_in.self)
                    }
                    saPtr = saPtr.advanced(by: saLen)
                }
            }

            if let dst = dstAddr, let gw = gwAddr, dst.sin_addr.s_addr == 0 {
                var gwStr = [CChar](repeating: 0, count: Int(INET_ADDRSTRLEN))
                var sinAddr = gw.sin_addr
                if inet_ntop(AF_INET, &sinAddr, &gwStr, socklen_t(gwStr.count)) != nil {
                    let res = String(cString: gwStr)
                    if !res.isEmpty && res != "0.0.0.0" {
                        return res
                    }
                }
            }

            ptr = ptr.advanced(by: msgLen)
        }
        return nil
    }

    // MARK: - 2. Real System DNS Servers via Darwin libresolv (_res)
    nonisolated public static func queryDnsServers() -> [String] {
        var results: [String] = []

        let resolvHandle = dlopen("/usr/lib/libresolv.9.dylib", RTLD_NOW)
            ?? dlopen("/usr/lib/libresolv.dylib", RTLD_NOW)
            ?? dlopen(nil, RTLD_NOW)

        if let handle = resolvHandle {
            if let symInit = dlsym(handle, "res_9_init") ?? dlsym(handle, "res_init") {
                let resInit = unsafeBitCast(symInit, to: DarwinResInitFn.self)
                _ = resInit()
            }
        }

        guard let sym = dlsym(resolvHandle, "_res") ?? dlsym(dlopen(nil, RTLD_NOW), "_res") else { return [] }
        let nscount = sym.advanced(by: 16).load(as: Int32.self)
        let listOffset = 20

        for i in 0..<min(4, max(0, Int(nscount))) {
            let sinPtr = sym.advanced(by: listOffset + (i * MemoryLayout<sockaddr_in>.size))
            let sin = sinPtr.load(as: sockaddr_in.self)
            var ipBuf = [CChar](repeating: 0, count: Int(INET_ADDRSTRLEN))
            var sinAddr = sin.sin_addr
            if inet_ntop(AF_INET, &sinAddr, &ipBuf, socklen_t(ipBuf.count)) != nil {
                let s = String(cString: ipBuf)
                if !s.isEmpty && s != "0.0.0.0" && !results.contains(s) {
                    results.append(s)
                }
            }
        }
        return results
    }

    // MARK: - 3. Real Active Devices via Darwin Kernel ARP Cache (RTF_LLINFO)
    nonisolated public static func queryArpTable() -> [KernelArpDevice] {
        var mib: [Int32] = [CTL_NET, PF_ROUTE, 0, AF_INET, NET_RT_FLAGS, RTF_LLINFO]
        var len: Int = 0
        guard sysctl(&mib, 6, nil, &len, nil, 0) == 0, len > 0 else { return [] }

        let buf = UnsafeMutablePointer<UInt8>.allocate(capacity: len)
        defer { buf.deallocate() }

        guard sysctl(&mib, 6, buf, &len, nil, 0) == 0 else { return [] }

        var results: [KernelArpDevice] = []
        var ptr = buf
        let end = buf.advanced(by: len)

        while ptr < end {
            guard ptr.distance(to: end) >= MemoryLayout<DarwinRtMsgHdr>.size else { break }
            let rawPtr = UnsafeRawPointer(ptr)
            let rtm = rawPtr.loadUnaligned(as: DarwinRtMsgHdr.self)
            let msgLen = Int(rtm.rtm_msglen)
            guard msgLen > 0 else { break }

            let sinPtr = rawPtr.advanced(by: MemoryLayout<DarwinRtMsgHdr>.size)
            guard sinPtr < UnsafeRawPointer(end) else { break }
            let sin = sinPtr.loadUnaligned(as: sockaddr_in.self)
            let sinLen = sin.sin_len > 0 ? Int((Int(sin.sin_len) + 3) & ~3) : 16

            let sdlPtr = sinPtr.advanced(by: sinLen)
            guard sdlPtr < UnsafeRawPointer(end) else { break }
            let sdl = sdlPtr.loadUnaligned(as: sockaddr_dl.self)

            if sin.sin_family == UInt8(AF_INET) && sdl.sdl_family == UInt8(AF_LINK) && sdl.sdl_alen == 6 {
                var ipBuf = [CChar](repeating: 0, count: Int(INET_ADDRSTRLEN))
                var sinAddr = sin.sin_addr
                if inet_ntop(AF_INET, &sinAddr, &ipBuf, socklen_t(ipBuf.count)) != nil {
                    let ipStr = String(cString: ipBuf)
                    let macOffset = MemoryLayout<sockaddr_dl>.offset(of: \sockaddr_dl.sdl_data)! + Int(sdl.sdl_nlen)
                    let macPtr = sdlPtr.advanced(by: macOffset)
                    let macBytes = (0..<6).map { i in
                        macPtr.advanced(by: i).loadUnaligned(as: UInt8.self)
                    }
                    let macStr = macBytes.map { String(format: "%02x", $0) }.joined(separator: ":")

                    // Filter out multicast, broadcast, and invalid entries
                    if !ipStr.hasPrefix("224.") && !ipStr.hasPrefix("239.") && !ipStr.hasPrefix("255.") &&
                       macStr != "00:00:00:00:00:00" && !results.contains(where: { $0.ip == ipStr }) {
                        let vendor = lookupMacVendor(mac: macStr)
                        results.append(KernelArpDevice(ip: ipStr, mac: macStr, vendor: vendor))
                    }
                }
            }
            ptr = ptr.advanced(by: msgLen)
        }
        return results
    }

    // MARK: - 4. MAC Address OUI Vendor Lookup
    nonisolated public static func lookupMacVendor(mac: String) -> String {
        let prefix = mac.prefix(8).lowercased()
        switch prefix {
        // Apple
        case "a4:83:e7", "74:d8:3e", "3c:06:30", "ac:bc:32", "f0:18:98", "40:6c:8f", "88:66:5a", "f4:d4:88", "18:65:90", "34:36:3b":
            return "Apple"
        // Xiaomi / Smart Home
        case "a4:39:b3", "78:11:dc", "50:d2:f5", "64:90:c1", "7c:49:eb", "0c:9a:60", "28:6c:07", "44:23:7c":
            return "Xiaomi"
        // Huawei / Honor
        case "54:af:97", "f8:ff:c2", "70:7b:e8", "14:a3:2f", "9c:28:ef", "00:e0:fc", "48:46:fb":
            return "Huawei"
        // TP-Link / Mercusys
        case "ec:88:8f", "14:75:90", "50:2b:73", "c0:06:c3", "98:42:65", "dc:fe:18", "b0:95:75":
            return "TP-Link"
        // Raspberry Pi / Embedded
        case "b8:27:eb", "dc:a6:32", "e4:5f:01", "28:cd:c1":
            return "Raspberry Pi"
        // Synology / QNAP NAS
        case "00:11:32", "90:09:d0", "24:5e:be", "00:08:9b":
            return "NAS Server"
        // Espressif IoT (ESP8266 / ESP32)
        case "24:6f:28", "30:ae:a4", "84:0d:8e", "2c:f4:32", "a4:cf:12":
            return "IoT Device"
        // Intel / Realtek PC
        case "d8:07:b6", "00:e0:4c", "00:1e:67", "00:15:5d", "80:86:f2":
            return "PC / Workstation"
        default:
            // Randomized private MAC detection (bit 1 of first byte is 1, e.g. 2, 6, A, E)
            if let firstByte = UInt8(mac.prefix(2), radix: 16), (firstByte & 0x02) != 0 {
                return "Private MAC"
            }
            return "LAN Host"
        }
    }

    // MARK: - 5. Apple80211 Private Wi-Fi Link Telemetry (SSID, BSSID, RSSI, Channel, TxRate)
    private typealias Apple80211OpenFn = @convention(c) (UnsafeMutablePointer<UnsafeMutableRawPointer?>) -> Int32
    private typealias Apple80211BindToInterfaceFn = @convention(c) (UnsafeMutableRawPointer, CFString) -> Int32
    private typealias Apple80211CloseFn = @convention(c) (UnsafeMutableRawPointer) -> Int32
    private typealias Apple80211GetInfoCopyFn = @convention(c) (UnsafeMutableRawPointer, UnsafeMutablePointer<Unmanaged<CFDictionary>?>) -> Int32

    nonisolated public static func queryWifiTelemetry() -> WifiHardwareTelemetry? {
        guard let handle = dlopen("/System/Library/PrivateFrameworks/Apple80211.framework/Apple80211", RTLD_NOW) else {
            return nil
        }
        defer { dlclose(handle) }

        guard let symOpen = dlsym(handle, "Apple80211Open"),
              let symBind = dlsym(handle, "Apple80211BindToInterface"),
              let symInfo = dlsym(handle, "Apple80211GetInfoCopy"),
              let symClose = dlsym(handle, "Apple80211Close") else {
            return nil
        }

        let openFn = unsafeBitCast(symOpen, to: Apple80211OpenFn.self)
        let bindFn = unsafeBitCast(symBind, to: Apple80211BindToInterfaceFn.self)
        let infoFn = unsafeBitCast(symInfo, to: Apple80211GetInfoCopyFn.self)
        let closeFn = unsafeBitCast(symClose, to: Apple80211CloseFn.self)

        var client: UnsafeMutableRawPointer? = nil
        guard openFn(&client) == 0, let c = client else { return nil }
        defer { _ = closeFn(c) }

        guard bindFn(c, "en0" as CFString) == 0 else { return nil }

        var infoDict: Unmanaged<CFDictionary>? = nil
        guard infoFn(c, &infoDict) == 0, let d = infoDict?.takeRetainedValue() as? [String: Any] else {
            return nil
        }

        var result = WifiHardwareTelemetry()

        if let s = d["SSID_STR"] as? String, !s.isEmpty {
            result.ssid = s
        }
        if let b = d["BSSID"] as? String, !b.isEmpty {
            result.bssid = b
        }
        if let r = d["RATE"] as? Int, r > 0 {
            result.txRateMbps = r
        }

        if let rssiDict = d["RSSI"] as? [String: Any], let val = rssiDict["RSSI_CTL_AGR"] {
            if let str = val as? String, let num = Int(str) {
                result.rssiDbm = num
            } else if let num = val as? Int {
                result.rssiDbm = num
            }
        }

        if let chDict = d["CHANNEL"] as? [String: Any], let ch = chDict["CHANNEL"] as? Int {
            result.channel = ch
        }

        if let noiseDict = d["NOISE"] as? [String: Any], let n = noiseDict["NOISE_CTL_AGR"] as? Int {
            result.noiseDbm = -n
        }

        return result
    }

    // MARK: - 6. Comprehensive Apple Device Wi-Fi Generation & Radio Topology
    nonisolated public static func detectWifiHardware(machine: String) -> (generation: String, standard: String) {
        // iPhone 16 family: Wi-Fi 7 (802.11be, 2.4/5/6 GHz, 320MHz, 4K-QAM)
        if machine.hasPrefix("iPhone17,") {
            return ("Wi-Fi 7", "802.11be")
        }

        // iPhone 15 Pro family: Wi-Fi 6E (802.11ax, 6 GHz band support)
        if machine == "iPhone16,1" || machine == "iPhone16,2" {
            return ("Wi-Fi 6E", "802.11ax 6GHz")
        }

        // iPhone 11 ~ 15 base: Wi-Fi 6 (802.11ax, 2x2 MIMO)
        if machine.hasPrefix("iPhone12,") || machine.hasPrefix("iPhone13,") ||
           machine.hasPrefix("iPhone14,") || machine.hasPrefix("iPhone15,") ||
           machine.hasPrefix("iPhone16,") {
            return ("Wi-Fi 6", "802.11ax")
        }

        // iPad Pro M4, M2, iPad Air M2: Wi-Fi 6E (802.11ax)
        if machine.hasPrefix("iPad16,3") || machine.hasPrefix("iPad16,4") ||
           machine.hasPrefix("iPad16,5") || machine.hasPrefix("iPad16,6") ||
           machine.hasPrefix("iPad14,3") || machine.hasPrefix("iPad14,4") ||
           machine.hasPrefix("iPad14,5") || machine.hasPrefix("iPad14,6") ||
           machine.hasPrefix("iPad14,8") || machine.hasPrefix("iPad14,9") ||
           machine.hasPrefix("iPad14,10") || machine.hasPrefix("iPad14,11") {
            return ("Wi-Fi 6E", "802.11ax")
        }

        // iPad Pro M1, iPad Air 4/5, iPad mini 6, iPad 10th gen: Wi-Fi 6
        if machine.hasPrefix("iPad13,") || machine.hasPrefix("iPad14,1") || machine.hasPrefix("iPad14,2") {
            return ("Wi-Fi 6", "802.11ax")
        }

        // iPhone 8, 8 Plus, X, XR, XS, XS Max, 7, 6s: Wi-Fi 5 (802.11ac)
        if machine.hasPrefix("iPhone10,") || machine.hasPrefix("iPhone11,") ||
           machine.hasPrefix("iPhone8,") || machine.hasPrefix("iPhone9,") ||
           machine.hasPrefix("iPhone7,") {
            return ("Wi-Fi 5", "802.11ac")
        }

        // Default Modern Baseline
        return ("Wi-Fi 6", "802.11ax")
    }
}
