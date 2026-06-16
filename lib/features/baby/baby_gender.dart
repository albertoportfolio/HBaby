import 'package:flutter/material.dart';

import '../../core/utils/l10n_extension.dart';

enum BabyGender {
  male,
  female;

  String label(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case BabyGender.male:
        return l10n.genderBoy;
      case BabyGender.female:
        return l10n.genderGirl;
    }
  }

  String get value {
    switch (this) {
      case BabyGender.male:
        return 'male';
      case BabyGender.female:
        return 'female';
    }
  }

  Color get color {
    switch (this) {
      case BabyGender.male:
        return const Color(0xFF89CFF0);
      case BabyGender.female:
        return const Color(0xFFFF8FAB);
    }
  }

  IconData get icon {
    switch (this) {
      case BabyGender.male:
        return Icons.boy_rounded;
      case BabyGender.female:
        return Icons.girl_rounded;
    }
  }

  static BabyGender fromValue(String value) =>
      BabyGender.values.firstWhere(
        (g) => g.value == value,
        orElse: () => BabyGender.male,
      );
}
