import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/settings/settings_provider.dart';
import '../l10n/app_localizations.dart';
import 'router.dart';
import 'theme.dart';

class BabyTrackerApp extends ConsumerWidget {
  const BabyTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeFor(settings.tone),
      // null = follow the device language.
      locale: settings.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      // Spanish first so it stays the fallback for unsupported device locales.
      supportedLocales: const [Locale('es'), Locale('en')],
      routerConfig: router,
    );
  }
}
