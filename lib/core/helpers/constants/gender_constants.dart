import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class GenderConstants {
  static const int male = 1;
  static const int female = 2;

  static const String maleValue = '1';
  static const String femaleValue = '2';

  static bool isValidGender(dynamic value) {
    if (value == null) return false;
    final str = value.toString().trim();
    return str == maleValue || str == femaleValue;
  }

  static List<DropdownMenuItem<String>> get dropdownItems => const [
        DropdownMenuItem(
          value: maleValue,
          child: TextInAppWidget(
            text: LocaleKeys.gender_male,
            textSize: 14,
          ),
        ),
        DropdownMenuItem(
          value: femaleValue,
          child: TextInAppWidget(
            text: LocaleKeys.gender_female,
            textSize: 14,
          ),
        ),
      ];
}

extension GenderIntExtension on int? {
  String toGenderText({String fallback = ''}) {
    if (this == GenderConstants.male) {
      return LocaleKeys.gender_male.tr();
    } else if (this == GenderConstants.female) {
      return LocaleKeys.gender_female.tr();
    }
    return fallback;
  }

  bool get isMale => this == GenderConstants.male;
  bool get isFemale => this == GenderConstants.female;
}

extension GenderStringExtension on String? {
  String toGenderText({String fallback = ''}) {
    if (this == null || this!.trim().isEmpty) return fallback;
    final parsed = int.tryParse(this!.trim());
    if (parsed != null) {
      return parsed.toGenderText(fallback: fallback);
    }
    return fallback;
  }

  bool get isMale => this?.trim() == GenderConstants.maleValue;
  bool get isFemale => this?.trim() == GenderConstants.femaleValue;
}
