import 'package:flutter/material.dart';
import '../../../../../../../../../core/helpers/constants/assets.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/widgets/custom_container.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';

class InternalServices extends StatelessWidget {
  const InternalServices({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      containerHeight: 110,
      containerWidth: 280,
      isSelected: false,
      onTap: () {},
      typeWidget: Center(
        child: Row(
          spacing: 10,
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(8),
            //   child: ColoredBox(
            //     color: AppColors.orangeColor.withAlpha(50),
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Image.asset(
            //         AppImageKeys.maintenance,
            //         width: 40,
            //         height: 40,
            //         fit: BoxFit.contain,
            //       ),
            //     ),
            //   ),
            // ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextInAppWidget(
                    text: LocaleKeys.washingAndCleaningKey,
                    textSize: 16,
                    textColor: AppColors.darkColor),
                TextInAppWidget(
                    text: LocaleKeys.ordersCountKey,
                    textSize: 16,
                    textColor: AppColors.orangeColor)
              ],
            )
          ],
        ),
      ),
    );
  }
}
