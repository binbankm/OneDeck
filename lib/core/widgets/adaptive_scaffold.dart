import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../localization/l10n_x.dart';
import 'dart:ui' show ImageFilter;
import '../theme/deck_colors.dart';
import 'deck_atmosphere.dart';
import '../../features/server/presentation/widgets/server_switcher_pill.dart';
import '../../features/settings/presentation/screens/app_settings_dialog.dart';

final activeNavIdProvider = StateProvider<String>((ref) => 'dashboard');
final sidebarCollapsedProvider = StateProvider<bool>((ref) => false);

/// Definition for a primary sidebar navigation item.
class NavItemDef {
  final String id;
  final IconData icon;
  final String Function(BuildContext) label;
  final String group;

  const NavItemDef({
    required this.id,
    required this.icon,
    required this.label,
    required this.group,
  });
}

/// A responsive, state-of-the-art titanium navigation shell for OneDeck.
class AdaptiveScaffold extends ConsumerWidget {
  final Widget child;

  const AdaptiveScaffold({
    super.key,
    required this.child,
  });

  /// Master list of all sidebar & tab navigation routes.
  static List<NavItemDef> getNavItems(BuildContext context) {
    return [
      // 1. Overview (监控与概览)
      NavItemDef(id: 'dashboard', icon: LucideIcons.layoutDashboard, label: (c) => c.l10n.nav_dashboard, group: 'overview'),
      NavItemDef(id: 'host', icon: LucideIcons.activity, label: (c) => c.l10n.nav_host, group: 'overview'),

      // 2. Apps & Services (应用与服务)
      NavItemDef(id: 'appstore', icon: LucideIcons.store, label: (c) => c.l10n.nav_app_store, group: 'apps'),
      NavItemDef(id: 'website', icon: LucideIcons.globe, label: (c) => c.l10n.nav_website, group: 'apps'),
      NavItemDef(id: 'container', icon: LucideIcons.box, label: (c) => c.l10n.nav_container, group: 'apps'),
      NavItemDef(id: 'database', icon: LucideIcons.database, label: (c) => c.l10n.nav_database, group: 'apps'),

      // 3. Ops & System (系统与运维)
      NavItemDef(id: 'file', icon: LucideIcons.folder, label: (c) => c.l10n.nav_file, group: 'ops'),
      NavItemDef(id: 'terminal', icon: LucideIcons.terminal, label: (c) => c.l10n.nav_terminal, group: 'ops'),
      NavItemDef(id: 'cronjob', icon: LucideIcons.clock, label: (c) => c.l10n.nav_cronjob, group: 'ops'),
      NavItemDef(id: 'supervisor', icon: LucideIcons.cpu, label: (c) => c.l10n.nav_supervisor, group: 'ops'),
      NavItemDef(id: 'toolbox', icon: LucideIcons.wrench, label: (c) => c.l10n.nav_toolbox, group: 'ops'),

      // 4. Security & Hub (安全与全局)
      NavItemDef(id: 'firewall', icon: LucideIcons.shield, label: (c) => c.l10n.nav_firewall, group: 'security'),
      NavItemDef(id: 'log', icon: LucideIcons.fileText, label: (c) => c.l10n.nav_log, group: 'security'),
      NavItemDef(id: 'panel_settings', icon: LucideIcons.sliders, label: (c) => c.l10n.nav_panel_settings, group: 'security'),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 840;

    return Scaffold(
      backgroundColor: DeckColors.canvas(context),
      body: DeckAtmosphere(
        child: isDesktop
            ? _buildDesktopLayout(context, ref)
            : _buildMobileLayout(context, ref),
      ),
      bottomNavigationBar: isDesktop ? null : _buildMobileBottomBar(context, ref),
    );
  }

  // ---------------------------------------------------------------------------
  // DESKTOP LAYOUT (>= 840px)
  // ---------------------------------------------------------------------------
  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCollapsed = ref.watch(sidebarCollapsedProvider);
    final activeId = ref.watch(activeNavIdProvider);
    final navItems = getNavItems(context);

    return Row(
      children: [
        // Left Sidebar with Signature Frosted Glass & Atmospheric Translucency
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: isCollapsed ? 68 : 236,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            DeckColors.darkCard.withValues(alpha: 0.78),
                            DeckColors.darkSidebar.withValues(alpha: 0.85),
                          ]
                        : [
                            Colors.white.withValues(alpha: 0.80),
                            const Color(0xFFF6F7FA).withValues(alpha: 0.68),
                          ],
                  ),
                  border: Border(
                    right: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.10)
                          : Colors.black.withValues(alpha: 0.07),
                      width: 0.8,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    // Sidebar Logo Header
                    _buildSidebarHeader(context, ref, isCollapsed),
                    Divider(
                      height: 1,
                      thickness: 0.8,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.06),
                    ),
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
                    Divider(
                      height: 1,
                      thickness: 0.8,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.06),
                    ),
                    // Sidebar Footer Actions
                    _buildSidebarFooter(context, ref, isCollapsed),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Right Main Content Pane (Zero top bar, pure cockpit immersion)
        Expanded(
          child: child,
        ),
      ],
    );
  }



  Widget _buildSidebarHeader(BuildContext context, WidgetRef ref, bool isCollapsed) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showFull = !isCollapsed && constraints.maxWidth > 110;
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: showFull ? 12 : 6,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: showFull ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Brand Logo & Name
              Row(
                mainAxisAlignment: showFull ? MainAxisAlignment.start : MainAxisAlignment.center,
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
                  if (showFull) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        context.l10n.appName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: DeckColors.textPrimary(context),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              // Server Switcher Integrated into Left Sidebar
              const ServerSwitcherPill(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavSection(
    BuildContext context,
    WidgetRef ref,
    List<NavItemDef> allItems,
    String groupKey,
    String groupLabel,
    bool isCollapsed,
    String activeId,
  ) {
    final sectionItems = allItems.where((i) => i.group == groupKey).toList();
    if (sectionItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isCollapsed)
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 6, top: 10),
            child: Text(
              groupLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: DeckColors.textMuted(context),
                letterSpacing: 0.3,
              ),
            ),
          ),
        ...sectionItems.map((item) {
          final isSelected = item.id == activeId;
          return _SidebarNavItem(
            item: item,
            isSelected: isSelected,
            isCollapsed: isCollapsed,
            onTap: () => ref.read(activeNavIdProvider.notifier).state = item.id,
          );
        }),
      ],
    );
  }

  Widget _buildSidebarFooter(BuildContext context, WidgetRef ref, bool isCollapsed) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showFull = !isCollapsed && constraints.maxWidth > 140;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: showFull ? 10 : 4, vertical: 10),
          child: !showFull
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: context.l10n.settings_title,
                      icon: const Icon(LucideIcons.settings, size: 17),
                      color: DeckColors.textMuted(context),
                      onPressed: () => showAppSettingsDialog(context),
                    ),
                    const SizedBox(height: 4),
                    IconButton(
                      tooltip: context.l10n.dashboard_sidebar_expand,
                      icon: const Icon(Icons.keyboard_double_arrow_right_rounded, size: 17),
                      color: DeckColors.textMuted(context),
                      onPressed: () {
                        ref.read(sidebarCollapsedProvider.notifier).state = false;
                      },
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => showAppSettingsDialog(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.settings, size: 15, color: DeckColors.textMuted(context)),
                            const SizedBox(width: 8),
                            Text(
                              context.l10n.settings_title,
                              style: TextStyle(
                                fontSize: 12,
                                color: DeckColors.textSecondary(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: context.l10n.dashboard_sidebar_collapse,
                      icon: Icon(
                        Icons.keyboard_double_arrow_left_rounded,
                        size: 17,
                        color: DeckColors.textMuted(context),
                      ),
                      onPressed: () {
                        ref.read(sidebarCollapsedProvider.notifier).state = true;
                      },
                    ),
                  ],
                ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // MOBILE / COMPACT LAYOUT (< 840px)
  // ---------------------------------------------------------------------------
  Widget _buildMobileLayout(BuildContext context, WidgetRef ref) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Top Mobile App Bar with Integrated Pill
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                height: 54,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: DeckColors.card(context).withValues(alpha: 0.78),
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withValues(alpha: 0.10)
                          : Colors.black.withValues(alpha: 0.08),
                      width: 0.8,
                    ),
                  ),
                ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isSuperCompact = constraints.maxWidth < 350;
                return Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [DeckColors.accentIndigo, DeckColors.accentCyan],
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Icon(LucideIcons.terminal, color: Colors.white, size: 14),
                    ),
                    if (!isSuperCompact) ...[
                      const SizedBox(width: 8),
                      Text(
                        'OneDeck',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          color: DeckColors.textPrimary(context),
                        ),
                      ),
                    ],
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ServerSwitcherPill(),
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      tooltip: context.l10n.settings_title,
                      icon: const Icon(LucideIcons.settings, size: 18),
                      onPressed: () => showAppSettingsDialog(context),
                    ),
                  ],
                );
              },
            ),
              ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final mainItems = [
      ('dashboard', LucideIcons.layoutDashboard, context.l10n.nav_dashboard),
      ('website', LucideIcons.globe, context.l10n.nav_website),
      ('container', LucideIcons.box, context.l10n.nav_container),
      ('file', LucideIcons.folder, context.l10n.nav_file),
    ];

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: DeckColors.card(context).withValues(alpha: isDark ? 0.82 : 0.88),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.10)
                    : Colors.black.withValues(alpha: 0.08),
                width: 0.8,
              ),
            ),
          ),
          child: Row(
        children: [
          ...mainItems.map((item) {
            final isSelected = item.$1 == activeId;
            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => ref.read(activeNavIdProvider.notifier).state = item.$1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.$2,
                        size: 20,
                        color: isSelected
                            ? DeckColors.accentIndigo
                            : DeckColors.textMuted(context),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.$3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected
                              ? DeckColors.accentIndigo
                              : DeckColors.textMuted(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          // More Menu button
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _showAllModulesDrawer(context, ref),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.moreHorizontal, size: 20, color: DeckColors.textMuted(context)),
                    const SizedBox(height: 3),
                    Text(
                      context.l10n.common_more,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10, color: DeckColors.textMuted(context)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
        ),
      ),
    );
  }

  void _showAllModulesDrawer(BuildContext context, WidgetRef ref) {
    const bottomBarIds = {'dashboard', 'website', 'container', 'file'};
    final allItems = getNavItems(context);
    final moreItems = allItems.where((item) => !bottomBarIds.contains(item.id)).toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.75,
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            decoration: BoxDecoration(
              color: DeckColors.card(context).withValues(alpha: isDark ? 0.88 : 0.94),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(color: DeckColors.subtleBorder(context), width: 0.8),
            ),
        child: SingleChildScrollView(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.common_more,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: DeckColors.textPrimary(context)),
                  ),
                  Text(
                    context.l10n.dashboard_more_modules_count(moreItems.length.toString()),
                    style: TextStyle(fontSize: 12, color: DeckColors.textMuted(context)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = (constraints.maxWidth - 36) / 4;
                  final cardWidth = itemWidth < 70 ? (constraints.maxWidth - 24) / 3 : itemWidth;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: moreItems.map((item) {
                      final isSelected = ref.watch(activeNavIdProvider) == item.id;

                      Color tileBg;
                      Border? tileBorder;
                      List<BoxShadow>? tileShadows;

                      if (isSelected) {
                        if (isDark) {
                          tileBg = Colors.white.withValues(alpha: 0.08);
                          tileBorder = Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                            width: 0.7,
                          );
                          tileShadows = [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ];
                        } else {
                          tileBg = Colors.white;
                          tileBorder = Border.all(
                            color: Colors.black.withValues(alpha: 0.06),
                            width: 0.7,
                          );
                          tileShadows = [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ];
                        }
                      } else {
                        tileBg = isDark ? Colors.white.withValues(alpha: 0.02) : DeckColors.canvas(context);
                        tileBorder = Border.all(
                          color: DeckColors.subtleBorder(context).withValues(alpha: 0.6),
                          width: 0.7,
                        );
                        tileShadows = null;
                      }

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          ref.read(activeNavIdProvider.notifier).state = item.id;
                          Navigator.of(ctx).pop();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 140),
                          width: cardWidth,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                          decoration: BoxDecoration(
                            color: tileBg,
                            borderRadius: BorderRadius.circular(12),
                            border: tileBorder,
                            boxShadow: tileShadows,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                item.icon,
                                size: 22,
                                color: isSelected ? DeckColors.accentIndigo : DeckColors.textSecondary(context),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.label(context),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: isSelected ? DeckColors.textPrimary(context) : DeckColors.textSecondary(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
        ),
      ),
    );
  }
}

class _SidebarNavItem extends StatefulWidget {
  final NavItemDef item;
  final bool isSelected;
  final bool isCollapsed;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.item,
    required this.isSelected,
    required this.isCollapsed,
    required this.onTap,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Border? border;
    List<BoxShadow>? shadows;

    Color? bgColor;
    Gradient? bgGradient;

    if (widget.isSelected) {
      if (isDark) {
        bgGradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DeckColors.accentIndigo.withValues(alpha: 0.28),
            Colors.white.withValues(alpha: 0.08),
          ],
        );
        border = Border.all(
          color: DeckColors.accentIndigo.withValues(alpha: 0.45),
          width: 0.8,
        );
        shadows = [
          BoxShadow(
            color: DeckColors.accentIndigo.withValues(alpha: 0.20),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ];
      } else {
        bgGradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DeckColors.accentIndigo.withValues(alpha: 0.12),
            Colors.white.withValues(alpha: 0.95),
          ],
        );
        border = Border.all(
          color: DeckColors.accentIndigo.withValues(alpha: 0.25),
          width: 0.8,
        );
        shadows = [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: -1,
          ),
          BoxShadow(
            color: DeckColors.accentIndigo.withValues(alpha: 0.10),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ];
      }
    } else if (_isHovered) {
      bgColor = isDark
          ? Colors.white.withValues(alpha: 0.06)
          : Colors.black.withValues(alpha: 0.04);
      border = null;
      shadows = null;
    } else {
      bgColor = Colors.transparent;
      border = null;
      shadows = null;
    }

    final accentColor = DeckColors.accentIndigo;
    final itemIconColor = widget.isSelected
        ? accentColor
        : (_isHovered
            ? DeckColors.textPrimary(context)
            : DeckColors.textSecondary(context));

    final itemTextColor = widget.isSelected
        ? DeckColors.textPrimary(context)
        : (_isHovered
            ? DeckColors.textPrimary(context)
            : DeckColors.textSecondary(context));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: MouseRegion(
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
          behavior: HitTestBehavior.opaque,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final showFull = !widget.isCollapsed && constraints.maxWidth > 90;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(
                  horizontal: showFull ? 9 : 6,
                  vertical: 7.5,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  gradient: bgGradient,
                  borderRadius: BorderRadius.circular(9),
                  border: border,
                  boxShadow: shadows,
                ),
                child: showFull
                    ? Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 3,
                            height: 14,
                            margin: const EdgeInsets.only(right: 7),
                            decoration: BoxDecoration(
                              color: widget.isSelected
                                  ? accentColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Icon(
                            widget.item.icon,
                            size: 16.5,
                            color: itemIconColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.item.label(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: widget.isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: itemTextColor,
                                letterSpacing: -0.1,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Icon(
                          widget.item.icon,
                          size: 17,
                          color: itemIconColor,
                        ),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}
