import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import '../theme/deck_colors.dart';

/// OneDeck's signature Glassmorphic Titanium Card component.
/// Provides a frosted glass surface (BackdropFilter), specular highlight borders,
/// dual-layer ambient elevation shadows, and micro-interactions.
class DeckCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final double borderRadius;
  final Border? customBorder;
  final bool enableGlass;

  const DeckCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color,
    this.borderRadius = 16.0,
    this.customBorder,
    this.enableGlass = true,
  });

  @override
  State<DeckCard> createState() => _DeckCardState();
}

class _DeckCardState extends State<DeckCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Specular highlight border: Top catches light with subtle alpha, sides/bottom darker
    final defaultBorder = Border.all(
      color: _isHovered
          ? DeckColors.accentIndigo.withValues(alpha: 0.55)
          : (isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.black.withValues(alpha: 0.08)),
      width: 0.8,
    );

    final effectiveBorder = widget.customBorder ?? defaultBorder;

    // Translucent glass gradient for Space Titanium & Warm Alabaster
    final bgGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
              (widget.color ?? DeckColors.darkCard).withValues(alpha: _isHovered ? 0.92 : 0.84),
              (widget.color ?? DeckColors.darkCardHover).withValues(alpha: _isHovered ? 0.82 : 0.72),
            ]
          : [
              Colors.white.withValues(alpha: _isHovered ? 0.98 : 0.94),
              Colors.white.withValues(alpha: _isHovered ? 0.92 : 0.86),
            ],
    );

    // Dual-layer soft elevation shadow tuned for Apple Pro & Linear
    final shadows = [
      BoxShadow(
        color: isDark ? Colors.black.withValues(alpha: 0.42) : const Color(0x0C000000),
        blurRadius: 20,
        offset: const Offset(0, 8),
        spreadRadius: -4,
      ),
      BoxShadow(
        color: isDark ? Colors.black.withValues(alpha: 0.22) : const Color(0x06000000),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
      if (_isHovered)
        BoxShadow(
          color: DeckColors.accentIndigo.withValues(alpha: isDark ? 0.22 : 0.12),
          blurRadius: 18,
          spreadRadius: 1,
        ),
    ];

    Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: widget.padding,
      decoration: BoxDecoration(
        gradient: bgGradient,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: effectiveBorder,
        boxShadow: shadows,
      ),
      child: widget.child,
    );

    if (widget.enableGlass) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: content,
        ),
      );
    }

    if (widget.onTap != null) {
      return MouseRegion(
        onEnter: (_) {
          if (mounted && !_isHovered) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _isHovered = true);
            });
          }
        },
        onExit: (_) {
          if (mounted && _isHovered) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _isHovered = false);
            });
          }
        },
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: content,
        ),
      );
    }

    return content;
  }
}
