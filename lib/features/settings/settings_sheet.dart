import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme.dart';
import '../../core/settings/settings_provider.dart';
import '../../core/utils/l10n_extension.dart';
import '../feeding/feeding_type.dart';

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
    // Resolved locale: the user's choice, or the device language by default.
    final languageCode = Localizations.localeOf(context).languageCode;

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
              label: 'Español',
              selected: languageCode == 'es',
              onTap: () => notifier.setLocale(const Locale('es')),
            ),
            _LanguageOption(
              label: 'English',
              selected: languageCode == 'en',
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
            const SizedBox(height: 24),
            const _QuickDefaultsSection(),
            const SizedBox(height: 16),
            Text(l10n.legalLabel, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            _LegalLink(
              label: l10n.privacyPolicy,
              url: 'https://h-baby-web.vercel.app/#/privacidad',
            ),
            _LegalLink(
              label: l10n.termsAndConditions,
              url: 'https://h-baby-web.vercel.app/#/terminos',
            ),
          ],
        ),
      ),
    );
  }
}

/// Lets the user configure the values used by the one-tap log buttons
/// on the dashboard (feeding type + amount/duration, and nap length).
class _QuickDefaultsSection extends ConsumerStatefulWidget {
  const _QuickDefaultsSection();

  @override
  ConsumerState<_QuickDefaultsSection> createState() =>
      _QuickDefaultsSectionState();
}

class _QuickDefaultsSectionState extends ConsumerState<_QuickDefaultsSection> {
  late final TextEditingController _amountController;
  late final TextEditingController _durationController;
  late final TextEditingController _napController;

  @override
  void initState() {
    super.initState();
    final s = ref.read(settingsProvider);
    _amountController =
        TextEditingController(text: _fmtNum(s.defaultFeedingAmountMl));
    _durationController =
        TextEditingController(text: '${s.defaultFeedingDurationMinutes}');
    _napController = TextEditingController(text: '${s.defaultNapMinutes}');
  }

  String _fmtNum(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : '$v';

  @override
  void dispose() {
    _amountController.dispose();
    _durationController.dispose();
    _napController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final type = FeedingType.fromValue(settings.defaultFeedingType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.quickDefaultsTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: 2),
        Text(l10n.quickDefaultsSubtitle, style: theme.textTheme.labelSmall),
        const SizedBox(height: 12),
        Text(l10n.defaultFeedingTypeLabel, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: FeedingType.values.map((t) {
            final selected = type == t;
            return ChoiceChip(
              avatar:
                  Icon(t.icon, size: 16, color: selected ? t.color : null),
              label: Text(t.shortLabel(context)),
              selected: selected,
              selectedColor: t.color.withValues(alpha: 0.2),
              onSelected: (_) => notifier.setDefaultFeedingType(t.value),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        if (type.isBottle)
          TextField(
            controller: _amountController,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
            ],
            decoration: InputDecoration(
              labelText: l10n.amountLabel,
              hintText: l10n.amountHint,
              suffixText: 'ml',
              prefixIcon: const Icon(Icons.local_drink_outlined),
            ),
            onChanged: (v) {
              final parsed = double.tryParse(v.replaceAll(',', '.'));
              if (parsed != null && parsed > 0) {
                notifier.setDefaultFeedingAmountMl(parsed);
              }
            },
          )
        else
          TextField(
            controller: _durationController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: l10n.durationLabel,
              hintText: l10n.durationHint,
              suffixText: l10n.minutesUnit,
              prefixIcon: const Icon(Icons.timer_outlined),
            ),
            onChanged: (v) {
              final parsed = int.tryParse(v);
              if (parsed != null && parsed > 0) {
                notifier.setDefaultFeedingDurationMinutes(parsed);
              }
            },
          ),
        const SizedBox(height: 12),
        TextField(
          controller: _napController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: l10n.defaultNapDurationLabel,
            suffixText: l10n.minutesUnit,
            prefixIcon: const Icon(Icons.bedtime_outlined),
          ),
          onChanged: (v) {
            final parsed = int.tryParse(v);
            if (parsed != null && parsed > 0) {
              notifier.setDefaultNapMinutes(parsed);
            }
          },
        ),
      ],
    );
  }
}

class _LegalLink extends StatelessWidget {
  final String label;
  final String url;

  const _LegalLink({required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(label, style: theme.textTheme.bodyMedium),
      trailing: Icon(
        Icons.open_in_new_rounded,
        size: 18,
        color: theme.colorScheme.primary,
      ),
      onTap: () =>
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
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
