import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/animations.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/empty_state.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../database/app_database.dart';
import '../providers/weight_provider.dart';

const _weightColor = Color(0xFF6BC5A0);

class WeightScreen extends ConsumerWidget {
  const WeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weightAsync = ref.watch(weightEntriesProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.weightScreenTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/weight/add'),
        child: const Icon(Icons.add_rounded),
      ),
      body: weightAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text(l10n.errorLabel('$e'))),
        data: (entries) {
          if (entries.isEmpty) {
            return EmptyState(
              icon: Icons.monitor_weight_outlined,
              title: l10n.weightEmptyTitle,
              subtitle: l10n.weightEmptySubtitle,
              actionLabel: l10n.addWeightAction,
              onAction: () => context.push('/weight/add'),
            );
          }

          // Entries arrive newest-first from the DAO.
          final grouped = <String, List<WeightEntry>>{};
          for (final entry in entries) {
            final day =
                DateFormatter.formatRelativeDate(context, entry.measuredAt);
            grouped.putIfAbsent(day, () => []).add(entry);
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: grouped.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _WeightSummaryHeader(entries: entries);
              }

              final day = grouped.keys.elementAt(index - 1);
              final items = grouped[day]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      day,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ),
                  ...items.map((entry) {
                    final pos = entries.indexOf(entry);
                    final previous =
                        pos + 1 < entries.length ? entries[pos + 1] : null;
                    return _WeightTile(
                      entry: entry,
                      previous: previous,
                      onDelete: () => _delete(context, ref, entry.id),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, String id) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteWeightTitle),
        content: Text(l10n.deleteWeightMessage),
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

    if (confirmed != true) return;

    await ref.read(databaseProvider).weightDao.deleteWeight(id);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.weightDeleted)),
      );
    }
  }
}

/// Header card showing the latest weight and the change vs the previous one.
class _WeightSummaryHeader extends StatelessWidget {
  final List<WeightEntry> entries;

  const _WeightSummaryHeader({required this.entries});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final latest = entries.first;
    final previous = entries.length > 1 ? entries[1] : null;
    final diff = previous != null
        ? latest.weightGrams - previous.weightGrams
        : null;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _weightColor.withValues(alpha: 0.15),
            _weightColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _weightColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.monitor_weight_rounded,
                color: _weightColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.currentWeight,
                    style: theme.textTheme.labelSmall),
                Text(
                  DateFormatter.formatWeight(context, latest.weightGrams),
                  style: theme.textTheme.headlineLarge,
                ),
                Text(
                  DateFormatter.formatRelativeDate(context, latest.measuredAt),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          if (diff != null && diff != 0) _DiffBadge(diffGrams: diff),
        ],
      ),
    );
  }
}

class _DiffBadge extends StatelessWidget {
  final double diffGrams;

  const _DiffBadge({required this.diffGrams});

  @override
  Widget build(BuildContext context) {
    final up = diffGrams > 0;
    final color = up ? _weightColor : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            color: color,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            '${diffGrams.abs().toStringAsFixed(0)} g',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _WeightTile extends StatelessWidget {
  final WeightEntry entry;
  final WeightEntry? previous;
  final VoidCallback onDelete;

  const _WeightTile({
    required this.entry,
    required this.previous,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final diff =
        previous != null ? entry.weightGrams - previous!.weightGrams : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _weightColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.monitor_weight_outlined,
              color: _weightColor, size: 24),
        ),
        title: Text(
          DateFormatter.formatWeight(context, entry.weightGrams),
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              DateFormatter.formatDateTime(context, entry.measuredAt),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            if (diff != null && diff != 0)
              Text(
                diff > 0
                    ? context.l10n.gainSincePrevious(diff.toStringAsFixed(0))
                    : context.l10n
                        .lossSincePrevious(diff.abs().toStringAsFixed(0)),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: diff > 0 ? _weightColor : Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (entry.notes != null && entry.notes!.isNotEmpty)
              Text(
                entry.notes!,
                style: theme.textTheme.labelSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline_rounded,
              color: Colors.redAccent, size: 20),
          onPressed: onDelete,
        ),
      ),
    ).softFade();
  }
}
