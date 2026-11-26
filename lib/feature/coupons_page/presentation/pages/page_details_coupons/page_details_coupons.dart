import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/page_details_coupons/screens/package_data_content/coupons_data_view.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class PageDetailsCoupons extends StatelessWidget {
  final int couponId;

  const PageDetailsCoupons({
    super.key,
    required this.couponId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        surfaceTintColor: AppColors.transparent,
        elevation: 0.5,
        leading: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.darkColor,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        title: const TextInAppWidget(
          text: LocaleKeys.couponInformation,
          textSize: 17,
          fontWeightIndex: FontSelectionData.boldFontFamily,
          textColor: AppColors.darkColor,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CouponDataView(
            couponId: couponId,
          ),
        ),
      ),
    );
  }
}
