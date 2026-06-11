import 'package:flutter/material.dart';

import '../../../core/utils/date_formatter.dart';
import '../../../database/app_database.dart';
import 'feeding_type.dart';

class FeedingTile extends StatelessWidget {
  final Feeding feeding;
  final VoidCallback? onDelete;

  const FeedingTile({super.key, required this.feeding, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = FeedingType.fromValue(feeding.type);

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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: type.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(type.icon, color: type.color, size: 24),
        ),
        title: Text(type.label(context), style: theme.textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              DateFormatter.formatDateTime(context, feeding.startTime),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            if (type.isBottle && feeding.amountMl != null)
              Text(
                DateFormatter.formatVolume(feeding.amountMl!),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (!type.isBottle && feeding.durationMinutes != null)
              Text(
                '${feeding.durationMinutes} min',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (feeding.notes != null && feeding.notes!.isNotEmpty)
              Text(
                feeding.notes!,
                style: theme.textTheme.labelSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
          onPressed: onDelete,
        ),
      ),
    );
  }
}