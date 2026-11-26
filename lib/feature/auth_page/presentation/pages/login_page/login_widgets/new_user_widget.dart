import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/widgets/navigate_to_page_widget.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import '../../sign_up_page/sign_up_page.dart';

class NewUserWidget extends StatelessWidget {
  const NewUserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          NavigateToPageWidget(const SignUpPage()),
        );
      },
      child: const TextInAppWidget(
        text: LocaleKeys.newUserKey,
        textSize: 18,
        textColor: AppColors.seaBlueColor,
        fontWeightIndex: FontSelectionData.semiBoldFontFamily,
        decorationText: TextDecoration.underline,
        decorationTextColor: AppColors.seaBlueColor,
      ),
    );
  }
}
