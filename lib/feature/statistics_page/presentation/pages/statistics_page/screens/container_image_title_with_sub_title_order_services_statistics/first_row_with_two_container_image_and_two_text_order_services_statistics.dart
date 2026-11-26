import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/feature/statistics_page/view_model/admin_dashboard_statistics_cubit/admin_dashboard_statistics_cubit.dart';
import 'package:web_admin_san/feature/statistics_page/view_model/admin_dashboard_statistics_cubit/admin_dashboard_statistics_state.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/container_with_image_container_and_two_text_widget.dart';

class FirstRowWithTwoContainerImageAndTwoTextStatisticsPage
    extends StatelessWidget {
  const FirstRowWithTwoContainerImageAndTwoTextStatisticsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDashboardStatisticsCubit,
        AdminDashboardStatisticsState>(
      builder: (context, state) {
        if (state is AdminDashboardStatisticsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is! AdminDashboardStatisticsSuccess) {
          return const SizedBox();
        }

        final summary = state.data.summary;

        final statistics = [
          {
            "title": LocaleKeys.ordersCountKey.tr(),
            "value": summary.totalOrders.toString(),
            "image": AppImageKeys.home,
          },
          {
            "title": LocaleKeys.customers.tr(),
            "value": summary.totalCustomers.toString(),
            "image": AppImageKeys.home,
          },
          {
            "title": LocaleKeys.companies.tr(),
            "value": summary.totalCompanies.toString(),
            "image": AppImageKeys.home,
          },
          {
            "title": LocaleKeys.serviceProviders.tr(),
            "value": summary.totalServiceProviders.toString(),
            "image": AppImageKeys.home,
          },
          {
            "title": LocaleKeys.totalSales.tr(),
            "value": summary.totalOrderSales.toString(),
            "image": AppImageKeys.home,
          },
        ];

        return LayoutBuilder(
          builder: (context, constraints) {
            const minItemWidth = 220.0;

            int itemsPerRow = (constraints.maxWidth / minItemWidth).floor();

            if (itemsPerRow < 1) {
              itemsPerRow = 1;
            }

            final itemWidth = (constraints.maxWidth / itemsPerRow) - 10;

            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: statistics.map((item) {
                return SizedBox(
                  width: itemWidth,
                  child: ContainerWithImageContainerAndTwoTextWidget(
                    imageAsset: item["image"] as String,
                    title: item["title"] as String,
                    subTitle: item["value"] as String,
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
