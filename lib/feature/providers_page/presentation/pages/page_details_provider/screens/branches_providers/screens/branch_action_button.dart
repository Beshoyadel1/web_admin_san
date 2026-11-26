import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class BranchActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSmall;

  const BranchActionButton({
    super.key,
    required this.onTap,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: CustomContainer(
        isSelected: false,
        onTap: onTap,
        containerColor: AppColors.darkGreyColor,
        containerWidth: isSmall ? double.infinity : 162,
        containerHeight: 42,
        typeWidget: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.visibility_outlined,
              color: AppColors.whiteColor,
              size: 20,
            ),
            SizedBox(width: 8),
            Flexible(
              child: TextInAppWidget(
                text: LocaleKeys.view,
                textSize: 16,
                textColor: AppColors.whiteColor,
                fontWeightIndex: FontSelectionData.boldFontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
