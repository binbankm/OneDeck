import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/localization/l10n_x.dart';
import 'core/localization/locale_provider.dart';
import 'core/theme/deck_colors.dart';
import 'core/theme/deck_theme.dart';
import 'core/theme/theme_provider.dart';

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
      child: const OneDeckApp(),
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
      locale: activeLocale,
      themeMode: themeMode,
      theme: DeckTheme.lightTheme,
      darkTheme: DeckTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const OneDeckPlaceholderScreen(),
    );
  }
}

/// Temporary placeholder screen to showcase the active theme and i18n
class OneDeckPlaceholderScreen extends ConsumerWidget {
  const OneDeckPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final currentTheme = ref.watch(themeModeProvider);
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: DeckColors.card(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: DeckColors.subtleBorder(context),
              width: 0.8,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [DeckColors.accentIndigo, DeckColors.accentCyan],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.dns_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.appName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: DeckColors.textPrimary(context),
                        ),
                      ),
                      Text(
                        l10n.appSlogan,
                        style: TextStyle(
                          fontSize: 12,
                          color: DeckColors.textMuted(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              // Theme Switcher row
              Text(
                l10n.settings_theme_mode,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: DeckColors.textSecondary(context),
                ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text(l10n.settings_theme_system, style: const TextStyle(fontSize: 12)),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text(l10n.settings_theme_dark, style: const TextStyle(fontSize: 12)),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text(l10n.settings_theme_light, style: const TextStyle(fontSize: 12)),
                  ),
                ],
                selected: {currentTheme},
                onSelectionChanged: (selected) {
                  ref.read(themeModeProvider.notifier).setThemeMode(selected.first);
                },
              ),
              const SizedBox(height: 18),
              // Language Switcher row
              Text(
                l10n.settings_language,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: DeckColors.textSecondary(context),
                ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'system',
                    label: Text(l10n.settings_lang_system, style: const TextStyle(fontSize: 12)),
                  ),
                  ButtonSegment(
                    value: 'zh',
                    label: Text(l10n.settings_lang_zh, style: const TextStyle(fontSize: 12)),
                  ),
                  ButtonSegment(
                    value: 'en',
                    label: Text(l10n.settings_lang_en, style: const TextStyle(fontSize: 12)),
                  ),
                ],
                selected: {
                  currentLocale == null ? 'system' : currentLocale.languageCode,
                },
                onSelectionChanged: (selected) {
                  ref.read(localeProvider.notifier).setLanguageCode(selected.first);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
