import 'package:flutter/material.dart';
import '../theme/deck_colors.dart';

/// OneDeck's signature Titanium Card component.
/// Provides a sleek surface with a subtle 0.8px micro-border and hover effects.
class DeckCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final double borderRadius;
  final Border? customBorder;

  const DeckCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color,
    this.borderRadius = 16.0,
    this.customBorder,
  });

  @override
  State<DeckCard> createState() => _DeckCardState();
}

class _DeckCardState extends State<DeckCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ??
        (_isHovered ? DeckColors.cardHover(context) : DeckColors.card(context));

    final effectiveBorder = widget.customBorder ??
        Border.all(
          color: _isHovered ? DeckColors.accentIndigo.withValues(alpha: 0.4) : DeckColors.subtleBorder(context),
          width: 0.8,
        );

    final cardWidget = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: effectiveBorder,
      ),
      child: widget.child,
    );

    if (widget.onTap != null) {
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: cardWidget,
        ),
      );
    }

    return cardWidget;
  }
}
