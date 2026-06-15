import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/settings/settings_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../database/app_database.dart';
import '../../baby/baby_avatar.dart';
import '../../baby/providers/baby_provider.dart';
import '../../feeding/feeding_provider.dart';
import '../../feeding/feeding_type.dart';
import '../../settings/settings_sheet.dart';
import '../../sleep/sleep_provider.dart';
import '../../weight/providers/weight_provider.dart';

const _sleepColor = Color(0xFF7C83FD);

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baby = ref.watch(selectedBabyProvider);
    final babiesAsync = ref.watch(babiesProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.child_care_rounded),
            tooltip: l10n.myBabies,
            onPressed: () => context.push('/babies'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            tooltip: l10n.settingsTitle,
            onPressed: () => showSettingsSheet(context),
          ),
        ],
      ),
      body: babiesAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text(l10n.errorLabel('$e'))),
        data: (_) {
          if (baby == null) {
            // The router redirects to /babies/add when there are no babies.
            return const SizedBox.shrink();
          }
          return _DashboardBody(baby: baby);
        },
      ),
    );
  }
}

class _DashboardBody extends ConsumerWidget {
  final Baby baby;

  const _DashboardBody({required this.baby});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSleep = ref.watch(activeSleepProvider).valueOrNull;
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        _BabyHeaderCard(baby: baby),
        if (activeSleep != null) ...[
          const SizedBox(height: 16),
          _ActiveSleepCard(active: activeSleep),
        ],
        const SizedBox(height: 24),
        Text(l10n.todaySummary, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        const _TodaySummary(),
        const SizedBox(height: 24),
        Text(l10n.quickActions, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        const _QuickActions(),
        const SizedBox(height: 24),
        Text(l10n.quickLogTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        const _QuickLog(),
      ],
    );
  }
}

// ── One-tap quick log ──────────────────────────────────────────────────────

class _QuickLog extends ConsumerWidget {
  const _QuickLog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.local_drink_rounded,
            label: l10n.quickLogFeeding,
            color: const Color(0xFF89CFF0),
            prefix: '',
            onTap: () => _logFeeding(context, ref),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.bedtime_rounded,
            label: l10n.quickLogNap,
            color: _sleepColor,
            prefix: '',
            onTap: () => _logNap(context, ref),
          ),
        ),
      ],
    );
  }

  Future<void> _logFeeding(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final baby = ref.read(selectedBabyProvider);
    if (baby == null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.selectBabyFirst)));
      return;
    }

    final settings = ref.read(settingsProvider);
    final type = FeedingType.fromValue(settings.defaultFeedingType);
    final db = ref.read(databaseProvider);
    final id = const Uuid().v4();

    try {
      await db.feedingsDao.insertFeeding(
        FeedingsCompanion.insert(
          id: id,
          babyId: baby.id,
          type: type.value,
          startTime: DateTime.now(),
          amountMl: type.isBottle
              ? Value(settings.defaultFeedingAmountMl)
              : const Value.absent(),
          durationMinutes: type.isBottle
              ? const Value.absent()
              : Value(settings.defaultFeedingDurationMinutes),
        ),
      );
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.feedingLogged),
          action: SnackBarAction(
            label: l10n.undoLabel,
            onPressed: () => db.feedingsDao.deleteFeeding(id),
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.saveError('$e'))));
    }
  }

  Future<void> _logNap(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final baby = ref.read(selectedBabyProvider);
    if (baby == null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.selectBabyFirst)));
      return;
    }

    final settings = ref.read(settingsProvider);
    final db = ref.read(databaseProvider);
    final id = const Uuid().v4();
    final end = DateTime.now();
    final start = end.subtract(Duration(minutes: settings.defaultNapMinutes));

    try {
      await db.sleepDao.insertSleep(
        SleepEntriesCompanion.insert(
          id: id,
          babyId: baby.id,
          startTime: start,
          endTime: Value(end),
        ),
      );
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.napLogged),
          action: SnackBarAction(
            label: l10n.undoLabel,
            onPressed: () => db.sleepDao.deleteSleep(id),
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.saveError('$e'))));
    }
  }
}

// ── Baby header ────────────────────────────────────────────────────────────

class _BabyHeaderCard extends StatelessWidget {
  final Baby baby;

  const _BabyHeaderCard({required this.baby});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.12),
            theme.colorScheme.secondary.withValues(alpha: 0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          BabyAvatar(
            name: baby.name,
            gender: baby.gender,
            photoBytes: baby.photoBytes,
            radius: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.helloIAm, style: theme.textTheme.labelSmall),
                Text(baby.name, style: theme.textTheme.headlineMedium),
                const SizedBox(height: 2),
                Text(
                  DateFormatter.getAge(context, baby.birthDate),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.swap_horiz_rounded,
              color: theme.colorScheme.primary,
            ),
            tooltip: context.l10n.switchBaby,
            onPressed: () => context.push('/babies'),
          ),
        ],
      ),
    );
  }
}

// ── Active sleep banner ────────────────────────────────────────────────────

class _ActiveSleepCard extends ConsumerWidget {
  final SleepEntry active;

  const _ActiveSleepCard({required this.active});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _sleepColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _sleepColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _sleepColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bedtime_rounded,
                color: _sleepColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.sleepingNow,
                  style:
                      theme.textTheme.titleMedium?.copyWith(color: _sleepColor),
                ),
                Text(
                  DateFormatter.elapsed(context, active.startTime),
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: _sleepColor.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final db = ref.read(databaseProvider);
              await db.sleepDao.updateSleep(
                SleepEntriesCompanion(
                  id: Value(active.id),
                  endTime: Value(DateTime.now()),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _sleepColor,
              minimumSize: const Size(80, 36),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: Text(context.l10n.stopButton),
          ),
        ],
      ),
    );
  }
}

// ── Today summary cards ────────────────────────────────────────────────────

class _TodaySummary extends ConsumerWidget {
  const _TodaySummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedings = ref.watch(feedingsProvider).valueOrNull ?? [];
    final sleepEntries = ref.watch(sleepEntriesProvider).valueOrNull ?? [];
    final weights = ref.watch(weightEntriesProvider).valueOrNull ?? [];
    final l10n = context.l10n;

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    // Feedings today
    final todayFeedings =
        feedings.where((f) => !f.startTime.isBefore(todayStart)).toList();
    double totalMl = 0;
    int totalBreastMin = 0;
    for (final f in todayFeedings) {
      if (FeedingType.fromValue(f.type).isBottle) {
        totalMl += f.amountMl ?? 0;
      } else {
        totalBreastMin += f.durationMinutes ?? 0;
      }
    }
    final feedingDetail = [
      if (totalMl > 0) DateFormatter.formatVolume(totalMl),
      if (totalBreastMin > 0) l10n.breastMinutes(totalBreastMin),
    ].join(' · ');
    final lastFeeding = feedings.isNotEmpty ? feedings.first : null;

    // Sleep today (entries that started today; active session counts until now)
    var todaySleep = Duration.zero;
    for (final e in sleepEntries) {
      if (e.startTime.isBefore(todayStart)) continue;
      todaySleep += (e.endTime ?? now).difference(e.startTime);
    }

    // Latest weight
    final lastWeight = weights.isNotEmpty ? weights.first : null;
    final prevWeight = weights.length > 1 ? weights[1] : null;
    String weightDetail = l10n.noRecords;
    if (lastWeight != null) {
      weightDetail =
          DateFormatter.formatRelativeDate(context, lastWeight.measuredAt);
      if (prevWeight != null) {
        final diff = lastWeight.weightGrams - prevWeight.weightGrams;
        if (diff != 0) {
          final sign = diff > 0 ? '+' : '−';
          weightDetail += ' · $sign${diff.abs().toStringAsFixed(0)} g';
        }
      }
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                icon: Icons.local_drink_rounded,
                color: const Color(0xFF89CFF0),
                title: l10n.feedingsLabel,
                value: '${todayFeedings.length}',
                detail: todayFeedings.isEmpty
                    ? (lastFeeding != null
                        ? l10n.lastFeedingElapsed(
                            DateFormatter.elapsed(context, lastFeeding.startTime)
                                .toLowerCase(),
                          )
                        : l10n.noRecordsToday)
                    : feedingDetail.isEmpty
                        ? l10n.todayWord
                        : feedingDetail,
                onTap: () => context.go('/feedings'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                icon: Icons.bedtime_rounded,
                color: _sleepColor,
                title: l10n.sleepLabel,
                value: todaySleep == Duration.zero
                    ? '—'
                    : DateFormatter.formatDuration(todaySleep),
                detail: todaySleep == Duration.zero
                    ? l10n.noRecordsToday
                    : l10n.todayWord,
                onTap: () => context.go('/sleep'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _SummaryCard(
          icon: Icons.monitor_weight_rounded,
          color: const Color(0xFFA8E6CF),
          title: l10n.weightLabel,
          value: lastWeight != null
              ? DateFormatter.formatWeight(context, lastWeight.weightGrams)
              : '—',
          detail: weightDetail,
          onTap: () => context.go('/weight'),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;
  final String detail;
  final VoidCallback onTap;

  const _SummaryCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    required this.detail,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(title, style: theme.textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 12),
              Text(value, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 2),
              Text(
                detail,
                style: theme.textTheme.labelSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Quick actions ──────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.local_drink_rounded,
            label: l10n.quickFeeding,
            color: const Color(0xFF89CFF0),
            onTap: () => context.push('/feedings/add'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.bedtime_rounded,
            label: l10n.sleepLabel,
            color: _sleepColor,
            onTap: () => context.push('/sleep/add'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.monitor_weight_rounded,
            label: l10n.weightLabel,
            color: const Color(0xFFA8E6CF),
            onTap: () => context.push('/weight/add'),
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  /// Text shown before the label. Defaults to '+ ' for the navigation actions;
  /// the one-tap log buttons pass an empty string.
  final String prefix;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.prefix = '+ ',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 6),
              Text(
                '$prefix$label',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
