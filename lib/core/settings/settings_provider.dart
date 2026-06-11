import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/l10n_extension.dart';

/// Overridden in main.dart with the real instance, like [databaseProvider].
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Overridden in main.dart'),
);

/// Color tone of the whole app. [dark] is the dark mode.
enum AppThemeTone {
  pink('pink'),
  blue('blue'),
  green('green'),
  dark('dark');

  final String value;

  const AppThemeTone(this.value);

  static AppThemeTone fromValue(String? value) => AppThemeTone.values
      .firstWhere((t) => t.value == value, orElse: () => AppThemeTone.pink);

  String label(BuildContext context) => switch (this) {
        AppThemeTone.pink => context.l10n.themePink,
        AppThemeTone.blue => context.l10n.themeBlue,
        AppThemeTone.green => context.l10n.themeGreen,
        AppThemeTone.dark => context.l10n.themeDark,
      };
}

class AppSettings {
  /// `null` means "follow the device language".
  final Locale? locale;
  final AppThemeTone tone;

  const AppSettings({this.locale, this.tone = AppThemeTone.pink});

  AppSettings copyWith({
    Locale? Function()? locale,
    AppThemeTone? tone,
  }) {
    return AppSettings(
      locale: locale != null ? locale() : this.locale,
      tone: tone ?? this.tone,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  static const _localeKey = 'settings.locale';
  static const _toneKey = 'settings.tone';

  final SharedPreferences _prefs;

  SettingsNotifier(this._prefs) : super(_load(_prefs));

  static AppSettings _load(SharedPreferences prefs) {
    final localeCode = prefs.getString(_localeKey);
    return AppSettings(
      locale: localeCode == null ? null : Locale(localeCode),
      tone: AppThemeTone.fromValue(prefs.getString(_toneKey)),
    );
  }

  /// Pass `null` to follow the device language.
  Future<void> setLocale(Locale? locale) async {
    state = state.copyWith(locale: () => locale);
    if (locale == null) {
      await _prefs.remove(_localeKey);
    } else {
      await _prefs.setString(_localeKey, locale.languageCode);
    }
  }

  Future<void> setTone(AppThemeTone tone) async {
    state = state.copyWith(tone: tone);
    await _prefs.setString(_toneKey, tone.value);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier(ref.watch(sharedPreferencesProvider));
});
