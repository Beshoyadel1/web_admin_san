import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';

enum HaragFilterTab {
  all,
  newCars,
  usedCars,
  soldCars,
}

class HaragFilterTabsWidget extends StatelessWidget {
  final HaragFilterTab selectedTab;
  final ValueChanged<HaragFilterTab> onTabChanged;

  const HaragFilterTabsWidget({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: [
        _buildPillTab(
          title: LocaleKeys.allCars.tr(),
          tab: HaragFilterTab.all,
        ),
        _buildPillTab(
          title: LocaleKeys.newCars.tr(),
          tab: HaragFilterTab.newCars,
        ),
        _buildPillTab(
          title: LocaleKeys.usedCars.tr(),
          tab: HaragFilterTab.usedCars,
        ),
        _buildPillTab(
          title: LocaleKeys.soldCars.tr(),
          tab: HaragFilterTab.soldCars,
        ),
      ],
    );
  }

  Widget _buildPillTab({
    required String title,
    required HaragFilterTab tab,
  }) {
    final isSelected = selectedTab == tab;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onTabChanged(tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.orangeColor
                : AppColors.greyColor.withOpacity(0.55),
            borderRadius: BorderRadius.circular(25),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.orangeColor.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: TextInAppWidget(
            text: title,
            textSize: 14,
            fontWeightIndex: isSelected
                ? FontSelectionData.boldFontFamily
                : FontSelectionData.mediumFontFamily,
            textColor: AppColors.whiteColor,
          ),
        ),
      ),
    );
  }
}
