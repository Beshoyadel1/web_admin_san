import 'package:flutter/material.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/assets.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';


class CustomAdminPermissionWidget extends StatelessWidget {
  final String permissionKey;
  final String text;
  final bool isChecked;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomAdminPermissionWidget({
    super.key,
    required this.permissionKey,
    required this.text,
    required this.isChecked,
    required this.readOnly,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: readOnly ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            activeColor: AppColors.orangeColor,
            value: isChecked,
            onChanged: readOnly
                ? null
                : (_) {
              onTap?.call();
            },
          ),

          Opacity(
            opacity: isChecked ? 1.0 : .5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ColorFiltered(
                  colorFilter: isChecked
                      ? const ColorFilter.mode(
                    AppColors.orangeColor,
                    BlendMode.srcIn,
                  )
                      :const ColorFilter.mode(
                    AppColors.greyColor,
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    _getPermissionImage(permissionKey),
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 5),

                TextInAppWidget(
                  text: text,
                  textSize: 11,
                  // Bold when selected
                  fontWeightIndex: isChecked
                      ? FontSelectionData.boldFontFamily
                      : FontSelectionData.regularFontFamily,

                  textColor: isChecked
                      ? AppColors.orangeColor
                      : AppColors.blackColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  String _getPermissionImage(String key) {
    switch (key) {
      case 'statistic':
        return AppImageKeys.pages;

      case 'orders':
        return AppImageKeys.order;

      case 'providers':
        return AppImageKeys.provider;

      case 'companies':
        return AppImageKeys.company;

      case 'users':
        return AppImageKeys.users;

      case 'finances':
        return AppImageKeys.wallet;

      case 'packages':
        return AppImageKeys.packages;

      case 'approvals':
        return AppImageKeys.approved;

      case 'ranks':
        return AppImageKeys.rank;

      case 'support':
        return AppImageKeys.support;

      case 'admins':
        return AppImageKeys.admin;

      case 'banners':
        return AppImageKeys.banner;

      case 'coupons':
        return AppImageKeys.coupon;

      case 'harage':
        return AppImageKeys.car;

      case 'insurance':
        return AppImageKeys.insurance;

      default:
        return AppImageKeys.userPermissions;
    }
  }
}