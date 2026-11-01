//
//  L10n.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Type-safe, instant in-app localized string dictionary.
//

import SwiftUI

public enum AppLanguage: String, CaseIterable, Identifiable {
    case system = "system"
    case zhHans = "zh-Hans"
    case en = "en"
    case zhHant = "zh-Hant"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .system:
            return L10n.Settings.langSystem
        case .zhHans:
            return "简体中文"
        case .en:
            return "English"
        case .zhHant:
            return "繁體中文"
        }
    }
}

public enum L10n {
    public static var currentLanguage: AppLanguage {
        AppState.shared.language
    }

    private static var systemLanguage: (isZh: Bool, isHant: Bool) {
        var candidates: [String] = []
        if let firstPref = Locale.preferredLanguages.first {
            candidates.append(firstPref)
        }
        candidates.append(Locale.current.identifier)
        if let langCode = Locale.current.language.languageCode?.identifier {
            candidates.append(langCode)
        }
        candidates.append(contentsOf: Locale.preferredLanguages)

        for lang in candidates {
            let lower = lang.lowercased()
            if lower.contains("zh-hant") || lower.contains("zh-hk") || lower.contains("zh-tw") || lower.contains("zh-mo") ||
               lower.contains("zh_hant") || lower.contains("zh_hk") || lower.contains("zh_tw") || lower.contains("zh_mo") {
                return (true, true)
            }
            if lower.hasPrefix("zh") || lower.contains("zh-hans") || lower.contains("zh_cn") || lower.contains("chinese") {
                return (true, false)
            }
        }
        return (false, false)
    }

    public static var isEnglish: Bool {
        switch currentLanguage {
        case .en:
            return true
        case .zhHans, .zhHant:
            return false
        case .system:
            return !systemLanguage.isZh
        }
    }

    public static var isChinese: Bool {
        switch currentLanguage {
        case .zhHans:
            return true
        case .zhHant:
            return false
        case .en:
            return false
        case .system:
            return systemLanguage.isZh && !systemLanguage.isHant
        }
    }

    private static var isTraditionalChinese: Bool {
        switch currentLanguage {
        case .zhHant:
            return true
        case .zhHans, .en:
            return false
        case .system:
            return systemLanguage.isZh && systemLanguage.isHant
        }
    }

    public static func tr(zh: String, en: String, hant: String? = nil) -> String {
        switch currentLanguage {
        case .en:
            return en
        case .zhHans:
            return zh
        case .zhHant:
            return hant ?? zh
        case .system:
            let sys = systemLanguage
            if sys.isZh {
                if sys.isHant {
                    return hant ?? zh
                }
                return zh
            }
            return en
        }
    }

    // MARK: - Common
    public enum Common {
        public static var done: String { tr(zh: "完成", en: "Done", hant: "完成") }
        public static var cancel: String { tr(zh: "取消", en: "Cancel", hant: "取消") }
        public static var close: String { tr(zh: "关闭", en: "Close", hant: "關閉") }
        public static var copy: String { tr(zh: "复制", en: "Copy", hant: "複製") }
        public static var copied: String { tr(zh: "已复制", en: "Copied", hant: "已複製") }
        public static var reset: String { tr(zh: "重置", en: "Reset", hant: "重設") }
        public static var start: String { tr(zh: "开始", en: "Start", hant: "開始") }
        public static var stop: String { tr(zh: "停止", en: "Stop", hant: "停止") }
        public static var loading: String { tr(zh: "加载中...", en: "Loading...", hant: "載入中...") }
        public static var refresh: String { tr(zh: "刷新", en: "Refresh", hant: "重新整理") }
        public static var success: String { tr(zh: "成功", en: "Success", hant: "成功") }
        public static var failed: String { tr(zh: "失败", en: "Failed", hant: "失敗") }
        public static var notAvailable: String { tr(zh: "不可用", en: "N/A", hant: "無法使用") }
        public static var unknown: String { tr(zh: "未知", en: "Unknown", hant: "未知") }
        public static var supported: String { tr(zh: "支持", en: "Supported", hant: "支援") }
        public static var notSupported: String { tr(zh: "不支持", en: "Unsupported", hant: "不支援") }
    }

    // MARK: - Tabs
    public enum Tabs {
        public static var overview: String { tr(zh: "概览", en: "Overview", hant: "概覽") }
        public static var battery: String { tr(zh: "电池", en: "Battery", hant: "電池") }
        public static var network: String { tr(zh: "网络", en: "Network", hant: "網絡") }
        public static var tools: String { tr(zh: "工具", en: "Tools", hant: "工具") }
        public static var settings: String { tr(zh: "设置", en: "Settings", hant: "設定") }
    }

    // MARK: - Overview
    public enum Overview {
        public static var title: String { tr(zh: "看板", en: "Dashboard", hant: "看板") }
        public static var deviceIdentity: String { tr(zh: "设备信息", en: "Device Info", hant: "裝置資訊") }
        public static var model: String { tr(zh: "设备型号", en: "Model", hant: "裝置型號") }
        public static var chip: String { tr(zh: "处理器", en: "Processor", hant: "處理器") }
        public static var boardId: String { tr(zh: "主板", en: "Board ID", hant: "主機板") }
        public static var retailType: String { tr(zh: "销售类型", en: "Sales Type", hant: "銷售類型") }
        public static var retailOriginal: String { tr(zh: "零售机 (M)", en: "Retail (M)", hant: "零售機 (M)") }
        public static var retailReplacement: String { tr(zh: "官换机 (N)", en: "Replacement (N)", hant: "官換機 (N)") }
        public static var retailRefurbished: String { tr(zh: "官翻机 (F)", en: "Refurbished (F)", hant: "官翻機 (F)") }
        public static var retailDemo: String { tr(zh: "展示机 (3)", en: "Demo (3)", hant: "展示機 (3)") }
        public static var region: String { tr(zh: "销售地区", en: "Region", hant: "銷售地區") }

        // HUD & Status
        public static var hudStorageAvailable: String { tr(zh: "存储", en: "Disk", hant: "儲存") }
        public static var hudCoresSuffix: String { tr(zh: "核", en: "Cores", hant: "核") }
        public static var hudRamActive: String { tr(zh: "已用", en: "Active", hant: "已用") }
        public static var hudDiskFree: String { tr(zh: "可用", en: "Free", hant: "可用") }
        public static var live30s: String { tr(zh: "30s 实时刷新", en: "30s Rolling", hant: "30s 即時重新整理") }

        // Thermals & Temperatures
        public static var thermalNominal: String { tr(zh: "正常", en: "Nominal", hant: "正常") }
        public static var thermalFair: String { tr(zh: "温热", en: "Warm", hant: "溫熱") }
        public static var thermalSerious: String { tr(zh: "较热", en: "Throttling", hant: "較熱") }
        public static var thermalCritical: String { tr(zh: "过热", en: "Critical", hant: "過熱") }
        public static var thermalSectionTitle: String { tr(zh: "设备温度", en: "Thermals", hant: "裝置溫度") }
        public static var socTemp: String { tr(zh: "芯片结温", en: "SoC Core", hant: "晶片溫度") }
        public static var batteryTemp: String { tr(zh: "电芯温度", en: "Battery Cell", hant: "電芯溫度") }
        public static var thermalPressure: String { tr(zh: "温控状态", en: "Thermal State", hant: "溫控狀態") }
        public static var thermalOptimal: String { tr(zh: "正常 (未降频)", en: "Nominal", hant: "正常 (未降頻)") }

        // CPU & Charts
        public static var cpuMonitor: String { tr(zh: "CPU 监视器", en: "CPU Monitor", hant: "CPU 監視器") }
        public static var cpuHistoryChart: String { tr(zh: "实时利用率", en: "Usage Trend", hant: "即時利用率") }
        public static var cpuTotalUsage: String { tr(zh: "总利用率", en: "Total Usage", hant: "總利用率") }

        // Real-Time Network Bandwidth
        public static var networkTraffic: String { tr(zh: "实时网络", en: "Network Speed", hant: "即時網絡") }
        public static var downloadSpeed: String { tr(zh: "下行", en: "Download", hant: "下行") }
        public static var uploadSpeed: String { tr(zh: "上行", en: "Upload", hant: "上行") }
        public static var activeInterface: String { tr(zh: "当前网卡", en: "Interface", hant: "目前網卡") }
        public static var cellularRadio: String { tr(zh: "蜂窝网络", en: "Cellular", hant: "行動網絡") }

        // Memory & Storage
        public static var memory: String { tr(zh: "运行内存 (RAM)", en: "Memory (RAM)", hant: "記憶體 (RAM)") }
        public static var memoryActive: String { tr(zh: "活跃", en: "Active", hant: "活躍") }
        public static var memoryWired: String { tr(zh: "联动", en: "Wired", hant: "聯動") }
        public static var memoryCompressed: String { tr(zh: "压缩", en: "Compressed", hant: "壓縮") }
        public static var memoryFree: String { tr(zh: "空闲", en: "Free", hant: "閒置") }

        public static var storage: String { tr(zh: "存储空间", en: "Storage", hant: "儲存空間") }
        public static var storageUsed: String { tr(zh: "已用", en: "Used", hant: "已用") }
        public static var storageAvailable: String { tr(zh: "可用", en: "Available", hant: "可用") }
        public static var storagePurgeable: String { tr(zh: "可清除", en: "Purgeable", hant: "可清除") }
        public static var cleanPurged: String { tr(zh: "释放缓存", en: "Clean Cache", hant: "釋放快取") }
        public static var cleaningCache: String { tr(zh: "正在释放...", en: "Cleaning...", hant: "正在釋放...") }
        public static var sessionTotal: String { tr(zh: "会话累计", en: "Session", hant: "工作階段累計") }
        public static var uptime: String { tr(zh: "运行时间", en: "System Uptime", hant: "運行時間") }
        public static var bootTime: String { tr(zh: "开机时间", en: "Boot Time", hant: "開機時間") }
        public static func uptimeText(days: Int, hours: Int, minutes: Int) -> String {
            if days > 0 {
                return tr(
                    zh: "\(days) 天 \(hours) 小时 \(minutes) 分",
                    en: "\(days)d \(hours)h \(minutes)m",
                    hant: "\(days) 天 \(hours) 小時 \(minutes) 分"
                )
            } else if hours > 0 {
                return tr(
                    zh: "\(hours) 小时 \(minutes) 分",
                    en: "\(hours)h \(minutes)m",
                    hant: "\(hours) 小時 \(minutes) 分"
                )
            } else {
                return tr(
                    zh: "\(minutes) 分钟",
                    en: "\(minutes)m",
                    hant: "\(minutes) 分鐘"
                )
            }
        }

        // Hardware Categories
        public static var hardwareInventory: String { tr(zh: "硬件规格", en: "Hardware Specifications", hant: "硬體規格") }
        public static var catDisplay: String { tr(zh: "屏幕", en: "Display", hant: "螢幕") }
        public static var catSoC: String { tr(zh: "芯片", en: "SoC", hant: "晶片") }
        public static var catGPU: String { tr(zh: "图形", en: "GPU", hant: "圖形") }
        public static var catFeatures: String { tr(zh: "外设", en: "Features", hant: "外設") }
        public static var catSecurity: String { tr(zh: "安全", en: "Security", hant: "安全") }
        public static var catSystem: String { tr(zh: "系统", en: "System", hant: "系統") }

        // Display Specs
        public static var resolution: String { tr(zh: "分辨率", en: "Resolution", hant: "解析度") }
        public static var refreshRate: String { tr(zh: "刷新率", en: "Refresh Rate", hant: "更新率") }
        public static var refreshRate120: String { tr(zh: "120 Hz ProMotion", en: "120 Hz ProMotion", hant: "120 Hz ProMotion") }
        public static var refreshRate60: String { tr(zh: "60 Hz 标准", en: "60 Hz Standard", hant: "60 Hz 標準") }
        public static var ppiScale: String { tr(zh: "像素密度", en: "Pixel Density", hant: "像素密度") }
        public static var displayTech: String { tr(zh: "屏幕面板", en: "Display Panel", hant: "螢幕面板") }

        public static var displaySuperRetinaHD: String { tr(zh: "超视网膜 HD (OLED)", en: "Super Retina HD", hant: "超Retina HD") }
        public static var displaySuperRetinaXDROLED: String { tr(zh: "超视网膜 XDR (OLED)", en: "Super Retina XDR", hant: "超Retina XDR") }
        public static var displaySuperRetinaXDRProMotion: String { tr(zh: "超视网膜 XDR (ProMotion)", en: "Super Retina XDR", hant: "超Retina XDR") }
        public static var displayUltraRetinaXDR: String { tr(zh: "超精视网膜 XDR (双层 OLED)", en: "Ultra Retina XDR", hant: "超精Retina XDR") }
        public static var displayLiquidRetina: String { tr(zh: "Liquid 视网膜 (LCD)", en: "Liquid Retina", hant: "Liquid Retina") }
        public static var displayTechDefault: String { tr(zh: "视网膜显示屏", en: "Retina Display", hant: "Retina 顯示器") }

        // SoC Specs
        public static var processNode: String { tr(zh: "制造工艺", en: "Process Node", hant: "製造工藝") }
        public static var isaArch: String { tr(zh: "指令架构", en: "ISA Arch", hant: "指令架構") }
        public static var cacheSizes: String { tr(zh: "多级缓存", en: "Cache", hant: "快取") }
        public static var pageSize: String { tr(zh: "分页大小", en: "Page Size", hant: "分頁大小") }
        public static var pageSizeDetails: String { tr(zh: "16 KB", en: "16 KB", hant: "16 KB") }
        public static var cpuClusterLabel: String { tr(zh: "核心规格", en: "CPU Cores", hant: "核心規格") }
        public static func cpuClusterText(total: Int, p: Int, e: Int) -> String {
            tr(
                zh: "\(total) 核 (\(p)P + \(e)E)",
                en: "\(total) Cores (\(p)P + \(e)E)",
                hant: "\(total) 核心 (\(p)P + \(e)E)"
            )
        }

        // GPU & AI Specs
        public static var metalRenderer: String { tr(zh: "Metal 引擎", en: "Metal Engine", hant: "Metal 引擎") }
        public static var gpuCores: String { tr(zh: "GPU 核心", en: "GPU Cores", hant: "GPU 核心") }
        public static var metalFeatureSet: String { tr(zh: "Metal 特性", en: "Metal Feature", hant: "Metal 特性") }
        public static var raytracing: String { tr(zh: "光线追踪", en: "Ray Tracing", hant: "光線追蹤") }
        public static var rtSupported: String { tr(zh: "硬件支持", en: "Hardware Supported", hant: "硬體支援") }
        public static var rtNotSupported: String { tr(zh: "不支持", en: "Not Supported", hant: "不支援") }
        public static var meshShading: String { tr(zh: "网格着色", en: "Mesh Shaders", hant: "網格著色") }
        public static var msSupported: String { tr(zh: "支持 (Metal 3)", en: "Supported (Metal 3)", hant: "支援 (Metal 3)") }
        public static var msNotSupported: String { tr(zh: "不支持", en: "Not Supported", hant: "不支援") }
        public static var neuralEngine: String { tr(zh: "神经网络引擎", en: "Neural Engine", hant: "神經網絡引擎") }
        public static var aneA11: String { tr(zh: "2 核 (0.6 TOPS)", en: "2-Core (0.6 TOPS)", hant: "2 核 (0.6 TOPS)") }
        public static var aneA12: String { tr(zh: "8 核 (5.0 TOPS)", en: "8-Core (5.0 TOPS)", hant: "8 核 (5.0 TOPS)") }
        public static var aneA13: String { tr(zh: "8 核 (6.0 TOPS)", en: "8-Core (6.0 TOPS)", hant: "8 核 (6.0 TOPS)") }
        public static var aneA14: String { tr(zh: "16 核 (11 TOPS)", en: "16-Core (11 TOPS)", hant: "16 核 (11 TOPS)") }
        public static var aneA15: String { tr(zh: "16 核 (15.8 TOPS)", en: "16-Core (15.8 TOPS)", hant: "16 核 (15.8 TOPS)") }
        public static var aneA16: String { tr(zh: "16 核 (17 TOPS)", en: "16-Core (17 TOPS)", hant: "16 核 (17 TOPS)") }
        public static var aneA17Pro: String { tr(zh: "16 核 (35 TOPS)", en: "16-Core (35 TOPS)", hant: "16 核 (35 TOPS)") }
        public static var aneA18Plus: String { tr(zh: "16 核 (35+ TOPS)", en: "16-Core (35+ TOPS)", hant: "16 核 (35+ TOPS)") }
        public static var aneAppleSiliconM: String { tr(zh: "16 核 (16~38 TOPS)", en: "16-Core (16~38 TOPS)", hant: "16 核 (16~38 TOPS)") }
        public static var neuralEngineStandard: String { tr(zh: "Apple NPU", en: "Apple Neural Engine", hant: "Apple NPU") }

        // Security & Ports
        public static var biometrics: String { tr(zh: "生物识别", en: "Biometrics", hant: "生物辨識") }
        public static var faceIdTrueDepth: String { tr(zh: "Face ID (原深感)", en: "Face ID (TrueDepth)", hant: "Face ID (原深感)") }
        public static var touchIdText: String { tr(zh: "Touch ID", en: "Touch ID", hant: "Touch ID") }
        public static var passcodeText: String { tr(zh: "密码保护", en: "Passcode", hant: "密碼保護") }
        public static var lidarScanner: String { tr(zh: "激光雷达", en: "LiDAR Scanner", hant: "光學雷達") }
        public static var lidarEquipped: String { tr(zh: "配备 (dToF)", en: "Equipped (dToF)", hant: "配備 (dToF)") }
        public static var lidarNotEquipped: String { tr(zh: "未配备", en: "Not Equipped", hant: "未配備") }
        public static var secureEnclave: String { tr(zh: "安全芯片", en: "Secure Enclave", hant: "安全晶片") }
        public static var sepText: String { tr(zh: "SEP 硬件隔离", en: "SEP Isolated", hant: "SEP 硬體隔離") }
        public static var usbPortSpeed: String { tr(zh: "数据接口", en: "Data Port", hant: "數據介面") }
        public static var portUsbC10G: String { tr(zh: "USB-C 3.2 (10 Gbps)", en: "USB-C (10 Gbps)", hant: "USB-C (10 Gbps)") }
        public static var portUsbC480M: String { tr(zh: "USB-C (480 Mbps)", en: "USB-C (480 Mbps)", hant: "USB-C (480 Mbps)") }
        public static var portLightning: String { tr(zh: "Lightning (480 Mbps)", en: "Lightning (480 Mbps)", hant: "Lightning (480 Mbps)") }
        public static var darwinKernel: String { tr(zh: "系统内核", en: "Darwin Kernel", hant: "系統核心") }
    }

    // MARK: - Battery
    public enum Battery {
        public static var title: String { tr(zh: "电池", en: "Battery", hant: "電池") }
        public static var batteryStatus: String { tr(zh: "电池状态", en: "Battery Status", hant: "電池狀態") }
        public static var healthTitle: String { tr(zh: "电池健康", en: "Battery Health", hant: "電池健康") }
        public static var livePowerTitle: String { tr(zh: "实时功率", en: "Live Power", hant: "即時功率") }
        public static var cellSettingsTitle: String { tr(zh: "电芯校准", en: "Cell Calibration", hant: "電芯校準") }

        public static var health: String { tr(zh: "健康度", en: "Health", hant: "健康度") }
        public static var cycleCount: String { tr(zh: "循环次数", en: "Cycle Count", hant: "循環次數") }
        public static var cyclesUnit: String { tr(zh: "次", en: "Cycles", hant: "次") }
        public static var designCapacity: String { tr(zh: "设计容量", en: "Design Capacity", hant: "設計容量") }
        public static var currentMaxCapacity: String { tr(zh: "最大容量", en: "Max Capacity", hant: "最大容量") }
        public static var remainingEnergy: String { tr(zh: "剩余电量", en: "Remaining", hant: "剩餘電量") }

        public static var livePower: String { tr(zh: "当前功率", en: "Current Power", hant: "目前功率") }
        public static var voltage: String { tr(zh: "电压", en: "Voltage", hant: "電壓") }
        public static var current: String { tr(zh: "电流", en: "Current", hant: "電流") }
        public static var wattage: String { tr(zh: "实时瓦数", en: "Wattage", hant: "即時瓦數") }
        public static var chargerProtocol: String { tr(zh: "供电状态", en: "Power Mode", hant: "供電狀態") }
        public static var batteryTemp: String { tr(zh: "电芯温度", en: "Cell Temp", hant: "電芯溫度") }

        public static var chargingStatus: String { tr(zh: "充电工况", en: "Charging Status", hant: "充電工況") }
        public static var discharging: String { tr(zh: "正在放电", en: "Discharging", hant: "正在放電") }
        public static var charging: String { tr(zh: "正在充电", en: "Charging", hant: "正在充電") }
        public static var full: String { tr(zh: "已充满", en: "Fully Charged", hant: "已充滿") }
        public static var stateFull: String { tr(zh: "已充满", en: "Fully Charged", hant: "已充滿") }
        public static var fullyChargedText: String { tr(zh: "已充满 · 涓流维护", en: "Fully Charged · Maintenance", hant: "已充滿 · 涓流維護") }
        public static var reverseCharging: String { tr(zh: "反向供电", en: "Reverse Charging", hant: "反向供電") }
        public static var timeRemaining: String { tr(zh: "预计充满", en: "Time to Full", hant: "預計充滿") }

        public static func protocolFastPD(watt: Int) -> String {
            tr(zh: "USB-PD 快充 (\(watt)W)", en: "USB-PD Fast (\(watt)W)", hant: "USB-PD 快充 (\(watt)W)")
        }
        public static var protocolStandardPD: String { tr(zh: "USB-PD 快充", en: "USB-PD Fast", hant: "USB-PD 快充") }
        public static var protocolTrickle: String { tr(zh: "涓流养护", en: "Trickle Charge", hant: "涓流養護") }
        public static var protocolLowPower: String { tr(zh: "低电量模式", en: "Low Power Mode", hant: "低耗電模式") }
        public static var protocolDischarge: String { tr(zh: "电池供电", en: "On Battery", hant: "電池供電") }

        public static func etaToFull(mins: Int) -> String {
            tr(zh: "预计约 \(mins) 分钟充满", en: "Est. \(mins)m to Full", hant: "預計約 \(mins) 分鐘充滿")
        }
        public static func etaRemaining(h: Int, m: Int) -> String {
            tr(zh: "剩余约 \(h) 小时 \(m) 分", en: "Est. \(h)h \(m)m Left", hant: "剩餘約 \(h) 小時 \(m) 分")
        }

        public static var importLogButton: String {
            tr(zh: "导入官方分析日志 (解锁 BMS 真值)", en: "Import Analytics Log (BMS Raw)", hant: "匯入官方分析日誌 (解鎖 BMS 真值)")
        }
        public static var importedSuccess: String { tr(zh: "BMS 原厂真值已载入", en: "BMS Raw Active", hant: "BMS 原廠真值已載入") }
        public static var parsedDatePrefix: String { tr(zh: "记录日期", en: "Recorded", hant: "記錄日期") }
        public static var isCustomToggle: String { tr(zh: "第三方 / 超容电池", en: "Aftermarket Battery", hant: "第三方 / 超容電池") }
        public static var customCapacityLabel: String { tr(zh: "电芯标称容量", en: "Nominal Capacity", hant: "電芯標稱容量") }

        public static var healthTierNormal: String { tr(zh: "正常", en: "Normal", hant: "正常") }
        public static var healthTierAging: String { tr(zh: "损耗", en: "Degraded", hant: "損耗") }
        public static var healthTierService: String { tr(zh: "检修", en: "Service", hant: "檢修") }

        // Thermal Chassis Blueprint
        public static var thermalChassisTitle: String { tr(zh: "机身热力透视", en: "Thermal Blueprint", hant: "機身熱力透視") }
        public static var thermalChassisSubtitle: String { tr(zh: "硬件分区温敏遥测", en: "Chassis Hardware Telemetry", hant: "硬體分區溫敏遙測") }
        public static var zoneSoc: String { tr(zh: "SoC 核心主板", en: "SoC Motherboard", hant: "SoC 核心主機板") }
        public static var zoneBattery: String { tr(zh: "锂电芯主仓", en: "Battery Chamber", hant: "鋰電芯主倉") }
        public static var zonePmic: String { tr(zh: "快充供电模块", en: "PMIC & Charging", hant: "快充供電模組") }
        public static var zoneWireless: String { tr(zh: "磁吸无线线圈", en: "Wireless Coil", hant: "磁吸無線線圈") }
        public static var zoneSocShort: String { tr(zh: "SoC 主板", en: "SoC", hant: "SoC 主機板") }
        public static var zoneBatteryShort: String { tr(zh: "电芯主仓", en: "Battery", hant: "電芯主倉") }
        public static var zonePmicShort: String { tr(zh: "快充供电", en: "Charging", hant: "快充供電") }
        public static var zoneWirelessShort: String { tr(zh: "无线线圈", en: "Wireless", hant: "無線線圈") }
        public static var thermalStatusCool: String { tr(zh: "清凉", en: "Cool", hant: "清涼") }
        public static var thermalStatusNormal: String { tr(zh: "正常", en: "Normal", hant: "正常") }
        public static var thermalStatusWarm: String { tr(zh: "微热", en: "Warm", hant: "微熱") }
        public static var thermalStatusHot: String { tr(zh: "过热", en: "Hot", hant: "過熱") }
        public static var thermalTipSoc: String { tr(zh: "A 系列芯片与 GPU 运算主热源", en: "SoC & GPU core cluster, main heat source", hant: "A 系列晶片與 GPU 運算主熱源") }
        public static var thermalTipBattery: String { tr(zh: "电芯储能区域，石墨层均热分散", en: "Li-ion cell chamber, graphite dispersed", hant: "電芯儲能區域，石墨層均熱分散") }
        public static var thermalTipPmic: String { tr(zh: "快充降压供电芯片，充电时温升", en: "Step-down PMIC, warms during fast charge", hant: "快充降壓供電晶片，充電時溫升") }
        public static var thermalTipWireless: String { tr(zh: "MagSafe/Qi 磁吸线圈感应温区", en: "MagSafe/Qi inductive coil thermal zone", hant: "MagSafe/Qi 磁吸線圈感應溫區") }
        public static var thermalOverallState: String { tr(zh: "整机温控", en: "Thermal State", hant: "整機溫控") }
        public static var thermalThrottling: String { tr(zh: "降频", en: "Throttling", hant: "降頻") }
        public static var thermalShutdownProtection: String { tr(zh: "关机保护", en: "Shutdown Protection", hant: "關機保護") }

        // Degradation Curve Chart
        public static var degradationChartTitle: String { tr(zh: "容量衰减轨迹", en: "Degradation Trajectory", hant: "容量衰減軌跡") }
        public static var degradationChartSubtitle: String { tr(zh: "循环次数与容量保留趋势", en: "Cycles vs. Retention Trend", hant: "循環次數與容量保留趨勢") }
        public static var degradationActualCurve: String { tr(zh: "本机实际", en: "Actual", hant: "本機實際") }
        public static var degradationAppleBaseline: String { tr(zh: "官方基准", en: "Apple Baseline", hant: "官方基準") }
        public static var degradationServiceThreshold: String { tr(zh: "80% 检修线", en: "80% Service", hant: "80% 檢修線") }
        public static var degradationCycleAxis: String { tr(zh: "循环", en: "Cycles", hant: "循環") }
        public static var degradationHealthAxis: String { tr(zh: "健康度", en: "Health", hant: "健康度") }
        public static var degradationImportHint: String { tr(zh: "导入官方分析日志后解锁本机真实衰减点", en: "Import Analytics Log to plot actual degradation point", hant: "匯入官方分析日誌後解鎖本機真實衰減點") }
        public static var baselineAbove: String { tr(zh: "优于官方基线", en: "Above Baseline", hant: "優於官方基線") }
        public static var baselineBelow: String { tr(zh: "低于官方基线", en: "Below Baseline", hant: "低於官方基線") }
        public static var projectedFuture: String { tr(zh: "预期走势", en: "Projected", hant: "預期走勢") }

        // Longevity & Care
        public static var longevityTitle: String { tr(zh: "电芯寿命评估", en: "Battery Longevity", hant: "電芯壽命評估") }
        public static var cycleDegradationRate: String { tr(zh: "循环衰减率", en: "Cycle Loss Rate", hant: "循環衰減率") }
        public static var serviceThresholdMargin: String { tr(zh: "80% 检修余量", en: "Margin to 80%", hant: "80% 檢修餘量") }
        public static var cycleTierGolden: String { tr(zh: "极缓损耗 · 黄金期", en: "Optimal Health", hant: "極緩損耗 · 黃金期") }
        public static var cycleTierAging: String { tr(zh: "正常自然衰减", en: "Normal Aging", hant: "正常自然衰減") }
        public static var cycleTierDegraded: String { tr(zh: "建议关注容量", en: "Service Attention", hant: "建議關注容量") }
        public static var marginSafe: String { tr(zh: "安全余量充裕", en: "Safe Margin", hant: "安全餘量充裕") }
        public static var marginWarning: String { tr(zh: "临界预警范围", en: "Near Threshold", hant: "臨界預警範圍") }
        public static var marginCritical: String { tr(zh: "建议检修更换", en: "Service Required", hant: "建議檢修更換") }

        public static var careTipOptimalCharge: String { tr(zh: "浅充浅放 · 维持 20%–80% 区间，延缓电芯损耗", en: "Shallow Cycles · Keep 20%–80% to extend cell life", hant: "淺充淺放 · 維持 20%–80% 區間，延緩電芯損耗") }
        public static var careTipTemperature: String { tr(zh: "控温散热 · 快充时避免高温积热，摘除厚保护壳", en: "Thermal Control · Prevent heat build-up during fast charge", hant: "控溫散熱 · 快充時避免高溫積熱，摘除厚保護殼") }
        public static var careTipHighVoltage: String { tr(zh: "高压保护 · 长期插电使用推荐开启 80% 充电上限", en: "Voltage Limit · Enable 80% limit when plugged in long-term", hant: "高壓保護 · 長期插電使用推薦開啟 80% 充電上限") }
        public static var exportReportButton: String { tr(zh: "导出硬件诊断报告", en: "Export Hardware Report", hant: "匯出硬體診斷報告") }
        public static var reportCopied: String { tr(zh: "诊断报告已复制", en: "Report Copied", hant: "診斷報告已複製") }
        public static var diagnosticGrade: String { tr(zh: "健康综合评级", en: "Health Grade", hant: "健康綜合評級") }
        public static var gradeA: String { tr(zh: "A 级 · 优良", en: "Grade A · Optimal", hant: "A 級 · 優良") }
        public static var gradeB: String { tr(zh: "B 级 · 良好", en: "Grade B · Normal", hant: "B 級 · 良好") }
        public static var gradeC: String { tr(zh: "C 级 · 建议检修", en: "Grade C · Service", hant: "C 級 · 建議檢修") }

        // Professional Diagnostic Hardware Report
        public static var reportHeader: String { tr(zh: "OneDeck 官方电池硬件诊断报告 (BMS Raw)", en: "OneDeck Battery Hardware Diagnostic Report (BMS Raw)", hant: "OneDeck 官方電池硬體診斷報告 (BMS Raw)") }
        public static var reportDeviceModel: String { tr(zh: "设备型号", en: "Device Model", hant: "設備型號") }
        public static var reportChip: String { tr(zh: "核心处理器", en: "SoC Processor", hant: "核心處理器") }
        public static var reportFactoryDesignCap: String { tr(zh: "出厂设计容量", en: "Factory Capacity", hant: "出廠設計容量") }
        public static var reportEffectiveDesignCap: String { tr(zh: "有效标称容量", en: "Effective Capacity", hant: "有效標稱容量") }
        public static var reportActualMaxCap: String { tr(zh: "实际可用容量", en: "Actual Max Capacity", hant: "實際可用容量") }
        public static var reportCycleCount: String { tr(zh: "充放电循环", en: "Cycle Count", hant: "充放電循環") }
        public static var reportHealth: String { tr(zh: "电芯健康度", en: "Battery Health", hant: "電芯健康度") }
        public static var reportRemainingEnergy: String { tr(zh: "当前剩余电量", en: "Remaining Energy", hant: "目前剩餘電量") }
        public static var reportCellTemp: String { tr(zh: "电芯工作温度", en: "Cell Temperature", hant: "電芯工作溫度") }
        public static var reportPowerMode: String { tr(zh: "当前供电状态", en: "Power Mode", hant: "目前供電狀態") }
        public static var reportThermalState: String { tr(zh: "系统热敏等级", en: "Thermal State", hant: "系統熱敏等級") }
        public static var reportGeneratedTime: String { tr(zh: "报告生成时间", en: "Timestamp", hant: "報告產生時間") }
        public static var reportPendingCalibration: String { tr(zh: "待导入日志校准", en: "Pending Import", hant: "待匯入日誌校準") }

        public static var guideTitle: String { tr(zh: "获取官方电芯日志", en: "Analytics Log Guide", hant: "取得官方電芯日誌") }
        public static var guideStepsHeader: String { tr(zh: "操作步骤", en: "Instructions", hant: "操作步驟") }
        public static var guideStep1: String {
            tr(
                zh: "1. 打开【设置】 > 【隐私与安全性】 > 【分析与改进】",
                en: "1. Settings > Privacy & Security > Analytics & Improvements",
                hant: "1. 開啟【設定】 > 【隱私權與安全性】 > 【分析與改進】"
            )
        }
        public static var guideStep2: String {
            tr(
                zh: "2. 进入【分析数据】，找到最新 Analytics-*.ips 文件",
                en: "2. Analytics Data > find newest Analytics-*.ips",
                hant: "2. 進入【分析資料】，找到最新 Analytics-*.ips 檔案"
            )
        }
        public static var guideStep3: String {
            tr(
                zh: "3. 点击分享存储到“文件”，在此处导入即可",
                en: "3. Share to Files, then select here",
                hant: "3. 點擊分享儲存到「檔案」，在此處匯入即可"
            )
        }
        public static var selectFileButton: String { tr(zh: "选择分析日志文件 (.ips)", en: "Select Analytics File (.ips)", hant: "選取分析日誌檔案 (.ips)") }
        public static var pasteLogButton: String { tr(zh: "粘贴日志文本解析", en: "Paste Log Text", hant: "貼上日誌文字解析") }
        public static var pastePlaceholder: String { tr(zh: "在此粘贴含有 last_value_CycleCount 的日志文本片段...", en: "Paste text snippet containing CycleCount...", hant: "在此貼上含有 last_value_CycleCount 的日誌文字片段...") }
        public static var parseNow: String { tr(zh: "立即解析", en: "Parse Now", hant: "立即解析") }

        public static var bmsRaw: String { tr(zh: "BMS 原厂真值", en: "BMS Raw", hant: "BMS 原廠真值") }
        public static var estimated: String { tr(zh: "基准估算", en: "Estimated", hant: "基準估算") }
        public static var pendingImport: String { tr(zh: "需导入日志", en: "Import Required", hant: "需匯入日誌") }
        public static var pendingImportNotice: String { tr(zh: "未导入官方分析文件，需导入以解锁原厂真值", en: "Official log not imported. Import to reveal BMS raw values", hant: "未匯入官方分析檔案，需匯入以解鎖原廠真值") }
        public static var flirMode: String { tr(zh: "红外热像", en: "FLIR IR", hant: "紅外熱像") }
        public static var xrayMode: String { tr(zh: "透视蓝图", en: "X-Ray", hant: "透視藍圖") }
        public static var maxSpot: String { tr(zh: "极温", en: "MAX", hant: "極溫") }
        public static var minSpot: String { tr(zh: "低温", en: "MIN", hant: "低溫") }
        public static var effectiveCap: String { tr(zh: "有效容量", en: "Effective", hant: "有效容量") }
        public static var customCalibrated: String { tr(zh: "超容校准", en: "Calibrated", hant: "超容校準") }
        public static var oemNominal: String { tr(zh: "原厂标称", en: "OEM", hant: "原廠標稱") }
        public static var highCap: String { tr(zh: "高容 (+12%)", en: "High (+12%)", hant: "高容 (+12%)") }
        public static var superCap: String { tr(zh: "超容 (+22%)", en: "Super (+22%)", hant: "超容 (+22%)") }
        public static var calibrateDesc: String { tr(zh: "校准第三方电芯容量与续航估算", en: "Calibrate cell capacity & battery life", hant: "校準第三方電芯容量與續航估算") }
        public static var chargeWaveform: String { tr(zh: "充电功率曲线", en: "Charging Curve", hant: "充電功率曲線") }
        public static var dischargeWaveform: String { tr(zh: "放电功率曲线", en: "Discharging Curve", hant: "放電功率曲線") }
        public static var orPasteSnippet: String { tr(zh: "或粘贴日志文本", en: "Or Paste Text", hant: "或貼上日誌文字") }
        public static var clearRecord: String { tr(zh: "清除记录", en: "Reset Data", hant: "清除記錄") }
        public static var errLogDecoding: String { tr(zh: "无法解码日志文件编码", en: "Unable to decode log file", hant: "無法解碼日誌檔案編碼") }
        public static var errCycleNotFound: String { tr(zh: "未在日志中找到电池循环次数 (last_value_CycleCount)", en: "Cycle count (last_value_CycleCount) not found in log", hant: "未在日誌中找到電池循環次數 (last_value_CycleCount)") }
    }

    // MARK: - Network
    public enum Network {
        public static var title: String { tr(zh: "网络", en: "Network", hant: "網絡") }
        public static var linkStatusTitle: String { tr(zh: "网络链路", en: "Network Link", hant: "網絡鏈路") }
        public static var connected: String { tr(zh: "已连接", en: "Connected", hant: "已連線") }
        public static var disconnected: String { tr(zh: "未连接", en: "Disconnected", hant: "未連線") }
        public static var interfaceType: String { tr(zh: "链路制式", en: "Link Type", hant: "鏈路制式") }
        public static var wifi: String { tr(zh: "Wi-Fi", en: "Wi-Fi", hant: "Wi-Fi") }
        public static var cellular: String { tr(zh: "蜂窝移动网络", en: "Cellular", hant: "行動網絡") }
        public static var wired: String { tr(zh: "有线以太网", en: "Ethernet", hant: "有線乙太網") }
        public static var hotspot: String { tr(zh: "个人热点", en: "Hotspot", hant: "個人熱點") }

        public static var localIP: String { tr(zh: "局域网 IP", en: "Local IP", hant: "區域網絡 IP") }
        public static var subnetMask: String { tr(zh: "子网掩码", en: "Subnet Mask", hant: "子網遮罩") }
        public static var gateway: String { tr(zh: "默认网关", en: "Gateway", hant: "預設閘道") }
        public static var gatewayShort: String { tr(zh: "网关", en: "Gateway", hant: "閘道") }
        public static var broadcastIP: String { tr(zh: "广播地址", en: "Broadcast", hant: "廣播位址") }
        public static var dnsServer: String { tr(zh: "DNS 服务器", en: "DNS Server", hant: "DNS 伺服器") }

        public static var trafficTitle: String { tr(zh: "实时流量", en: "Traffic", hant: "即時流量") }
        public static var downloadSpeed: String { tr(zh: "下行速率", en: "Download", hant: "下行速率") }
        public static var uploadSpeed: String { tr(zh: "上行速率", en: "Upload", hant: "上行速率") }
        public static var totalIn: String { tr(zh: "入站总量", en: "Total In", hant: "入站總量") }
        public static var totalOut: String { tr(zh: "出站总量", en: "Total Out", hant: "出站總量") }

        public static var latencyTitle: String { tr(zh: "网络延迟", en: "Latency", hant: "網絡延遲") }
        public static var latency: String { tr(zh: "网络延迟", en: "Latency", hant: "網絡延遲") }
        public static var latencyLive: String { tr(zh: "实时探测", en: "Live", hant: "即時探測") }
        public static var latencyBenchmark: String { tr(zh: "DNS 基准", en: "DNS", hant: "DNS 基準") }
        public static var pingTarget: String { tr(zh: "探测节点", en: "Target Node", hant: "探測節點") }
        public static var jitter: String { tr(zh: "抖动", en: "Jitter", hant: "抖動") }
        public static var packetLoss: String { tr(zh: "丢包", en: "Loss", hant: "丟包") }
        public static var qualityOptimal: String { tr(zh: "极佳 (<25ms)", en: "Optimal (<25ms)", hant: "極佳 (<25ms)") }
        public static var qualityGood: String { tr(zh: "良好 (<60ms)", en: "Good (<60ms)", hant: "良好 (<60ms)") }
        public static var qualityFair: String { tr(zh: "一般 (<120ms)", en: "Fair (<120ms)", hant: "一般 (<120ms)") }
        public static var qualityPoor: String { tr(zh: "拥塞 (≥120ms)", en: "Poor (≥120ms)", hant: "擁塞 (≥120ms)") }
        public static var msSuffix: String { tr(zh: "毫秒", en: "ms", hant: "毫秒") }

        public static var publicIPTitle: String { tr(zh: "公网出口", en: "Public IP", hant: "公網出口") }
        public static var publicIP: String { tr(zh: "公网 IP", en: "Public IP", hant: "公網 IP") }
        public static var carrierIsp: String { tr(zh: "运营商 / ASN", en: "ISP & ASN", hant: "電信業者 / ASN") }
        public static var geoCity: String { tr(zh: "地理位置", en: "Location", hant: "地理位置") }
        public static var refreshGeoIP: String { tr(zh: "刷新", en: "Refresh", hant: "重新整理") }
        public static var refresh: String { tr(zh: "刷新", en: "Refresh", hant: "重新整理") }
        public static var querying: String { tr(zh: "查询中...", en: "Querying...", hant: "查詢中...") }
        public static var proxyExit: String { tr(zh: "代理出口", en: "Proxy Exit", hant: "代理出口") }

        public static var lanScanTitle: String { tr(zh: "局域网发现", en: "LAN Discovery", hant: "區域網絡發現") }
        public static var startScan: String { tr(zh: "发现设备", en: "Discover", hant: "發現設備") }
        public static var scanning: String { tr(zh: "扫描中...", en: "Scanning...", hant: "掃描中...") }
        public static var scanComplete: String { tr(zh: "扫描完成", en: "Complete", hant: "掃描完成") }
        public static func devicesCountText(count: Int) -> String {
            tr(zh: "已发现 \(count) 台设备", en: "\(count) Devices", hant: "已發現 \(count) 台設備")
        }

        public static var wolTitle: String { tr(zh: "网络唤醒", en: "Wake-on-LAN", hant: "網絡喚醒") }
        public static var wolPortBadge: String { tr(zh: "UDP · 端口 9", en: "UDP · Port 9", hant: "UDP · 埠 9") }
        public static var macAddress: String { tr(zh: "目标 MAC 地址", en: "Target MAC Address", hant: "目標 MAC 位址") }
        public static var sendWol: String { tr(zh: "发送唤醒包", en: "Send Packet", hant: "發送喚醒包") }
        public static var wolSuccess: String { tr(zh: "魔术包已广播至局域网", en: "Magic Packet Broadcasted", hant: "魔術包已廣播至區域網絡") }
        public static var wolInvalidMac: String { tr(zh: "请输入有效 12 位 MAC 地址", en: "Invalid 12-digit MAC", hant: "請輸入有效 12 位 MAC 位址") }
        public static var wolDesc: String { tr(zh: "广播 102 字节魔术包", en: "102-byte Magic Packet", hant: "廣播 102 位元組魔術包") }
        public static var presets: String { tr(zh: "快捷预设", en: "Presets", hant: "快捷預設") }
        public static var presetNas: String { tr(zh: "NAS 主机", en: "NAS Server", hant: "NAS 主機") }
        public static var presetWorkstation: String { tr(zh: "工作站 PC", en: "Workstation", hant: "工作站 PC") }
        public static var presetMedia: String { tr(zh: "家庭影音", en: "Home Theater", hant: "家庭影音") }
        public static var copied: String { tr(zh: "已复制", en: "Copied", hant: "已複製") }
        public static var expensiveCellular: String { tr(zh: "计费网络", en: "Metered", hant: "計費網絡") }
        public static var lowDataMode: String { tr(zh: "低数据模式", en: "Low Data", hant: "低數據模式") }
        public static var noLanDevices: String { tr(zh: "未发现活动 Bonjour 服务", en: "No Bonjour Services Found", hant: "未發現活動 Bonjour 服務") }
        public static var noLanDevicesHint: String { tr(zh: "请确认同局域网设备已开启共享服务", en: "Check local devices have sharing enabled", hant: "請確認同區域網絡設備已開啟共享服務") }
        public static var lanScanDesc: String { tr(zh: "自动发现本地 mDNS 设备", en: "Auto-discover local mDNS devices", hant: "自動發現本地 mDNS 設備") }

        // Hardware interface specs
        public static var mtu: String { tr(zh: "最大传输单元", en: "MTU", hant: "最大傳輸單元") }
        public static var linkSpeed: String { tr(zh: "协商速率", en: "Link Speed", hant: "協商速率") }
        public static var subnetRange: String { tr(zh: "网段", en: "Subnet", hant: "網段") }

        // Multi-Node DNS Benchmark
        public static var dnsBenchmarkTitle: String { tr(zh: "DNS 延迟基准", en: "DNS Benchmark", hant: "DNS 延遲基準") }
        public static var dnsBenchmarkDesc: String { tr(zh: "并发探测主流公共 DNS 解析延迟", en: "Benchmark public DNS latency", hant: "並發探測主流公共 DNS 解析延遲") }
        public static var runBenchmark: String { tr(zh: "并发测速", en: "Benchmark", hant: "並發測速") }
        public static var fastestNode: String { tr(zh: "最优线路", en: "Fastest", hant: "最優線路") }

        // Port Scanner
        public static var portScanTitle: String { tr(zh: "端口扫描", en: "Port Scanner", hant: "埠掃描") }
        public static var portScanDesc: String { tr(zh: "探测主机常用服务端口", en: "Scan common service ports", hant: "探測主機常用服務埠") }
        public static var checkPorts: String { tr(zh: "扫描端口", en: "Scan Ports", hant: "掃描埠") }
        public static var portOpen: String { tr(zh: "开放", en: "Open", hant: "開放") }
        public static var portClosed: String { tr(zh: "关闭", en: "Closed", hant: "關閉") }
        public static var targetHost: String { tr(zh: "目标主机", en: "Target Host", hant: "目標主機") }

        // DNS Lookup & Dig
        public static var dnsLookupTitle: String { tr(zh: "域名解析", en: "DNS Lookup", hant: "網域名稱解析") }
        public static var dnsPortBadge: String { tr(zh: "POSIX · 端口 53", en: "POSIX · Port 53", hant: "POSIX · 埠 53") }
        public static var dnsRecordA: String { tr(zh: "A 记录 (IPv4)", en: "A Record (IPv4)", hant: "A 記錄 (IPv4)") }
        public static var dnsRecordAaaa: String { tr(zh: "AAAA 记录 (IPv6)", en: "AAAA Record (IPv6)", hant: "AAAA 記錄 (IPv6)") }
        public static var dnsLookupDesc: String { tr(zh: "POSIX 原生解析 A / AAAA 记录", en: "POSIX A / AAAA lookup", hant: "POSIX 原生解析 A / AAAA 記錄") }
        public static var domainInputPlaceholder: String { tr(zh: "输入域名 (如 apple.com)", en: "Domain (e.g. apple.com)", hant: "輸入網域名稱 (如 apple.com)") }
        public static var resolveDomain: String { tr(zh: "解析", en: "Resolve", hant: "解析") }
        public static var queryTime: String { tr(zh: "解析耗时", en: "Query Time", hant: "解析耗時") }

        // Active Speed Test
        public static var speedTestTitle: String { tr(zh: "带宽测速", en: "Speed Test", hant: "頻寬測速") }
        public static var startSpeedTest: String { tr(zh: "开始测速", en: "Start Test", hant: "開始測速") }
        public static var peakSpeed: String { tr(zh: "峰值带宽", en: "Peak", hant: "峰值頻寬") }
        public static func peakSpeedFormatted(mbps: Double) -> String {
            tr(zh: "峰值 \(String(format: "%.1f", mbps)) Mbps", en: "Peak \(String(format: "%.1f", mbps)) Mbps", hant: "峰值 \(String(format: "%.1f", mbps)) Mbps")
        }
        public static var avgSpeed: String { tr(zh: "平均速率", en: "Average", hant: "平均速率") }
        public static var speedTesting: String { tr(zh: "测速中...", en: "Testing...", hant: "測速中...") }
        public static var speedStagePing: String { tr(zh: "探测延迟...", en: "Probing Ping...", hant: "探測延遲...") }
        public static var speedStageDownload: String { tr(zh: "下行测速...", en: "Testing Download...", hant: "下行測速...") }
        public static var speedStageUpload: String { tr(zh: "上行测速...", en: "Testing Upload...", hant: "上行測速...") }
        public static var speedStageCompleted: String { tr(zh: "测速完成", en: "Completed", hant: "測速完成") }
        public static var speedTestRestart: String { tr(zh: "重新测速", en: "Retest", hant: "重新測速") }
        public static var speedTestStop: String { tr(zh: "停止测速", en: "Stop", hant: "停止測速") }
        public static var speedRating: String { tr(zh: "网络评级", en: "Rating", hant: "網絡評級") }
        public static func speedTestRatingText(for downMbps: Double) -> String {
            if downMbps >= 300.0 {
                return tr(zh: "S · 极速千兆", en: "S · Gigabit Ultra", hant: "S · 極速千兆")
            } else if downMbps >= 100.0 {
                return tr(zh: "A+ · 卓越极速", en: "A+ · Excellent", hant: "A+ · 卓越極速")
            } else if downMbps >= 50.0 {
                return tr(zh: "A · 高速优质", en: "A · High Speed", hant: "A · 高速優質")
            } else if downMbps >= 20.0 {
                return tr(zh: "B · 良好流畅", en: "B · Good", hant: "B · 良好流暢")
            } else {
                return tr(zh: "C · 基础网络", en: "C · Basic", hant: "C · 基礎網絡")
            }
        }
        public static var serverNode: String { tr(zh: "测试节点", en: "Server Node", hant: "測試節點") }
        public static var cellularGen: String { tr(zh: "网络制式", en: "Cellular Standard", hant: "網絡制式") }
        public static var carrier: String { tr(zh: "运营商", en: "Carrier", hant: "電信業者") }
        public static var wifiGen: String { tr(zh: "Wi-Fi 规格", en: "Wi-Fi Spec", hant: "Wi-Fi 規格") }
        public static var speedReady: String { tr(zh: "待测速", en: "Ready", hant: "待測速") }
        public static var collapse: String { tr(zh: "收起", en: "Collapse", hant: "收起") }
        public static var expandDetails: String { tr(zh: "详情", en: "Details", hant: "詳情") }
        public static var clearResults: String { tr(zh: "清除", en: "Clear", hant: "清除") }
        public static var lastSpeedTest: String { tr(zh: "上次测速", en: "Last Test", hant: "上次測速") }
        public static var speedTestHistory: String { tr(zh: "测速历史", en: "Test History", hant: "測速歷史") }
        public static var clearHistory: String { tr(zh: "清空", en: "Clear", hant: "清空") }
        public static var noSpeedTestHistory: String { tr(zh: "暂无测速记录", en: "No Records", hant: "暫無測速記錄") }
    }

    // MARK: - Tools
    public enum Tools {
        public static var title: String { tr(zh: "工具箱", en: "Tools", hant: "工具箱") }
        public static var spiritLevel: String { tr(zh: "水平仪", en: "Spirit Level", hant: "水平儀") }
        public static var spiritLevelSub: String { tr(zh: "双轴倾角测量", en: "Dual-axis Inclinometer", hant: "雙軸傾角測量") }
        public static var screenRuler: String { tr(zh: "屏幕卡尺", en: "Screen Caliper", hant: "螢幕卡尺") }
        public static var screenRulerSub: String { tr(zh: "基于原生 PPI 物理换算", en: "Native PPI Physical Scale", hant: "基於原生 PPI 物理換算") }
        public static var waterEjector: String { tr(zh: "声波排水", en: "Sonic Water Ejector", hant: "聲波排水") }
        public static var waterEjectorSub: String { tr(zh: "165Hz 共振声波清理", en: "165Hz Acoustic Clear", hant: "165Hz 共振聲波清理") }
        public static var decibelMeter: String { tr(zh: "分贝计", en: "Decibel Meter", hant: "分貝計") }
        public static var toneGenerator: String { tr(zh: "音频发生器", en: "Tone Generator", hant: "音訊發生器") }
        public static var torchLab: String { tr(zh: "精细手电筒", en: "Precision Torch", hant: "精細手電筒") }
        public static var touchMatrix: String { tr(zh: "触控测试", en: "Touch Matrix Test", hant: "觸控測試") }
    }

    // MARK: - Settings
    public enum Settings {
        public static var title: String { tr(zh: "设置", en: "Settings", hant: "設定") }
        public static var appearanceSection: String { tr(zh: "外观", en: "Appearance", hant: "外觀") }
        public static var appearanceMode: String { tr(zh: "模式", en: "Theme Mode", hant: "模式") }
        public static var modeDark: String { tr(zh: "深色", en: "Dark", hant: "深色") }
        public static var modeLight: String { tr(zh: "浅色", en: "Light", hant: "淺色") }
        public static var modeSystem: String { tr(zh: "跟随系统", en: "System", hant: "跟隨系統") }

        public static var themeColor: String { tr(zh: "强调色", en: "Accent Color", hant: "強調色") }
        public static var customPalette: String { tr(zh: "调色板", en: "Custom Palette", hant: "調色盤") }
        public static var hexCode: String { tr(zh: "HEX 色值", en: "HEX Color", hant: "HEX 色值") }
        public static var presets: String { tr(zh: "预设主题", en: "Curated Presets", hant: "預設主題") }

        public static var languageSection: String { tr(zh: "语言", en: "Language", hant: "語言") }
        public static var langSystem: String { tr(zh: "跟随系统", en: "System Default", hant: "跟隨系統") }

        public static var signingSection: String { tr(zh: "证书与签名", en: "Provisioning", hant: "憑證與簽名") }
        public static var certExpiry: String { tr(zh: "证书有效期", en: "Certificate Countdown", hant: "憑證有效期") }
        public static func certDaysHours(days: Int, hours: Int) -> String {
            tr(zh: "\(days) 天 \(hours) 小时", en: "\(days)d \(hours)h Left", hant: "\(days) 天 \(hours) 小時")
        }
        public static var sevenDaysCountdown: String { tr(zh: "7 天掉签倒计时", en: "7-Day Timer", hant: "7 天倒數") }

        public static var sysPrefsSection: String { tr(zh: "系统设置快捷直达", en: "System Shortcuts", hant: "系統設定快捷直達") }
        public static var prefWifi: String { tr(zh: "Wi-Fi", en: "Wi-Fi", hant: "Wi-Fi") }
        public static var prefBluetooth: String { tr(zh: "蓝牙", en: "Bluetooth", hant: "藍牙") }
        public static var prefBattery: String { tr(zh: "电池健康", en: "Battery Health", hant: "電池健康") }
        public static var prefVpn: String { tr(zh: "VPN", en: "VPN", hant: "VPN") }
        public static var prefHotspot: String { tr(zh: "个人热点", en: "Personal Hotspot", hant: "個人熱點") }
        public static var prefGeneralUpdate: String { tr(zh: "软件更新", en: "Software Update", hant: "軟體更新") }

        public static var aboutSection: String { tr(zh: "关于", en: "About", hant: "關於") }
        public static var version: String { tr(zh: "版本", en: "Version", hant: "版本") }
        public static var openSourceRepo: String { tr(zh: "开源仓库", en: "Repository", hant: "開原始碼") }
    }
}
