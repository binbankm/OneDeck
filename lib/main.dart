import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/localization/l10n_x.dart';
import 'core/localization/locale_provider.dart';
import 'core/theme/deck_colors.dart';
import 'core/theme/deck_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/widgets/adaptive_scaffold.dart';
import 'core/widgets/deck_card.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure edge-to-edge system UI styling
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const OneDeckApp(),
      ),
    ),
  );
}

/// The root application widget for OneDeck.
class OneDeckApp extends ConsumerWidget {
  const OneDeckApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLocale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'OneDeck',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context) ?? activeLocale,
      themeMode: themeMode,
      theme: DeckTheme.lightTheme,
      darkTheme: DeckTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        final previewChild = DevicePreview.appBuilder(context, child);
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(
            textScaler: mq.textScaler.clamp(
              minScaleFactor: 0.85,
              maxScaleFactor: 1.18,
            ),
          ),
          child: previewChild,
        );
      },
      home: const OneDeckHomeScreen(),
    );
  }
}

/// The main dashboard screen hosting the adaptive layout shell and active module view.
class OneDeckHomeScreen extends ConsumerWidget {
  const OneDeckHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeNavId = ref.watch(activeNavIdProvider);

    Widget content;
    switch (activeNavId) {
      case 'dashboard':
        content = const DashboardScreen();
        break;
      default:
        content = _buildModulePlaceholder(context, ref, activeNavId);
        break;
    }

    return AdaptiveScaffold(child: content);
  }

  Widget _buildModulePlaceholder(BuildContext context, WidgetRef ref, String navId) {
    final navItems = AdaptiveScaffold.getNavItems(context);
    final item = navItems.where((i) => i.id == navId).firstOrNull;

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 360;
          return SingleChildScrollView(
            padding: EdgeInsets.all(isNarrow ? 12 : 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: DeckCard(
                padding: EdgeInsets.all(isNarrow ? 16 : 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item != null) ...[
                      Container(
                        padding: EdgeInsets.all(isNarrow ? 10 : 14),
                        decoration: BoxDecoration(
                          color: DeckColors.accentIndigo.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(item.icon, size: isNarrow ? 24 : 32, color: DeckColors.accentIndigo),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        item.label(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isNarrow ? 16 : 18,
                          fontWeight: FontWeight.bold,
                          color: DeckColors.textPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Text(
                      '此模块已准备就绪，即将连接 1Panel V2 真实数据。',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: DeckColors.textMuted(context)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
