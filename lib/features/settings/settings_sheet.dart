import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/settings/settings_provider.dart';
import '../../core/utils/l10n_extension.dart';

/// Opens the settings bottom sheet (language + app color tone).
Future<void> showSettingsSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (context) => const SettingsSheet(),
  );
}

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(l10n.settingsTitle, style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 16),
            Text(l10n.languageLabel, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            _LanguageOption(
              label: l10n.languageSystem,
              selected: settings.locale == null,
              onTap: () => notifier.setLocale(null),
            ),
            _LanguageOption(
              label: 'Español',
              selected: settings.locale?.languageCode == 'es',
              onTap: () => notifier.setLocale(const Locale('es')),
            ),
            _LanguageOption(
              label: 'English',
              selected: settings.locale?.languageCode == 'en',
              onTap: () => notifier.setLocale(const Locale('en')),
            ),
            const SizedBox(height: 16),
            Text(l10n.themeLabel, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                for (final tone in AppThemeTone.values) ...[
                  Expanded(
                    child: _ToneOption(
                      tone: tone,
                      selected: settings.tone == tone,
                      onTap: () => notifier.setTone(tone),
                    ),
                  ),
                  if (tone != AppThemeTone.values.last)
                    const SizedBox(width: 12),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: theme.textTheme.bodyLarge),
      trailing: selected
          ? Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}

class _ToneOption extends StatelessWidget {
  // Swatch colors shown in the picker, independent of the active theme.
  static const _swatches = <AppThemeTone, Color>{
    AppThemeTone.pink: AppTheme.pink,
    AppThemeTone.blue: Color(0xFF6FBDE8),
    AppThemeTone.green: Color(0xFF6FCF97),
    AppThemeTone.dark: Color(0xFF23232E),
  };

  final AppThemeTone tone;
  final bool selected;
  final VoidCallback onTap;

  const _ToneOption({
    required this.tone,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _swatches[tone]!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.dividerTheme.color ?? Colors.transparent,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: tone == AppThemeTone.dark
                  ? const Icon(Icons.dark_mode_rounded,
                      color: Colors.white70, size: 20)
                  : selected
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 20)
                      : null,
            ),
            const SizedBox(height: 6),
            Text(
              tone.label(context),
              style: theme.textTheme.labelSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
