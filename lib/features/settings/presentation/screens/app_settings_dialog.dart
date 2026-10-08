import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/l10n_x.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/theme/deck_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/deck_card.dart';

Future<void> showAppSettingsDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => const Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: AppSettingsCard(),
    ),
  );
}

class AppSettingsCard extends ConsumerWidget {
  const AppSettingsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final currentTheme = ref.watch(themeModeProvider);
    final currentLocale = ref.watch(localeProvider);

    return Container(
      constraints: const BoxConstraints(maxWidth: 540),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DeckColors.card(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DeckColors.subtleBorder(context), width: 0.8),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: DeckColors.accentIndigo.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.settings_rounded, color: DeckColors.accentIndigo, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.settings_title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: DeckColors.textPrimary(context),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 1. Appearance & Theme
            Text(
              l10n.settings_appearance,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: DeckColors.accentIndigo,
              ),
            ),
            const SizedBox(height: 10),
            DeckCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.settings_theme_mode, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: DeckColors.textPrimary(context))),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<ThemeMode>(
                      segments: [
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text(l10n.settings_theme_system, style: const TextStyle(fontSize: 12)),
                          icon: const Icon(Icons.brightness_auto_rounded, size: 16),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text(l10n.settings_theme_dark, style: const TextStyle(fontSize: 12)),
                          icon: const Icon(Icons.dark_mode_rounded, size: 16),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text(l10n.settings_theme_light, style: const TextStyle(fontSize: 12)),
                          icon: const Icon(Icons.light_mode_rounded, size: 16),
                        ),
                      ],
                      selected: {currentTheme},
                      onSelectionChanged: (selected) {
                        ref.read(themeModeProvider.notifier).setThemeMode(selected.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Language
            Text(
              l10n.settings_language,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: DeckColors.accentIndigo,
              ),
            ),
            const SizedBox(height: 10),
            DeckCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.settings_language, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: DeckColors.textPrimary(context))),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<String>(
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. About
            Text(
              l10n.settings_about,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: DeckColors.accentIndigo,
              ),
            ),
            const SizedBox(height: 10),
            DeckCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [DeckColors.accentIndigo, DeckColors.accentCyan],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.dns_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${l10n.appName} v1.0.0',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: DeckColors.textPrimary(context),
                          ),
                        ),
                        const SizedBox(height: 2),
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
            ),
          ],
        ),
      ),
    );
  }
}
