<div align="center">

# OneDeck

### Industrial-grade Hardware Telemetry & Diagnostics Console for iOS

[![iOS 17.0+](https://img.shields.io/badge/iOS-17.0%2B-blue?style=flat-square&logo=apple)](https://developer.apple.com/ios/)
[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9%2B-F05138?style=flat-square&logo=swift)](https://swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-10B981?style=flat-square)](LICENSE)
[![Zero Analytics](https://img.shields.io/badge/Privacy-100%25%20Local-success?style=flat-square)](#-privacy--zero-telemetry-pledge)

[English](README_EN.md) · [简体中文](README.md)

</div>

---

## 📖 Overview

**OneDeck** is a flagship hardware telemetry, environmental sensing, and diagnostic console designed exclusively for iOS. Built on native **SwiftUI** and direct **Darwin / Mach Kernel / IOKit** pipes, OneDeck consolidates high-frequency sensors, battery management systems (BMS), low-level networking, and micro-mechanical physical instruments into an industrial cockpit.

> [!NOTE]
> Engineered strictly against the Apple Human Interface Guidelines (HIG) and industrial measurement standards. Zero drop shadows, responsive layouts, 100% local computing, and zero remote tracking or analytics.

---

## ⚡️ Core Modules

### 1. Overview Dashboard
- **SoC & Thermal State**: Real-time junction temperature, battery cell temperature, and thermal pressure state.
- **CPU Monitor**: 60Hz live dynamic usage graph, multi-core telemetry (Performance & Efficiency cores).
- **Memory & Storage**: Granular physical RAM metrics (Active, Wired, Compressed, Free); one-tap cache purging.
- **Live Bandwidth**: 30-second rolling bidirectional network throughput stream with interface detection.
- **Hardware Architecture**: Detailed hardware specs including TSMC semiconductor process (nm), ISA architecture, GPU cores, Metal 3 ray tracing, Apple Neural Engine TOPS, and Secure Enclave (SEP).

### 2. Battery & Thermals
- **BMS Raw Telemetry**: Direct reading or parsing of official analytics logs (`.ips`) to unlock factory cycle counts and true cell health.
- **Live Power Delivery**: Real-time voltage (V), current (mA), instantaneous power (W), and charging protocol negotiation.
- **Thermal Chassis View**: Dual-mode FLIR thermal vision and architectural blueprint with 4-zone temperature sensing (SoC, Battery Chamber, Fast-Charge PMIC, Wireless Coil).
- **Degradation Trajectory**: Cycle-to-retention curve tracking with 80% service threshold baseline.

### 3. Network & Diagnostics
- **Link Telemetry**: Local IP, subnet mask, gateway, DNS servers, MTU, and negotiated interface speed.
- **Multi-Node DNS Benchmark**: Concurrent latency probing across major public DNS resolvers.
- **Public IP & ISP**: External IP address, geographic location, ASN provider, and proxy exit status.
- **LAN Discovery (mDNS)**：Automated scanning of active Bonjour services and local network hosts.
- **Wake-on-LAN**: POSIX UDP 102-byte Magic Packet broadcasting.
- **Port Scanner & Dig**: Common service port scanning and POSIX A / AAAA record lookups.

### 4. Tools & Physical Instruments
- **Dual-Axis Spirit Level**: High-precision Roll (X) and Pitch (Y) inclinometer with slope (%) and acoustic 0.0° zero-lock.
- **Screen Caliper**: 1:1 native physical scale (mm / inch) with dual free-floating jaws.
- **Acoustic Water Ejector**: 165Hz diaphragm harmonic water clearance and 440Hz dust clearing.
- **Precision Torch**: 1% ~ 100% linear lumen dimming, SOS Morse beacon, and optical tachometer strobe.
- **EMF & Metal Detector**: Tri-axial magnetic flux oscilloscope for metal stud finding.
- **Barometer & Altimeter**: Atmospheric pressure (hPa), relative elevation, and vertical speed indicator (VSI).
- **Tone Generator**: 20Hz ~ 20kHz synthesizer and cochlear high-frequency hearing age evaluation.
- **Screen Quality & Touch Matrix**: Dead pixel color inspector and 120Hz continuous touch digitizer sampling.
- **Haptic Lab**: Taptic Engine linear actuator impact forces and rotary mechanical detent simulation.
- **Decibel Meter**: Sound pressure level (dB SPL), peak/average noise telemetry.
- **Electronic Compass & Seismometer**: Magnetic heading, tri-axial seismic acceleration, and intensity rating.
- **PPG Pulse Meter**: Optical photoplethysmography heart rate and HRV measurement.
- **Lux Meter**: Ambient illuminance (Lux), foot-candles (fc), and EV calculation.
- **GNSS Satellite Hub**: Multi-constellation differential status, HDOP/VDOP metrics, and datum transformation.
- **BLE Radar & Microscope**: Near-field Bluetooth beacon proximity and macro surface inspection.

### 5. Settings & Provisioning
- **Theme Mode Dropdown**: Standard iOS pull-down menu with System, Light, and Dark modes.
- **Custom Accent Palette**: Native color picker combined with real-time HEX code editor.
- **Pure Hardware App Icons**: 4 minimalist, zero-text geometric icons with native iOS switching.
- **Language Dropdown**: System default, Simplified Chinese, Traditional Chinese, and English.
- **Hardware Preferences**: Taptic haptic feedback toggle, audio alignment beep toggle, low-power throttling, and IMU zero Tare reset.
- **Signing & Sideload Management**: Embedded mobileprovision inspection showing real-time 7-day or 365-day expiration countdown, team ID, and cert type without system jump shortcuts.
- **Open Source Licenses & Diagnostics**: Full MIT License review and one-tap hardware diagnostic summary export.

---

## 🛠️ Build & Requirements

- **macOS**: macOS 14.0 (Sonoma) or newer
- **Xcode**: Xcode 15.0+ (Swift 5.9+)
- **Target**: iOS 17.0+ (iPhone / iPad)

```bash
git clone https://github.com/binbankm/OneDeck.git
cd OneDeck
open OneDeck.xcodeproj
```

---

## 🔒 Privacy & Zero Telemetry Pledge

OneDeck is built on the foundation of **local computation, zero tracking, and absolute transparency**:
- **100% Local**: All sensor, battery, network, and system telemetry computations execute locally inside the iOS sandbox.
- **No Third-Party SDKs**: Zero advertising libraries, analytics trackers, or user profiling SDKs.
- **Zero Uploads**: Device hardware metrics and diagnostic reports remain exclusively on your device.

---

## 📄 License

OneDeck is licensed under the **MIT License**. See [LICENSE](LICENSE) for details.
