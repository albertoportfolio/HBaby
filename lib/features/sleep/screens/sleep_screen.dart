import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/empty_state.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../database/app_database.dart';
import '../sleep_provider.dart';
import '../sleep_tile.dart';

class SleepScreen extends ConsumerWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sleepAsync = ref.watch(sleepEntriesProvider);
    final activeAsync = ref.watch(activeSleepProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sueño')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/sleep/add'),
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          // Active session banner
          activeAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (active) => active != null
                ? _ActiveSleepBanner(active: active)
                : const SizedBox.shrink(),
          ),

          // List
          Expanded(
            child: sleepAsync.when(
              loading: () => const LoadingWidget(),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (entries) {
                // Filter out active entry from the main list to avoid duplication
                final finished = entries.where((e) => e.endTime != null).toList();
                final hasActive = entries.any((e) => e.endTime == null);

                if (entries.isEmpty) {
                  return EmptyState(
                    icon: Icons.bedtime_outlined,
                    title: 'Sin registros de sueño',
                    subtitle: 'Pulsa el botón + para registrar el primer sueño.',
                    actionLabel: 'Registrar sueño',
                    onAction: () => context.push('/sleep/add'),
                  );
                }

                if (finished.isEmpty && hasActive) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bedtime_outlined,
                          size: 60,
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.35),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Hay un sueño en curso. Termina la sesión desde el banner superior.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
                              ),
                        ),
                      ],
                    ),
                  );
                }

                // Group by day
                final grouped = <String, List<SleepEntry>>{};
                for (final e in finished) {
                  final key =
                      DateFormatter.formatRelativeDate(context, e.startTime);
                  grouped.putIfAbsent(key, () => []).add(e);
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: grouped.length,
                  itemBuilder: (_, i) {
                    final day = grouped.keys.elementAt(i);
                    final items = grouped[day]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            day,
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.outline,
                                    ),
                          ),
                        ),
                        ...items.map(
                          (e) => SleepTile(
                            entry: e,
                            onDelete: () => _delete(context, ref, e.id),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(BuildContext ctx, WidgetRef ref, String id) async {
    final confirmed = await showDialog<bool>(
      context: ctx,
      builder: (c) => AlertDialog(
        title: const Text('Eliminar registro'),
        content: const Text('¿Seguro que quieres eliminar este registro de sueño?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(databaseProvider).sleepDao.deleteSleep(id);
    }
  }
}

class _ActiveSleepBanner extends ConsumerWidget {
  final SleepEntry active;

  const _ActiveSleepBanner({required this.active});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    const color = Color(0xFF7C83FD);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bedtime_rounded, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.sleepingNow,
                  style: theme.textTheme.titleMedium?.copyWith(color: color),
                ),
                Text(
                  DateFormatter.elapsed(context, active.startTime),
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: color.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _stopSleep(ref),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              minimumSize: const Size(80, 36),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Text('Detener'),
          ),
        ],
      ),
    );
  }

  Future<void> _stopSleep(WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    await db.sleepDao.updateSleep(
      SleepEntriesCompanion(
        id: Value(active.id),
        endTime: Value(DateTime.now()),
      ),
    );
  }
}