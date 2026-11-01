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

    private static var isChinese: Bool {
        switch currentLanguage {
        case .zhHans:
            return true
        case .zhHant:
            return false
        case .en:
            return false
        case .system:
            let preferred = Locale.preferredLanguages.first ?? "en"
            return preferred.hasPrefix("zh-Hans") || preferred.hasPrefix("zh-CN")
        }
    }

    private static var isTraditionalChinese: Bool {
        switch currentLanguage {
        case .zhHant:
            return true
        case .system:
            let preferred = Locale.preferredLanguages.first ?? "en"
            return preferred.hasPrefix("zh-Hant") || preferred.hasPrefix("zh-HK") || preferred.hasPrefix("zh-TW")
        default:
            return false
        }
    }

    public static func tr(zh: String, en: String, hant: String? = nil) -> String {
        if isChinese {
            return zh
        } else if isTraditionalChinese {
            return hant ?? zh
        } else {
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
        public static var title: String { tr(zh: "设备看板", en: "Dashboard", hant: "裝置看板") }
        public static var deviceIdentity: String { tr(zh: "设备身份证", en: "Device Identity", hant: "裝置身份") }
        public static var model: String { tr(zh: "设备型号", en: "Model", hant: "裝置型號") }
        public static var chip: String { tr(zh: "芯片架构", en: "Processor", hant: "晶片架構") }
        public static var boardId: String { tr(zh: "主板代号", en: "Board ID", hant: "主機板代號") }
        public static var retailType: String { tr(zh: "销售类型", en: "Sales Type", hant: "銷售類型") }
        public static var retailOriginal: String { tr(zh: "原装零售 (M)", en: "Retail (M)", hant: "原裝零售 (M)") }
        public static var retailReplacement: String { tr(zh: "官换机 (N)", en: "Replacement (N)", hant: "官換機 (N)") }
        public static var retailRefurbished: String { tr(zh: "官方翻新 (F)", en: "Refurbished (F)", hant: "官方翻新 (F)") }
        public static var retailDemo: String { tr(zh: "展示机 (3)", en: "Demo (3)", hant: "展示機 (3)") }
        public static var region: String { tr(zh: "销售区域", en: "Region", hant: "銷售區域") }

        // HUD & Status
        public static var hudStorageAvailable: String { tr(zh: "存储", en: "Disk", hant: "儲存") }
        public static var hudCoresSuffix: String { tr(zh: "核", en: "Cores", hant: "核") }
        public static var hudRamActive: String { tr(zh: "已用", en: "Active", hant: "已用") }
        public static var hudDiskFree: String { tr(zh: "可用", en: "Free", hant: "可用") }
        public static var live30s: String { tr(zh: "30s 实时刷新", en: "30s Rolling", hant: "30s 即時重新整理") }

        // Thermals & Temperatures
        public static var thermalNominal: String { tr(zh: "温控良好", en: "Nominal", hant: "溫控良好") }
        public static var thermalFair: String { tr(zh: "轻微温热", en: "Warm", hant: "輕微溫熱") }
        public static var thermalSerious: String { tr(zh: "机身发热", en: "Throttling", hant: "機身發熱") }
        public static var thermalCritical: String { tr(zh: "严重高温", en: "Critical Heat", hant: "嚴重高溫") }
        public static var thermalSectionTitle: String { tr(zh: "设备温度与热负荷", en: "Thermals & Heat Load", hant: "裝置溫度與熱負載") }
        public static var socTemp: String { tr(zh: "SoC 芯片结温", en: "SoC Core", hant: "SoC 晶片溫度") }
        public static var batteryTemp: String { tr(zh: "电池电芯温度", en: "Battery Cell", hant: "電池電芯溫度") }
        public static var thermalPressure: String { tr(zh: "温控节流压力", en: "Thermal Pressure", hant: "溫控節流壓力") }
        public static var thermalOptimal: String { tr(zh: "全速无降频", en: "Full Speed (No Throttling)", hant: "全速無降頻") }

        // CPU & Charts
        public static var cpuMonitor: String { tr(zh: "CPU 多核监视器", en: "CPU Monitor", hant: "CPU 多核監視器") }
        public static var cpuHistoryChart: String { tr(zh: "实时利用率折线图", en: "Real-time Trend", hant: "即時利用率折線圖") }
        public static var cpuTotalUsage: String { tr(zh: "总体利用率", en: "Total Usage", hant: "總體利用率") }

        // Real-Time Network Bandwidth
        public static var networkTraffic: String { tr(zh: "实时网络速率", en: "Network Speed", hant: "即時網絡速率") }
        public static var downloadSpeed: String { tr(zh: "下行速率", en: "Download", hant: "下載速率") }
        public static var uploadSpeed: String { tr(zh: "上行速率", en: "Upload", hant: "上傳速率") }
        public static var activeInterface: String { tr(zh: "活跃接口", en: "Interface", hant: "活躍介面") }
        public static var cellularRadio: String { tr(zh: "5G / 蜂窝移动", en: "Cellular / 5G", hant: "5G / 行動網絡") }

        // Memory & Storage
        public static var memory: String { tr(zh: "物理内存 (RAM)", en: "Memory (RAM)", hant: "實體記憶體 (RAM)") }
        public static var memoryActive: String { tr(zh: "活跃", en: "Active", hant: "活躍") }
        public static var memoryWired: String { tr(zh: "联动常驻", en: "Wired", hant: "常駐") }
        public static var memoryCompressed: String { tr(zh: "已压缩", en: "Compressed", hant: "已壓縮") }
        public static var memoryFree: String { tr(zh: "空闲", en: "Free", hant: "閒置") }

        public static var storage: String { tr(zh: "存储空间", en: "Storage", hant: "儲存空間") }
        public static var storageUsed: String { tr(zh: "已用容量", en: "Used", hant: "已用容量") }
        public static var storageAvailable: String { tr(zh: "可用容量", en: "Available", hant: "可用容量") }
        public static var storagePurgeable: String { tr(zh: "可清除缓存", en: "Purgeable", hant: "可清除快取") }
        public static var cleanPurged: String { tr(zh: "清理系统缓存", en: "Clean Cache", hant: "清理系統快取") }
        public static var cleaningCache: String { tr(zh: "正在释放缓存...", en: "Cleaning Cache...", hant: "正在釋放快取...") }
        public static var sessionTotal: String { tr(zh: "会话累计", en: "Session", hant: "工作階段累計") }
        public static var uptime: String { tr(zh: "持续开机时间", en: "System Uptime", hant: "持續開機時間") }

        // Hardware Categories
        public static var hardwareInventory: String { tr(zh: "全景硬件规格清单", en: "Hardware Specifications", hant: "全景硬體規格清單") }
        public static var catDisplay: String { tr(zh: "屏幕", en: "Display", hant: "螢幕") }
        public static var catSoC: String { tr(zh: "芯片", en: "SoC", hant: "晶片") }
        public static var catGPU: String { tr(zh: "图形", en: "GPU", hant: "圖形") }
        public static var catFeatures: String { tr(zh: "外设特性", en: "Features", hant: "外設特性") }
        public static var catSecurity: String { tr(zh: "外设特性", en: "Features", hant: "外設特性") }

        // Display Specs
        public static var resolution: String { tr(zh: "物理分辨率", en: "Resolution", hant: "實體解析度") }
        public static var refreshRate: String { tr(zh: "屏幕刷新率", en: "Refresh Rate", hant: "螢幕更新率") }
        public static var refreshRate120: String { tr(zh: "120 Hz (ProMotion)", en: "120 Hz ProMotion", hant: "120 Hz (ProMotion)") }
        public static var refreshRate60: String { tr(zh: "60 Hz (标准刷新)", en: "60 Hz Standard", hant: "60 Hz (標準更新)") }
        public static var ppiScale: String { tr(zh: "像素密度与比例", en: "Pixel Density", hant: "像素密度與比例") }
        public static var displayTech: String { tr(zh: "面板与色彩技术", en: "Display Panel", hant: "面板與色彩技術") }

        public static var displaySuperRetinaHD: String { tr(zh: "超视网膜 HD (OLED)", en: "Super Retina HD (OLED)", hant: "超Retina HD (OLED)") }
        public static var displaySuperRetinaXDROLED: String { tr(zh: "超视网膜 XDR (OLED)", en: "Super Retina XDR (OLED)", hant: "超Retina XDR (OLED)") }
        public static var displaySuperRetinaXDRProMotion: String { tr(zh: "超视网膜 XDR (ProMotion)", en: "Super Retina XDR (ProMotion)", hant: "超Retina XDR (ProMotion)") }
        public static var displayUltraRetinaXDR: String { tr(zh: "超精视网膜 XDR (双层 OLED)", en: "Ultra Retina XDR (Tandem OLED)", hant: "超精Retina XDR (雙層 OLED)") }
        public static var displayLiquidRetina: String { tr(zh: "Liquid 视网膜 (LCD)", en: "Liquid Retina (LCD)", hant: "Liquid Retina (LCD)") }
        public static var displayTechDefault: String { tr(zh: "Retina 视网膜", en: "Retina Display", hant: "Retina 顯示器") }

        // SoC Specs
        public static var processNode: String { tr(zh: "半导体制程", en: "Process Node", hant: "半導體製程") }
        public static var isaArch: String { tr(zh: "指令集架构", en: "ISA Architecture", hant: "指令集架構") }
        public static var cacheSizes: String { tr(zh: "片上多级缓存", en: "On-Chip Cache", hant: "晶片多級快取") }
        public static var pageSize: String { tr(zh: "内核分页大小", en: "Kernel Page Size", hant: "核心分頁大小") }
        public static var pageSizeDetails: String { tr(zh: "16 KB (ARM64 标准物理页)", en: "16 KB (ARM64 Standard)", hant: "16 KB (ARM64 標準物理頁)") }
        public static var cpuClusterLabel: String { tr(zh: "CPU 核心架构", en: "CPU Cores", hant: "CPU 核心架構") }
        public static func cpuClusterText(total: Int, p: Int, e: Int) -> String {
            tr(
                zh: "\(total) 核 (\(p) 性能核 + \(e) 能效核)",
                en: "\(total) Cores (\(p)P + \(e)E)",
                hant: "\(total) 核心 (\(p) 效能 + \(e) 節能)"
            )
        }

        // GPU & AI Specs
        public static var metalRenderer: String { tr(zh: "Metal 图形引擎", en: "Metal Engine", hant: "Metal 圖形引擎") }
        public static var gpuCores: String { tr(zh: "GPU 核心规模", en: "GPU Cores", hant: "GPU 核心架構") }
        public static var metalFeatureSet: String { tr(zh: "Metal 架构特性", en: "Metal Feature", hant: "Metal 架構特性") }
        public static var raytracing: String { tr(zh: "硬件加速光追", en: "Ray Tracing", hant: "硬體光線追蹤") }
        public static var rtSupported: String { tr(zh: "支持 (硬件加速光追)", en: "Hardware-Accelerated", hant: "支援 (硬體光線追蹤)") }
        public static var rtNotSupported: String { tr(zh: "不支持 (A17 Pro+ 专属)", en: "Not Supported (A17 Pro+)", hant: "不支援 (A17 Pro+ 專屬)") }
        public static var meshShading: String { tr(zh: "网格着色技术", en: "Mesh Shaders", hant: "網格著色技術") }
        public static var msSupported: String { tr(zh: "支持 (Metal 3 几何管线)", en: "Supported (Metal 3)", hant: "支援 (Metal 3 幾何管線)") }
        public static var msNotSupported: String { tr(zh: "不支持", en: "Not Supported", hant: "不支援") }
        public static var neuralEngine: String { tr(zh: "神经网络引擎", en: "Neural Engine", hant: "神經網絡引擎") }
        public static var aneA11: String { tr(zh: "2 核 ANE (0.6 TOPS)", en: "2-Core ANE (0.6 TOPS)", hant: "2 核心 ANE (0.6 TOPS)") }
        public static var aneA12: String { tr(zh: "8 核 ANE (5.0 TOPS)", en: "8-Core ANE (5.0 TOPS)", hant: "8 核心 ANE (5.0 TOPS)") }
        public static var aneA13: String { tr(zh: "8 核 ANE (6.0 TOPS)", en: "8-Core ANE (6.0 TOPS)", hant: "8 核心 ANE (6.0 TOPS)") }
        public static var aneA14: String { tr(zh: "16 核 ANE (11 TOPS)", en: "16-Core ANE (11 TOPS)", hant: "16 核心 ANE (11 TOPS)") }
        public static var aneA15: String { tr(zh: "16 核 ANE (15.8 TOPS)", en: "16-Core ANE (15.8 TOPS)", hant: "16 核心 ANE (15.8 TOPS)") }
        public static var aneA16: String { tr(zh: "16 核 ANE (17 TOPS)", en: "16-Core ANE (17 TOPS)", hant: "16 核心 ANE (17 TOPS)") }
        public static var aneA17Pro: String { tr(zh: "16 核 ANE (35 TOPS)", en: "16-Core ANE (35 TOPS)", hant: "16 核心 ANE (35 TOPS)") }
        public static var aneA18Plus: String { tr(zh: "16 核 ANE (35+ TOPS)", en: "16-Core ANE (35+ TOPS)", hant: "16 核心 ANE (35+ TOPS)") }
        public static var aneAppleSiliconM: String { tr(zh: "16 核 ANE (16~38 TOPS)", en: "16-Core ANE (16~38 TOPS)", hant: "16 核心 ANE (16~38 TOPS)") }
        public static var neuralEngineStandard: String { tr(zh: "Apple 神经网络引擎", en: "Apple Neural Engine", hant: "Apple 神經網絡引擎") }

        // Security & Ports
        public static var biometrics: String { tr(zh: "生物安全识别", en: "Biometrics", hant: "生物安全識別") }
        public static var faceIdTrueDepth: String { tr(zh: "Face ID (原深感摄像头)", en: "Face ID (TrueDepth)", hant: "Face ID (原深感鏡頭)") }
        public static var touchIdText: String { tr(zh: "Touch ID (指纹传感器)", en: "Touch ID (Capacitive)", hant: "Touch ID (指紋感測器)") }
        public static var passcodeText: String { tr(zh: "系统数字密码保护", en: "Passcode Protection", hant: "系統數字密碼保護") }
        public static var lidarScanner: String { tr(zh: "LiDAR 激光雷达", en: "LiDAR Scanner", hant: "LiDAR 光學雷達") }
        public static var lidarEquipped: String { tr(zh: "配备 (dToF 3D 测距)", en: "Equipped (dToF Depth)", hant: "搭載 (dToF 3D 測距)") }
        public static var lidarNotEquipped: String { tr(zh: "未配备 (Pro 专属)", en: "Not Equipped (Pro Only)", hant: "未搭載 (Pro 專屬)") }
        public static var secureEnclave: String { tr(zh: "安全加密芯片", en: "Secure Enclave", hant: "安全加密晶片") }
        public static var sepText: String { tr(zh: "硬件隔离保护 (SEP)", en: "Hardware Isolated (SEP)", hant: "硬體隔離保護 (SEP)") }
        public static var usbPortSpeed: String { tr(zh: "物理数据接口", en: "Physical Port", hant: "實體數據介面") }
        public static var portUsbC10G: String { tr(zh: "USB-C 3.2 (10 Gbps)", en: "USB-C 3.2 (10 Gbps)", hant: "USB-C 3.2 (10 Gbps)") }
        public static var portUsbC480M: String { tr(zh: "USB-C (480 Mbps)", en: "USB-C (480 Mbps)", hant: "USB-C (480 Mbps)") }
        public static var portLightning: String { tr(zh: "Lightning (480 Mbps)", en: "Lightning (480 Mbps)", hant: "Lightning (480 Mbps)") }
        public static var darwinKernel: String { tr(zh: "操作系统内核", en: "Darwin Kernel", hant: "作業系統核心") }
    }

    // MARK: - Battery
    public enum Battery {
        public static var title: String { tr(zh: "电池与供电", en: "Battery & Power", hant: "電池與供電") }
        public static var health: String { tr(zh: "电池健康度", en: "Battery Health", hant: "電池健康度") }
        public static var cycleCount: String { tr(zh: "循环计数", en: "Cycle Count", hant: "循環次數") }
        public static var cyclesUnit: String { tr(zh: "次", en: "Cycles", hant: "次") }
        public static var designCapacity: String { tr(zh: "出厂设计容量", en: "Design Capacity", hant: "出廠設計容量") }
        public static var currentMaxCapacity: String { tr(zh: "实际最大容量", en: "Current Max Capacity", hant: "實際最大容量") }
        public static var livePower: String { tr(zh: "实时充放电功率", en: "Live Power", hant: "即時充放電功率") }
        public static var voltage: String { tr(zh: "当前电压", en: "Voltage", hant: "目前電壓") }
        public static var current: String { tr(zh: "实时电流", en: "Current", hant: "即時電流") }
        public static var wattage: String { tr(zh: "实时瓦数", en: "Wattage", hant: "即時瓦數") }
        public static var chargerProtocol: String { tr(zh: "充电协议", en: "Protocol", hant: "充電協定") }
        public static var batteryTemp: String { tr(zh: "电芯温度", en: "Battery Temp", hant: "電芯溫度") }
        public static var chargingStatus: String { tr(zh: "充电状态", en: "Charging Status", hant: "充電狀態") }
        public static var discharging: String { tr(zh: "放电中", en: "Discharging", hant: "放電中") }
        public static var charging: String { tr(zh: "正在充电", en: "Charging", hant: "充電中") }
        public static var full: String { tr(zh: "已充满", en: "Fully Charged", hant: "已充滿") }
        public static var reverseCharging: String { tr(zh: "反向供电中", en: "Reverse Charging", hant: "反向供電中") }
        public static var timeRemaining: String { tr(zh: "预计充满时间", en: "Time to Full", hant: "預估充滿時間") }
    }

    // MARK: - Network
    public enum Network {
        public static var title: String { tr(zh: "网络工坊", en: "Network Hub", hant: "網絡工坊") }
        public static var wifiStatus: String { tr(zh: "无线局域网 (Wi-Fi)", en: "Wi-Fi Status", hant: "無線區域網絡 (Wi-Fi)") }
        public static var ssid: String { tr(zh: "网络名称 (SSID)", en: "SSID", hant: "網絡名稱 (SSID)") }
        public static var localIP: String { tr(zh: "内网 IP 地址", en: "Local IP", hant: "區域網絡 IP") }
        public static var gateway: String { tr(zh: "网关路由器", en: "Gateway Router", hant: "閘道路由器") }
        public static var cellular: String { tr(zh: "蜂窝移动数据", en: "Cellular", hant: "行動網絡") }
        public static var carrier: String { tr(zh: "运营商", en: "Carrier", hant: "電信業者") }
        public static var radioTech: String { tr(zh: "制式网络", en: "Radio RAT", hant: "網絡制式") }
        public static var publicIP: String { tr(zh: "公网出口 IP", en: "Public IP", hant: "公網出口 IP") }
        public static var pingTest: String { tr(zh: "ICMP Ping 测速", en: "Ping Latency", hant: "ICMP Ping 延遲") }
        public static var lanScan: String { tr(zh: "局域网 ARP 扫描", en: "LAN ARP Scan", hant: "區域網絡 ARP 掃描") }
        public static var wol: String { tr(zh: "远程局域网唤醒 (WOL)", en: "Wake-on-LAN", hant: "網絡喚醒 (WOL)") }
        public static var portScan: String { tr(zh: "常用端口扫描器", en: "Port Scanner", hant: "常用通訊埠掃描") }
    }

    // MARK: - Tools
    public enum Tools {
        public static var title: String { tr(zh: "硬件工具箱", en: "Hardware Lab", hant: "硬體工具箱") }
        public static var spiritLevel: String { tr(zh: "双轴高精度水平仪", en: "Spirit Level", hant: "雙軸高精度水平儀") }
        public static var spiritLevelSub: String { tr(zh: "360° 平面圆盘 + 90° 立面角度计", en: "360° Circular & Vertical Angle", hant: "360° 平面圓盤 + 90° 立面角度") }
        public static var screenRuler: String { tr(zh: "1:1 毫米微米屏幕卡尺", en: "Screen Caliper", hant: "1:1 毫米微米螢幕卡尺") }
        public static var screenRulerSub: String { tr(zh: "基于物理 PPI 精准换算物理实物标尺", en: "Exact Physical Scale via Native PPI", hant: "基於實體 PPI 精準換算實物標尺") }
        public static var waterEjector: String { tr(zh: "165Hz 声波扬声器排水", en: "Sonic Water Ejector", hant: "165Hz 聲波揚聲器排水") }
        public static var waterEjectorSub: String { tr(zh: "物理共振气压震飞听筒与喇叭孔水珠", en: "Resonant acoustic wave for water clearing", hant: "物理共振氣壓震出聽筒與喇叭水珠") }
        public static var decibelMeter: String { tr(zh: "环境噪音分贝计", en: "Decibel Meter", hant: "環境噪音分貝計") }
        public static var toneGenerator: String { tr(zh: "音频信号发生器", en: "Tone Generator", hant: "音訊訊號發生器") }
        public static var torchLab: String { tr(zh: "1%~100% 极精细手电筒", en: "Precision Torch", hant: "1%~100% 極精細手電筒") }
        public static var touchMatrix: String { tr(zh: "全屏触控断触测试", en: "Touch Matrix Test", hant: "全螢幕觸控斷觸測試") }
    }

    // MARK: - Settings
    public enum Settings {
        public static var title: String { tr(zh: "控制中枢与设置", en: "Control Hub", hant: "控制中心與設定") }
        public static var appearanceSection: String { tr(zh: "外观与界面", en: "Appearance & Theme", hant: "外觀與主題") }
        public static var appearanceMode: String { tr(zh: "外观模式", en: "Appearance Mode", hant: "外觀模式") }
        public static var modeDark: String { tr(zh: "黑曜石深色", en: "Obsidian Dark", hant: "黑曜石深色") }
        public static var modeLight: String { tr(zh: "陶瓷极简浅色", en: "Ceramic Light", hant: "陶瓷極簡淺色") }
        public static var modeSystem: String { tr(zh: "跟随系统", en: "Follow System", hant: "跟隨系統") }

        public static var themeColor: String { tr(zh: "全局主题色", en: "Accent Color", hant: "全域主題色") }
        public static var customPalette: String { tr(zh: "自定义全光谱调色板", en: "Custom Palette", hant: "自訂全光譜調色盤") }
        public static var hexCode: String { tr(zh: "HEX 颜色值", en: "HEX Color Code", hant: "HEX 顏色碼") }
        public static var presets: String { tr(zh: "经典极客预设", en: "Curated Presets", hant: "經典極客預設") }

        public static var languageSection: String { tr(zh: "语言 (Language)", en: "Language", hant: "語言 (Language)") }
        public static var langSystem: String { tr(zh: "跟随系统 (System)", en: "System Default", hant: "跟隨系統 (System)") }

        public static var signingSection: String { tr(zh: "自签证书与特权", en: "Sideload & Provisioning", hant: "自簽憑證與特權") }
        public static var certExpiry: String { tr(zh: "个人证书剩余有效期", en: "Certificate Countdown", hant: "個人憑證剩餘有效期") }
        public static var sevenDaysCountdown: String { tr(zh: "7 天掉签倒计时", en: "7-Day Expiry Timer", hant: "7 天掉簽倒數計時") }

        public static var sysPrefsSection: String { tr(zh: "系统深层设置一键直达 (App-prefs)", en: "System Settings Shortcuts", hant: "系統深層設定一鍵直達 (App-prefs)") }
        public static var prefWifi: String { tr(zh: "Wi-Fi 设置直达", en: "Wi-Fi Settings", hant: "Wi-Fi 設定直達") }
        public static var prefBluetooth: String { tr(zh: "蓝牙详情直达", en: "Bluetooth Settings", hant: "藍牙詳情直達") }
        public static var prefBattery: String { tr(zh: "电池健康直达", en: "Battery Health", hant: "電池健康直達") }
        public static var prefVpn: String { tr(zh: "VPN 管理直达", en: "VPN Settings", hant: "VPN 管理直達") }
        public static var prefHotspot: String { tr(zh: "个人热点直达", en: "Personal Hotspot", hant: "個人熱點直達") }
        public static var prefGeneralUpdate: String { tr(zh: "软件更新直达", en: "Software Update", hant: "軟體更新直達") }

        public static var aboutSection: String { tr(zh: "关于 OneDeck", en: "About OneDeck", hant: "關於 OneDeck") }
        public static var version: String { tr(zh: "版本号", en: "Version", hant: "版本號") }
        public static var openSourceRepo: String { tr(zh: "开源代码仓库", en: "Open Source Repository", hant: "開原始碼倉庫") }
    }
}
