import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/locale_provider.dart';

const _kThemeModeStorageKey = 'onedeck_app_theme_mode';

/// Notifier to manage the active [ThemeMode] across the app with persistence.
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._prefs) : super(_loadInitialThemeMode(_prefs));

  final SharedPreferences? _prefs;

  static ThemeMode _loadInitialThemeMode(SharedPreferences? prefs) {
    final modeString = prefs?.getString(_kThemeModeStorageKey);
    switch (modeString) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final value = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    };
    await _prefs?.setString(_kThemeModeStorageKey, value);
  }
}

/// Provider exposing the current [ThemeMode] and methods to change it.
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});
