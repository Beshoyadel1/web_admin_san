import 'package:flutter/cupertino.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';

class FirstRowInDataInContainerProfitsFromMinistryOfInteriorServices
    extends StatelessWidget {
  const FirstRowInDataInContainerProfitsFromMinistryOfInteriorServices(
      {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth;
    bool isTabletCustom = size.width > ValuesOfAllApp.mobileWidth &&
        size.width <= ValuesOfAllApp.customTabWidth;
    bool isTab = size.width > ValuesOfAllApp.tabWidth;
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextInAppWidget(
            text: LocaleKeys.internalServicesStats,
            textSize: 15,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.blackColor,
          ),
        ),
        // SelectTimeProfitServiceWidget(
        //   hint: LocaleKeys.selectTime,
        //   options: [
        //     LocaleKeys.daily,
        //     LocaleKeys.weekly,
        //     LocaleKeys.monthly,
        //   ],
        // )
      ],
    );
  }
}
