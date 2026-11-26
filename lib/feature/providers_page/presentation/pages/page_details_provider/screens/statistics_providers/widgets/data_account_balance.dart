import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_provider_total_rate_and_employee_and_balance_model/get_provider_total_rate_and_employee_and_balance_model.dart';
import '../../../../../../../../core/helpers/themes/fonts.dart';

class DataAccountBalance extends StatelessWidget {
  final AccountBalance item;

  const DataAccountBalance({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.all(0),
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(10),
      typeWidget: ListTile(
        // leading: Image.asset(
        //   AppImageKeys.maintenance,
        //   height: 34,
        //   width: 34,
        // ),

        title: TextInAppWidget(
          text: item.getName(context),
          textSize: 12,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.orangeColor,
        ),

        subtitle: Row(
          children: [
            const TextInAppWidget(
              text: LocaleKeys.identity,
              textSize: 12,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: AppColors.darkColor,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: TextInAppWidget(
                text: ": ${item.recentOrderId ?? 0}",
                textSize: 12,
                fontWeightIndex: FontSelectionData.regularFontFamily,
                textColor: AppColors.darkColor,
              ),
            ),
          ],
        ),

        trailing: TextInAppWidget(
          text: "${item.amount ?? 0}",
          textSize: 16,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.greenColor,
        ),
      ),
    );
  }
}
