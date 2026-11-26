import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/feature/companies_page/view_model/get_company_general_statistics_cubit/get_company_general_statistics_cubit.dart';
import 'package:web_admin_san/feature/companies_page/view_model/get_company_general_statistics_cubit/get_company_general_statistics_state.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/container_with_image_container_and_two_text_widget.dart';

class CompanyOrdersSummaryCards extends StatelessWidget {
  const CompanyOrdersSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCompanyGeneralStatisticsCubit,
        GetCompanyGeneralStatisticsState>(
      builder: (context, state) {
        if (state is GetCompanyGeneralStatisticsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is! GetCompanyGeneralStatisticsSuccess) {
          return const SizedBox();
        }

        final summary = state.data.ordersSummary;

        final statistics = [
          {
            "title": LocaleKeys.completedOrders.tr(),
            "value": summary.doneOrders.toString(),
            "image": AppImageKeys.home,
          },
          {
            "title": LocaleKeys.ordersUnderService.tr(),
            "value": summary.inServiceOrders.toString(),
            "image": AppImageKeys.home,
          },
          {
            "title": LocaleKeys.pendingOrders.tr(),
            "value": summary.newOrders.toString(),
            "image": AppImageKeys.home,
          },
        ];

        return LayoutBuilder(
          builder: (context, constraints) {
            int itemsPerRow;

            if (constraints.maxWidth >= 800) {
              itemsPerRow = 3;
            } else if (constraints.maxWidth >= 600) {
              itemsPerRow = 2;
            } else {
              itemsPerRow = 1;
            }

            const spacing = 10.0;

            final itemWidth =
                (constraints.maxWidth - (spacing * (itemsPerRow - 1))) /
                    itemsPerRow;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
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

// Backward compatibility alias
typedef FirstRowWithTwoContainerImageAndTwoTextCompanyStatistics
    = CompanyOrdersSummaryCards;
