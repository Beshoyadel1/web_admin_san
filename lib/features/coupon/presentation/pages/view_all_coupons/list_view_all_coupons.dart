import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/show_delete_confirmation_dialog_in_app.dart';
import 'package:web_admin_san/features/coupon/presentation/bloc/coupon_cubit/coupon_cubit.dart';
import 'package:web_admin_san/features/coupon/presentation/bloc/coupon_cubit/coupon_state.dart';
import 'package:web_admin_san/features/coupon/presentation/custom_widget/widget_design_list_coupon.dart';
import 'package:web_admin_san/features/coupon/presentation/pages/page_details_coupons/page_details_coupons.dart';
import 'package:web_admin_san/features/coupon/presentation/pages/view_all_coupons/create_coupon_dialog.dart';
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
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(
                height: 400,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
        }

        // =========================================
        // FAILURE
        // =========================================

        if (state is CouponFailure) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: 400,
                child: Center(
                  child: Text(
                    state.message,
                  ),
                ),
              ),
            ],
          );
        }

        // =========================================
        // SUCCESS
        // =========================================

        if (state is CouponGetAllSuccess) {
          // =========================================
          // EMPTY
          // =========================================

          if (state.coupons.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(
                  height: 400,
                  child: Center(
                    child: TextEmptyViewData(),
                  ),
                ),
              ],
            );
          }

          // =========================================
          // DATA
          // =========================================

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(
              bottom: 20,
            ),
            children: [
              CustomContainer(
                isSelected: false,
                containerWidth: double.infinity,
                onTap: () {},

                typeWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    state.coupons.length,
                        (index) {
                      final coupon = state.coupons[index];

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == state.coupons.length - 1
                              ? 0
                              : 20,
                        ),
                        child: WidgetDesignListCoupon(
                          couponId: coupon.coupon.couponId,

                          couponCode: coupon.coupon.couponCode,

                          discountValue: coupon.coupon.discountValue,

                          isActive: coupon.coupon.isActive,

                          startDate: coupon.coupon.couponStartDate,

                          endDate: coupon.coupon.couponEndDate,

                          // =================================
                          // DETAILS
                          // =================================

                          onTapDetails: () async {
                            if (coupon.providers.isEmpty) {
                              return;
                            }

                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                                  return PageDetailsCoupons(
                                    couponCode:
                                    coupon.coupon.couponCode ?? '',
                                    userId: coupon.providers.first,
                                  );
                                },
                              ),
                            );

                            if (!context.mounted) {
                              return;
                            }

                            if (result == true) {
                              await context
                                  .read<CouponCubit>()
                                  .getAllCoupons();
                            }
                          },

                          // =================================
                          // EDIT
                          // =================================

                          onTapEdit: () async {
                            final result = await showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) {
                                return BlocProvider.value(
                                  value: context.read<CouponCubit>(),
                                  child: CreateCouponDialog(
                                    couponData: coupon,
                                  ),
                                );
                              },
                            );

                            if (!context.mounted) {
                              return;
                            }

                            if (result == true) {
                              await context
                                  .read<CouponCubit>()
                                  .getAllCoupons();
                            }
                          },

                          // =================================
                          // DELETE
                          // =================================

                          onTapDelete: () async {
                            final confirmed =
                            await showDeleteConfirmationDialogInApp(
                              context,
                            );

                            if (confirmed != true) {
                              return;
                            }

                            final couponId =
                                coupon.coupon.couponId;

                            if (couponId == null) {
                              return;
                            }

                            if (!context.mounted) {
                              return;
                            }

                            await context
                                .read<CouponCubit>()
                                .deleteCoupon(
                              couponId: couponId,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }

        // =========================================
        // INITIAL
        // =========================================

        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(
              height: 400,
            ),
          ],
        );
      },
    );
  }
}