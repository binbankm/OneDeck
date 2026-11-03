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
        scheme == .dark ? Color(hex: "#13131A") : Color.white
    }

    // Card Subtle Border
    public static func cardBorder(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.06)
    }

    // Text Colors - Fully calibrated for WCAG AA compliance (Contrast >= 4.5:1)
    public static func textPrimary(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Color.white : Color(hex: "#111114")
    }

    public static func textSecondary(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(hex: "#B0B0BD") : Color(hex: "#54545F")
    }

    public static func textTertiary(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(hex: "#8E8E9C") : Color(hex: "#666672")
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

// MARK: - Global Typography Design System Tokens
public enum Typography {
    /// Hero KPI Numbers (Battery %, Latency ms, Speedtest Mbps)
    public static let displayHero: Font = .system(size: 40, weight: .bold, design: .rounded)
    /// Large Sub-Hero Metric (Public IP 24pt, Model Name Headline)
    public static let heroSubValue: Font = .system(size: 24, weight: .bold, design: .rounded)
    public static let heroSubValueMono: Font = .system(size: 24, weight: .bold, design: .monospaced)
    /// Top View Titles & Device Names (20pt)
    public static let title1: Font = .system(size: 20, weight: .bold, design: .rounded)
    /// Secondary Section Projections (18pt)
    public static let title2: Font = .system(size: 18, weight: .bold, design: .rounded)
    /// Primary Action Button Labels & Prominent Hero Metrics (16pt)
    public static let headlineValue: Font = .system(size: 16, weight: .bold, design: .rounded)
    /// Bento Card Section Headers (14pt)
    public static let sectionHeader: Font = .system(size: 14, weight: .bold, design: .rounded)
    public static let sectionHeaderMono: Font = .system(size: 14, weight: .bold, design: .monospaced)
    /// Core Metric Values in list tiles & gauges (13pt)
    public static let bodyValue: Font = .system(size: 13, weight: .semibold, design: .rounded)
    public static let bodyValueMono: Font = .system(size: 13, weight: .semibold, design: .monospaced)
    /// List Row Field Labels & Property Names (12pt)
    public static let calloutLabel: Font = .system(size: 12, weight: .medium)
    public static let calloutBold: Font = .system(size: 12, weight: .bold, design: .rounded)
    public static let calloutMono: Font = .system(size: 12, weight: .semibold, design: .monospaced)
    /// Secondary descriptions, hardware specs & sub-details (11pt)
    public static let caption: Font = .system(size: 11, weight: .medium)
    public static let captionRegular: Font = .system(size: 11, weight: .regular)
    public static let captionBold: Font = .system(size: 11, weight: .semibold, design: .rounded)
    public static let captionMono: Font = .system(size: 11, weight: .semibold, design: .monospaced)
    /// Micro Badges, Tags & Pill Labels (10pt)
    public static let badgeTag: Font = .system(size: 10, weight: .bold, design: .rounded)
    public static let badgeTagMedium: Font = .system(size: 10, weight: .medium)
    public static let badgeTagMono: Font = .system(size: 10, weight: .bold, design: .monospaced)
    public static let badgeTagMonoMedium: Font = .system(size: 10, weight: .medium, design: .monospaced)
    /// Chart Axis Ticks & Viewfinder HUD indicators (8.5pt Strict Minimum Limit)
    public static let microAxis: Font = .system(size: 8.5, weight: .semibold, design: .monospaced)
}

// MARK: - Spacing Design System Tokens (8pt Grid System)
public enum SpacingTheme {
    /// Tightest inline micro gap between icon & text (2pt)
    public static let micro: CGFloat = 2.0
    /// Inline badge & tag internal spacing (4pt)
    public static let tight: CGFloat = 4.0
    /// Standard component inner spacing (6pt / 8pt)
    public static let compact: CGFloat = 6.0
    public static let standard: CGFloat = 8.0
    /// Bento card inner row spacing (10pt / 12pt)
    public static let row: CGFloat = 10.0
    public static let rowStandard: CGFloat = 12.0
    /// Bento card internal major section spacing (14pt)
    public static let cardInternal: CGFloat = 14.0
    /// Section / Card stack spacing (16pt)
    public static let cardStack: CGFloat = 16.0
    /// Hero container / Empty state vertical breathing room (18pt)
    public static let heroPadding: CGFloat = 18.0
    /// Modal sheet horizontal padding (24pt)
    public static let modalPadding: CGFloat = 24.0
}

// MARK: - Corner Radius Design System Tokens
public enum CornerRadiusTheme {
    /// Micro tag & indicator pill radius (4pt)
    public static let micro: CGFloat = 4.0
    /// Secondary badge & small platter radius (6pt)
    public static let compact: CGFloat = 6.0
    /// Standard section header icon platter radius (7pt / 8pt)
    public static let platter: CGFloat = 7.0
    public static let standard: CGFloat = 8.0
    /// Inner list tile & sub-card container radius (10pt)
    public static let tile: CGFloat = 10.0
    /// Action button & prominent container radius (12pt / 14pt)
    public static let button: CGFloat = 12.0
    public static let prominent: CGFloat = 14.0
    /// Modal sheet inner card radius (16pt)
    public static let sheetCard: CGFloat = 16.0
    /// Main Bento Card outer corner radius (18pt)
    public static let card: CGFloat = 18.0
}

// MARK: - Icon Design System Tokens
public enum IconTheme {
    /// Section Header icon font size (optical match with 14pt bold title)
    public static let sectionHeader: Font = .system(size: 15, weight: .semibold)
    /// Bento Tile leading icon font size (optical 1:1 match with 11pt/12pt label)
    public static let tileLeading: Font = .system(size: 11, weight: .semibold)
    /// Inline badge icon font size (inside status pill)
    public static let badgeInline: Font = .system(size: 10, weight: .bold)
    /// Top card action / refresh / copy button icon font size
    public static let actionButton: Font = .system(size: 12, weight: .semibold)
    /// Inline secondary copy indicator icon font size
    public static let copyIndicator: Font = .system(size: 11, weight: .medium)
    /// Prominent card control / action button icon font size
    public static let prominentAction: Font = .system(size: 24, weight: .semibold)
    /// Hero avatar / Device preview icon font size
    public static let heroAvatar: Font = .system(size: 22, weight: .semibold)
    /// Empty state & device graphic icon font size
    public static let emptyState: Font = .system(size: 26, weight: .medium)
}

// MARK: - Chart Design System Tokens
public enum ChartTheme {
    /// Standard curve stroke width
    public static let lineWidth: CGFloat = 2.0
    public static let subLineWidth: CGFloat = 1.5
    public static let sparklineWidth: CGFloat = 1.8
    /// Chart trailing margin for right-aligned axis labels (32pt)
    public static let trailingMargin: CGFloat = 32.0

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

// MARK: - Flow Layout for Adaptive Wrapping Tags & Badges
public struct FlowLayout: Layout {
    public var spacing: CGFloat
    public var rowSpacing: CGFloat

    public init(spacing: CGFloat = 6.0, rowSpacing: CGFloat = 6.0) {
        self.spacing = spacing
        self.rowSpacing = rowSpacing
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > width && currentX > 0 {
                currentX = 0
                currentY += lineHeight + rowSpacing
                lineHeight = 0
            }
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
        }
        return CGSize(width: width, height: currentY + lineHeight)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX = bounds.minX
        var currentY = bounds.minY
        var lineHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > bounds.maxX && currentX > bounds.minX {
                currentX = bounds.minX
                currentY += lineHeight + rowSpacing
                lineHeight = 0
            }
            subview.place(at: CGPoint(x: currentX, y: currentY), proposal: ProposedViewSize(size))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
        }
    }
}

