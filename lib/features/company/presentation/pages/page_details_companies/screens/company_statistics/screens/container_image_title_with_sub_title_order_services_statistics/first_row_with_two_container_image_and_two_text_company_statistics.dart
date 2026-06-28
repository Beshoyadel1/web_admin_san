import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/theming/assets.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_company_general_statistics_cubit/get_company_general_statistics_cubit.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_company_general_statistics_cubit/get_company_general_statistics_state.dart';
import '../../../../../../../../../../core/language/language.dart';
import '../../../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../../../features/internal_services/presentation/pages/internal_orders/custom_widget/container_with_image_container_and_two_text_widget.dart';

class FirstRowWithTwoContainerImageAndTwoTextCompanyStatistics
    extends StatelessWidget {
  const FirstRowWithTwoContainerImageAndTwoTextCompanyStatistics({
    super.key,
  });

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
            "title": AppLocalizations.of(context)
                .translate(AppLanguageKeys.completedOrders),
            "value": summary.doneOrders.toString(),
            "image": AppImageKeys.home,
          },
          {
            "title": AppLocalizations.of(context)
                .translate(AppLanguageKeys.ordersUnderService),
            "value": summary.inServiceOrders.toString(),
            "image": AppImageKeys.home,
          },
          {
            "title": AppLocalizations.of(context)
                .translate(AppLanguageKeys.pendingOrders),
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

            final itemWidth = (constraints.maxWidth -
                (spacing * (itemsPerRow - 1))) /
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