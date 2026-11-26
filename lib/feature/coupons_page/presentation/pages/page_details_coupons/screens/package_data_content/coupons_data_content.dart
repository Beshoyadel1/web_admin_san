import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/coupons_page/data/model/coupon_model/coupon_model.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/page_details_coupons/screens/package_data_content/coupon_statistics_widget.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/page_details_coupons/widgets/coupon_assigned_providers_card.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/page_details_coupons/widgets/coupon_details_header_card.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/page_details_coupons/widgets/coupon_discount_rules_card.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/page_details_coupons/widgets/coupon_usage_validity_card.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/view_all_coupons/create_coupon_dialog.dart';
import 'package:web_admin_san/feature/coupons_page/view_model/coupon_cubit/coupon_cubit.dart';
import 'package:web_admin_san/feature/coupons_page/view_model/coupon_cubit/coupon_state.dart';

class CouponsDataContent extends StatefulWidget {
  final int couponId;

  const CouponsDataContent({
    super.key,
    required this.couponId,
  });

  @override
  State<CouponsDataContent> createState() => _CouponsDataContentState();
}

class _CouponsDataContentState extends State<CouponsDataContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openEditDialog(CouponWithProviderModel couponData) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<CouponCubit>(),
          child: CreateCouponDialog(
            couponData: couponData,
          ),
        );
      },
    );

    if (result == true && mounted) {
      await context.read<CouponCubit>().getCouponDetails(
            couponId: widget.couponId,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.orangeColor,
      onRefresh: () async {
        await context.read<CouponCubit>().getCouponDetails(
              couponId: widget.couponId,
            );
      },
      child: BlocBuilder<CouponCubit, CouponState>(
        builder: (context, state) {
          final cubit = context.read<CouponCubit>();

          // Loading
          if (state is CouponLoading && cubit.currentCoupon == null) {
            return const SizedBox(
              height: 400,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          // Error
          if (state is CouponFailure && cubit.currentCoupon == null) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.redColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 40,
                      color: AppColors.redColor,
                    ),
                    const SizedBox(height: 12),
                    TextInAppWidget(
                      text: state.message,
                      textSize: 14,
                      textColor: AppColors.darkGreyColor,
                      isTextCenter: true,
                    ),
                    const SizedBox(height: 16),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<CouponCubit>().getCouponDetails(
                                couponId: widget.couponId,
                              );
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: TextInAppWidget(
                          text: LocaleKeys.retry.tr(),
                          textSize: 13,
                          textColor: AppColors.whiteColor,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orangeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Coupon Data
          if (cubit.currentCoupon != null) {
            final data = cubit.currentCoupon!;
            final coupon = data.coupon;

            return Scrollbar(
              thumbVisibility: true,
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isSideBySide = constraints.maxWidth >= 840;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header Hero Card
                        CouponDetailsHeaderCard(
                          coupon: coupon,
                          onEdit: () => _openEditDialog(data),
                        ),

                        const SizedBox(height: 20),

                        // Statistics Section
                        CouponStatisticsWidget(
                          couponId: coupon.couponId ?? 0,
                        ),

                        const SizedBox(height: 20),

                        // Responsive Side-by-Side Detail Cards
                        if (isSideBySide)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
                                child: CouponDiscountRulesCard(
                                  coupon: coupon,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 6,
                                child: CouponUsageValidityCard(
                                  coupon: coupon,
                                ),
                              ),
                            ],
                          )
                        else ...[
                          CouponDiscountRulesCard(
                            coupon: coupon,
                          ),
                          const SizedBox(height: 20),
                          CouponUsageValidityCard(
                            coupon: coupon,
                          ),
                        ],

                        const SizedBox(height: 20),

                        // Assigned Providers Card
                        CouponAssignedProvidersCard(
                          providerIds: data.providers,
                          providerUsers: cubit.providerUsers,
                        ),

                        const SizedBox(height: 40),
                      ],
                    );
                  },
                ),
              ),
            );
          }

          return const SizedBox(height: 300);
        },
      ),
    );
  }
}
