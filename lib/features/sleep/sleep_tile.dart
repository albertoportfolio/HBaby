import 'package:flutter/material.dart';

import '../../../core/utils/animations.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../database/app_database.dart';

class SleepTile extends StatelessWidget {
  final SleepEntry entry;
  final VoidCallback? onDelete;

  const SleepTile({super.key, required this.entry, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = entry.endTime == null;
    final accentColor = const Color(0xFF7C83FD);

    String durationText;
    if (isActive) {
      durationText = DateFormatter.elapsed(context, entry.startTime);
    } else {
      final dur = entry.endTime!.difference(entry.startTime);
      durationText = DateFormatter.formatDuration(dur);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: isActive
            ? Border.all(color: accentColor.withValues(alpha: 0.5), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isActive ? Icons.bedtime_rounded : Icons.bedtime_outlined,
            color: accentColor,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Text(
              DateFormatter.formatDateTime(context, entry.startTime),
              style: theme.textTheme.titleMedium,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  context.l10n.sleepingBadge,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            if (entry.endTime != null)
              Text(
                context.l10n.endPrefix(
                    DateFormatter.formatDateTime(context, entry.endTime!)),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            Text(
              durationText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (entry.notes != null && entry.notes!.isNotEmpty)
              Text(entry.notes!, style: theme.textTheme.labelSmall),
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