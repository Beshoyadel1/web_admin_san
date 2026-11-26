import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/layout/view_model/layout_cubit/app_cubit.dart';
import 'package:web_admin_san/feature/layout/view_model/layout_cubit/app_states.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';

class FreeTrialWidget extends StatelessWidget {
  const FreeTrialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      buildWhen: (previous, current) => current is ChangeAllAppLanguageState,
      builder: (BuildContext context, AppStates state) {
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {},
          child: SizedBox(
            width: context.read<AppCubit>().isAllAppLanguageArabic ? 150 : 100,
            child: const Column(
              children: [
                TextInAppWidget(
                  text: LocaleKeys.Free_Trial,
                  textSize: 20,
                  fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                  textColor: AppColors.scaffoldColor,
                ),
                Divider(
                  color: AppColors.scaffoldColor,
                  thickness: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
