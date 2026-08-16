import 'package:flutter/material.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/coupon/data/model/statistic_item/statistic_item.dart';

class StatisticsCard extends StatelessWidget {
  final StatisticItem item;

  const StatisticsCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.orangeColor.withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      ),
      child: Row(
        children: [
          // =====================================
          // ICON
          // =====================================

          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.orangeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.icon,
              color: AppColors.orangeColor,
              size: 25,
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          // =====================================
          // TEXT
          // =====================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                TextInAppWidget(
                  text: item.title,
                  textSize: 12,
                  fontWeightIndex:
                  FontSelectionData.mediumFontFamily,
                  textColor:
                  AppColors.greyColor,
                ),


                TextInAppWidget(
                  text: item.value,
                  textSize: 15,
                  fontWeightIndex:
                  FontSelectionData.boldFontFamily,
                  textColor:
                  AppColors.darkColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}