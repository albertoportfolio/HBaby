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
  /// `null` means "follow the device language" (default until the user
  /// explicitly picks a language in settings).
  final Locale? locale;
  final AppThemeTone tone;

  // ── One-tap quick-log defaults ────────────────────────────────────────────
  /// Feeding type stored as its DB string value (see FeedingType.value).
  final String defaultFeedingType;

  /// Volume in ml used when the default feeding type is a bottle.
  final double defaultFeedingAmountMl;

  /// Duration in minutes used when the default feeding type is breast.
  final int defaultFeedingDurationMinutes;

  /// Duration in minutes of the nap logged by the quick-nap button.
  final int defaultNapMinutes;

  const AppSettings({
    this.locale,
    this.tone = AppThemeTone.pink,
    this.defaultFeedingType = 'breast_left',
    this.defaultFeedingAmountMl = 120,
    this.defaultFeedingDurationMinutes = 15,
    this.defaultNapMinutes = 60,
  });

  AppSettings copyWith({
    Locale? locale,
    AppThemeTone? tone,
    String? defaultFeedingType,
    double? defaultFeedingAmountMl,
    int? defaultFeedingDurationMinutes,
    int? defaultNapMinutes,
  }) {
    return AppSettings(
      locale: locale ?? this.locale,
      tone: tone ?? this.tone,
      defaultFeedingType: defaultFeedingType ?? this.defaultFeedingType,
      defaultFeedingAmountMl:
          defaultFeedingAmountMl ?? this.defaultFeedingAmountMl,
      defaultFeedingDurationMinutes:
          defaultFeedingDurationMinutes ?? this.defaultFeedingDurationMinutes,
      defaultNapMinutes: defaultNapMinutes ?? this.defaultNapMinutes,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  static const _localeKey = 'settings.locale';
  static const _toneKey = 'settings.tone';
  static const _feedingTypeKey = 'settings.defaultFeedingType';
  static const _feedingAmountKey = 'settings.defaultFeedingAmountMl';
  static const _feedingDurationKey = 'settings.defaultFeedingDurationMinutes';
  static const _napMinutesKey = 'settings.defaultNapMinutes';

  final SharedPreferences _prefs;

  SettingsNotifier(this._prefs) : super(_load(_prefs));

  static AppSettings _load(SharedPreferences prefs) {
    final localeCode = prefs.getString(_localeKey);
    const defaults = AppSettings();
    return AppSettings(
      locale: localeCode == null ? null : Locale(localeCode),
      tone: AppThemeTone.fromValue(prefs.getString(_toneKey)),
      defaultFeedingType:
          prefs.getString(_feedingTypeKey) ?? defaults.defaultFeedingType,
      defaultFeedingAmountMl:
          prefs.getDouble(_feedingAmountKey) ?? defaults.defaultFeedingAmountMl,
      defaultFeedingDurationMinutes: prefs.getInt(_feedingDurationKey) ??
          defaults.defaultFeedingDurationMinutes,
      defaultNapMinutes:
          prefs.getInt(_napMinutesKey) ?? defaults.defaultNapMinutes,
    );
  }

  Future<void> setLocale(Locale locale) async {
    state = state.copyWith(locale: locale);
    await _prefs.setString(_localeKey, locale.languageCode);
  }

  Future<void> setTone(AppThemeTone tone) async {
    state = state.copyWith(tone: tone);
    await _prefs.setString(_toneKey, tone.value);
  }

  Future<void> setDefaultFeedingType(String typeValue) async {
    state = state.copyWith(defaultFeedingType: typeValue);
    await _prefs.setString(_feedingTypeKey, typeValue);
  }

  Future<void> setDefaultFeedingAmountMl(double amount) async {
    state = state.copyWith(defaultFeedingAmountMl: amount);
    await _prefs.setDouble(_feedingAmountKey, amount);
  }

  Future<void> setDefaultFeedingDurationMinutes(int minutes) async {
    state = state.copyWith(defaultFeedingDurationMinutes: minutes);
    await _prefs.setInt(_feedingDurationKey, minutes);
  }

  Future<void> setDefaultNapMinutes(int minutes) async {
    state = state.copyWith(defaultNapMinutes: minutes);
    await _prefs.setInt(_napMinutesKey, minutes);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier(ref.watch(sharedPreferencesProvider));
});
