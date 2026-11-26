import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/coupons_page/view_model/coupon_cubit/coupon_cubit.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/page_details_coupons/screens/package_data_content/coupons_data_content.dart';

class CouponDataView extends StatelessWidget {
  final int couponId;

  const CouponDataView({
    super.key,
    required this.couponId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CouponCubit()..getCouponDetails(couponId: couponId),
      child: CouponsDataContent(
        couponId: couponId,
      ),
    );
  }
}
