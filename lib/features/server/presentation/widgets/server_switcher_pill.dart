import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/l10n_x.dart';
import '../../../../core/theme/deck_colors.dart';
import '../providers/server_provider.dart';
import '../../../../features/dashboard/presentation/widgets/server_os_avatar.dart';
import '../../../../features/dashboard/presentation/providers/dashboard_provider.dart';
import 'server_switcher_sheet.dart';

/// Top bar switcher pill displaying active server status, real-time latency and fast-switch popup.
class ServerSwitcherPill extends ConsumerWidget {
  const ServerSwitcherPill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final activeServer = ref.watch(activeServerProvider);
    final dashState = ref.watch(dashboardStateProvider);
    final distro = dashState.base?.prettyDistro ?? dashState.base?.platformFamily ?? dashState.base?.os;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        showServerSwitcherSheet(context);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSuperNarrow = constraints.maxWidth < 65;
          final isCompact = constraints.maxWidth < 160;
          final latency = activeServer?.lastLatencyMs;

          Color latencyColor = DeckColors.statusOnline;
          if (latency != null) {
            if (latency > 500) {
              latencyColor = DeckColors.statusError;
            } else if (latency > 250) {
              latencyColor = DeckColors.statusWarning;
            }
          }

          final hPadding = isSuperNarrow ? 6.0 : (isCompact ? 8.0 : 12.0);

          return Container(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth),
            padding: EdgeInsets.symmetric(
              horizontal: hPadding,
              vertical: 5.5,
            ),
            decoration: BoxDecoration(
              color: isDark ? DeckColors.card(context) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.08),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Distro Brand Badge or Status Dot
                if (distro != null && distro.isNotEmpty)
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ServerOsAvatar(
                        distro: distro,
                        size: 18,
                        borderRadius: 5,
                      ),
                      Positioned(
                        right: -1.5,
                        bottom: -1.5,
                        child: Container(
                          width: 6.5,
                          height: 6.5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: activeServer != null
                                ? (activeServer.isOnline == false
                                    ? DeckColors.statusError
                                    : DeckColors.statusOnline)
                                : DeckColors.statusMuted,
                            border: Border.all(
                              color: isDark ? DeckColors.darkCard : Colors.white,
                              width: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: activeServer != null
                          ? (activeServer.isOnline == false
                              ? DeckColors.statusError
                              : DeckColors.statusOnline)
                          : DeckColors.statusMuted,
                      boxShadow: [
                        BoxShadow(
                          color: activeServer != null
                              ? (activeServer.isOnline == false
                                  ? DeckColors.statusErrorGlow
                                  : DeckColors.statusOnlineGlow)
                              : Colors.transparent,
                          blurRadius: 6,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                if (!isSuperNarrow) ...[
                  const SizedBox(width: 7),
                  // Server Name with Flexible & FittedBox
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          activeServer?.name ?? l10n.server_no_servers,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: DeckColors.textPrimary(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Real-time Latency badge (only when space permits >= 180px)
                  if (latency != null && latency > 0 && constraints.maxWidth >= 180) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: DeckColors.canvas(context),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${latency}ms',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: latencyColor,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 5),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 15,
                    color: DeckColors.textMuted(context),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
