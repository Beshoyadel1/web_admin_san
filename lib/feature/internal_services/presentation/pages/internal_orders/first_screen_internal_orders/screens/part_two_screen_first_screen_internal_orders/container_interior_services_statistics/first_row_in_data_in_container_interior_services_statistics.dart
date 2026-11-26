import 'package:flutter/cupertino.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../../../core/helpers/themes/text_styles.dart';

class FirstRowInDataInContainerInteriorServicesStatistics
    extends StatelessWidget {
  const FirstRowInDataInContainerInteriorServicesStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: TextInAppWidget(
            text: LocaleKeys.internalServicesProfit,
            textSize: 15,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.blackColor,
          ),
        ),
      ],
    );
  }
}
