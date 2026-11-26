import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/helpers/constants/assets.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/widgets/custom_container.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 15,
        runSpacing: 5,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          Wrap(
            spacing: 15,
            runSpacing: 5,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              CustomContainer(
                containerHeight: 35,
                containerWidth: 131,
                isSelected: true,
                onTap: () {},
                containerColor: AppColors.darkGreyColor,
                padding: EdgeInsets.zero,
                border: const Border(),
                typeWidget: const Center(
                  child: TextInAppWidget(
                    text: LocaleKeys.searchKey,
                    textSize: 16,
                    textColor: AppColors.whiteColor,
                  ),
                ),
              ),
            ],
          ),
          CustomContainer(
            containerHeight: 35,
            containerWidth: 107,
            isSelected: true,
            onTap: () {},
            containerColor: AppColors.lightGreyColor,
            padding: EdgeInsets.zero,
            border: const Border(),
            typeWidget: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   AppImageKeys.filter,
                  //   height: 24,
                  //   width: 24,
                  // ),
                  const TextInAppWidget(
                    text: LocaleKeys.filterKey,
                    textSize: 16,
                    textColor: AppColors.darkColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
