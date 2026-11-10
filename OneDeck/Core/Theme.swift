//
//  Theme.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Design system defining spacing, typography, colors, and layout tokens.
//

import SwiftUI

// MARK: - App Theme Preset
public struct ThemePreset: Hashable, Identifiable {
    public var id: String { hex }
    public let hex: String

    public static let emerald = ThemePreset(hex: "#00DC82")
    public static let cyan = ThemePreset(hex: "#00D2FF")
    public static let blue = ThemePreset(hex: "#3B82F6")
    public static let purple = ThemePreset(hex: "#A855F7")
    public static let crimson = ThemePreset(hex: "#F43F5E")
    public static let orange = ThemePreset(hex: "#FF6B00")
    public static let gold = ThemePreset(hex: "#EAB308")

    public static let defaultPreset: ThemePreset = .blue

    public static let allPresets: [ThemePreset] = [
        .blue,
        .cyan,
        .emerald,
        .purple,
        .crimson,
        .orange,
        .gold
    ]
}

// MARK: - Theme Manager
public enum Theme {
    // Pre-instantiated static colors for zero-allocation 120Hz rendering performance
    private static let darkCanvas = Color(hex: "#07070A")
    private static let lightCanvas = Color(hex: "#F4F5F8")

    private static let darkCard = Color(hex: "#13131A")
    private static let lightCard = Color.white

    private static let darkCardBorder = Color.white.opacity(0.08)
    private static let lightCardBorder = Color.black.opacity(0.06)

    private static let darkTextPrimary = Color.white
    private static let lightTextPrimary = Color(hex: "#111114")

    private static let darkTextSecondary = Color(hex: "#B0B0BD")
    private static let lightTextSecondary = Color(hex: "#54545F")

    private static let darkTextTertiary = Color(hex: "#8E8E9C")
    private static let lightTextTertiary = Color(hex: "#666672")

    private static let darkChipBg = Color.white.opacity(0.08)
    private static let lightChipBg = Color(hex: "#ECEDF2")
    private static let darkChipBorder = Color.white.opacity(0.10)
    private static let lightChipBorder = Color.black.opacity(0.10)

    private static let lightReadableYellow = Color(hex: "#B45309")
    private static let lightReadableCyan = Color(hex: "#0369A1")
    private static let lightReadableGreen = Color(hex: "#15803D")
    private static let lightReadableOrange = Color(hex: "#C2410C")
    private static let lightReadableRed = Color(hex: "#DC2626")

    private static let darkTileBg = Color.white.opacity(0.035)
    private static let lightTileBg = Color.black.opacity(0.025)
    private static let darkTileBorder = Color.white.opacity(0.07)
    private static let lightTileBorder = Color.black.opacity(0.06)

    // Canvas Background
    public static func background(for scheme: ColorScheme) -> Color {
        scheme == .dark ? darkCanvas : lightCanvas
    }

    // Card Surface
    public static func cardBackground(for scheme: ColorScheme) -> Color {
        scheme == .dark ? darkCard : lightCard
    }

    // Card Subtle Border
    public static func cardBorder(for scheme: ColorScheme) -> Color {
        scheme == .dark ? darkCardBorder : lightCardBorder
    }

    // Nested Tile Surface inside Bento Cards
    public static func tileBackground(for scheme: ColorScheme) -> Color {
        scheme == .dark ? darkTileBg : lightTileBg
    }

    public static func tileBorder(for scheme: ColorScheme) -> Color {
        scheme == .dark ? darkTileBorder : lightTileBorder
    }

    // Chip & Unselected Pill Surfaces
    public static func chipBackground(for scheme: ColorScheme) -> Color {
        scheme == .dark ? darkChipBg : lightChipBg
    }

    public static func chipBorder(for scheme: ColorScheme) -> Color {
        scheme == .dark ? darkChipBorder : lightChipBorder
    }

    // Accessible Accent Variants for Light & Dark Surfaces
    public static func readableYellow(for scheme: ColorScheme) -> Color {
        scheme == .dark ? .yellow : lightReadableYellow
    }

    public static func readableCyan(for scheme: ColorScheme) -> Color {
        scheme == .dark ? .cyan : lightReadableCyan
    }

    public static func readableGreen(for scheme: ColorScheme) -> Color {
        scheme == .dark ? .green : lightReadableGreen
    }

    public static func readableOrange(for scheme: ColorScheme) -> Color {
        scheme == .dark ? .orange : lightReadableOrange
    }

    public static func readableRed(for scheme: ColorScheme) -> Color {
        scheme == .dark ? .red : lightReadableRed
    }

    /// Calibrates user-selected accent colors (including bright presets like gold/cyan/emerald
    /// or dark custom HEX values) so small text and icons maintain >= 4.5:1 WCAG contrast on cards.
    public static func readableAccent(_ accent: Color, for scheme: ColorScheme) -> Color {
        #if canImport(UIKit)
        let uic = UIColor(accent)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        guard uic.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return accent
        }
        let cr = Double(min(max(r, 0.0), 1.0))
        let cg = Double(min(max(g, 0.0), 1.0))
        let cb = Double(min(max(b, 0.0), 1.0))

        let rl = srgbToLinear(cr)
        let gl = srgbToLinear(cg)
        let bl = srgbToLinear(cb)
        let luminance = 0.2126 * rl + 0.7152 * gl + 0.0722 * bl

        if scheme == .light {
            let maxLightLuminance = 0.145
            guard luminance > maxLightLuminance else { return accent }
            let scale = maxLightLuminance / luminance
            return Color(
                .sRGB,
                red: linearToSrgb(rl * scale),
                green: linearToSrgb(gl * scale),
                blue: linearToSrgb(bl * scale),
                opacity: Double(a)
            )
        } else {
            let minDarkLuminance = 0.21
            guard luminance < minDarkLuminance else { return accent }
            let factor = (minDarkLuminance - luminance) / max(1.0 - luminance, 0.0001)
            return Color(
                .sRGB,
                red: linearToSrgb(rl + factor * (1.0 - rl)),
                green: linearToSrgb(gl + factor * (1.0 - gl)),
                blue: linearToSrgb(bl + factor * (1.0 - bl)),
                opacity: Double(a)
            )
        }
        #else
        return accent
        #endif
    }

    internal static func relativeLuminance(of color: Color) -> Double {
        #if canImport(UIKit)
        let uic = UIColor(color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        guard uic.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return 0.0
        }
        let rl = srgbToLinear(Double(min(max(r, 0.0), 1.0)))
        let gl = srgbToLinear(Double(min(max(g, 0.0), 1.0)))
        let bl = srgbToLinear(Double(min(max(b, 0.0), 1.0)))
        return 0.2126 * rl + 0.7152 * gl + 0.0722 * bl
        #else
        return 0.0
        #endif
    }

    private static func srgbToLinear(_ channel: Double) -> Double {
        channel <= 0.04045 ? channel / 12.92 : pow((channel + 0.055) / 1.055, 2.4)
    }

    private static func linearToSrgb(_ channel: Double) -> Double {
        let clamped = min(max(channel, 0.0), 1.0)
        return clamped <= 0.0031308 ? clamped * 12.92 : 1.055 * pow(clamped, 1.0 / 2.4) - 0.055
    }

    public static func contrastingForeground(for background: Color) -> Color {
        #if canImport(UIKit)
        let uic = UIColor(background)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        guard uic.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return .white
        }
        let cr = min(max(r, 0.0), 1.0)
        let cg = min(max(g, 0.0), 1.0)
        let cb = min(max(b, 0.0), 1.0)
        let luminance = 0.2126 * cr + 0.7152 * cg + 0.0722 * cb
        return luminance > 0.42 ? .black : .white
        #else
        return .white
        #endif
    }

    // Text Colors - Fully calibrated for WCAG AA compliance (Contrast >= 4.5:1)
    public static func textPrimary(for scheme: ColorScheme) -> Color {
        scheme == .dark ? darkTextPrimary : lightTextPrimary
    }

    public static func textSecondary(for scheme: ColorScheme) -> Color {
        scheme == .dark ? darkTextSecondary : lightTextSecondary
    }

    public static func textTertiary(for scheme: ColorScheme) -> Color {
        scheme == .dark ? darkTextTertiary : lightTextTertiary
    }

    // Dynamic Gradient Generator from any single Color
    public static func gradient(for primary: Color) -> LinearGradient {
        LinearGradient(
            colors: [primary, primary.opacity(0.75)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Global Typography Design System Tokens (Dynamic Type Enabled)
public enum Typography {
    /// Hero KPI Numbers (Battery %, Latency ms, Speedtest Mbps)
    public static let displayHero: Font = .system(.largeTitle, design: .rounded, weight: .bold)
    /// Large Sub-Hero Metric (Public IP, Model Name Headline)
    public static let heroSubValue: Font = .system(.title2, design: .rounded, weight: .bold)
    public static let heroSubValueMono: Font = .system(.title2, design: .monospaced, weight: .bold)
    /// Top View Titles & Device Names
    public static let title1: Font = .system(.title3, weight: .bold)
    /// Secondary Section Projections
    public static let title2: Font = .system(.headline, weight: .bold)
    /// Primary Action Button Labels & Prominent Hero Metrics
    public static let headlineValue: Font = .system(.callout, weight: .semibold)
    /// Bento Card Section Headers
    public static let sectionHeader: Font = .system(.subheadline, weight: .bold)
    /// Core Metric Values in list tiles & gauges
    public static let bodyValue: Font = .system(.footnote, weight: .semibold)
    public static let bodyMedium: Font = .system(.footnote, weight: .medium)
    public static let bodyValueMono: Font = .system(.footnote, design: .monospaced, weight: .semibold)
    /// List Row Field Labels & Property Names
    public static let calloutLabel: Font = .system(.caption, weight: .medium)
    public static let calloutBold: Font = .system(.caption, weight: .semibold)
    public static let calloutMono: Font = .system(.caption, design: .monospaced, weight: .semibold)
    /// Secondary descriptions, hardware specs & sub-details
    public static let caption: Font = .system(.caption2, weight: .medium)
    public static let captionRegular: Font = .system(.caption2, weight: .regular)
    public static let captionBold: Font = .system(.caption2, weight: .semibold)
    public static let captionMono: Font = .system(.caption2, design: .monospaced, weight: .semibold)
    /// Micro Badges, Tags & Pill Labels
    public static let badgeTag: Font = .system(.caption2, weight: .bold)
    public static let badgeTagMedium: Font = .system(.caption2, weight: .medium)
    public static let badgeTagMono: Font = .system(.caption2, design: .monospaced, weight: .bold)
    public static let badgeTagMonoMedium: Font = .system(.caption2, design: .monospaced, weight: .medium)
    /// Chart Axis Ticks & Viewfinder HUD indicators
    public static let microAxis: Font = .system(.caption2, design: .monospaced, weight: .semibold)
}

// MARK: - Spacing Design System Tokens (8pt Grid System)
public enum SpacingTheme {
    /// Zero spacing token (0pt)
    public static let none: CGFloat = 0.0
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

// MARK: - Layout Constraints & Accessibility Hit-Target Tokens
public enum LayoutTheme {
    /// Maximum readable content column width across phones and iPads
    public static let maxContentWidth: CGFloat = 680.0
    /// Apple HIG minimum accessible touch target dimension
    public static let minTapTarget: CGFloat = 44.0
}

// MARK: - Corner Radius Design System Tokens
public enum CornerRadiusTheme {
    /// Micro tag & indicator pill radius (4pt)
    public static let micro: CGFloat = 4.0
    /// Secondary badge & small platter radius (6pt)
    public static let compact: CGFloat = 6.0
    /// Standard section header icon platter radius (8pt)
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
    /// Micro menu chevron up/down indicator font size
    public static let chevronIndicator: Font = .system(size: 9, weight: .semibold)
    /// Prominent card control / action button icon font size
    public static let prominentAction: Font = .system(size: 24, weight: .semibold)
    /// Tool launcher card 44x44 squircle platter icon size
    public static let launcherIcon: Font = .system(size: 20, weight: .semibold)
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
    /// Distinct secondary curve color for network uplink / uploads
    public static let uploadColor = Color(hex: "#00C9FF")
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
    public static func normalizedValidHex(_ rawHex: String) -> String? {
        let stripped = rawHex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted).uppercased()
        guard stripped.count == 3 || stripped.count == 6 || stripped.count == 8,
              stripped.allSatisfy(\.isHexDigit) else {
            return nil
        }
        return "#\(stripped)"
    }

    public init(hex: String) {
        let clean = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        let isValid = (clean.count == 3 || clean.count == 6 || clean.count == 8) && clean.allSatisfy(\.isHexDigit)
        var int: UInt64 = 0
        let scanner = Scanner(string: clean)
        let parsed = isValid && scanner.scanHexInt64(&int) && scanner.isAtEnd

        let a, r, g, b: UInt64
        if parsed {
            switch clean.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (255, 59, 130, 246)
            }
        } else {
            // Fall back to default blue preset (#3B82F6) rather than opaque black
            (a, r, g, b) = (255, 59, 130, 246)
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
        let clampedR = min(max(r, 0.0), 1.0)
        let clampedG = min(max(g, 0.0), 1.0)
        let clampedB = min(max(b, 0.0), 1.0)
        return String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(clampedR * 255)),
            lroundf(Float(clampedG * 255)),
            lroundf(Float(clampedB * 255))
        )
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
    public var hasShadow: Bool
    public var accentColor: Color

    public init(
        padding: CGFloat,
        cornerRadius: CGFloat,
        isHighlighted: Bool = false,
        hasShadow: Bool = true,
        accentColor: Color
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.isHighlighted = isHighlighted
        self.hasShadow = hasShadow
        self.accentColor = accentColor
    }

    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(padding)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme))
                    .shadow(
                        color: (hasShadow && !isHighlighted)
                            ? Color.black.opacity(colorScheme == .dark ? 0.3 : 0.04)
                            : (isHighlighted ? accentColor.opacity(0.12) : .clear),
                        radius: hasShadow ? (isHighlighted ? 12 : 8) : 0,
                        x: 0,
                        y: hasShadow ? 4 : 0
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        isHighlighted ? accentColor.opacity(0.5) : Theme.cardBorder(for: colorScheme),
                        lineWidth: isHighlighted ? 1.0 : 0.5
                    )
            }
            .frame(maxWidth: .infinity)
    }
}

extension View {
    public func bentoCard(
        padding: CGFloat = SpacingTheme.cardStack,
        cornerRadius: CGFloat = CornerRadiusTheme.card,
        isHighlighted: Bool = false,
        hasShadow: Bool = true,
        accent: Color = .blue
    ) -> some View {
        modifier(BentoCardModifier(
            padding: padding,
            cornerRadius: cornerRadius,
            isHighlighted: isHighlighted,
            hasShadow: hasShadow,
            accentColor: accent
        ))
    }
}

// MARK: - Bento Card Interactive Button Style
public struct BentoCardButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.88 : 1.0)
            .animation(.spring(response: 0.22, dampingFraction: 0.75), value: configuration.isPressed)
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
        let availableWidth = proposal.width ?? .infinity
        let childProposal = ProposedViewSize(width: availableWidth.isFinite ? availableWidth : nil, height: nil)
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var maxRowWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(childProposal)
            if currentX + size.width > availableWidth && currentX > 0 {
                maxRowWidth = max(maxRowWidth, currentX - spacing)
                currentX = 0
                currentY += lineHeight + rowSpacing
                lineHeight = 0
            }
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
        }
        if currentX > 0 {
            maxRowWidth = max(maxRowWidth, currentX - spacing)
        }
        let resolvedWidth = availableWidth.isFinite ? availableWidth : maxRowWidth
        return CGSize(width: resolvedWidth, height: currentY + lineHeight)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX = bounds.minX
        var currentY = bounds.minY
        var lineHeight: CGFloat = 0
        let childProposal = ProposedViewSize(width: bounds.width.isFinite ? bounds.width : nil, height: nil)

        for subview in subviews {
            let size = subview.sizeThatFits(childProposal)
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
