import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/providers_page/data/model/facility_provider_model/get_provider_branches_model/provider_branch_model.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class BranchCardItem extends StatelessWidget {
  final ProviderBranchModel branch;
  final VoidCallback onViewDetails;

  const BranchCardItem({
    super.key,
    required this.branch,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final branchName = branch.getBranchName(context);
    final fallbackName =
        (branch.branchName != null && branch.branchName!.isNotEmpty)
            ? branch.branchName!
            : (branch.branchLatinName ?? '');

    final displayName = branchName.isNotEmpty ? branchName : fallbackName;
    final secondaryName = (branch.branchLatinName != null &&
            branch.branchLatinName!.isNotEmpty &&
            branch.branchLatinName != displayName)
        ? branch.branchLatinName!
        : '';

    final address = branch.getAddressText(context);
    final fallbackAddress =
        (branch.addressText != null && branch.addressText!.isNotEmpty)
            ? branch.addressText!
            : (branch.addressLatinText ?? '');
    final displayAddress = address.isNotEmpty ? address : fallbackAddress;

    final hasCoordinates = branch.lat != null &&
        branch.long != null &&
        branch.lat != 0 &&
        branch.long != 0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGreyColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon + Names + Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: AppColors.orangeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Icons.store_mall_directory_rounded,
                    color: AppColors.whiteColor,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName.isNotEmpty
                          ? displayName
                          : LocaleKeys.branchName.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (secondaryName.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        secondaryName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGreyColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: branch.isActive == true
                      ? AppColors.greenColor.withValues(alpha: 0.12)
                      : AppColors.greyColor200,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: branch.isActive == true
                        ? AppColors.greenColor.withValues(alpha: 0.3)
                        : AppColors.lightGreyColor,
                  ),
                ),
                child: Text(
                  branch.isActive == true
                      ? LocaleKeys.branchActiveStatus.tr()
                      : LocaleKeys.branchInactiveStatus.tr(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: branch.isActive == true
                        ? AppColors.greenColor
                        : AppColors.darkGreyColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.veryLightGreyColor,
          ),
          const SizedBox(height: 12),

          // Address details
          if (displayAddress.isNotEmpty) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: AppColors.orangeColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    displayAddress,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.darkColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // National Address
          if (branch.nationalAddress != null &&
              branch.nationalAddress!.isNotEmpty) ...[
            Row(
              children: [
                const Icon(
                  Icons.tag_rounded,
                  size: 16,
                  color: AppColors.darkGreyColor,
                ),
                const SizedBox(width: 6),
                Text(
                  "${LocaleKeys.branchNationalAddress.tr()}: ",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.darkGreyColor,
                  ),
                ),
                Text(
                  branch.nationalAddress!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // Coordinates Badge
          if (hasCoordinates) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.lightOrangeColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.my_location_rounded,
                    size: 13,
                    color: AppColors.orangeColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${branch.lat!.toStringAsFixed(4)}, ${branch.long!.toStringAsFixed(4)}",
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.orangeColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ] else ...[
            const SizedBox(height: 4),
          ],

          const Spacer(),

          // Footer Action Button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: InkWell(
              onTap: onViewDetails,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.orangeColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.orangeColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.visibility_outlined,
                      size: 16,
                      color: AppColors.orangeColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      LocaleKeys.view.tr(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.orangeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
