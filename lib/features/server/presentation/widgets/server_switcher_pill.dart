import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/l10n_x.dart';
import '../../../../core/theme/deck_colors.dart';
import '../providers/server_provider.dart';
import 'server_switcher_sheet.dart';

/// Top bar switcher pill displaying active server status, real-time latency and fast-switch popup.
class ServerSwitcherPill extends ConsumerWidget {
  const ServerSwitcherPill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final activeServer = ref.watch(activeServerProvider);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        showServerSwitcherSheet(context);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSuperNarrow = constraints.maxWidth < 60;
          final latency = activeServer?.lastLatencyMs;

          Color latencyColor = DeckColors.statusOnline;
          if (latency != null) {
            if (latency > 500) {
              latencyColor = DeckColors.statusError;
            } else if (latency > 250) {
              latencyColor = DeckColors.statusWarning;
            }
          }

          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSuperNarrow ? 6 : 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: DeckColors.card(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: DeckColors.subtleBorder(context),
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status pulse dot
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
                  const SizedBox(width: 8),
                  // Server Name
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 160),
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
                  // Real-time Latency badge if available
                  if (latency != null && latency > 0 && constraints.maxWidth > 140) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: DeckColors.canvas(context),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${latency}ms',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: latencyColor,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 6),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 16,
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
