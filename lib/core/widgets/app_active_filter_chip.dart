import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';

class AppActiveFilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onDeleted;

  const AppActiveFilterChip({
    super.key,
    required this.label,
    required this.icon,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.orangeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.orangeColor.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.orangeColor,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.darkColor,
            ),
          ),
          if (onDeleted != null) ...[
            const SizedBox(width: 6),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: onDeleted,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.orangeColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 13,
                    color: AppColors.orangeColor,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AppClearAllFiltersChip extends StatelessWidget {
  final VoidCallback onClearAll;

  AppClearAllFiltersChip({
    super.key,
    VoidCallback? onClearAll,
    VoidCallback? onPressed,
  }) : onClearAll = (onClearAll ?? onPressed ?? () {});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onClearAll,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.scaffoldColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.lightGreyColor),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.restart_alt_rounded,
                size: 14,
                color: AppColors.darkGreyColor,
              ),
              SizedBox(width: 4),
              Text(
                'مسح الكل',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGreyColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
