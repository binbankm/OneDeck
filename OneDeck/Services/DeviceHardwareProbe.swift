//
//  DeviceHardwareProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Low-level device identity and hardware specification telemetry probe.
//

import Darwin
import Foundation
import MachO

// MARK: - Deep Device Identity & Hardware Telemetry Data Model
public struct DeviceIdentityHardwareTelemetry: Sendable {
    public var serialNumber: String?
    public var boardId: String?
    public var modelNumber: String?
    public var regulatoryModel: String?
    public var regionCode: String?
    public var salesTypeZh: String?
    public var salesTypeEn: String?
    public var salesTypeHant: String?
    public var osBuildNumber: String?
    public var pCores: Int?
    public var eCores: Int?
    public var l1dKb: Int?
    public var l2Mb: Int?
    public var clockFrequencyHz: UInt64?

    public nonisolated init() {}
}

// MARK: - Device Hardware Probe Engine
public enum DeviceHardwareProbe {
    private typealias IOServiceMatchingFunc = @convention(c) (UnsafePointer<CChar>) -> Unmanaged<CFMutableDictionary>?
    private typealias IOServiceGetMatchingServiceFunc = @convention(c) (mach_port_t, Unmanaged<CFMutableDictionary>) -> mach_port_t
    private typealias IORegistryEntryCreateCFPropertyFunc = @convention(c) (mach_port_t, CFString, CFAllocator?, UInt32) -> Unmanaged<CFTypeRef>?
    private typealias IOObjectReleaseFunc = @convention(c) (mach_port_t) -> kern_return_t
    private typealias MGCopyAnswerFunc = @convention(c) (CFString) -> Unmanaged<CFTypeRef>?

    public nonisolated static let current: DeviceIdentityHardwareTelemetry = computeHardwareIdentity()

    public nonisolated static func sample() -> DeviceIdentityHardwareTelemetry {
        current
    }

    private nonisolated static func computeHardwareIdentity() -> DeviceIdentityHardwareTelemetry {
        var result = DeviceIdentityHardwareTelemetry()

        // 1. IOKit IOPlatformExpertDevice (Platform Serial, Board ID, Device-Tree Reference Clock Frequency)
        if let handle = dlopen("/System/Library/Frameworks/IOKit.framework/IOKit", RTLD_NOW) {
            defer { dlclose(handle) }
            if let symMatching = dlsym(handle, "IOServiceMatching"),
               let symGetService = dlsym(handle, "IOServiceGetMatchingService"),
               let symCreateProp = dlsym(handle, "IORegistryEntryCreateCFProperty"),
               let symRelease = dlsym(handle, "IOObjectRelease") {
                let ioServiceMatching = unsafeBitCast(symMatching, to: IOServiceMatchingFunc.self)
                let ioServiceGetMatchingService = unsafeBitCast(symGetService, to: IOServiceGetMatchingServiceFunc.self)
                let ioRegistryEntryCreateCFProperty = unsafeBitCast(symCreateProp, to: IORegistryEntryCreateCFPropertyFunc.self)
                let ioObjectRelease = unsafeBitCast(symRelease, to: IOObjectReleaseFunc.self)

                if let dict = ioServiceMatching("IOPlatformExpertDevice") {
                    let service = ioServiceGetMatchingService(0, dict)
                    if service != 0 {
                        defer { _ = ioObjectRelease(service) }
                        // Serial Number
                        if let prop = ioRegistryEntryCreateCFProperty(service, "IOPlatformSerialNumber" as CFString, kCFAllocatorDefault, 0) {
                            let val = prop.takeRetainedValue()
                            if let s = val as? String, !s.isEmpty {
                                result.serialNumber = s
                            }
                        }
                        if result.serialNumber == nil, let prop = ioRegistryEntryCreateCFProperty(service, "serial-number" as CFString, kCFAllocatorDefault, 0) {
                            let val = prop.takeRetainedValue()
                            if let data = val as? Data, let s = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .controlCharacters), !s.isEmpty {
                                result.serialNumber = s
                            }
                        }

                        // Board ID / Model
                        if let prop = ioRegistryEntryCreateCFProperty(service, "board-id" as CFString, kCFAllocatorDefault, 0) {
                            let val = prop.takeRetainedValue()
                            if let data = val as? Data, let b = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .controlCharacters), !b.isEmpty {
                                result.boardId = b
                            } else if let b = val as? String, !b.isEmpty {
                                result.boardId = b
                            }
                        }

                        // Clock Frequency
                        if let prop = ioRegistryEntryCreateCFProperty(service, "clock-frequency" as CFString, kCFAllocatorDefault, 0) {
                            let val = prop.takeRetainedValue()
                            if CFGetTypeID(val) == CFDataGetTypeID(), let data = val as? Data {
                                if data.count == 4 {
                                    let hz = data.withUnsafeBytes { $0.loadUnaligned(as: UInt32.self) }
                                    result.clockFrequencyHz = UInt64(hz)
                                } else if data.count == 8 {
                                    let hz = data.withUnsafeBytes { $0.loadUnaligned(as: UInt64.self) }
                                    result.clockFrequencyHz = hz
                                }
                            } else if let num = val as? NSNumber {
                                result.clockFrequencyHz = num.uint64Value
                            }
                        }
                    }
                }
            }
        }

        // 2. MobileGestalt (libMobileGestalt.dylib for ModelNumber & Region)
        if let mgHandle = dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_NOW) {
            defer { dlclose(mgHandle) }
            if let sym = dlsym(mgHandle, "MGCopyAnswer") {
                let mgCopyAnswer = unsafeBitCast(sym, to: MGCopyAnswerFunc.self)

                if result.serialNumber == nil, let ans = mgCopyAnswer("SerialNumber" as CFString) {
                    if let s = ans.takeRetainedValue() as? String, !s.isEmpty {
                        result.serialNumber = s
                    }
                }

                var rawModel: String?
                var rawRegion: String?

                if let ans = mgCopyAnswer("ModelNumber" as CFString) {
                    if let m = ans.takeRetainedValue() as? String, !m.isEmpty {
                        rawModel = m
                    }
                }
                if let ans = mgCopyAnswer("RegulatoryModelNumber" as CFString) {
                    if let r = ans.takeRetainedValue() as? String, !r.isEmpty {
                        result.regulatoryModel = r
                    }
                }
                if let ans = mgCopyAnswer("RegionInfo" as CFString) ?? mgCopyAnswer("RegionCode" as CFString) {
                    if let reg = ans.takeRetainedValue() as? String, !reg.isEmpty {
                        rawRegion = reg
                    }
                }

                // Assemble full commercial model number, e.g. "MLTE3" + "CH/A" -> "MLTE3CH/A"
                if let m = rawModel {
                    if let r = rawRegion, !r.isEmpty {
                        if m.contains("/") {
                            result.modelNumber = m
                            result.regionCode = r
                        } else if r.contains("/") {
                            result.modelNumber = "\(m)\(r)"
                            result.regionCode = r
                        } else {
                            result.modelNumber = "\(m)\(r)/A"
                            result.regionCode = "\(r)/A"
                        }
                    } else {
                        result.modelNumber = m
                    }
                }
            }
        }

        // 3. Sysctl Kernel Telemetry (P/E cores, caches, OS build, boardId fallback)
        var buildChars = [CChar](repeating: 0, count: 64)
        var bSize = buildChars.count
        if sysctlbyname("kern.osversion", &buildChars, &bSize, nil, 0) == 0 {
            let b = String(cString: buildChars)
            if !b.isEmpty { result.osBuildNumber = b }
        }

        if result.boardId == nil {
            var modelChars = [CChar](repeating: 0, count: 64)
            var mSize = modelChars.count
            if sysctlbyname("hw.model", &modelChars, &mSize, nil, 0) == 0 {
                let m = String(cString: modelChars)
                if !m.isEmpty { result.boardId = m }
            }
        }

        var pCores: Int32 = 0
        var eCores: Int32 = 0
        var intSize = MemoryLayout<Int32>.size
        if sysctlbyname("hw.perflevel0.physicalcpu", &pCores, &intSize, nil, 0) == 0 && pCores > 0 {
            result.pCores = Int(pCores)
        }
        intSize = MemoryLayout<Int32>.size
        if sysctlbyname("hw.perflevel1.physicalcpu", &eCores, &intSize, nil, 0) == 0 && eCores > 0 {
            result.eCores = Int(eCores)
        }

        var l1d: Int64 = 0
        var l2: Int64 = 0
        var i64Size = MemoryLayout<Int64>.size
        if sysctlbyname("hw.l1dcachesize", &l1d, &i64Size, nil, 0) == 0 && l1d > 0 {
            result.l1dKb = Int(l1d / 1024)
        }
        i64Size = MemoryLayout<Int64>.size
        if sysctlbyname("hw.l2cachesize", &l2, &i64Size, nil, 0) == 0 && l2 > 0 {
            result.l2Mb = Int(l2 / (1024 * 1024))
        }

        // 4. Parse Real Sales Type & Region from Model Number / Region Code (e.g. "MLTE3CH/A")
        if let model = result.modelNumber, !model.isEmpty {
            let (typeZh, typeEn, typeHant, prefixChar) = Self.parseSalesType(model: model)
            let regionSource = result.regionCode ?? model
            let (regionZh, regionEn, regionHant) = Self.parseRegionLabels(from: regionSource)

            if !regionZh.isEmpty {
                result.salesTypeZh = "\(regionZh) \(typeZh) (\(prefixChar))"
                result.salesTypeEn = "\(typeEn) (\(regionEn)) (\(prefixChar))"
                result.salesTypeHant = "\(regionHant) \(typeHant) (\(prefixChar))"
            } else {
                result.salesTypeZh = "\(typeZh) (\(prefixChar))"
                result.salesTypeEn = "\(typeEn) (\(prefixChar))"
                result.salesTypeHant = "\(typeHant) (\(prefixChar))"
            }
        }

        return result
    }

    internal nonisolated static func parseSalesType(model: String) -> (zh: String, en: String, hant: String, prefix: String) {
        let firstChar = model.prefix(1).uppercased()
        switch firstChar {
        case "M": return ("零售机", "Retail", "零售機", firstChar)
        case "N": return ("官换机", "Replacement", "官換機", firstChar)
        case "F": return ("官翻机", "Refurbished", "官翻機", firstChar)
        case "P": return ("定制机", "Custom", "客製機", firstChar)
        case "3": return ("展示机", "Demo", "展示機", firstChar)
        default: return ("零售机", "Retail", "零售機", firstChar)
        }
    }

    internal nonisolated static func parseRegionLabels(from codeOrModel: String) -> (zh: String, en: String, hant: String) {
        let upper = codeOrModel.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let beforeSlash = upper.split(separator: "/").first.map(String.init) ?? upper
        // Extract trailing alphabetic region token (e.g. "MLTE3CH/A" -> "CH", "MF840AB/A" -> "AB")
        let tokenChars = beforeSlash.reversed().prefix(while: { $0.isLetter }).reversed()
        let regionToken = String(tokenChars)
        switch regionToken {
        case "CH": return ("国行", "CN", "國行")
        case "LL": return ("美版", "US", "美版")
        case "ZA": return ("港澳", "HK/MO", "港澳")
        case "ZP": return ("新加坡/港澳", "SG/HK", "新加坡/港澳")
        case "J": return ("日版", "JP", "日版")
        case "KH": return ("韩版", "KR", "韓版")
        case "B": return ("英版", "UK", "英版")
        case "ZD": return ("欧版", "EU", "歐版")
        case "TA": return ("台版", "TW", "台版")
        case "C": return ("加版", "CA", "加版")
        case "X": return ("澳版", "AU", "澳版")
        default: return ("", "", "")
        }
    }
}
