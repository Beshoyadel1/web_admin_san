import 'package:flutter/material.dart';
import 'package:web_admin_san/features/coupon/presentation/pages/page_details_coupons/screens/package_data_content/coupons_data_view.dart';
import '../../../../../../core/theming/colors.dart';


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
        backgroundColor: AppColors.scaffoldColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: CouponDataView(
          couponId: couponId,
        ),
      ),
    );
  }
}