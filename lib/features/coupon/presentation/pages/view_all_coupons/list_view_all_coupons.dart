import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/features/coupon/presentation/bloc/coupon_cubit/coupon_cubit.dart';
import 'package:web_admin_san/features/coupon/presentation/bloc/coupon_cubit/coupon_state.dart';
import 'package:web_admin_san/features/coupon/presentation/custom_widget/widget_design_list_coupon.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';

class ListViewAllCoupons extends StatelessWidget {
  const ListViewAllCoupons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CouponCubit, CouponState>(
      builder: (
          context,
          state,
          ) {
        // =========================================
        // LOADING
        // =========================================

        if (state is CouponLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // =========================================
        // ERROR
        // =========================================

        if (state is CouponFailure) {
          return Center(
            child: Text(
              state.message,
            ),
          );
        }

        // =========================================
        // SUCCESS
        // =========================================

        if (state is CouponGetAllSuccess) {
          if (state.coupons.isEmpty) {
            return const Center(
              child: TextEmptyViewData(),
            );
          }

          return CustomContainer(
            isSelected: false,
            onTap: () {},

            typeWidget:
            ListView.separated(
              itemCount:
              state.coupons.length,

              separatorBuilder: (
                  _,
                  __,
                  ) {
                return const SizedBox(
                  height: 20,
                );
              },

              itemBuilder: (
                  context,
                  index,
                  ) {
                final coupon =
                state.coupons[index];

                return WidgetDesignListCoupon(
                  couponId:
                  coupon.coupon.couponId,
                  couponCode:
                  coupon.coupon.couponCode,
                  discountType:
                  coupon.coupon.discountType,
                  discountValue:
                  coupon.coupon.discountValue,
                  isActive:
                  coupon.coupon.isActive,
                  maxDiscountValue:
                  coupon.coupon.maxDiscountValue,
                  minValueToApply:
                  coupon.coupon.minValueToApply,
                  startDate:
                  coupon.coupon.couponStartDate,
                  endDate:
                  coupon.coupon.couponEndDate,
                  providers:
                  coupon.providers,

                  onTapDetails: () async {
                    // final result =
                    // await Navigator.push(
                    //   context,
                    //   NavigateToPageWidget(
                    //     PageDetailsCoupon(
                    //       couponId:
                    //       coupon.coupon.couponId ??
                    //           0,
                    //     ),
                    //   ),
                    // );
                    //
                    // if (result == true &&
                    //     context.mounted) {
                    //   await context
                    //       .read<CouponCubit>()
                    //       .getAllCoupons();
                    // }
                  },
                );
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}