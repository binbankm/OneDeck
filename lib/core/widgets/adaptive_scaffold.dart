import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../localization/l10n_x.dart';
import '../theme/deck_colors.dart';
import '../../features/server/presentation/widgets/server_switcher_pill.dart';
import '../../features/settings/presentation/screens/app_settings_dialog.dart';

/// Currently active navigation destination ID across the app.
final activeNavIdProvider = StateProvider<String>((ref) => 'dashboard');

/// Sidebar collapse state on desktop.
final sidebarCollapsedProvider = StateProvider<bool>((ref) => false);

class NavItemDef {
  final String id;
  final IconData icon;
  final String Function(BuildContext context) label;
  final String group;

  const NavItemDef({
    required this.id,
    required this.icon,
    required this.label,
    required this.group,
  });
}

/// The master adaptive shell for OneDeck across Desktop, Tablet, and Mobile.
class AdaptiveScaffold extends ConsumerWidget {
  final Widget child;

  const AdaptiveScaffold({
    super.key,
    required this.child,
  });

  static List<NavItemDef> getNavItems(BuildContext context) {
    return [
      // 1. Overview
      NavItemDef(
        id: 'dashboard',
        icon: LucideIcons.layoutDashboard,
        label: (ctx) => ctx.l10n.nav_dashboard,
        group: 'overview',
      ),
      NavItemDef(
        id: 'host',
        icon: LucideIcons.server,
        label: (ctx) => ctx.l10n.nav_host,
        group: 'overview',
      ),

      // 2. Apps & Services
      NavItemDef(
        id: 'app_store',
        icon: LucideIcons.shoppingBag,
        label: (ctx) => ctx.l10n.nav_app_store,
        group: 'apps',
      ),
      NavItemDef(
        id: 'website',
        icon: LucideIcons.globe,
        label: (ctx) => ctx.l10n.nav_website,
        group: 'apps',
      ),
      NavItemDef(
        id: 'container',
        icon: LucideIcons.box,
        label: (ctx) => ctx.l10n.nav_container,
        group: 'apps',
      ),
      NavItemDef(
        id: 'database',
        icon: LucideIcons.database,
        label: (ctx) => ctx.l10n.nav_database,
        group: 'apps',
      ),

      // 3. Ops & System
      NavItemDef(
        id: 'file',
        icon: LucideIcons.folder,
        label: (ctx) => ctx.l10n.nav_file,
        group: 'ops',
      ),
      NavItemDef(
        id: 'terminal',
        icon: LucideIcons.terminal,
        label: (ctx) => ctx.l10n.nav_terminal,
        group: 'ops',
      ),
      NavItemDef(
        id: 'cronjob',
        icon: LucideIcons.clock,
        label: (ctx) => ctx.l10n.nav_cronjob,
        group: 'ops',
      ),
      NavItemDef(
        id: 'supervisor',
        icon: LucideIcons.shieldAlert,
        label: (ctx) => ctx.l10n.nav_supervisor,
        group: 'ops',
      ),
      NavItemDef(
        id: 'toolbox',
        icon: LucideIcons.wrench,
        label: (ctx) => ctx.l10n.nav_toolbox,
        group: 'ops',
      ),

      // 4. Security & Hub
      NavItemDef(
        id: 'firewall',
        icon: LucideIcons.shieldCheck,
        label: (ctx) => ctx.l10n.nav_firewall,
        group: 'security',
      ),
      NavItemDef(
        id: 'log',
        icon: LucideIcons.fileText,
        label: (ctx) => ctx.l10n.nav_log,
        group: 'security',
      ),
      NavItemDef(
        id: 'panel_settings',
        icon: LucideIcons.sliders,
        label: (ctx) => ctx.l10n.nav_panel_settings,
        group: 'security',
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 840;

    return Scaffold(
      backgroundColor: DeckColors.canvas(context),
      body: isDesktop
          ? _buildDesktopLayout(context, ref)
          : _buildMobileLayout(context, ref),
      bottomNavigationBar: isDesktop ? null : _buildMobileBottomBar(context, ref),
    );
  }

  // ---------------------------------------------------------------------------
  // DESKTOP LAYOUT (>= 840px)
  // ---------------------------------------------------------------------------
  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref) {
    final isCollapsed = ref.watch(sidebarCollapsedProvider);
    final activeId = ref.watch(activeNavIdProvider);
    final navItems = getNavItems(context);

    return Row(
      children: [
        // Left Sidebar
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: isCollapsed ? 68 : 236,
          decoration: BoxDecoration(
            color: DeckColors.sidebar(context),
            border: Border(
              right: BorderSide(color: DeckColors.subtleBorder(context), width: 0.8),
            ),
          ),
          child: Column(
            children: [
              // Sidebar Logo Header
              _buildSidebarHeader(context, ref, isCollapsed),
              const Divider(),
              // Navigation Items List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  children: [
                    _buildNavSection(context, ref, navItems, 'overview', context.l10n.group_overview, isCollapsed, activeId),
                    const SizedBox(height: 12),
                    _buildNavSection(context, ref, navItems, 'apps', context.l10n.group_apps, isCollapsed, activeId),
                    const SizedBox(height: 12),
                    _buildNavSection(context, ref, navItems, 'ops', context.l10n.group_ops, isCollapsed, activeId),
                    const SizedBox(height: 12),
                    _buildNavSection(context, ref, navItems, 'security', context.l10n.group_security, isCollapsed, activeId),
                  ],
                ),
              ),
              const Divider(),
              // Sidebar Footer Actions
              _buildSidebarFooter(context, ref, isCollapsed),
            ],
          ),
        ),

        // Right Main Content Pane
        Expanded(
          child: Column(
            children: [
              // Top Bar
              _buildDesktopTopBar(context, ref),
              const Divider(),
              // Active Content
              Expanded(child: child),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarHeader(BuildContext context, WidgetRef ref, bool isCollapsed) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 12 : 16),
      child: Row(
        mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [DeckColors.accentIndigo, DeckColors.accentCyan],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.dns_rounded, color: Colors.white, size: 18),
          ),
          if (!isCollapsed) ...[
            const SizedBox(width: 12),
            Text(
              context.l10n.appName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: DeckColors.textPrimary(context),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavSection(
    BuildContext context,
    WidgetRef ref,
    List<NavItemDef> allItems,
    String groupKey,
    String groupTitle,
    bool isCollapsed,
    String activeId,
  ) {
    final items = allItems.where((i) => i.group == groupKey).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isCollapsed)
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 6, top: 4),
            child: Text(
              groupTitle.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: DeckColors.textMuted(context),
                letterSpacing: 0.6,
              ),
            ),
          ),
        ...items.map((item) {
          final isSelected = item.id == activeId;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Tooltip(
              message: isCollapsed ? item.label(context) : '',
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => ref.read(activeNavIdProvider.notifier).state = item.id,
                child: Container(
                  height: 38,
                  padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 0 : 12),
                  decoration: BoxDecoration(
                    color: isSelected ? DeckColors.accentIndigo.withValues(alpha: 0.12) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? DeckColors.accentIndigo.withValues(alpha: 0.5) : Colors.transparent,
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                    children: [
                      Icon(
                        item.icon,
                        size: 18,
                        color: isSelected ? DeckColors.accentIndigo : DeckColors.textSecondary(context),
                      ),
                      if (!isCollapsed) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.label(context),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? DeckColors.accentIndigo : DeckColors.textPrimary(context),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSidebarFooter(BuildContext context, WidgetRef ref, bool isCollapsed) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            tooltip: context.l10n.settings_title,
            icon: const Icon(LucideIcons.settings, size: 18),
            onPressed: () => showAppSettingsDialog(context),
          ),
          if (!isCollapsed)
            IconButton(
              tooltip: 'Collapse sidebar',
              icon: const Icon(LucideIcons.panelLeftClose, size: 18),
              onPressed: () => ref.read(sidebarCollapsedProvider.notifier).state = true,
            )
          else
            IconButton(
              tooltip: 'Expand sidebar',
              icon: const Icon(LucideIcons.panelLeftOpen, size: 18),
              onPressed: () => ref.read(sidebarCollapsedProvider.notifier).state = false,
            ),
        ],
      ),
    );
  }

  Widget _buildDesktopTopBar(BuildContext context, WidgetRef ref) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: DeckColors.card(context),
      child: Row(
        children: [
          // Active Server Switcher Pill
          const ServerSwitcherPill(),
          const Spacer(),
          // Preferences Shortcut
          IconButton(
            tooltip: context.l10n.settings_title,
            icon: const Icon(LucideIcons.settings, size: 18),
            onPressed: () => showAppSettingsDialog(context),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MOBILE LAYOUT (< 840px)
  // ---------------------------------------------------------------------------
  Widget _buildMobileLayout(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        children: [
          // Mobile Top Bar
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: DeckColors.card(context),
              border: Border(bottom: BorderSide(color: DeckColors.subtleBorder(context), width: 0.8)),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [DeckColors.accentIndigo, DeckColors.accentCyan],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.dns_rounded, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 12),
                const ServerSwitcherPill(),
                const Spacer(),
                IconButton(
                  icon: const Icon(LucideIcons.settings, size: 18),
                  onPressed: () => showAppSettingsDialog(context),
                ),
              ],
            ),
          ),
          // Content
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildMobileBottomBar(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeNavIdProvider);

    final mainItems = [
      ('dashboard', LucideIcons.layoutDashboard, context.l10n.nav_dashboard),
      ('website', LucideIcons.globe, context.l10n.nav_website),
      ('container', LucideIcons.box, context.l10n.nav_container),
      ('file', LucideIcons.folder, context.l10n.nav_file),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: DeckColors.card(context),
        border: Border(top: BorderSide(color: DeckColors.subtleBorder(context), width: 0.8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ...mainItems.map((item) {
            final isSelected = item.$1 == activeId;
            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => ref.read(activeNavIdProvider.notifier).state = item.$1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.$2,
                      size: 20,
                      color: isSelected ? DeckColors.accentIndigo : DeckColors.textSecondary(context),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.$3,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? DeckColors.accentIndigo : DeckColors.textMuted(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          // More Menu button
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showAllModulesDrawer(context, ref),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.moreHorizontal, size: 20, color: DeckColors.textSecondary(context)),
                  const SizedBox(height: 2),
                  Text(
                    context.l10n.common_more,
                    style: TextStyle(fontSize: 10, color: DeckColors.textMuted(context)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAllModulesDrawer(BuildContext context, WidgetRef ref) {
    final navItems = getNavItems(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: DeckColors.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: DeckColors.subtleBorder(context), width: 0.8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: DeckColors.textMuted(context).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              context.l10n.common_more,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: DeckColors.textPrimary(context)),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: navItems.map((item) {
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    ref.read(activeNavIdProvider.notifier).state = item.id;
                    Navigator.of(ctx).pop();
                  },
                  child: Container(
                    width: 96,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: DeckColors.canvas(context),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: DeckColors.subtleBorder(context), width: 0.8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(item.icon, size: 22, color: DeckColors.accentIndigo),
                        const SizedBox(height: 6),
                        Text(
                          item.label(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: DeckColors.textPrimary(context)),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
