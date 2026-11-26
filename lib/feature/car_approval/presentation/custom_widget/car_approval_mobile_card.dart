import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/car_approval/data/model/car_approval_request_item_model.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'car_approval_status_badge.dart';
import 'car_approval_type_badge.dart';

class CarApprovalMobileCard extends StatelessWidget {
  final CarApprovalRequestItemModel item;
  final VoidCallback onInspect;

  const CarApprovalMobileCard({
    super.key,
    required this.item,
    required this.onInspect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardStroke),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top row: ID + Badges
          Row(
            children: [
              Text(
                '#${item.requestId}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.darkColor,
                ),
              ),
              const Spacer(),
              CarApprovalTypeBadge(requestType: item.requestType),
              const SizedBox(width: 8),
              CarApprovalStatusBadge(status: item.status),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.veryLightGreyColor),
          const SizedBox(height: 12),

          // Car info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  color: AppColors.orangeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.brandName} ${item.modelName}'.trim(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.darkColor,
                      ),
                    ),
                    if (item.carName != null && item.carName!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.carName!,
                        style: const TextStyle(
                          color: AppColors.darkGreyColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.pin_outlined,
                            size: 14, color: AppColors.darkGreyColor),
                        const SizedBox(width: 4),
                        Text(
                          '${LocaleKeys.plateLabel.tr()} ${item.plateNo ?? "—"}',
                          style: const TextStyle(
                            color: AppColors.darkColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Owner & Date
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.scaffoldColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_outline_rounded,
                    size: 16, color: AppColors.darkGreyColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.ownerName.isEmpty
                        ? '${LocaleKeys.userPrefix.tr()}${item.ownerId}'
                        : item.ownerName,
                    style: const TextStyle(
                      color: AppColors.darkColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (item.ownerPhone.isNotEmpty) ...[
                  Text(
                    item.ownerPhone,
                    style: const TextStyle(
                      color: AppColors.darkGreyColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: item.isPending
                    ? AppColors.orangeColor
                    : AppColors.seaBlueColor,
                foregroundColor: AppColors.whiteColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onInspect,
              icon: Icon(
                item.isPending
                    ? Icons.rate_review_outlined
                    : Icons.visibility_outlined,
                size: 16,
              ),
              label: Text(item.isPending
                  ? LocaleKeys.inspectAndReviewRequest.tr()
                  : LocaleKeys.viewDetails.tr()),
            ),
          ),
        ],
      ),
    );
  }
}
