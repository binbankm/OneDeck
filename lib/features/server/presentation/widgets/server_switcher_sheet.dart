import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/l10n_x.dart';
import '../../../../core/theme/deck_colors.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../dashboard/presentation/widgets/server_os_avatar.dart';
import '../../domain/models/server_model.dart';
import '../providers/server_provider.dart';
import 'add_server_dialog.dart';

/// Shows the server switcher bottom sheet / modal.
Future<void> showServerSwitcherSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => const ServerSwitcherSheet(),
  );
}

/// Bottom sheet displaying the list of servers with quick switching and management.
class ServerSwitcherSheet extends ConsumerWidget {
  const ServerSwitcherSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final servers = ref.watch(serversProvider);
    final activeId = ref.watch(activeServerIdProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.75,
          ),
          margin: const EdgeInsets.only(top: 60),
          decoration: BoxDecoration(
            color: DeckColors.card(context).withValues(alpha: isDark ? 0.88 : 0.94),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: DeckColors.subtleBorder(context), width: 0.8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: DeckColors.textMuted(context).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Title Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.server_switch,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: DeckColors.textPrimary(context),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showAddOrEditServerDialog(context);
                      },
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: Text(l10n.server_add),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Server List
              if (servers.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                  child: Column(
                    children: [
                      Icon(Icons.dns_outlined, size: 48, color: DeckColors.textMuted(context)),
                      const SizedBox(height: 12),
                      Text(
                        l10n.server_no_servers,
                        style: TextStyle(fontSize: 14, color: DeckColors.textSecondary(context)),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          showAddOrEditServerDialog(context);
                        },
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: Text(l10n.server_add_first),
                      ),
                    ],
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: servers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final server = servers[index];
                      final isActive = server.id == activeId;

                      return _ServerListTile(
                        server: server,
                        isActive: isActive,
                        onTap: () {
                          ref.read(activeServerIdProvider.notifier).selectServer(server.id);
                          Navigator.of(context).pop();
                        },
                        onEdit: () {
                          Navigator.of(context).pop();
                          showAddOrEditServerDialog(context, initialServer: server);
                        },
                        onDelete: () => _confirmDelete(context, ref, server),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, ServerModel server) {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: DeckColors.card(ctx),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: DeckColors.subtleBorder(ctx), width: 0.8),
        ),
        title: Text(
          l10n.server_delete,
          style: TextStyle(color: DeckColors.textPrimary(ctx), fontWeight: FontWeight.bold),
        ),
        content: Text(
          l10n.server_delete_confirm,
          style: TextStyle(color: DeckColors.textSecondary(ctx)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.common_cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: DeckColors.statusError),
            onPressed: () {
              ref.read(serversProvider.notifier).deleteServer(server.id);
              Navigator.of(ctx).pop();
            },
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
  }
}

class _ServerListTile extends ConsumerWidget {
  final ServerModel server;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ServerListTile({
    required this.server,
    required this.isActive,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Distro icon lookup if this is active server
    final base = isActive ? ref.watch(dashboardStateProvider).base : null;
    final distro = base?.prettyDistro ?? base?.platformFamily ?? base?.os;

    Color bgColor;
    Border? border;
    List<BoxShadow>? shadows;

    if (isActive) {
      if (isDark) {
        bgColor = Colors.white.withValues(alpha: 0.08);
        border = Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 0.7,
        );
        shadows = [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];
      } else {
        bgColor = Colors.white;
        border = Border.all(
          color: Colors.black.withValues(alpha: 0.06),
          width: 0.7,
        );
        shadows = [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ];
      }
    } else {
      bgColor = isDark ? Colors.white.withValues(alpha: 0.02) : DeckColors.canvas(context);
      border = Border.all(
        color: DeckColors.subtleBorder(context).withValues(alpha: 0.6),
        width: 0.7,
      );
      shadows = null;
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: border,
        boxShadow: shadows,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // Active indicator line
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 3.5,
                  height: 32,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: isActive ? DeckColors.accentIndigo : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Server Distro Avatar with Status Dot
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ServerOsAvatar(
                      distro: distro,
                      size: 34,
                      borderRadius: 9,
                    ),
                    if (server.isOnline == true)
                      Positioned(
                        right: -1,
                        bottom: -1,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: DeckColors.statusOnline,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? const Color(0xFF191B20) : Colors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),

                // Server Name and URL
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              server.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                                color: DeckColors.textPrimary(context),
                              ),
                            ),
                          ),
                          if (server.lastLatencyMs != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              margin: const EdgeInsets.only(left: 6),
                              decoration: BoxDecoration(
                                color: DeckColors.card(context),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: DeckColors.subtleBorder(context).withValues(alpha: 0.5),
                                  width: 0.6,
                                ),
                              ),
                              child: Text(
                                '${server.lastLatencyMs}ms',
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: DeckColors.statusOnline,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        server.displayUrl,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: DeckColors.textMuted(context),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),

                // Actions
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 17),
                      color: DeckColors.textMuted(context),
                      onPressed: onEdit,
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 17),
                      color: DeckColors.statusError.withValues(alpha: 0.8),
                      onPressed: onDelete,
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
