import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class CarApprovalStatusBadge extends StatelessWidget {
  final int status;

  const CarApprovalStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textColor;
    IconData icon;
    String label;

    switch (status) {
      case 1:
        bg = AppColors.lightAmberColor;
        textColor = AppColors.amberColor;
        icon = Icons.hourglass_top_rounded;
        label = LocaleKeys.pendingReview.tr();
        break;
      case 2:
        bg = AppColors.lightGreenColor;
        textColor = AppColors.greenColor;
        icon = Icons.check_circle_rounded;
        label = LocaleKeys.approved.tr();
        break;
      case 3:
        bg = AppColors.pinkColor;
        textColor = AppColors.redColor;
        icon = Icons.cancel_rounded;
        label = LocaleKeys.rejected.tr();
        break;
      default:
        bg = AppColors.veryLightGreyColor;
        textColor = AppColors.darkGreyColor;
        icon = Icons.help_outline_rounded;
        label = LocaleKeys.undefinedStatus.tr();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
