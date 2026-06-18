import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/theming/assets.dart';
import 'package:web_admin_san/features/order_services/presentation/cubit/admin_dashboard_statistics_cubit/admin_dashboard_statistics_cubit.dart';
import 'package:web_admin_san/features/order_services/presentation/cubit/admin_dashboard_statistics_cubit/admin_dashboard_statistics_state.dart';
import '../../../../../../../../../../core/language/language.dart';
import '../../../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../../../features/internal_services/presentation/cubit/loading_dashboard/loading_dashboard_state.dart';
import '../../../../../../../../../../features/internal_services/presentation/pages/internal_orders/custom_widget/container_with_image_container_and_two_text_widget.dart';

class FirstRowWithTwoContainerImageAndTwoTextOrderServicesStatistics
    extends StatelessWidget {
  const FirstRowWithTwoContainerImageAndTwoTextOrderServicesStatistics({
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
            "title": AppLocalizations.of(context).translate(AppLanguageKeys.ordersCountKey),
            "value": summary.totalOrders.toString(),
            "image": AppImageKeys.home,
          },
          {
            "title": AppLocalizations.of(context)
                .translate(AppLanguageKeys.customers),
            "value": summary.totalCustomers.toString(),
            "image": AppImageKeys.home,
          },
          {
            "title": AppLocalizations.of(context)
                .translate(AppLanguageKeys.companies),
            "value": summary.totalCompanies.toString(),
            "image": AppImageKeys.home,
          },
          {
            "title": AppLocalizations.of(context)
                .translate(AppLanguageKeys.serviceProviders),
            "value": summary.totalServiceProviders.toString(),
            "image": AppImageKeys.home,
          },
          {
            "title": AppLocalizations.of(context)
                .translate(AppLanguageKeys.totalSales),
            "value": summary.totalOrderSales.toString(),
            "image": AppImageKeys.home,
          },
        ];

        return LayoutBuilder(
          builder: (context, constraints) {
            const minItemWidth = 220.0;

            int itemsPerRow =
            (constraints.maxWidth / minItemWidth).floor();

            if (itemsPerRow < 1) {
              itemsPerRow = 1;
            }

            final itemWidth =
                (constraints.maxWidth / itemsPerRow) - 10;

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
