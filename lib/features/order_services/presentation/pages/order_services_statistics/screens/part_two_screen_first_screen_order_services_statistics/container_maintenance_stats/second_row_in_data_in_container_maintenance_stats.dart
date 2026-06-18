import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/core/language/language.dart';
import 'package:web_admin_san/features/order_services/presentation/custom_widget/color_title_sub_title_widget.dart';
import 'package:web_admin_san/features/order_services/presentation/pages/order_services_statistics/screens/part_two_screen_first_screen_order_services_statistics/container_maintenance_stats/maintenance_stats_pie_chart.dart';
import '../../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../../core/theming/colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/order_services/presentation/cubit/admin_dashboard_statistics_cubit/admin_dashboard_statistics_cubit.dart';
import 'package:web_admin_san/features/order_services/presentation/cubit/admin_dashboard_statistics_cubit/admin_dashboard_statistics_state.dart';


class SecondRowInDataInContainerMaintenanceStats
    extends StatelessWidget {
  const SecondRowInDataInContainerMaintenanceStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDashboardStatisticsCubit,
        AdminDashboardStatisticsState>(
      builder: (context, state) {
        if (state is! AdminDashboardStatisticsSuccess) {
          return const SizedBox.shrink();
        }

        final maintenanceStats = state.data.maintenanceStats;

        return Row(
          children: [
            Expanded(
              child: Column(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ColorTitleSubTitleWidget(
                    backgroundColor: AppColors.orangeColor,
                    title: AppLanguageKeys.userCarsCount,
                    subTitle:
                    '${maintenanceStats.userCarsCount} ${AppLocalizations.of(context).translate(AppLanguageKeys.cars)}',
                  ),
                  ColorTitleSubTitleWidget(
                    backgroundColor: AppColors.seaBlueColor,
                    title: AppLanguageKeys.companyCarsCount,
                    subTitle:
                    '${maintenanceStats.companyCarsCount} ${AppLocalizations.of(context).translate(AppLanguageKeys.cars)}',
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 150,
                child: MaintenanceStatsPieChart(
                  userCarsCount: maintenanceStats.userCarsCount,
                  companyCarsCount: maintenanceStats.companyCarsCount,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}