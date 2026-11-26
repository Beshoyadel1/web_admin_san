import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/communication_and_policies_page/data/model/get_all_pages_about_model/get_all_pages_about_model.dart';

class PolicyTabsBar extends StatelessWidget {
  final List<AboutPageModel> pages;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const PolicyTabsBar({
    super.key,
    required this.pages,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  IconData _getIconForPage(int id) {
    switch (id) {
      case 1:
        return Icons.info_outline_rounded;
      case 2:
        return Icons.gavel_rounded;
      case 3:
        return Icons.security_rounded;
      case 4:
        return Icons.headset_mic_outlined;
      default:
        return Icons.article_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardStroke),
        boxShadow: const [
          BoxShadow(
            color: AppColors.greyColor200,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(pages.length, (index) {
            final page = pages[index];
            final isSelected = selectedIndex == index;
            final title = page.getTitle(isArabic);
            final icon = _getIconForPage(page.id);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: PolicyTabPill(
                title: title,
                icon: icon,
                isSelected: isSelected,
                onTap: () => onTabSelected(index),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class PolicyTabPill extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PolicyTabPill({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.orangeColor : AppColors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: AppColors.greyColor200,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color:
                    isSelected ? AppColors.whiteColor : AppColors.darkGreyColor,
              ),
              const SizedBox(width: 8),
              TextInAppWidget(
                text: title.isEmpty ? 'صفحة' : title,
                textSize: 14,
                fontWeightIndex: isSelected
                    ? FontSelectionData.boldFontFamily
                    : FontSelectionData.mediumFontFamily,
                textColor:
                    isSelected ? AppColors.whiteColor : AppColors.darkColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
