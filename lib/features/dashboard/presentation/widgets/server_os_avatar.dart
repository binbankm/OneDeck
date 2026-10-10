import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/deck_colors.dart';

/// Distro configuration descriptor holding asset path and brand gradient colors.
class DistroConfig {
  final String asset;
  final List<Color> gradient;
  final Color glowColor;

  const DistroConfig({
    required this.asset,
    required this.gradient,
    required this.glowColor,
  });
}

/// Visual Server OS Brand Avatar.
/// Automatically detects Ubuntu, Debian, CentOS, AlmaLinux, Rocky, Arch,
/// Alpine, Fedora, RedHat, Windows, macOS, etc., and renders an authentic
/// brand gradient box with the official vector logo silhouette.
class ServerOsAvatar extends StatelessWidget {
  final String? distro;
  final double size;
  final double? borderRadius;

  const ServerOsAvatar({
    super.key,
    required this.distro,
    this.size = 38.0,
    this.borderRadius,
  });

  static DistroConfig getDistroConfig(String? raw) {
    final d = (raw ?? '').toLowerCase().trim();

    if (d.contains('ubuntu')) {
      return const DistroConfig(
        asset: 'assets/icons/distros/ubuntu.svg',
        gradient: [Color(0xFFE95420), Color(0xFF77216F)],
        glowColor: Color(0xFFE95420),
      );
    }
    if (d.contains('debian')) {
      return const DistroConfig(
        asset: 'assets/icons/distros/debian.svg',
        gradient: [Color(0xFFD70A53), Color(0xFFA80030)],
        glowColor: Color(0xFFD70A53),
      );
    }
    if (d.contains('centos')) {
      return const DistroConfig(
        asset: 'assets/icons/distros/centos.svg',
        gradient: [Color(0xFF262577), Color(0xFF93227F)],
        glowColor: Color(0xFF262577),
      );
    }
    if (d.contains('alma')) {
      return const DistroConfig(
        asset: 'assets/icons/distros/almalinux.svg',
        gradient: [Color(0xFF0047AB), Color(0xFF1473E6)],
        glowColor: Color(0xFF0047AB),
      );
    }
    if (d.contains('rocky')) {
      return const DistroConfig(
        asset: 'assets/icons/distros/rocky.svg',
        gradient: [Color(0xFF10B981), Color(0xFF047857)],
        glowColor: Color(0xFF10B981),
      );
    }
    if (d.contains('arch')) {
      return const DistroConfig(
        asset: 'assets/icons/distros/arch.svg',
        gradient: [Color(0xFF1793D1), Color(0xFF0F5A84)],
        glowColor: Color(0xFF1793D1),
      );
    }
    if (d.contains('alpine')) {
      return const DistroConfig(
        asset: 'assets/icons/distros/alpine.svg',
        gradient: [Color(0xFF0D597F), Color(0xFF073248)],
        glowColor: Color(0xFF0D597F),
      );
    }
    if (d.contains('fedora')) {
      return const DistroConfig(
        asset: 'assets/icons/distros/fedora.svg',
        gradient: [Color(0xFF294172), Color(0xFF51A2DA)],
        glowColor: Color(0xFF294172),
      );
    }
    if (d.contains('redhat') || d.contains('rhel')) {
      return const DistroConfig(
        asset: 'assets/icons/distros/redhat.svg',
        gradient: [Color(0xFFEE0000), Color(0xFFA60000)],
        glowColor: Color(0xFFEE0000),
      );
    }
    if (d.contains('suse')) {
      return const DistroConfig(
        asset: 'assets/icons/distros/opensuse.svg',
        gradient: [Color(0xFF73BA25), Color(0xFF35B9AB)],
        glowColor: Color(0xFF73BA25),
      );
    }
    if (d.contains('windows')) {
      return const DistroConfig(
        asset: 'assets/icons/distros/windows.svg',
        gradient: [Color(0xFF0078D4), Color(0xFF002050)],
        glowColor: Color(0xFF0078D4),
      );
    }
    if (d.contains('darwin') || d.contains('macos') || d.contains('apple')) {
      return const DistroConfig(
        asset: 'assets/icons/distros/apple.svg',
        gradient: [Color(0xFF4B5563), Color(0xFF1F2937)],
        glowColor: Color(0xFF4B5563),
      );
    }

    // Generic Linux or default server
    return const DistroConfig(
      asset: 'assets/icons/distros/linux.svg',
      gradient: [DeckColors.accentIndigo, DeckColors.accentCyan],
      glowColor: DeckColors.accentIndigo,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cfg = getDistroConfig(distro);
    final radius = borderRadius ?? (size >= 40 ? 12.0 : 10.0);
    final innerPadding = size * 0.22;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: cfg.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.22),
          width: 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: cfg.glowColor.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(innerPadding),
          child: SvgPicture.asset(
            cfg.asset,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
