import 'package:flutter/material.dart';

/// OneDeck's signature color palette: "Titanium Cyber-Deck".
/// Defines bespoke colors for both Dark (Titanium Obsidian) and Light (Polar Titanium) modes.
abstract final class DeckColors {
  // --- 1. Brand Accents (签名强调色) ---
  /// Electric Indigo - Main signature accent
  static const Color accentIndigo = Color(0xFF6366F1);
  /// Cyber Cyan - Secondary glowing highlight
  static const Color accentCyan = Color(0xFF06B6D4);
  /// Electric Purple - Complementary accent
  static const Color accentPurple = Color(0xFF8B5CF6);

  // --- 2. Dark Palette: Titanium Obsidian (深空钛黑) ---
  static const Color darkCanvas = Color(0xFF0B0E17);
  static const Color darkCard = Color(0xFF131826);
  static const Color darkCardHover = Color(0xFF1A2234);
  static const Color darkSidebar = Color(0xFF0E121E);
  static const Color darkSubtleBorder = Color(0x14FFFFFF); // rgba(255,255,255, 0.08)
  static const Color darkGlowBorder = Color(0x286366F1); // subtle indigo border glow

  static const Color darkTextPrimary = Color(0xFFF1F5F9); // slate-100
  static const Color darkTextSecondary = Color(0xFF94A3B8); // slate-400
  static const Color darkTextMuted = Color(0xFF64748B); // slate-500

  // --- 3. Light Palette: Polar Titanium (极地钛白) ---
  static const Color lightCanvas = Color(0xFFF8FAFC); // slate-50
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardHover = Color(0xFFF1F5F9);
  static const Color lightSidebar = Color(0xFFF1F5F9);
  static const Color lightSubtleBorder = Color(0xFFE2E8F0); // slate-200
  static const Color lightGlowBorder = Color(0x1F6366F1);

  static const Color lightTextPrimary = Color(0xFF0F172A); // slate-900
  static const Color lightTextSecondary = Color(0xFF475569); // slate-600
  static const Color lightTextMuted = Color(0xFF94A3B8); // slate-400

  // --- 4. Semantic Status Colors (状态指示灯) ---
  /// Normal / Running / Healthy
  static const Color statusOnline = Color(0xFF10B981); // Emerald
  static const Color statusOnlineGlow = Color(0x3310B981);

  /// High Load / Warning / Attention
  static const Color statusWarning = Color(0xFFF59E0B); // Amber
  static const Color statusWarningGlow = Color(0x33F59E0B);

  /// Stopped / Offline / Critical Error
  static const Color statusError = Color(0xFFEF4444); // Rose/Red
  static const Color statusErrorGlow = Color(0x33EF4444);

  /// Inactive / Paused / Unknown
  static const Color statusMuted = Color(0xFF64748B); // Slate

  // --- 5. Contextual Helpers ---
  static Color canvas(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkCanvas : lightCanvas;

  static Color card(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkCard : lightCard;

  static Color cardHover(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkCardHover : lightCardHover;

  static Color sidebar(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkSidebar : lightSidebar;

  static Color subtleBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkSubtleBorder : lightSubtleBorder;

  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTextPrimary : lightTextPrimary;

  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTextSecondary : lightTextSecondary;

  static Color textMuted(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTextMuted : lightTextMuted;
}
