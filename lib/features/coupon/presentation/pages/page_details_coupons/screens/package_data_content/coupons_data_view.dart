import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/coupon/presentation/bloc/coupon_cubit/coupon_cubit.dart';
import 'package:web_admin_san/features/coupon/presentation/pages/page_details_coupons/screens/package_data_content/coupons_data_content.dart';
import 'package:web_admin_san/features/packages/presentation/pages/page_details_packages/screens/package_data_content/package_data_content.dart';
import '../../../../../../../features/packages/presentation/bloc/packages_cubit/packages_cubit.dart';

class CouponDataView extends StatelessWidget {
  final String couponCode;
  final int userId;

  const CouponDataView({
    super.key,
    required this.couponCode,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CouponCubit()
        ..getCouponByCode(
          couponCode: couponCode,
          userId: userId,
        ),
      child: CouponsDataContent(
        couponCode: couponCode, userId: userId,
      ),
    );
  }
}
