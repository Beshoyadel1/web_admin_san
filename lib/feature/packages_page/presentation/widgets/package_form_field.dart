import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/widgets/text_form_field_widget.dart';

class PackageFormField extends StatelessWidget {
  const PackageFormField({
    super.key,
    required this.title,
    required this.controller,
    this.hintText,
    this.isDigitDot = false,
    this.maxLines = 1,
    this.textFormHeight = 35,
    this.validator,
  });

  final String title;
  final TextEditingController controller;
  final String? hintText;
  final bool isDigitDot;
  final int maxLines;
  final double? textFormHeight;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormFieldWidget(
      textFormController: controller,
      text: title,
      hintText: hintText ?? title,
      isColumn: true,
      textSize: 14,
      textColor: AppColors.darkColor,
      fillColor: AppColors.whiteColor,
      borderColor: AppColors.lightGreyColor,
      focusBorderColor: AppColors.orangeColor,
      isDigitDot: isDigitDot,
      maxLines: maxLines,
      textFormHeight: maxLines > 1 ? (textFormHeight ?? 80) : 35,
      validator: validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return '${title.tr()} ${LocaleKeys.common_required_field.tr()}';
            }
            if (isDigitDot) {
              final parsed = double.tryParse(value.trim());
              if (parsed == null || parsed < 0) {
                return LocaleKeys.enterYourData.tr();
              }
            }
            return null;
          },
    );
  }
}
