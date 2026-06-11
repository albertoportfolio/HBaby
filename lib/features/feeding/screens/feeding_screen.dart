import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/empty_state.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../database/app_database.dart';
import '../feeding_provider.dart';
import '../feeding_tile.dart';
import '../feeding_type.dart';

class FeedingScreen extends ConsumerWidget {
  const FeedingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedingsAsync = ref.watch(feedingsProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.feedingScreenTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/feedings/add'),
        child: const Icon(Icons.add_rounded),
      ),
      body: feedingsAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text(l10n.errorLabel('$e'))),
        data: (feedings) {
          if (feedings.isEmpty) {
            return EmptyState(
              icon: Icons.local_drink_outlined,
              title: l10n.feedingEmptyTitle,
              subtitle: l10n.feedingEmptySubtitle,
              actionLabel: l10n.addFeedingAction,
              onAction: () => context.push('/feedings/add'),
            );
          }

          // Group by day
          final grouped = <String, List<Feeding>>{};
          for (final f in feedings) {
            final key = DateFormatter.formatRelativeDate(context, f.startTime);
            grouped.putIfAbsent(key, () => []).add(f);
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          day,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                        Text(
                          _daySummary(context, items),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  ...items.map(
                    (f) => FeedingTile(
                      feeding: f,
                      onDelete: () => _delete(context, ref, f.id),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  /// e.g. '5 tomas · 320 ml · 25 min'
  String _daySummary(BuildContext context, List<Feeding> items) {
    double totalMl = 0;
    int totalMin = 0;
    for (final f in items) {
      if (FeedingType.fromValue(f.type).isBottle) {
        totalMl += f.amountMl ?? 0;
      } else {
        totalMin += f.durationMinutes ?? 0;
      }
    }
    return [
      context.l10n.feedingsCount(items.length),
      if (totalMl > 0) DateFormatter.formatVolume(totalMl),
      if (totalMin > 0) '$totalMin min',
    ].join(' · ');
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteFeedingTitle),
        content: Text(l10n.deleteFeedingMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(databaseProvider).feedingsDao.deleteFeeding(id);
    }
  }
}