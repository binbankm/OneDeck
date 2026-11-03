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
    private typealias IOServiceMatchingFunc = @convention(c) (UnsafePointer<CChar>) -> CFMutableDictionary?
    private typealias IOServiceGetMatchingServiceFunc = @convention(c) (mach_port_t, CFDictionary) -> mach_port_t
    private typealias IORegistryEntryCreateCFPropertyFunc = @convention(c) (mach_port_t, CFString, CFAllocator?, UInt32) -> Unmanaged<CFTypeRef>?
    private typealias IOObjectReleaseFunc = @convention(c) (mach_port_t) -> kern_return_t
    private typealias MGCopyAnswerFunc = @convention(c) (CFString) -> Unmanaged<CFTypeRef>?

    public nonisolated static func sample() -> DeviceIdentityHardwareTelemetry {
        var result = DeviceIdentityHardwareTelemetry()

        // 1. IOKit IOPlatformExpertDevice (Platform Serial, Board ID, Clock Frequency)
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
                                    let hz = data.withUnsafeBytes { $0.load(as: UInt32.self) }
                                    result.clockFrequencyHz = UInt64(hz)
                                } else if data.count == 8 {
                                    let hz = data.withUnsafeBytes { $0.load(as: UInt64.self) }
                                    result.clockFrequencyHz = hz
                                }
                            } else if let num = val as? NSNumber {
                                result.clockFrequencyHz = num.uint64Value
                            }
                        }

                        _ = ioObjectRelease(service)
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

        // 4. Parse Real Sales Type & Region from Model Number (e.g. "MLTE3CH/A")
        if let model = result.modelNumber, !model.isEmpty {
            let firstChar = model.prefix(1).uppercased()
            let (typeZh, typeEn, typeHant): (String, String, String) = {
                switch firstChar {
                case "M": return ("零售机", "Retail", "零售機")
                case "N": return ("官换机", "Replacement", "官換機")
                case "F": return ("官翻机", "Refurbished", "官翻機")
                case "P": return ("定制机", "Custom", "客製機")
                case "3": return ("展示机", "Demo", "展示機")
                default: return ("零售机", "Retail", "零售機")
                }
            }()

            let (regionZh, regionEn, regionHant): (String, String, String) = {
                if model.contains("CH/A") || model.hasSuffix("CH") { return ("国行", "CN", "國行") }
                if model.contains("LL/A") || model.hasSuffix("LL") { return ("美版", "US", "美版") }
                if model.contains("ZA/A") || model.hasSuffix("ZA") { return ("港澳", "HK/MO", "港澳") }
                if model.contains("ZP/A") || model.hasSuffix("ZP") { return ("新加坡", "SG", "新加坡") }
                if model.contains("J/A") || model.hasSuffix("J") { return ("日版", "JP", "日版") }
                if model.contains("KH/A") || model.hasSuffix("KH") { return ("韩版", "KR", "韓版") }
                if model.contains("B/A") || model.hasSuffix("B") { return ("英版", "UK", "英版") }
                if model.contains("ZD/A") || model.hasSuffix("ZD") { return ("欧版", "EU", "歐版") }
                if model.contains("TA/A") || model.hasSuffix("TA") { return ("台版", "TW", "台版") }
                if model.contains("C/A") || model.hasSuffix("C") { return ("加版", "CA", "加版") }
                if model.contains("X/A") || model.hasSuffix("X") { return ("澳版", "AU", "澳版") }
                return ("", "", "")
            }()

            if !regionZh.isEmpty {
                result.salesTypeZh = "\(regionZh) \(typeZh) (\(firstChar))"
                result.salesTypeEn = "\(typeEn) (\(regionEn)) (\(firstChar))"
                result.salesTypeHant = "\(regionHant) \(typeHant) (\(firstChar))"
            } else {
                result.salesTypeZh = "\(typeZh) (\(firstChar))"
                result.salesTypeEn = "\(typeEn) (\(firstChar))"
                result.salesTypeHant = "\(typeHant) (\(firstChar))"
            }
        }

        return result
    }
}
