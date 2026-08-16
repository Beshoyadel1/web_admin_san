import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/coupon/data/model/statistic_item/statistic_item.dart';
import 'package:web_admin_san/features/coupon/presentation/bloc/coupon_cubit/coupon_cubit.dart';
import 'package:web_admin_san/features/coupon/presentation/bloc/coupon_cubit/coupon_state.dart';
import 'package:web_admin_san/features/coupon/presentation/pages/page_details_coupons/screens/package_data_content/statistics_card.dart';

class CouponStatisticsWidget extends StatelessWidget {
  final int couponId;

  const CouponStatisticsWidget({
    super.key,
    required this.couponId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CouponCubit, CouponState>(
      buildWhen: (
          previous,
          current,
          ) {
        return current is CouponStatisticsLoading ||
            current is CouponStatisticsSuccess ||
            current is CouponStatisticsFailure;
      },
      builder: (
          context,
          state,
          ) {
        // =========================================
        // LOADING
        // =========================================

        if (state is CouponStatisticsLoading) {
          return const SizedBox(
            height: 180,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // =========================================
        // ERROR
        // =========================================

        if (state is CouponStatisticsFailure) {
          return SizedBox(
            height: 180,
            child: Center(
              child: TextInAppWidget(
                text: state.message,
                textSize: 14,
                textColor: AppColors.greyColor,
                isTextCenter: true,
              ),
            ),
          );
        }

        // =========================================
        // SUCCESS
        // =========================================

        if (state is CouponStatisticsSuccess) {
          final statistics = state.statistics;

          if (statistics.isEmpty) {
            return const SizedBox(
              height: 150,
              child: Center(
                child: TextInAppWidget(
                  text: '-',
                  textSize: 15,
                  textColor: AppColors.greyColor,
                  isTextCenter: true,
                ),
              ),
            );
          }

          // API returns List
          // Take the first result
          final data = statistics.first;

          return _buildStatistics(
            context,
            data,
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildStatistics(
      BuildContext context,
      dynamic data,
      ) {
    final statistics = [
      StatisticItem(
        title: AppLanguageKeys.ordersCountKey,
        value: data.totalOrders.toString(),
        icon: Icons.shopping_cart_outlined,
      ),

      StatisticItem(
        title: AppLanguageKeys.totalSales,
        value: _formatNumber(
          data.totalSales,
        ),
        icon: Icons.payments_outlined,
      ),

      StatisticItem(
        title: AppLanguageKeys.uniqueUsersCount,
        value: data.uniqueUsersCount.toString(),
        icon: Icons.people_outline,
      ),
    ];

    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        const double minItemWidth = 220;

        int itemsPerRow =
        (constraints.maxWidth / minItemWidth).floor();

        if (itemsPerRow < 1) {
          itemsPerRow = 1;
        }

        final double itemWidth =
            (constraints.maxWidth -
                ((itemsPerRow - 1) * 15)) /
                itemsPerRow;

        return Wrap(
          spacing: 15,
          runSpacing: 15,
          children: statistics.map(
                (item) {
              return SizedBox(
                width: itemWidth,
                child: StatisticsCard(
                  item: item,
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }

  String _formatNumber(
      double value,
      ) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }
}

