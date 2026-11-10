//
//  NetworkKernelProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Darwin kernel routing, resolver, and network interface telemetry probe.
//

import CoreFoundation
import Darwin
import Foundation
import os

// MARK: - Darwin BSD Routing Socket & Header Constants (iOS SDK Private Mapping)
private nonisolated let RTAX_DST: Int = 0
private nonisolated let RTAX_GATEWAY: Int = 1
private nonisolated let RTAX_MAX: Int = 8
private nonisolated let RTF_LLINFO: Int32 = 0x400

internal struct DarwinRtMsgHdr {
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
    var rtm_rmx: (
        UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32,
        UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32
    ) = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
}

// MARK: - Darwin Resolv.h Dynamic Function Binding
private typealias DarwinResInitFn = @convention(c) () -> Int32

// MARK: - Network Kernel Telemetry Data Models
public struct KernelArpDevice: Sendable, Hashable {
    public let ip: String
    public let mac: String
    public let vendor: String

    public nonisolated init(ip: String, mac: String, vendor: String) {
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

    public nonisolated init() {}
}

// MARK: - Network Kernel Probe Engine
public enum NetworkKernelProbe {
    // MARK: - 1. Real Default Gateway via Darwin Routing Socket (PF_ROUTE sysctl)
    public nonisolated static func queryDefaultGateway() -> String? {
        var mib: [Int32] = [CTL_NET, PF_ROUTE, 0, AF_INET, NET_RT_DUMP, 0]
        var len = 0
        guard sysctl(&mib, 6, nil, &len, nil, 0) == 0, len > 0 else { return nil }

        let buf = UnsafeMutablePointer<UInt8>.allocate(capacity: len)
        defer { buf.deallocate() }

        guard sysctl(&mib, 6, buf, &len, nil, 0) == 0 else { return nil }
        return parseDefaultGateway(from: UnsafeRawPointer(buf), length: len)
    }

    internal nonisolated static func readSockaddrIn(from ptr: UnsafeRawPointer, available: Int) -> sockaddr_in? {
        guard available >= 2 else { return nil }
        let saLenRaw = Int(ptr.load(as: UInt8.self))
        let saFamily = ptr.advanced(by: 1).load(as: UInt8.self)
        if saLenRaw == 0 && (saFamily == 0 || saFamily == UInt8(AF_INET)) {
            return sockaddr_in()
        }
        guard saFamily == UInt8(AF_INET) else { return nil }
        let copyLen = min(available, MemoryLayout<sockaddr_in>.size, saLenRaw > 0 ? saLenRaw : available)
        var sin = sockaddr_in()
        withUnsafeMutableBytes(of: &sin) { dst in
            let src = UnsafeRawBufferPointer(start: ptr, count: copyLen)
            for idx in 0 ..< min(copyLen, dst.count) {
                dst[idx] = src[idx]
            }
        }
        sin.sin_family = sa_family_t(AF_INET)
        return sin
    }

    internal nonisolated static func parseDefaultGateway(from buffer: UnsafeRawPointer, length: Int) -> String? {
        guard length > 0 else { return nil }
        var offset = 0
        let hdrSize = MemoryLayout<DarwinRtMsgHdr>.size

        while offset + hdrSize <= length {
            let rawPtr = buffer.advanced(by: offset)
            let rtm = rawPtr.loadUnaligned(as: DarwinRtMsgHdr.self)
            let msgLen = Int(rtm.rtm_msglen)
            guard msgLen >= hdrSize, offset + msgLen <= length else { break }

            let msgEnd = rawPtr.advanced(by: msgLen)
            var saPtr = rawPtr.advanced(by: hdrSize)
            var hasDefaultDst = false
            var gwAddr: sockaddr_in?

            for i in 0 ..< RTAX_MAX {
                if (Int32(rtm.rtm_addrs) & (1 << i)) != 0 {
                    let saRemaining = saPtr.distance(to: msgEnd)
                    guard saRemaining >= 2 else { break }
                    let saLenRaw = saPtr.load(as: UInt8.self)
                    let saFamily = saPtr.advanced(by: 1).load(as: UInt8.self)
                    let saLen = saLenRaw > 0 ? ((Int(saLenRaw) + 3) & ~3) : 4
                    guard saLen > 0, saLen <= saRemaining else { break }

                    if i == RTAX_DST {
                        if saFamily == 0 && saLenRaw <= 4 {
                            hasDefaultDst = true
                        } else if let dst = readSockaddrIn(from: saPtr, available: saRemaining), dst.sin_addr.s_addr == 0 {
                            hasDefaultDst = true
                        }
                    } else if i == RTAX_GATEWAY && saFamily == UInt8(AF_INET) {
                        gwAddr = readSockaddrIn(from: saPtr, available: saRemaining)
                    }
                    saPtr = saPtr.advanced(by: saLen)
                }
            }

            if hasDefaultDst, let gw = gwAddr {
                var gwStr = [CChar](repeating: 0, count: Int(INET_ADDRSTRLEN))
                var sinAddr = gw.sin_addr
                if inet_ntop(AF_INET, &sinAddr, &gwStr, socklen_t(gwStr.count)) != nil {
                    let res = String(cString: gwStr)
                    if !res.isEmpty && res != "0.0.0.0" {
                        return res
                    }
                }
            }

            offset += msgLen
        }
        return nil
    }

    // MARK: - Thread-Safe Dynamic C Bridges
    private final nonisolated class ResolvBridge: @unchecked Sendable {
        static let shared = ResolvBridge()

        let lock = OSAllocatedUnfairLock()
        let resInit: DarwinResInitFn?
        let resSymbol: UnsafeMutableRawPointer?

        private init() {
            let handle = dlopen("/usr/lib/libresolv.9.dylib", RTLD_NOW)
                ?? dlopen("/usr/lib/libresolv.dylib", RTLD_NOW)
                ?? dlopen(nil, RTLD_NOW)

            if let handle {
                if let symInit = dlsym(handle, "res_9_init") ?? dlsym(handle, "res_init") {
                    self.resInit = unsafeBitCast(symInit, to: DarwinResInitFn.self)
                } else {
                    self.resInit = nil
                }
                self.resSymbol = dlsym(handle, "_res")
            } else {
                self.resInit = nil
                self.resSymbol = nil
            }
        }
    }

    private typealias Apple80211OpenFn = @convention(c) (UnsafeMutablePointer<UnsafeMutableRawPointer?>) -> Int32
    private typealias Apple80211BindToInterfaceFn = @convention(c) (UnsafeMutableRawPointer, CFString) -> Int32
    private typealias Apple80211CloseFn = @convention(c) (UnsafeMutableRawPointer) -> Int32
    private typealias Apple80211GetInfoCopyFn = @convention(c) (UnsafeMutableRawPointer, UnsafeMutablePointer<Unmanaged<CFDictionary>?>) -> Int32

    private final nonisolated class Apple80211Bridge: @unchecked Sendable {
        static let shared = Apple80211Bridge()

        let openFn: Apple80211OpenFn?
        let bindFn: Apple80211BindToInterfaceFn?
        let infoFn: Apple80211GetInfoCopyFn?
        let closeFn: Apple80211CloseFn?

        private init() {
            guard let handle = dlopen("/System/Library/PrivateFrameworks/Apple80211.framework/Apple80211", RTLD_NOW) else {
                self.openFn = nil
                self.bindFn = nil
                self.infoFn = nil
                self.closeFn = nil
                return
            }

            func resolve<T>(_ name: String, _ type: T.Type) -> T? {
                dlsym(handle, name).map { unsafeBitCast($0, to: type) }
            }

            self.openFn = resolve("Apple80211Open", Apple80211OpenFn.self)
            self.bindFn = resolve("Apple80211BindToInterface", Apple80211BindToInterfaceFn.self)
            self.infoFn = resolve("Apple80211GetInfoCopy", Apple80211GetInfoCopyFn.self)
            self.closeFn = resolve("Apple80211Close", Apple80211CloseFn.self)
        }
    }

    // MARK: - 2. Real System DNS Servers via Darwin libresolv (_res)
    public nonisolated static func queryDnsServers() -> [String] {
        let bridge = ResolvBridge.shared
        return bridge.lock.withLock {
            var results: [String] = []
            _ = bridge.resInit?()

            guard let sym = bridge.resSymbol else { return [] }
            let nscount = sym.advanced(by: 16).load(as: Int32.self)
            let listOffset = 20

            // Darwin <resolv.h> MAXNS is 3
            for i in 0 ..< min(3, max(0, Int(nscount))) {
                let sinPtr = sym.advanced(by: listOffset + (i * MemoryLayout<sockaddr_in>.size))
                let sin = sinPtr.loadUnaligned(as: sockaddr_in.self)
                guard sin.sin_family == UInt8(AF_INET) else { continue }
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
    }

    // MARK: - 3. Real Active Devices via Darwin Kernel ARP Cache (RTF_LLINFO)
    public nonisolated static func queryArpTable() -> [KernelArpDevice] {
        var mib: [Int32] = [CTL_NET, PF_ROUTE, 0, AF_INET, NET_RT_FLAGS, RTF_LLINFO]
        var len = 0
        guard sysctl(&mib, 6, nil, &len, nil, 0) == 0, len > 0 else { return [] }

        let buf = UnsafeMutablePointer<UInt8>.allocate(capacity: len)
        defer { buf.deallocate() }

        guard sysctl(&mib, 6, buf, &len, nil, 0) == 0 else { return [] }
        return parseArpTable(from: UnsafeRawPointer(buf), length: len)
    }

    internal nonisolated static func parseArpTable(from buffer: UnsafeRawPointer, length: Int) -> [KernelArpDevice] {
        guard length > 0, let sdlDataOffset = MemoryLayout<sockaddr_dl>.offset(of: \sockaddr_dl.sdl_data) else {
            return []
        }

        var results: [KernelArpDevice] = []
        var offset = 0
        let hdrSize = MemoryLayout<DarwinRtMsgHdr>.size

        while offset + hdrSize <= length {
            let rawPtr = buffer.advanced(by: offset)
            let rtm = rawPtr.loadUnaligned(as: DarwinRtMsgHdr.self)
            let msgLen = Int(rtm.rtm_msglen)
            guard msgLen >= hdrSize, offset + msgLen <= length else { break }

            let msgEnd = rawPtr.advanced(by: msgLen)
            var saPtr = rawPtr.advanced(by: hdrSize)
            var dstAddr: sockaddr_in?
            var macStr: String?

            for i in 0 ..< RTAX_MAX {
                if (Int32(rtm.rtm_addrs) & (1 << i)) != 0 {
                    let saRemaining = saPtr.distance(to: msgEnd)
                    guard saRemaining >= 2 else { break }
                    let saLenRaw = saPtr.load(as: UInt8.self)
                    let saFamily = saPtr.advanced(by: 1).load(as: UInt8.self)
                    let saLen = saLenRaw > 0 ? ((Int(saLenRaw) + 3) & ~3) : 4
                    guard saLen > 0, saLen <= saRemaining else { break }

                    if i == RTAX_DST && saFamily == UInt8(AF_INET) {
                        dstAddr = readSockaddrIn(from: saPtr, available: saRemaining)
                    } else if i == RTAX_GATEWAY && saFamily == UInt8(AF_LINK) && saRemaining >= sdlDataOffset {
                        let sdlNlen = Int(saPtr.advanced(by: 5).load(as: UInt8.self))
                        let sdlAlen = Int(saPtr.advanced(by: 6).load(as: UInt8.self))
                        let macOffset = sdlDataOffset + sdlNlen
                        if sdlAlen == 6 && macOffset >= sdlDataOffset && (macOffset + 6) <= saRemaining {
                            let macPtr = saPtr.advanced(by: macOffset)
                            let macBytes = (0 ..< 6).map { idx in
                                macPtr.advanced(by: idx).loadUnaligned(as: UInt8.self)
                            }
                            macStr = macBytes.map { String(format: "%02x", $0) }.joined(separator: ":")
                        }
                    }
                    saPtr = saPtr.advanced(by: saLen)
                }
            }

            if let sin = dstAddr, let mac = macStr {
                var ipBuf = [CChar](repeating: 0, count: Int(INET_ADDRSTRLEN))
                var sinAddr = sin.sin_addr
                if inet_ntop(AF_INET, &sinAddr, &ipBuf, socklen_t(ipBuf.count)) != nil {
                    let ipStr = String(cString: ipBuf)
                    // Filter out multicast, broadcast, and invalid entries
                    if !ipStr.hasPrefix("224.") && !ipStr.hasPrefix("239.") && !ipStr.hasPrefix("255.") &&
                        ipStr != "0.0.0.0" && mac != "00:00:00:00:00:00" && !results.contains(where: { $0.ip == ipStr }) {
                        let vendor = lookupMacVendor(mac: mac)
                        results.append(KernelArpDevice(ip: ipStr, mac: mac, vendor: vendor))
                    }
                }
            }

            offset += msgLen
        }
        return results
    }

    // MARK: - 4. MAC Address OUI Vendor Lookup
    public nonisolated static func lookupMacVendor(mac: String) -> String {
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
    public nonisolated static func queryWifiTelemetry() -> WifiHardwareTelemetry? {
        let bridge = Apple80211Bridge.shared
        guard let openFn = bridge.openFn,
              let bindFn = bridge.bindFn,
              let infoFn = bridge.infoFn,
              let closeFn = bridge.closeFn else {
            return nil
        }

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
            result.noiseDbm = n > 0 ? -n : n
        }

        return result
    }

    // MARK: - 6. Comprehensive Apple Device Wi-Fi Generation & Radio Topology
    public nonisolated static func detectWifiHardware(machine: String) -> (generation: String, standard: String) {
        // iPhone 16e: Wi-Fi 6 (802.11ax, 2x2 MIMO with Apple C1 modem)
        if machine == "iPhone17,5" {
            return ("Wi-Fi 6", "802.11ax")
        }

        // iPhone 16/17/18 family & iPad Pro M5: Wi-Fi 7 (802.11be)
        if machine.hasPrefix("iPhone17,") || machine.hasPrefix("iPhone18,") || machine.hasPrefix("iPhone19,") ||
            machine.hasPrefix("iPad17,") {
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

        // iPad Pro M4, M2, iPad Air M4/M2, iPad mini A17 Pro: Wi-Fi 6E (802.11ax)
        if machine.hasPrefix("iPad16,") ||
            machine.hasPrefix("iPad14,3") || machine.hasPrefix("iPad14,4") ||
            machine.hasPrefix("iPad14,5") || machine.hasPrefix("iPad14,6") ||
            machine.hasPrefix("iPad14,8") || machine.hasPrefix("iPad14,9") ||
            machine.hasPrefix("iPad14,10") || machine.hasPrefix("iPad14,11") {
            return ("Wi-Fi 6E", "802.11ax")
        }

        // iPad Pro M1, iPad Air 4/5, iPad mini 6, iPad 10th gen: Wi-Fi 6
        if machine.hasPrefix("iPad13,") || machine.hasPrefix("iPad14,1") || machine.hasPrefix("iPad14,2") ||
            machine.hasPrefix("iPad15,") {
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
