<div align="center">

# OneDeck

### 工控级 iOS 硬件遥测与诊断控制台
**Industrial-grade Hardware Telemetry & Diagnostics Console for iOS**

[![iOS 17.0+](https://img.shields.io/badge/iOS-17.0%2B-blue?style=flat-square&logo=apple)](https://developer.apple.com/ios/)
[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9%2B-F05138?style=flat-square&logo=swift)](https://swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-10B981?style=flat-square)](LICENSE)
[![Zero Analytics](https://img.shields.io/badge/Privacy-Zero%20Analytics-success?style=flat-square)](#-隐私安全与网络披露)

[简体中文](README.md) · [English](README_EN.md)

</div>

---

## 📖 简介

**OneDeck** 是一款专为 iOS 平台打造的旗舰级工业工控硬件遥测、环境感知与诊断控制台。基于原生 **SwiftUI** 与 **Darwin / Mach Kernel / IOKit** 底层通道构建，整合高频传感器、电芯管理系统 (BMS) 解析、底层网络协议栈与 19 项高精度微机械测量工具。

> [!NOTE]
> 遵循 Apple 人机界面指南 (HIG) 与工控仪表面板规范：采用高对比度 Bento 卡片、VoiceOver 无障碍标注与对称三语覆盖（简体中文 / 繁體中文 / English）。在 iOS 模拟器或沙盒受限环境中，受保护的硬件寄存器诚实降级并明确标识状态（`模型估算` / `受保护` / `--`），**绝不伪造硬件读数**。

---

## ⚡️ 核心功能模块

### 1. 概览看板 (Overview)
- **SoC 芯片与温控**：实时温控热压等级（正常 / 温热 / 较热 / 过热）；支持 IOHID/BMS 直读结温与电芯温度，无直接传感器通道时诚实标注为模型估算。
- **CPU 监视器**：实时 Mach `host_processor_info` 多核动态负载曲线，自动探测 P 核（性能核）与 E 核（能效核）集群拓扑。
- **内存与存储**：活跃、非活跃/联动、压缩、空闲物理 RAM 细分图表；一键清理应用临时目录与磁盘/网络缓存。
- **实时网络带宽**：基于 `getifaddrs` (`AF_LINK`) 的 30s 动态双向网速流，内置 **32 位无符号字节计数器溢出回绕（wraparound）与重置检测**。
- **全量硬件档案**：动态探测芯片制程节点、ARM64 ISA 等级、`sysctl` L1/L2 缓存、Metal GPU 渲染器/光线追踪/网格着色能力、神经网络引擎规格、生物识别与 LiDAR 配置。

### 2. 电池遥测 (Battery & Thermals)
- **BMS 原厂真值与日志解析**：支持导入并解析官方 Apple Sysdiagnose 分析日志（`.ips` / `.ips.ca.synced`），提取循环次数、`NominalChargeCapacity`、`MaximumFCC` 与小数精度 `MaximumCapacityPercent` 健康度。
- **实时供电功率**：动态显示实时电压（V）、电流（mA）、充放电瞬时瓦数（W）与协商协议（USB-PD 快充曲线、恒压降流、涓流维护、电池放电）。
- **机身热力透视**：红外热像 (FLIR) 与透视蓝图双模，四分区温敏展示（SoC 主板、锂电芯主仓、快充供电模组、磁吸无线线圈）。
- **容量衰减与电芯校准**：循环次数与容量保留率走势图（含 80% 检修线），支持自定义更换电芯的额定设计容量基准。

### 3. 网络内核 (Network & Diagnostics)
- **链路信息**：局域网 IPv4、子网掩码、默认网关（`PF_ROUTE` 路由表）、DNS 服务器（`libresolv`）、MTU 与接口速率。
- **多节点 DNS 与 RTT 延迟探测**：并发探测 `223.5.5.5`、`119.29.29.29`、`1.1.1.1`、`8.8.8.8`、`180.76.76.76` 及本地网关的 TCP 连接延迟与抖动。
- **公网出口与双栈识别**：并发探测国内直连与国际边缘节点出口 IP、运营商归属地及代理分流退出状态。
- **局域网发现 (mDNS & ARP)**：结合 Darwin 内核 ARP 缓存、MAC OUI 厂商识别/私有随机 MAC 检测与 Bonjour/mDNS 服务扫描。
- **网络唤醒 (Wake-on-LAN)**：POSIX UDP 广播 102 字节魔术包。
- **端口扫描与域名解析**：常用服务端口并发扫描、POSIX 原生 `A` / `AAAA` 记录解析与主动带宽测速卡片。

### 4. 工业工具箱 (Tools & Instruments · 19 项)
- **双轴水平仪**：横滚角 (X) 与俯仰角 (Y) 高精度解算，支持平面/立面模式、坡度 (%) 转换、零点校准与 0.0° 声学/触感对准提示。
- **屏幕物理卡尺**：1:1 原生物理换算（mm / cm / inch），支持双游标自由测量、归零偏置与测量记录持久化。
- **声波共振排水**：165Hz 低频声学物理排水与 440Hz 扬声器振膜除尘（附带实时重触感激励）。
- **精细手电调光**：1% ~ 100% 线性流明微调、SOS 国际莫尔斯电码信标、频闪仪与屏幕柔光箱。
- **金属与电磁寻线**：三轴磁通示波器、基线归零及盖革计数音效反馈。
- **气压与相对海拔**：实时大气压强 (hPa)、相对高程差（含零点基准保存）与垂直升降速度 (VSI)。
- **纯音频发生器**：20Hz ~ 20,000Hz 正弦波/方波/三角波/锯齿波实时音频合成与听力高频评估。
- **屏幕质量与全屏触控矩阵**：全屏坏点/漏光纯色巡检、120Hz 80 格触控连贯性测试及距离传感器联动。
- **触觉马达与立体声测试**：Taptic Engine 线性致动器脉冲实验、左右声道独立分离测试。
- **环境噪声分贝计**：实时声压等级 (dB SPL)、动态波形、峰值/均值/最小值环境噪声监测。
- **电子罗盘与微震烈度**：地磁/真北航向罗盘、三轴地动加速度与微震烈度分级。
- **光电容积脉搏波 (PPG) 与照度计**：后置摄像头 PPG 心率与 HRV 分析；环境照度 (Lux)、尺烛光 (fc) 与 EV 曝光值实时换算。
- **卫星导航 (GNSS Hub)**：差分定位状态、HDOP/VDOP 估算，实时转换 **WGS-84 / GCJ-02 / BD-09 / MGRS**（含挪威/斯瓦尔巴 UTM 例外区与极区 UPS 标识）。
- **蓝牙雷达与工业微距**：近场 BLE 信号 RSSI 测距雷达；后置微距 1x–15x 变焦、定格 freeze 与 **CoreImage 实时滤镜**（`CIColorInvert` 反色、`CIColorControls` 高反差黑白、`CIEdges` 边缘提取）。

### 5. 系统与设置 (Settings)
- **外观模式与强调色**：【跟随系统 / 浅色 / 深色】下拉菜单；7 款精选强调色板、系统原生取色器与实时 HEX 输入（自动限幅 P3 广色域分量）。
- **三语对称本地化**：支持跟随系统、简体中文、繁體中文、English 即时切换（正确识别 `en_CN` 为英文环境）。
- **硬件偏好设置**：Taptic 触觉反馈开关、声学提示音开关、屏幕常亮控制、传感器低功耗降频及 IMU/仪器零点一键复位。
- **证书与签名解析**：读取并校验 `embedded.mobileprovision` 与 X.509 SHA-1 / SHA-256 指纹、权限 Entitlements，识别个人免费 7 天签名 / 开发者 / 企业 / App Store / TestFlight / TrollStore 及模拟环境。
- **开源许可与关于**：MIT 许可证全文查阅、原生 Apple 系统框架列表与实时硬件档案摘要。

---

## 🛠️ 构建与测试

### 系统与工具要求
- **macOS**：macOS 15.0+ (推荐 macOS 15 / 26)
- **Xcode**：Xcode 16.0+（工程采用 Synchronized Root Group `objectVersion = 77`，兼容 Swift 5.9+ / Swift 6 `@MainActor` 默认隔离特性）
- **目标系统**：iOS 17.0+ (iPhone / iPad)

### 编译与单元测试
1. 克隆仓库并打开 Xcode 工程：
   ```bash
   git clone https://github.com/binbankm/OneDeck.git
   cd OneDeck
   open OneDeck.xcodeproj
   ```
2. 命令行运行编译与 `OneDeckTests` 单元测试：
   ```bash
   xcodebuild test \
     -project OneDeck.xcodeproj \
     -scheme OneDeck \
     -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
   ```
3. 构建未签名 Release IPA（用于自定义重签或 TrollStore 部署）：
   ```bash
   ./scripts/build_unsigned_ipa.sh
   ```

---

## 🔒 隐私安全与网络披露

OneDeck **零第三方 SDK、零广告追踪、零后台静默上传**：
- **本地运算优先**：传感器、电芯解析、局域网扫描、地理坐标转换与配置状态全部在本地沙盒内完成，诊断记录仅保存在本地内存或 `UserDefaults`。
- **用户触发的外部网络诊断端点披露**：以下主动网络功能会在您进入**网络页签**或点击相应诊断按钮时，直接向目标节点发起一次性请求（无遥测上报）：
  - **公网 IP 与代理出口探测**：`https://myip.ipip.net`、`https://ipinfo.io/json`、`https://api.ip.sb/geoip`、`https://api.ipify.org?format=json`
  - **主动带宽测速**：`https://speed.cloudflare.com/__down` 与 `https://speed.cloudflare.com/__up`
  - **延迟与 DNS 基准测试**：向 `1.1.1.1`、`223.5.5.5`、`8.8.8.8`、`119.29.29.29`、`180.76.76.76` 或局域网网关发起 POSIX TCP 握手测时

---

## 📄 开源许可证

本项目基于 **MIT 许可证** 开源，详情请参阅 [LICENSE](LICENSE) 文件。
