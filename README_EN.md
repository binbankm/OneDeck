<div align="center">

# OneDeck

### Industrial-grade Hardware Telemetry & Diagnostics Console for iOS

[![iOS 17.0+](https://img.shields.io/badge/iOS-17.0%2B-blue?style=flat-square&logo=apple)](https://developer.apple.com/ios/)
[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9%2B-F05138?style=flat-square&logo=swift)](https://swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-10B981?style=flat-square)](LICENSE)
[![Zero Analytics](https://img.shields.io/badge/Privacy-Zero%20Analytics-success?style=flat-square)](#-privacy--network-disclosure)

[English](README_EN.md) · [简体中文](README.md)

</div>

---

## 📖 Overview

**OneDeck** is a native hardware telemetry, environmental sensing, and diagnostics console engineered for iOS. Built on **SwiftUI** and direct **Darwin / Mach Kernel / IOKit** interfaces, OneDeck unifies high-frequency sensors, battery management system (BMS) log analysis, low-level network diagnostics, and 19 physical measurement instruments into a structured cockpit.

> [!NOTE]
> Built with full VoiceOver accessibility labeling and symmetric localization across Simplified Chinese, Traditional Chinese, and English. On the iOS Simulator or sandboxed environments where private hardware registers are restricted, OneDeck degrades gracefully with explicit status indicators (`Model Estimated` / `Protected` / `--`) rather than fabricating sensor readings.

---

## ⚡️ Core Modules

### 1. Overview Dashboard
- **SoC & Thermal State**: Real-time thermal pressure reporting; supports direct IOHID/BMS sensor reads when accessible, and clearly badges fallback thermal model estimates.
- **CPU Monitor**: Mach `host_processor_info` multi-core usage telemetry with dynamic Performance (P) and Efficiency (E) cluster detection (`hw.perflevel*`).
- **Memory & Storage**: Granular physical RAM breakdown (Active, Wired, Compressed, Free) via `host_statistics64`, plus one-tap temporary directory and URL cache purging.
- **Live Bandwidth**: 30-second rolling throughput charts via `getifaddrs` (`AF_LINK`), with **32-bit unsigned byte-counter wraparound rollover and reset handling**.
- **Hardware Architecture**: Dynamic SoC process/ISA reporting, L1/L2 cache sizes, Metal GPU capabilities (ray tracing & mesh shaders), Neural Engine tier, biometrics, and LiDAR inspection.

### 2. Battery & Thermals
- **BMS Telemetry & Analytics Log Parser**: Reads accessible IOKit/IOPS properties and imports official Apple Sysdiagnose analytics logs (`.ips` / `.ips.ca.synced`), extracting cycle counts, `NominalChargeCapacity`, `MaximumFCC`, and integer/decimal `MaximumCapacityPercent`.
- **Live Power Delivery**: Voltage (V), current (mA), power flow (W), and charging stage status (USB-PD fast charge curve, CV tapering, trickle maintenance, discharging).
- **Thermal Chassis View**: Dual-mode FLIR thermal visualization and blueprint overlay covering 4 thermal zones (SoC, Battery Chamber, PMIC, Wireless Coil).
- **Degradation & Custom Cell Calibration**: Cycle retention trajectory with an 80% service threshold reference and configurable design capacity for aftermarket battery cells.

### 3. Network & Diagnostics
- **Link Telemetry**: Local IPv4, subnet mask, kernel default gateway (`PF_ROUTE`), DNS servers (`libresolv`), MTU, and negotiated interface speed.
- **Multi-Node DNS & RTT Benchmark**: Concurrent TCP connect RTT probing across `223.5.5.5`, `119.29.29.29`, `1.1.1.1`, `8.8.8.8`, `180.76.76.76`, and local gateway.
- **Public IP & Dual-Stack Detection**: Concurrent domestic and edge IP checks, ISP attribution, IPv6 dual-stack awareness, and proxy exit verification.
- **LAN Discovery (mDNS & ARP)**: Combines Darwin kernel ARP table inspection, OUI vendor / randomized private MAC identification, and Bonjour/mDNS browsing (`NSBonjourServices`).
- **Wake-on-LAN**: POSIX UDP 102-byte Magic Packet broadcaster.
- **Port Scanner, Dig & Speed Test**: Concurrent port scanner, POSIX `getaddrinfo` `A`/`AAAA` lookups, and an interactive bandwidth speed test sheet.

### 4. Tools & Physical Instruments (19 Instruments)
- **Dual-Axis Spirit Level**: Roll (X) / Pitch (Y) inclinometer with flat/vertical modes, slope (%), tare zeroing, and 0.0° acoustic/taptic lock cues.
- **Native Screen Caliper**: 1:1 physical scaling (mm / cm / inch), dual calipers, tare offset, and persistent measurement history.
- **Acoustic Water Ejector**: 165Hz diaphragm resonance clearance and 440Hz dust clearance with heavy haptic bursts.
- **Precision Torch & Strobe**: 1%–100% linear brightness control, SOS Morse beacon, optical strobe, and screen softbox mode.
- **EMF & Metal Detector**: Tri-axial magnetic flux oscilloscope with baseline tare and Geiger audio feedback.
- **Barometer & Altimeter**: Atmospheric pressure (hPa), tare-calibrated relative elevation, and vertical speed indicator (VSI).
- **Audio Tone Generator & Stereo Lab**: 20Hz–20kHz real-time synthesizer (sine, square, triangle, sawtooth), hearing age challenge, and left/right stereo channel separation.
- **Screen Quality & Touch Matrix**: Full-screen dead-pixel color tester, 80-cell 120Hz touch continuity grid, and proximity sensor check.
- **Haptic Lab & Decibel Meter**: Taptic Engine actuator patterns and live microphone dB SPL metering with peak/avg/min tracking.
- **Electronic Compass & Seismometer**: Magnetic/true heading compass alongside tri-axial seismic acceleration and intensity classification.
- **PPG Pulse & Ambient Lux Meter**: Camera PPG optical heart rate / HRV measurement and ambient illuminance (Lux, fc, EV).
- **GNSS Satellite Hub**: Differential fix status, DOP estimation, and geodetic conversions across **WGS-84 / GCJ-02 / BD-09 / MGRS** (including Norway/Svalbard UTM zone exceptions and UPS polar zones).
- **BLE Radar & Industrial Microscope**: Near-field Bluetooth RSSI proximity radar and rear-camera macro inspection with 1x–15x zoom, frame freeze, and **CoreImage filters** (`CIColorInvert`, `CIColorControls`, `CIEdges`).

### 5. Settings & Provisioning
- **Appearance & Accent Palette**: System / Light / Dark menu, 7 curated theme presets, native `ColorPicker`, and real-time HEX input (with Display P3 out-of-gamut component clamping).
- **Symmetric Localization**: Instant switching between System, Simplified Chinese, Traditional Chinese, and English (properly resolving `en_CN` to English).
- **Hardware Preferences**: Haptics toggle, instrument sound cues toggle, keep screen awake, sensor power-saving throttle, and one-tap calibration reset.
- **Provisioning & Signing Inspector**: Parses `embedded.mobileprovision` X.509 certificates (SHA-1 / SHA-256), expiration countdowns, entitlements, and environment type (Free 7-day / Developer / Enterprise / App Store / TestFlight / TrollStore / Simulator).
- **Licenses & About**: Interactive MIT License sheet, native framework list, device summary, and repository link.

---

## 🛠️ Build & Testing

### Requirements
- **macOS**: macOS 15.0+
- **Xcode**: Xcode 16.0+ (`objectVersion = 77` Synchronized Root Groups, Swift 5.9+ with approachable concurrency & `@MainActor` default isolation)
- **Target**: iOS 17.0+ (iPhone / iPad)

### Running Builds & Unit Tests
1. Clone and open the project:
   ```bash
   git clone https://github.com/binbankm/OneDeck.git
   cd OneDeck
   open OneDeck.xcodeproj
   ```
2. Run the app build and `OneDeckTests` unit test suite from Terminal:
   ```bash
   xcodebuild test \
     -project OneDeck.xcodeproj \
     -scheme OneDeck \
     -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
   ```
3. Build an unsigned Release IPA (for custom signing or TrollStore):
   ```bash
   ./scripts/build_unsigned_ipa.sh
   ```

---

## 🔒 Privacy & Network Disclosure

OneDeck contains **zero third-party SDKs, zero analytics/crash trackers, and zero background data uploads**:
- **Local-First Computation**: Sensor processing, battery `.ips` log parsing, LAN ARP/mDNS inspection, geodetic coordinate math, and preferences remain locally inside the iOS sandbox.
- **User-Initiated External Diagnostic Endpoints**: When you open the **Network** tab or manually run network tools, OneDeck connects directly to the following endpoints purely to perform the requested diagnostic check:
  - **Public IP & Proxy Exit Lookup**: `https://myip.ipip.net`, `https://ipinfo.io/json`, `https://api.ip.sb/geoip`, `https://api.ipify.org?format=json`
  - **Active Speed Test**: `https://speed.cloudflare.com/__down` and `https://speed.cloudflare.com/__up`
  - **TCP RTT Latency & DNS Benchmark**: `1.1.1.1`, `223.5.5.5`, `8.8.8.8`, `119.29.29.29`, `180.76.76.76`, and your local gateway

---

## 📄 License

OneDeck is licensed under the **MIT License**. See [LICENSE](LICENSE) for details.
