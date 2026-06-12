# H Baby — Baby Tracker

Flutter app to manage a baby's daily routine and growth: milk/food feedings,
sleep sessions and weight records. All data is stored **locally** on the
device with SQLite; there is no backend and no network access.

## Features

- 👶 **Multi-baby**: register several babies and switch between them from any
  screen; the rest of the app is filtered by the selected baby.
- 🍼 **Feeding**: breast (left/right, duration in minutes) or bottle
  (formula/breast milk, amount in ml), with history grouped by day.
- 😴 **Sleep**: log finished naps or start an "ongoing" session that shows as
  an active banner until you stop it.
- ⚖️ **Weight**: growth tracking with the difference from the previous
  measurement.
- 🏠 **Dashboard**: today's summary (feedings, accumulated sleep, latest
  weight) and quick actions to add records.
- 🌍 **Multi-language**: Spanish and English. Follows the device language by
  default (with Spanish as fallback) and can be overridden from settings.
- 🎨 **Themes**: four selectable tones — pink, blue, green and dark mode —
  persisted across sessions.

## Tech stack

| Area | Technology |
|---|---|
| State | `flutter_riverpod` (classic providers, no codegen) |
| Navigation | `go_router` with `StatefulShellRoute.indexedStack` (4 tabs) |
| Database | `drift` + `sqlite3_flutter_libs` (local `baby_tracker.sqlite` file) |
| i18n | `flutter_localizations` + `gen-l10n` (`.arb` files in `lib/l10n/`) |
| Preferences | `shared_preferences` (language and theme) |
| Typography | `google_fonts` (Poppins), Material 3 |

## Getting started

```bash
flutter pub get                                            # dependencies
dart run build_runner build --delete-conflicting-outputs   # Drift codegen (*.g.dart)
flutter run                                                # run the app
```

Other useful commands:

```bash
flutter analyze     # static analysis
flutter test        # tests
flutter gen-l10n    # regenerate localizations (also runs on build)
```

> After modifying any table or DAO in `lib/database/`, run `build_runner`
> again. The `*.g.dart` files and `lib/l10n/app_localizations*.dart` are
> generated: never edit them by hand.

## Project structure

```
lib/
├── main.dart                  # initializes intl and prefs; injects AppDatabase via ProviderScope
├── app/                       # MaterialApp.router, GoRouter and themes (AppTheme.themeFor)
├── core/
│   ├── settings/              # settingsProvider: persisted language and color tone
│   ├── utils/                 # DateFormatter, selected_baby_provider, context.l10n extension
│   └── widgets/               # shared widgets (LoadingWidget, EmptyState...)
├── database/
│   ├── app_database.dart      # @DriftDatabase + databaseProvider
│   ├── tables/                # Babies, Feedings, SleepEntries, WeightEntries
│   └── daos/                  # one DAO per table with watch* streams for reactive UI
├── l10n/                      # app_en.arb (template), app_es.arb and generated code
└── features/<feature>/        # baby, feeding, sleep, weight, home, settings
    ├── screens/               # list screen + add screen
    └── ...                    # feature-specific providers, tiles and enums
```

## Internationalization

Every visible string lives in `lib/l10n/app_en.arb` (template) and
`app_es.arb`, and is used in code via `context.l10n.<key>`. To add a string:
add it to both `.arb` files and rebuild (or run `flutter gen-l10n`).
Detailed documentation in [`i10ndoc.txt`](i10ndoc.txt).

## Data conventions

- IDs: UUID v4 stored in text columns.
- Weight: stored in **grams**; the UI asks for kg.
- Feedings: `type` is a string (`breast_left`, `bottle_formula`, ...) mapped
  by the `FeedingType` enum.
- Deletions: always behind a confirmation dialog; FKs use
  `onDelete: cascade`.
- Migrations: bump `schemaVersion` in `app_database.dart` and add the
  migration in `onUpgrade`.

More contributor detail (provider patterns, UI conventions) in
[`CLAUDE.md`](CLAUDE.md).
