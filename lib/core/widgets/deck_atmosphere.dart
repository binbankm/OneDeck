import 'package:flutter/material.dart';
import '../theme/deck_colors.dart';

/// OneDeck Cinematic Ambient Atmosphere.
/// Renders a deep cosmic canvas with subtle luminous radial aurora mesh blooms
/// that provide frosted glassmorphic cards with soft refractive depth and visual vitality.
class DeckAtmosphere extends StatelessWidget {
  final Widget child;

  const DeckAtmosphere({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // 1. Deep Foundation Canvas
        Positioned.fill(
          child: Container(
            color: DeckColors.canvas(context),
          ),
        ),

        // 2. Ambient Aurora Blooms (Subtle Luminous Mesh)
        if (isDark) ...[
          // Top-Right Aurora Bloom (Gentle Titanium Indigo Aura)
          Positioned(
            top: -120,
            right: -80,
            width: 460,
            height: 460,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      DeckColors.accentIndigo.withValues(alpha: 0.09),
                      DeckColors.accentPurple.withValues(alpha: 0.04),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Mid-Left Ambient Nebula Bloom (Subtle Cyan Breath)
          Positioned(
            top: 260,
            left: -120,
            width: 480,
            height: 480,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      DeckColors.accentCyan.withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
            ),
          ),

          // Bottom-Right Specular Bloom
          Positioned(
            bottom: -90,
            right: 20,
            width: 400,
            height: 400,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      DeckColors.accentIndigo.withValues(alpha: 0.04),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.8],
                  ),
                ),
              ),
            ),
          ),
        ] else ...[
          // Light Mode: Subtle Warm Alabaster Specular Ambient Wash
          Positioned(
            top: -80,
            right: -40,
            width: 420,
            height: 420,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      DeckColors.accentIndigo.withValues(alpha: 0.035),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.8],
                  ),
                ),
              ),
            ),
          ),
        ],

        // 3. Main Interactive Viewport
        Positioned.fill(child: child),
      ],
    );
  }
}
