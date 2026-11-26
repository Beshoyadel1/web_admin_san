import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/feature/permissions/view_model/check_box_with_text_cubit.dart';
import '../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../core/helpers/themes/fonts.dart';
import '../../../../../core/helpers/themes/text_styles.dart';

class CheckBoxWithText extends StatelessWidget {
  final String text;
  final String? imageSelect;

  const CheckBoxWithText({
    super.key,
    required this.text,
    this.imageSelect,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckBoxWithTextCubit(),
      child: BlocBuilder<CheckBoxWithTextCubit, bool>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, isChecked) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                activeColor: AppColors.orangeColor,
                value: isChecked,
                onChanged: (value) {
                  context.read<CheckBoxWithTextCubit>().toggle(value ?? false);
                },
              ),
              if (imageSelect != null)
                Opacity(
                  opacity: isChecked ? 1 : 0.5,
                  child: Column(
                    spacing: 5,
                    children: [
                      Image.asset(
                        imageSelect!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                      TextInAppWidget(
                        text: text,
                        textSize: 11,
                        fontWeightIndex: FontSelectionData.regularFontFamily,
                        textColor: AppColors.blackColor,
                      ),
                    ],
                  ),
                )
              else
                TextInAppWidget(
                  text: text,
                  textSize: 11,
                  fontWeightIndex: FontSelectionData.regularFontFamily,
                  textColor:
                      isChecked ? AppColors.blackColor : AppColors.greyColor,
                ),
            ],
          );
        },
      ),
    );
  }
}
