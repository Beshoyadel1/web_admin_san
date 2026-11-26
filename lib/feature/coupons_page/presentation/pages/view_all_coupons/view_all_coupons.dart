import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/view_all_coupons/create_coupon_dialog.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/view_all_coupons/list_view_all_coupons.dart';
import 'package:web_admin_san/feature/coupons_page/view_model/coupon_cubit/coupon_cubit.dart';

class CouponsPage extends StatelessWidget {
  const CouponsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CouponCubit()..getAllCoupons(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: RefreshIndicator(
                  color: AppColors.orangeColor,
                  onRefresh: () async {
                    await context.read<CouponCubit>().getAllCoupons();
                  },
                  child: const ListCouponsPage(),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.orangeColor,
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (_) {
                    return BlocProvider.value(
                      value: context.read<CouponCubit>(),
                      child: const CreateCouponDialog(),
                    );
                  },
                );

                if (!context.mounted) {
                  return;
                }

                if (result == true) {
                  await context.read<CouponCubit>().getAllCoupons();
                }
              },
              child: const Icon(
                Icons.add,
                color: AppColors.whiteColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
