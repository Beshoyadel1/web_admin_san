import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class CarApprovalTypeBadge extends StatelessWidget {
  final int requestType;

  const CarApprovalTypeBadge({
    super.key,
    required this.requestType,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCreate = requestType == 1;

    final Color bg =
        isCreate ? AppColors.blueColor100 : AppColors.CircleLightorangeColor;
    final Color textColor =
        isCreate ? AppColors.blueColor : AppColors.orangeColor;
    final IconData icon =
        isCreate ? Icons.add_circle_outline_rounded : Icons.edit_note_rounded;
    final String label = isCreate
        ? LocaleKeys.newCarBadge.tr()
        : LocaleKeys.updateDataBadge.tr();

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
