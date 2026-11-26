import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class CarApprovalFilterTabs extends StatelessWidget {
  final int? selectedStatus;
  final int? selectedRequestType;
  final int pendingCount;
  final Function(int? status) onStatusChanged;
  final Function(int? requestType) onRequestTypeChanged;

  const CarApprovalFilterTabs({
    super.key,
    required this.selectedStatus,
    required this.selectedRequestType,
    required this.pendingCount,
    required this.onStatusChanged,
    required this.onRequestTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardStroke),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: [
          // Status Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                StatusTabButton(
                  label: LocaleKeys.pendingReview.tr(),
                  isSelected: selectedStatus == 1,
                  badgeCount: pendingCount > 0 ? pendingCount : null,
                  badgeColor: AppColors.amberColor,
                  onTap: () => onStatusChanged(1),
                ),
                const SizedBox(width: 8),
                StatusTabButton(
                  label: LocaleKeys.approvedStatus.tr(),
                  isSelected: selectedStatus == 2,
                  onTap: () => onStatusChanged(2),
                ),
                const SizedBox(width: 8),
                StatusTabButton(
                  label: LocaleKeys.rejectedStatus.tr(),
                  isSelected: selectedStatus == 3,
                  onTap: () => onStatusChanged(3),
                ),
                const SizedBox(width: 8),
                StatusTabButton(
                  label: LocaleKeys.allRequests.tr(),
                  isSelected: selectedStatus == null,
                  onTap: () => onStatusChanged(null),
                ),
              ],
            ),
          ),

          // Request Type Selector
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                LocaleKeys.requestTypeLabel.tr(),
                style: const TextStyle(
                  color: AppColors.darkGreyColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.cardStroke),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int?>(
                    value: selectedRequestType,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: AppColors.darkGreyColor),
                    style: const TextStyle(
                      color: AppColors.darkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    items: [
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Text(LocaleKeys.allRequestTypes.tr()),
                      ),
                      DropdownMenuItem<int?>(
                        value: 1,
                        child: Text(LocaleKeys.createCarOnly.tr()),
                      ),
                      DropdownMenuItem<int?>(
                        value: 2,
                        child: Text(LocaleKeys.updateCarOnly.tr()),
                      ),
                    ],
                    onChanged: onRequestTypeChanged,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatusTabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final int? badgeCount;
  final Color? badgeColor;
  final VoidCallback onTap;

  const StatusTabButton({
    super.key,
    required this.label,
    required this.isSelected,
    this.badgeCount,
    this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.orangeColor : AppColors.scaffoldColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.orangeColor : AppColors.cardStroke,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color:
                      isSelected ? AppColors.whiteColor : AppColors.darkColor,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              if (badgeCount != null && badgeCount! > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.whiteColor
                        : (badgeColor ?? AppColors.orangeColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.orangeColor
                          : AppColors.whiteColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
