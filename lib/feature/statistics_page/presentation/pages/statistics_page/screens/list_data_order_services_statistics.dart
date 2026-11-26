import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/statistics_page/view_model/admin_dashboard_statistics_cubit/admin_dashboard_statistics_cubit.dart';
import 'package:web_admin_san/feature/statistics_page/view_model/admin_dashboard_statistics_cubit/admin_dashboard_statistics_state.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/pages/statistics_page/screens/part_two_screen_first_screen_order_services_statistics/container_current_year_sales/container_current_year_sales.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/pages/statistics_page/screens/part_two_screen_first_screen_order_services_statistics/container_last_year_sales/container_last_year_sales.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/pages/statistics_page/screens/part_two_screen_first_screen_order_services_statistics/container_maintenance_stats/container_maintenance_stats.dart';
import 'package:web_admin_san/feature/layout/view_model/layout_cubit/app_cubit.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/pages/statistics_page/screens/big_container_of_new_order_services_statistics/container_new_order_in_list_data_first_screen_order_services_statistics.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/pages/statistics_page/screens/container_image_title_with_sub_title_order_services_statistics/first_row_with_two_container_image_and_two_text_order_services_statistics.dart';

typedef ListDataOrderServicesStatistics = ListDataStatisticsPage;

class ListDataStatisticsPage extends StatelessWidget {
  const ListDataStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobileCustom = size.width <= 720;
    bool isMobile =
        size.width <= ValuesOfAllApp.mobileWidth + 200 && size.width > 720;

    return BlocBuilder<AdminDashboardStatisticsCubit,
        AdminDashboardStatisticsState>(
      builder: (context, state) {
        return Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const FirstRowWithTwoContainerImageAndTwoTextStatisticsPage(),
            ContainerNewOrderInListDataFirstScreenStatisticsPage(
              onTap: () {
                AppCubit.get(context)
                    .navigateToPage(PagesOfAllApp.dashboardOrderPageNumber);
              },
              serviceId: 1,
            ),
            if ((isMobile && !isMobileCustom))
              const Column(
                spacing: 10,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(child: ContainerCurrentYearSales()),
                      Expanded(child: ContainerLastYearSales())
                    ],
                  ),
                  ContainerMaintenanceStats(),
                ],
              ),
            if ((!isMobile && isMobileCustom))
              const Column(
                spacing: 10,
                children: [
                  ContainerCurrentYearSales(),
                  ContainerLastYearSales(),
                  ContainerMaintenanceStats(),
                ],
              ),
          ],
        );
      },
    );
  }
}
