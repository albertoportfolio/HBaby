import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/animations.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/empty_state.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../baby/providers/baby_provider.dart';
import '../../feeding/feeding_provider.dart';
import '../../sleep/sleep_provider.dart';
import '../../weight/providers/weight_provider.dart';

const _sleepColor = Color(0xFF7C83FD);
const _feedingColor = Color(0xFF89CFF0);
const _weightColor = Color(0xFF6BC5A0);

/// Number of days shown in the daily-aggregated charts (sleep, feeding).
const _windowDays = 14;

/// Evolution charts for sleep, feeding and weight.
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final baby = ref.watch(selectedBabyProvider);

    final feedingsAsync = ref.watch(feedingsProvider);
    final sleepAsync = ref.watch(sleepEntriesProvider);
    final weightsAsync = ref.watch(weightEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.statsTitle)),
      body: Builder(
        builder: (context) {
          if (baby == null) return const SizedBox.shrink();
          if (feedingsAsync.isLoading ||
              sleepAsync.isLoading ||
              weightsAsync.isLoading) {
            return const LoadingWidget();
          }

          final feedings = feedingsAsync.valueOrNull ?? const [];
          final sleep = sleepAsync.valueOrNull ?? const [];
          final weights = weightsAsync.valueOrNull ?? const [];

          if (feedings.isEmpty && sleep.isEmpty && weights.isEmpty) {
            return EmptyState(
              icon: Icons.insights_rounded,
              title: l10n.statsEmptyTitle,
              subtitle: l10n.statsEmptySubtitle,
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            children: [
              _SleepChartCard(entries: sleep).entrance(order: 0),
              const SizedBox(height: 16),
              _FeedingChartCard(feedings: feedings).entrance(order: 1),
              const SizedBox(height: 16),
              _WeightChartCard(entries: weights).entrance(order: 2),
            ],
          );
        },
      ),
    );
  }
}

// ── Sleep: hours per day ────────────────────────────────────────────────────

class _SleepChartCard extends StatelessWidget {
  final List<SleepEntry> entries;

  const _SleepChartCard({required this.entries});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final days = _lastDays(now, _windowDays);
    final minutesPerDay = {for (final d in days) d: 0.0};

    for (final e in entries) {
      final end = e.endTime ?? now;
      final key = _dayKey(e.startTime);
      if (minutesPerDay.containsKey(key)) {
        minutesPerDay[key] =
            minutesPerDay[key]! + end.difference(e.startTime).inMinutes;
      }
    }

    final spots = <FlSpot>[
      for (var i = 0; i < days.length; i++)
        FlSpot(i.toDouble(), minutesPerDay[days[i]]! / 60),
    ];
    final hasData = spots.any((s) => s.y > 0);

    return _ChartCard(
      icon: Icons.bedtime_rounded,
      color: _sleepColor,
      title: l10n.statsSleepCardTitle,
      subtitle: l10n.statsSleepCardSubtitle,
      child: !hasData
          ? _NoData(message: l10n.statsNoData)
          : _DailyLineChart(
              spots: spots,
              days: days,
              color: _sleepColor,
              leftLabel: (v) => '${v.toInt()}h',
              tooltip: (i) => DateFormatter.formatDuration(
                Duration(minutes: minutesPerDay[days[i]]!.round()),
              ),
            ),
    );
  }
}

// ── Feeding: count per day ──────────────────────────────────────────────────

class _FeedingChartCard extends StatelessWidget {
  final List<Feeding> feedings;

  const _FeedingChartCard({required this.feedings});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final days = _lastDays(now, _windowDays);
    final countPerDay = {for (final d in days) d: 0.0};

    for (final f in feedings) {
      final key = _dayKey(f.startTime);
      if (countPerDay.containsKey(key)) {
        countPerDay[key] = countPerDay[key]! + 1;
      }
    }

    final spots = <FlSpot>[
      for (var i = 0; i < days.length; i++)
        FlSpot(i.toDouble(), countPerDay[days[i]]!),
    ];
    final hasData = spots.any((s) => s.y > 0);

    return _ChartCard(
      icon: Icons.local_drink_rounded,
      color: _feedingColor,
      title: l10n.statsFeedingCardTitle,
      subtitle: l10n.statsFeedingCardSubtitle,
      child: !hasData
          ? _NoData(message: l10n.statsNoData)
          : _DailyLineChart(
              spots: spots,
              days: days,
              color: _feedingColor,
              leftLabel: (v) => v.toInt().toString(),
              tooltip: (i) => l10n.feedingsCount(countPerDay[days[i]]!.toInt()),
            ),
    );
  }
}

// ── Weight: value over time ─────────────────────────────────────────────────

class _WeightChartCard extends StatelessWidget {
  final List<WeightEntry> entries;

  const _WeightChartCard({required this.entries});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Provider streams newest-first; chart needs chronological order.
    final sorted = [...entries]
      ..sort((a, b) => a.measuredAt.compareTo(b.measuredAt));

    Widget child;
    if (sorted.length < 2) {
      child = _NoData(message: l10n.statsNoData);
    } else {
      final spots = <FlSpot>[
        for (var i = 0; i < sorted.length; i++)
          FlSpot(i.toDouble(), sorted[i].weightGrams / 1000),
      ];
      child = _WeightLineChart(spots: spots, entries: sorted);
    }

    return _ChartCard(
      icon: Icons.monitor_weight_rounded,
      color: _weightColor,
      title: l10n.statsWeightCardTitle,
      subtitle: l10n.statsWeightCardSubtitle,
      child: child,
    );
  }
}

// ── Reusable chart card shell ───────────────────────────────────────────────

class _ChartCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final Widget child;

  const _ChartCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  Text(subtitle, style: theme.textTheme.labelSmall),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(height: 180, child: child),
        ],
      ),
    );
  }
}

class _NoData extends StatelessWidget {
  final String message;

  const _NoData({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
      ),
    );
  }
}

// ── Daily line chart (sleep / feeding) ──────────────────────────────────────

class _DailyLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final List<DateTime> days;
  final Color color;
  final String Function(double value) leftLabel;
  final String Function(int dayIndex) tooltip;

  const _DailyLineChart({
    required this.spots,
    required this.days,
    required this.color,
    required this.leftLabel,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final dayFmt = DateFormat('d', locale);
    final maxData = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final maxY = (maxData * 1.2).ceilToDouble().clamp(1, double.infinity).toDouble();
    final leftInterval =
        (maxY / 4).ceilToDouble().clamp(1, double.infinity).toDouble();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (days.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        gridData: _gridData(context, leftInterval),
        borderData: FlBorderData(show: false),
        titlesData: _titlesData(
          context,
          leftInterval: leftInterval,
          leftLabel: leftLabel,
          bottomLabel: (x) {
            final i = x.round();
            // Show roughly 5 labels across the window.
            if (i % 3 != 0 || i < 0 || i >= days.length) return '';
            return dayFmt.format(days[i]);
          },
        ),
        lineTouchData: _touchData(
          context,
          color: color,
          label: (spot) => tooltip(spot.x.round()),
        ),
        lineBarsData: [_barData(spots, color)],
      ),
    );
  }
}

// ── Weight line chart (irregular dates) ─────────────────────────────────────

class _WeightLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final List<WeightEntry> entries;

  const _WeightLineChart({required this.spots, required this.entries});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final dateFmt = DateFormat('d/M', locale);
    final values = spots.map((s) => s.y).toList();
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final pad = ((maxY - minY) * 0.2).clamp(0.1, double.infinity).toDouble();
    final chartMin = minY - pad;
    final chartMax = maxY + pad;
    final leftInterval =
        ((chartMax - chartMin) / 4).clamp(0.1, double.infinity).toDouble();
    // Label step keeps roughly 5 dates on the axis.
    final step = (entries.length / 5).ceil().clamp(1, entries.length);

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (entries.length - 1).toDouble(),
        minY: chartMin,
        maxY: chartMax,
        gridData: _gridData(context, leftInterval),
        borderData: FlBorderData(show: false),
        titlesData: _titlesData(
          context,
          leftInterval: leftInterval,
          leftLabel: (v) => v.toStringAsFixed(1),
          bottomLabel: (x) {
            final i = x.round();
            if (i < 0 || i >= entries.length) return '';
            if (i % step != 0 && i != entries.length - 1) return '';
            return dateFmt.format(entries[i].measuredAt);
          },
        ),
        lineTouchData: _touchData(
          context,
          color: _weightColor,
          label: (spot) => DateFormatter.formatWeight(
            context,
            entries[spot.x.round()].weightGrams,
          ),
        ),
        lineBarsData: [_barData(spots, _weightColor)],
      ),
    );
  }
}

// ── Shared fl_chart styling helpers ─────────────────────────────────────────

LineChartBarData _barData(List<FlSpot> spots, Color color) {
  return LineChartBarData(
    spots: spots,
    isCurved: true,
    curveSmoothness: 0.3,
    preventCurveOverShooting: true,
    color: color,
    barWidth: 3,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: true,
      getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
        radius: 3,
        color: color,
        strokeWidth: 0,
      ),
    ),
    belowBarData: BarAreaData(
      show: true,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.25),
          color.withValues(alpha: 0.0),
        ],
      ),
    ),
  );
}

FlGridData _gridData(BuildContext context, double interval) {
  final line = Theme.of(context).colorScheme.outline.withValues(alpha: 0.15);
  return FlGridData(
    show: true,
    drawVerticalLine: false,
    horizontalInterval: interval,
    getDrawingHorizontalLine: (_) => FlLine(color: line, strokeWidth: 1),
  );
}

FlTitlesData _titlesData(
  BuildContext context, {
  required double leftInterval,
  required String Function(double value) leftLabel,
  required String Function(double x) bottomLabel,
}) {
  final style = Theme.of(context).textTheme.labelSmall;
  return FlTitlesData(
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 34,
        interval: leftInterval,
        getTitlesWidget: (value, meta) {
          // Skip the top edge label to avoid clipping against the card.
          if (value == meta.max) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Text(leftLabel(value), style: style),
          );
        },
      ),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        interval: 1,
        getTitlesWidget: (value, meta) {
          final label = bottomLabel(value);
          if (label.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(label, style: style),
          );
        },
      ),
    ),
  );
}

LineTouchData _touchData(
  BuildContext context, {
  required Color color,
  required String Function(FlSpot spot) label,
}) {
  return LineTouchData(
    touchTooltipData: LineTouchTooltipData(
      getTooltipColor: (_) => Theme.of(context).colorScheme.surface,
      tooltipBorder: BorderSide(color: color.withValues(alpha: 0.4)),
      tooltipBorderRadius: BorderRadius.circular(12),
      getTooltipItems: (spots) => spots
          .map((s) => LineTooltipItem(
                label(s),
                Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ))
          .toList(),
    ),
  );
}

// ── Date helpers ────────────────────────────────────────────────────────────

DateTime _dayKey(DateTime d) => DateTime(d.year, d.month, d.day);

/// Last [count] days ending today, oldest first.
List<DateTime> _lastDays(DateTime now, int count) {
  final today = DateTime(now.year, now.month, now.day);
  return [
    for (var i = count - 1; i >= 0; i--) today.subtract(Duration(days: i)),
  ];
}
