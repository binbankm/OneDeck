//
//  Theme.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Obsidian Bento Glassmorphism Design System & Dynamic Full-Spectrum Palette Engine.
//

import SwiftUI

// MARK: - App Theme Preset
public struct ThemePreset: Identifiable, Hashable {
    public let id: String
    public let nameZh: String
    public let nameEn: String
    public let hex: String
    public let secondaryHex: String

    public var displayName: String {
        L10n.tr(zh: nameZh, en: nameEn)
    }

    public var primaryColor: Color {
        Color(hex: hex)
    }

    public var secondaryColor: Color {
        Color(hex: secondaryHex)
    }

    public static let emerald = ThemePreset(
        id: "emerald",
        nameZh: "赛博冷翠",
        nameEn: "Cyber Emerald",
        hex: "#00F5A0",
        secondaryHex: "#00D084"
    )

    public static let cyan = ThemePreset(
        id: "cyan",
        nameZh: "深邃青蓝",
        nameEn: "Cyber Cyan",
        hex: "#00C9FF",
        secondaryHex: "#0072FF"
    )

    public static let orange = ThemePreset(
        id: "orange",
        nameZh: "钛金暖橙",
        nameEn: "Titanium Orange",
        hex: "#FF9500",
        secondaryHex: "#FF5E3A"
    )

    public static let violet = ThemePreset(
        id: "violet",
        nameZh: "霓虹紫罗兰",
        nameEn: "Neon Violet",
        hex: "#AF52DE",
        secondaryHex: "#5856D6"
    )

    public static let blue = ThemePreset(
        id: "blue",
        nameZh: "极速电蓝",
        nameEn: "Electric Blue",
        hex: "#007AFF",
        secondaryHex: "#00C9FF"
    )

    public static let silver = ThemePreset(
        id: "silver",
        nameZh: "极简冰银",
        nameEn: "Monochrome Ice",
        hex: "#E5E5EA",
        secondaryHex: "#8E8E93"
    )

    public static let allPresets: [ThemePreset] = [
        .emerald, .cyan, .orange, .violet, .blue, .silver
    ]
}

// MARK: - Theme Manager
public enum Theme {
    // Canvas Background
    public static func background(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(hex: "#07070A") : Color(hex: "#F4F5F8")
    }

    // Card Surface
    public static func cardBackground(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(hex: "#121218").opacity(0.85) : Color.white
    }

    // Card Subtle Border
    public static func cardBorder(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.06)
    }

    // Text Colors
    public static func textPrimary(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Color.white : Color(hex: "#111114")
    }

    public static func textSecondary(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(hex: "#8E8E98") : Color(hex: "#6C6C75")
    }

    public static func textTertiary(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(hex: "#50505A") : Color(hex: "#A0A0A8")
    }

    // Dynamic Gradient Generator from any single Color
    public static func gradient(for primary: Color) -> LinearGradient {
        LinearGradient(
            colors: [primary, primary.opacity(0.75)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    public static func dualGradient(primary: Color, secondary: Color) -> LinearGradient {
        LinearGradient(
            colors: [primary, secondary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Chart Design System Tokens
public enum ChartTheme {
    /// Standard curve stroke width
    public static let lineWidth: CGFloat = 2.0
    public static let subLineWidth: CGFloat = 1.5
    public static let sparklineWidth: CGFloat = 1.8

    /// Standard dashed grid line stroke style
    public static let gridStroke = StrokeStyle(lineWidth: 0.6, dash: [2.5, 3])

    /// Bento adaptive grid line color
    public static func gridColor(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.06)
    }

    /// Unified area under curve gradient (standard 0.24 to 0.0)
    public static func areaGradient(for color: Color) -> LinearGradient {
        LinearGradient(
            colors: [color.opacity(0.24), color.opacity(0.0)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    /// Unified axis typography
    public static let axisLabelFont: Font = .system(size: 8.5, weight: .semibold, design: .monospaced)
    public static let compactAxisLabelFont: Font = .system(size: 8, weight: .semibold, design: .monospaced)

    /// Unified axis label color
    public static func axisLabelColor(for scheme: ColorScheme) -> Color {
        Theme.textTertiary(for: scheme)
    }
}

// MARK: - Dedicated Horizontal Dashed Grid Line Shape
public struct HorizontalDashedLine: Shape {
    public init() {}
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        return path
    }
}

// MARK: - Color Hex Extensions
extension Color {
    public init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 245, 160) // default emerald
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    public func toHex() -> String {
        #if canImport(UIKit)
        let uic = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uic.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        #else
        return "#00F5A0"
        #endif
    }
}

// MARK: - Bento Card Modifier
public struct BentoCardModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    public var padding: CGFloat
    public var cornerRadius: CGFloat
    public var isHighlighted: Bool
    public var accentColor: Color

    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(padding)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme))
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        isHighlighted ? accentColor.opacity(0.5) : Theme.cardBorder(for: colorScheme),
                        lineWidth: isHighlighted ? 1.0 : 0.5
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(
                color: isHighlighted ? accentColor.opacity(0.12) : Color.black.opacity(colorScheme == .dark ? 0.3 : 0.04),
                radius: isHighlighted ? 12 : 8,
                x: 0,
                y: 4
            )
            .frame(maxWidth: .infinity)
    }
}

extension View {
    public func bentoCard(
        padding: CGFloat = 16,
        cornerRadius: CGFloat = 18,
        isHighlighted: Bool = false,
        accent: Color = .green
    ) -> some View {
        modifier(BentoCardModifier(
            padding: padding,
            cornerRadius: cornerRadius,
            isHighlighted: isHighlighted,
            accentColor: accent
        ))
    }
}

