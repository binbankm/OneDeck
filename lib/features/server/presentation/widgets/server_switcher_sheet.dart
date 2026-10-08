import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/l10n_x.dart';
import '../../../../core/theme/deck_colors.dart';
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

class ServerSwitcherSheet extends ConsumerWidget {
  const ServerSwitcherSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final servers = ref.watch(serversProvider);
    final activeId = ref.watch(activeServerIdProvider);

    return Container(
      constraints: const BoxConstraints(maxWidth: 580),
      margin: const EdgeInsets.only(top: 60),
      decoration: BoxDecoration(
        color: DeckColors.card(context),
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
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, ServerModel server) {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.server_delete),
        content: Text(l10n.server_delete_confirm),
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

class _ServerListTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? DeckColors.accentIndigo.withValues(alpha: 0.1)
            : DeckColors.canvas(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActive ? DeckColors.accentIndigo : DeckColors.subtleBorder(context),
          width: isActive ? 1.2 : 0.8,
        ),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onTap: onTap,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive ? DeckColors.accentIndigo : DeckColors.card(context),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.dns_rounded,
            color: isActive ? Colors.white : DeckColors.textSecondary(context),
            size: 18,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                server.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${server.lastLatencyMs}ms',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: DeckColors.statusOnline,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
          ],
        ),
        subtitle: Text(
          server.displayUrl,
          style: TextStyle(
            fontSize: 12,
            color: DeckColors.textMuted(context),
            fontFamily: 'monospace',
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18),
              onPressed: onEdit,
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              color: DeckColors.statusError,
              onPressed: onDelete,
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}
