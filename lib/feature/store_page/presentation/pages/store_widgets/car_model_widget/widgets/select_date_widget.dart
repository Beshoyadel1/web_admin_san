import 'package:flutter/material.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/widgets/text_form_field_widget.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';

class SelectDateWidget extends StatelessWidget {
  const SelectDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: TextFormFieldWidget(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              textFormController: TextEditingController(),
              text: LocaleKeys.fromKey,
              textSize: 16,
              isColumn: true,
              textColor: AppColors.darkColor,
              borderColor: AppColors.darkGreyColor,
              fillColor: AppColors.whiteColor,
              textFormHeight: 35,
              hintText: '2020',
              suffixIcon: Icons.keyboard_arrow_down_outlined,
              suffixIconSize: 27,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Flexible(
            child: TextFormFieldWidget(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              textFormController: TextEditingController(),
              text: LocaleKeys.toKey,
              textSize: 16,
              isColumn: true,
              textColor: AppColors.darkColor,
              borderColor: AppColors.darkGreyColor,
              //borderRadius: 20,
              fillColor: AppColors.whiteColor,
              textFormHeight: 35,
              hintText: '2025',
              suffixIcon: Icons.keyboard_arrow_down_outlined,
              suffixIconSize: 27,
              //suffixIconColor: AppColors.darkGreyColor,
            ),
          ),
        ],
      ),
    );
  }
}
