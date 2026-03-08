import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const supportedAppLocales = <Locale>[Locale('de'), Locale('en')];
const fallbackAppLocale = Locale('de');

const _localePreferenceKey = 'app_locale_preference';

enum AppLocalePreference { system, de, en }

extension AppLocalePreferenceX on AppLocalePreference {
  String get storageValue {
    switch (this) {
      case AppLocalePreference.system:
        return 'system';
      case AppLocalePreference.de:
        return 'de';
      case AppLocalePreference.en:
        return 'en';
    }
  }

  Locale? get locale {
    switch (this) {
      case AppLocalePreference.system:
        return null;
      case AppLocalePreference.de:
        return const Locale('de');
      case AppLocalePreference.en:
        return const Locale('en');
    }
  }

  static AppLocalePreference fromStorage(String? value) {
    switch (value) {
      case 'de':
        return AppLocalePreference.de;
      case 'en':
        return AppLocalePreference.en;
      default:
        return AppLocalePreference.system;
    }
  }
}

class AppLocaleState {
  const AppLocaleState({required this.preference});

  final AppLocalePreference preference;

  Locale? get locale => preference.locale;
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main().');
});

class AppLocaleNotifier extends Notifier<AppLocaleState> {
  @override
  AppLocaleState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_localePreferenceKey);
    final preference = AppLocalePreferenceX.fromStorage(stored);
    return AppLocaleState(preference: preference);
  }

  void setPreference(AppLocalePreference preference) {
    state = AppLocaleState(preference: preference);
    ref
        .read(sharedPreferencesProvider)
        .setString(_localePreferenceKey, preference.storageValue);
  }
}

final appLocaleProvider = NotifierProvider<AppLocaleNotifier, AppLocaleState>(
  AppLocaleNotifier.new,
);
