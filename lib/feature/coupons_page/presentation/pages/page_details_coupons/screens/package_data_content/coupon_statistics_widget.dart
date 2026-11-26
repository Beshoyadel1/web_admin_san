import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/coupons_page/data/model/coupon_statistics_model/coupon_statistics_model.dart';
import 'package:web_admin_san/feature/coupons_page/data/model/statistic_item/statistic_item.dart';
import 'package:web_admin_san/feature/coupons_page/data/request/get_coupon_statistics_request/get_coupon_statistics_request.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/page_details_coupons/screens/package_data_content/statistics_card.dart';
import 'package:web_admin_san/feature/coupons_page/view_model/coupon_cubit/coupon_cubit.dart';
import 'package:web_admin_san/feature/coupons_page/view_model/coupon_cubit/coupon_state.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class CouponStatisticsWidget extends StatelessWidget {
  final int couponId;

  const CouponStatisticsWidget({
    super.key,
    required this.couponId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CouponCubit, CouponState>(
      buildWhen: (previous, current) {
        return current is CouponStatisticsLoading ||
            current is CouponStatisticsSuccess ||
            current is CouponStatisticsFailure;
      },
      builder: (context, state) {
        if (state is CouponStatisticsLoading) {
          return const SizedBox(
            height: 90,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.orangeColor,
              ),
            ),
          );
        }

        if (state is CouponStatisticsFailure) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.redColor.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextInAppWidget(
                    text: state.message,
                    textSize: 13,
                    textColor: AppColors.darkGreyColor,
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: TextButton.icon(
                    onPressed: () {
                      context.read<CouponCubit>().getCouponStatistics(
                            request: GetCouponStatisticsRequest(
                              couponId: couponId,
                            ),
                          );
                    },
                    icon: const Icon(
                      Icons.refresh,
                      size: 16,
                      color: AppColors.orangeColor,
                    ),
                    label: TextInAppWidget(
                      text: LocaleKeys.retry.tr(),
                      textSize: 13,
                      textColor: AppColors.orangeColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is CouponStatisticsSuccess) {
          final statistics = state.statistics;

          if (statistics.isEmpty) {
            return const SizedBox();
          }

          final data = statistics.first;
          return CouponStatisticsList(data: data);
        }

        return const SizedBox();
      },
    );
  }
}

class CouponStatisticsList extends StatelessWidget {
  final CouponStatisticsModel data;

  const CouponStatisticsList({
    super.key,
    required this.data,
  });

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final statistics = [
      StatisticItem(
        title: LocaleKeys.ordersCountKey.tr(),
        value: data.totalOrders.toString(),
        icon: Icons.shopping_cart_outlined,
      ),
      StatisticItem(
        title: LocaleKeys.totalSales.tr(),
        value:
            '${_formatNumber(data.totalSales)} ${LocaleKeys.sarCurrency.tr()}',
        icon: Icons.payments_outlined,
      ),
      StatisticItem(
        title: LocaleKeys.uniqueUsersCount.tr(),
        value: data.uniqueUsersCount.toString(),
        icon: Icons.people_outline,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const double minItemWidth = 240;
        int itemsPerRow = (constraints.maxWidth / minItemWidth).floor();
        if (itemsPerRow < 1) {
          itemsPerRow = 1;
        }

        final double itemWidth =
            (constraints.maxWidth - ((itemsPerRow - 1) * 16)) / itemsPerRow;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: statistics.map((item) {
            return SizedBox(
              width: itemWidth,
              child: StatisticsCard(item: item),
            );
          }).toList(),
        );
      },
    );
  }
}
