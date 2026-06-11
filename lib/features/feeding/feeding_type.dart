import 'package:flutter/material.dart';

import '../../core/utils/l10n_extension.dart';

enum FeedingType {
  breastLeft,
  breastRight,
  bottleFormula,
  bottleBreastMilk;

  String label(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case FeedingType.breastLeft:
        return l10n.feedingBreastLeft;
      case FeedingType.breastRight:
        return l10n.feedingBreastRight;
      case FeedingType.bottleFormula:
        return l10n.feedingBottleFormula;
      case FeedingType.bottleBreastMilk:
        return l10n.feedingBottleBreastMilk;
    }
  }

  String shortLabel(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case FeedingType.breastLeft:
        return l10n.feedingBreastLeftShort;
      case FeedingType.breastRight:
        return l10n.feedingBreastRightShort;
      case FeedingType.bottleFormula:
        return l10n.feedingFormulaShort;
      case FeedingType.bottleBreastMilk:
        return l10n.feedingBreastMilkShort;
    }
  }

  /// Value stored in the database.
  String get value {
    switch (this) {
      case FeedingType.breastLeft:
        return 'breast_left';
      case FeedingType.breastRight:
        return 'breast_right';
      case FeedingType.bottleFormula:
        return 'bottle_formula';
      case FeedingType.bottleBreastMilk:
        return 'bottle_breast_milk';
    }
  }

  IconData get icon {
    switch (this) {
      case FeedingType.breastLeft:
      case FeedingType.breastRight:
        return Icons.child_friendly_rounded;
      case FeedingType.bottleFormula:
      case FeedingType.bottleBreastMilk:
        return Icons.local_drink_outlined;
    }
  }

  Color get color {
    switch (this) {
      case FeedingType.breastLeft:
        return const Color(0xFFFF8FAB);
      case FeedingType.breastRight:
        return const Color(0xFFFFB3C6);
      case FeedingType.bottleFormula:
        return const Color(0xFF89CFF0);
      case FeedingType.bottleBreastMilk:
        return const Color(0xFFA8E6CF);
    }
  }

  bool get isBottle =>
      this == FeedingType.bottleFormula ||
      this == FeedingType.bottleBreastMilk;

  static FeedingType fromValue(String value) => FeedingType.values.firstWhere(
        (t) => t.value == value,
        orElse: () => FeedingType.breastLeft,
      );
}
