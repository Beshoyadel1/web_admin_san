import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/widgets/color_title_sub_title_widget.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/pages/statistics_page/screens/part_two_screen_first_screen_order_services_statistics/container_maintenance_stats/maintenance_stats_pie_chart.dart';
import '../../../../../../../../../core/helpers/colors/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/statistics_page/view_model/admin_dashboard_statistics_cubit/admin_dashboard_statistics_cubit.dart';
import 'package:web_admin_san/feature/statistics_page/view_model/admin_dashboard_statistics_cubit/admin_dashboard_statistics_state.dart';

class SecondRowInDataInContainerMaintenanceStats extends StatelessWidget {
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
                    title: LocaleKeys.userCarsCount,
                    subTitle:
                        '${maintenanceStats.userCarsCount} ${LocaleKeys.cars.tr()}',
                  ),
                  ColorTitleSubTitleWidget(
                    backgroundColor: AppColors.seaBlueColor,
                    title: LocaleKeys.companyCarsCount,
                    subTitle:
                        '${maintenanceStats.companyCarsCount} ${LocaleKeys.cars.tr()}',
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
