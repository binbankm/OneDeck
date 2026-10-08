import 'package:flutter/material.dart';
import '../theme/deck_colors.dart';

/// Pulsing live status dot indicating resource health.
class DeckStatusDot extends StatefulWidget {
  final bool isOnline;
  final bool isWarning;
  final double size;

  const DeckStatusDot({
    super.key,
    required this.isOnline,
    this.isWarning = false,
    this.size = 8.0,
  });

  @override
  State<DeckStatusDot> createState() => _DeckStatusDotState();
}

class _DeckStatusDotState extends State<DeckStatusDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _glowAnimation = Tween<double>(begin: 1.5, end: 4.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    if (widget.isOnline) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant DeckStatusDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOnline && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isOnline && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = !widget.isOnline
        ? DeckColors.statusError
        : (widget.isWarning ? DeckColors.statusWarning : DeckColors.statusOnline);

    final glowColor = !widget.isOnline
        ? DeckColors.statusErrorGlow
        : (widget.isWarning ? DeckColors.statusWarningGlow : DeckColors.statusOnlineGlow);

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: glowColor,
                blurRadius: widget.isOnline ? _glowAnimation.value * 2 : 2,
                spreadRadius: widget.isOnline ? _glowAnimation.value : 1,
              ),
            ],
          ),
        );
      },
    );
  }
}
