import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = 'onedeck_app_locale';

/// Manages the active application [Locale].
/// A `null` value indicates following the operating system's locale.
class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier(this._prefs) : super(_loadInitialLocale(_prefs));

  final SharedPreferences? _prefs;

  static Locale? _loadInitialLocale(SharedPreferences? prefs) {
    final languageCode = prefs?.getString(_kLocaleStorageKey);
    if (languageCode == null || languageCode.isEmpty) {
      return null; // System default
    }
    return Locale(languageCode);
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    if (locale == null) {
      await _prefs?.remove(_kLocaleStorageKey);
    } else {
      await _prefs?.setString(_kLocaleStorageKey, locale.languageCode);
    }
  }

  Future<void> setLanguageCode(String code) async {
    if (code == 'system') {
      await setLocale(null);
    } else {
      await setLocale(Locale(code));
    }
  }
}

/// Provider for SharedPreferences instance.
final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) => null);

/// Provider for managing app locale state with persistence.
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});
