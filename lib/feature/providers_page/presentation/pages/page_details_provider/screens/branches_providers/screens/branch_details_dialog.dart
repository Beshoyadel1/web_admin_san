import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/providers_page/data/model/facility_provider_model/get_provider_branches_model/provider_branch_model.dart';

void showBranchDetailsDialog(BuildContext context, ProviderBranchModel branch) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => BranchDetailsDialog(branch: branch),
  );
}

class BranchDetailsDialog extends StatelessWidget {
  final ProviderBranchModel branch;

  const BranchDetailsDialog({
    super.key,
    required this.branch,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.maybeLocaleOf(context)?.languageCode != 'en';
    final hasCoordinates = branch.lat != null &&
        branch.long != null &&
        branch.lat != 0 &&
        branch.long != 0;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final dialogWidth = screenWidth < 700 ? (screenWidth * 0.95) : 640.0;
    final isTwoColumns = dialogWidth >= 480;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: BranchDialogHeader(branch: branch),
      content: SizedBox(
        width: dialogWidth,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 620),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Basic Information Section
                Text(
                  LocaleKeys.basicInformation.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 12),
                if (isTwoColumns) ...[
                  Row(
                    children: [
                      Expanded(
                        child: BranchInfoTile(
                          icon: Icons.store_outlined,
                          label: LocaleKeys.branchNameArabic.tr(),
                          value: (branch.branchName != null &&
                                  branch.branchName!.isNotEmpty)
                              ? branch.branchName!
                              : '-',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BranchInfoTile(
                          icon: Icons.language_outlined,
                          label: LocaleKeys.branchNameEnglish.tr(),
                          value: (branch.branchLatinName != null &&
                                  branch.branchLatinName!.isNotEmpty)
                              ? branch.branchLatinName!
                              : '-',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: BranchInfoTile(
                          icon: Icons.tag_rounded,
                          label: LocaleKeys.nationalAddress.tr(),
                          value: (branch.nationalAddress != null &&
                                  branch.nationalAddress!.isNotEmpty)
                              ? branch.nationalAddress!
                              : '-',
                          onCopy: branch.nationalAddress != null &&
                                  branch.nationalAddress!.isNotEmpty
                              ? () {
                                  Clipboard.setData(ClipboardData(
                                      text: branch.nationalAddress!));
                                  AppSnackBar.showSuccess(
                                      LocaleKeys.nationalAddressCopied.tr());
                                }
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BranchInfoTile(
                          icon: Icons.verified_user_outlined,
                          label: LocaleKeys.branchStatus.tr(),
                          value: branch.isActive == true
                              ? (LocaleKeys.branchActiveStatus.tr())
                              : (LocaleKeys.branchInactiveStatus.tr()),
                          valueColor: branch.isActive == true
                              ? AppColors.greenColor
                              : AppColors.darkGreyColor,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  BranchInfoTile(
                    icon: Icons.store_outlined,
                    label: LocaleKeys.branchNameArabic.tr(),
                    value: (branch.branchName != null &&
                            branch.branchName!.isNotEmpty)
                        ? branch.branchName!
                        : '-',
                  ),
                  const SizedBox(height: 12),
                  BranchInfoTile(
                    icon: Icons.language_outlined,
                    label: LocaleKeys.branchNameEnglish.tr(),
                    value: (branch.branchLatinName != null &&
                            branch.branchLatinName!.isNotEmpty)
                        ? branch.branchLatinName!
                        : '-',
                  ),
                  const SizedBox(height: 12),
                  BranchInfoTile(
                    icon: Icons.tag_rounded,
                    label: LocaleKeys.nationalAddress.tr(),
                    value: (branch.nationalAddress != null &&
                            branch.nationalAddress!.isNotEmpty)
                        ? branch.nationalAddress!
                        : '-',
                    onCopy: branch.nationalAddress != null &&
                            branch.nationalAddress!.isNotEmpty
                        ? () {
                            Clipboard.setData(
                                ClipboardData(text: branch.nationalAddress!));
                            AppSnackBar.showSuccess(
                                LocaleKeys.nationalAddressCopied.tr());
                          }
                        : null,
                  ),
                  const SizedBox(height: 12),
                  BranchInfoTile(
                    icon: Icons.verified_user_outlined,
                    label: LocaleKeys.branchStatus.tr(),
                    value: branch.isActive == true
                        ? (LocaleKeys.branchActiveStatus.tr())
                        : (LocaleKeys.branchInactiveStatus.tr()),
                    valueColor: branch.isActive == true
                        ? AppColors.greenColor
                        : AppColors.darkGreyColor,
                  ),
                ],
                const SizedBox(height: 20),

                // Address & Location Section
                Text(
                  LocaleKeys.addressAndLocation.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 12),
                BranchInfoTile(
                  icon: Icons.location_on_outlined,
                  label: LocaleKeys.addressDetailsArabic.tr(),
                  value: (branch.addressText != null &&
                          branch.addressText!.isNotEmpty)
                      ? branch.addressText!
                      : ((branch.address != null && branch.address!.isNotEmpty)
                          ? branch.address!
                          : '-'),
                ),
                if (branch.addressLatinText != null &&
                    branch.addressLatinText!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  BranchInfoTile(
                    icon: Icons.translate_rounded,
                    label: LocaleKeys.addressDetailsEnglish.tr(),
                    value: branch.addressLatinText!,
                  ),
                ],
                const SizedBox(height: 12),
                BranchInfoTile(
                  icon: Icons.my_location_rounded,
                  label: LocaleKeys.gpsCoordinates.tr(),
                  value: hasCoordinates
                      ? '${branch.lat!.toStringAsFixed(6)}, ${branch.long!.toStringAsFixed(6)}'
                      : (LocaleKeys.notSpecified.tr()),
                  onCopy: hasCoordinates
                      ? () {
                          Clipboard.setData(ClipboardData(
                              text: '${branch.lat}, ${branch.long}'));
                          AppSnackBar.showSuccess(
                              LocaleKeys.coordinatesCopied.tr());
                        }
                      : null,
                ),

                // Interactive Map Preview
                if (hasCoordinates) ...[
                  const SizedBox(height: 16),
                  Text(
                    LocaleKeys.mapLocation.tr(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGreyColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  BranchMapPreview(
                    lat: branch.lat!,
                    long: branch.long!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      actions: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orangeColor,
                foregroundColor: AppColors.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 28),
                elevation: 0,
              ),
              child: Text(
                LocaleKeys.close.tr(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BranchDialogHeader extends StatelessWidget {
  final ProviderBranchModel branch;

  const BranchDialogHeader({
    super.key,
    required this.branch,
  });

  @override
  Widget build(BuildContext context) {
    final branchName = branch.getBranchName(context);
    final isArabic = Localizations.maybeLocaleOf(context)?.languageCode != 'en';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(
          bottom: BorderSide(color: AppColors.veryLightGreyColor),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: AppColors.orangeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(
                Icons.store_mall_directory_rounded,
                color: AppColors.orangeColor,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        branchName.isNotEmpty
                            ? branchName
                            : (branch.branchName ??
                                LocaleKeys.branchDefault.tr()),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (branch.branchId != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldColor,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.lightGreyColor),
                        ),
                        child: Text(
                          '#${branch.branchId}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkGreyColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: branch.isActive == true
                            ? AppColors.greenColor.withValues(alpha: 0.12)
                            : AppColors.greyColor200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        branch.isActive == true
                            ? (LocaleKeys.branchActiveStatus.tr())
                            : (LocaleKeys.branchInactiveStatus.tr()),
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
              ],
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: IconButton(
              icon: const Icon(Icons.close_rounded, size: 20),
              color: AppColors.darkGreyColor,
              onPressed: () => Navigator.of(context).pop(),
              tooltip: LocaleKeys.close.tr(),
            ),
          ),
        ],
      ),
    );
  }
}

class BranchInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final VoidCallback? onCopy;

  const BranchInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightGreyColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              icon,
              size: 18,
              color: AppColors.orangeColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.darkGreyColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? AppColors.darkColor,
                  ),
                ),
              ],
            ),
          ),
          if (onCopy != null)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: IconButton(
                icon: const Icon(Icons.copy_rounded, size: 16),
                color: AppColors.orangeColor,
                onPressed: onCopy,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: LocaleKeys.copyTooltip.tr(),
              ),
            ),
        ],
      ),
    );
  }
}

class BranchMapPreview extends StatelessWidget {
  final double lat;
  final double long;

  const BranchMapPreview({
    super.key,
    required this.lat,
    required this.long,
  });

  @override
  Widget build(BuildContext context) {
    final location = LatLng(lat, long);
    final isTestEnvironment =
        WidgetsBinding.instance.runtimeType.toString().contains('Test');

    return Container(
      height: 200,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGreyColor),
      ),
      child: isTestEnvironment
          ? Container(
              color: AppColors.scaffoldColor,
              child: const Center(
                child: Icon(
                  Icons.location_on,
                  size: 40,
                  color: AppColors.orangeColor,
                ),
              ),
            )
          : FlutterMap(
              options: MapOptions(
                center: location,
                zoom: 14.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.smat_admin',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: location,
                      width: 44,
                      height: 44,
                      builder: (_) => const Center(
                        child: Icon(
                          Icons.location_on,
                          size: 40,
                          color: AppColors.orangeColor,
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
