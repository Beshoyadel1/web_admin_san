import 'package:flutter/cupertino.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../../core/helpers/themes/text_styles.dart';

class DataColumnOfFirstRowInDataContainerInListDataFirstScreenInternalOrders
    extends StatelessWidget {
  const DataColumnOfFirstRowInDataContainerInListDataFirstScreenInternalOrders(
      {super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInAppWidget(
            text: LocaleKeys.newRequests,
            textSize: 15,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.blackColor,
          ),
          TextInAppWidget(
            text: LocaleKeys.newRequestsList,
            textSize: 13,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
            textColor: AppColors.greyColor,
          )
        ],
      ),
    );
  }
}
