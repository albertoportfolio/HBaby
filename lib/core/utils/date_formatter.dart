import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'l10n_extension.dart';

class DateFormatter {
  DateFormatter._();

  static String _locale(BuildContext context) =>
      Localizations.localeOf(context).toString();

  // ── Basic formats ──────────────────────────────────────────────────────

  static String formatDate(BuildContext context, DateTime date) =>
      DateFormat('dd MMM yyyy', _locale(context)).format(date);

  static String formatTime(BuildContext context, DateTime date) =>
      DateFormat('HH:mm', _locale(context)).format(date);

  static String formatDateTime(BuildContext context, DateTime date) =>
      DateFormat('dd MMM · HH:mm', _locale(context)).format(date);

  static String formatShortDate(BuildContext context, DateTime date) =>
      DateFormat('dd/MM/yyyy', _locale(context)).format(date);

  // ── Relative labels ────────────────────────────────────────────────────

  /// Returns 'Today'/'Hoy', 'Yesterday'/'Ayer' or the formatted date.
  static String formatRelativeDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);

    if (d == today) return context.l10n.today;
    if (d == today.subtract(const Duration(days: 1))) {
      return context.l10n.yesterday;
    }
    return formatDate(context, date);
  }

  // ── Baby age ───────────────────────────────────────────────────────────

  /// Returns a human-readable age string based on birth date.
  static String getAge(BuildContext context, DateTime birthDate) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final days = now.difference(birthDate).inDays;

    if (days < 0) return l10n.ageDays(0);
    if (days == 0) return l10n.newborn;
    if (days < 7) return l10n.ageDays(days);

    final weeks = days ~/ 7;
    if (weeks < 5) return l10n.ageWeeks(weeks);

    final months = _monthsBetween(birthDate, now);
    if (months < 24) return l10n.ageMonths(months);

    final years = months ~/ 12;
    final remainingMonths = months % 12;
    if (remainingMonths == 0) return l10n.ageYears(years);
    return l10n.ageYearsMonths(
      l10n.ageYears(years),
      l10n.ageMonths(remainingMonths),
    );
  }

  static int _monthsBetween(DateTime from, DateTime to) {
    return (to.year - from.year) * 12 + (to.month - from.month);
  }

  // ── Duration ───────────────────────────────────────────────────────────

  /// Formats a duration as 'Xh Ymin' or 'Ymin' (language-neutral).
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0 && minutes > 0) return '${hours}h ${minutes}min';
    if (hours > 0) return '${hours}h';
    return '${minutes}min';
  }

  /// Elapsed time since [start], e.g. 'Hace 2h 15min' / '2h 15min ago'.
  static String elapsed(BuildContext context, DateTime start) {
    final d = DateTime.now().difference(start);
    return context.l10n.elapsedTime(formatDuration(d));
  }

  // ── Weight ─────────────────────────────────────────────────────────────

  /// Shows grams below 1000 g, kilograms above (locale-aware decimal mark).
  static String formatWeight(BuildContext context, double grams) {
    if (grams < 1000) {
      return '${grams.toStringAsFixed(0)} g';
    }
    final kg = grams / 1000;
    final formatted = NumberFormat('0.00', _locale(context)).format(kg);
    return '$formatted kg';
  }

  // ── Volume ─────────────────────────────────────────────────────────────

  static String formatVolume(double ml) => '${ml.toStringAsFixed(0)} ml';
}
