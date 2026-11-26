import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../../core/helpers/themes/text_styles.dart';

class TitleWithSubTitleInOrderDetailsEmp extends StatelessWidget {
  const TitleWithSubTitleInOrderDetailsEmp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TextInAppWidget(
        //   text:'تفاصيل الطلب رقم #452',
        //   textSize: 18,
        //   fontWeightIndex: FontSelectionData.semiBoldFontFamily,
        //   textColor:AppColors.blackColor,
        // ),
        TextInAppWidget(
          text: LocaleKeys.viewAllOrderDetails,
          textSize: 17,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.blackColor44,
        ),
      ],
    );
  }
}
