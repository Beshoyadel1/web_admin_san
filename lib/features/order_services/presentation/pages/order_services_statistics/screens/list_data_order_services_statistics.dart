import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/order_services/presentation/cubit/admin_dashboard_statistics_cubit/admin_dashboard_statistics_cubit.dart';
import 'package:web_admin_san/features/order_services/presentation/cubit/admin_dashboard_statistics_cubit/admin_dashboard_statistics_state.dart';
import 'package:web_admin_san/features/order_services/presentation/pages/order_services_statistics/screens/part_two_screen_first_screen_order_services_statistics/container_current_year_sales/container_current_year_sales.dart';
import 'package:web_admin_san/features/order_services/presentation/pages/order_services_statistics/screens/part_two_screen_first_screen_order_services_statistics/container_last_year_sales/container_last_year_sales.dart';
import 'package:web_admin_san/features/order_services/presentation/pages/order_services_statistics/screens/part_two_screen_first_screen_order_services_statistics/container_maintenance_stats/container_maintenance_stats.dart';
import '../../../../../../core/cubit/app_cubit/app_cubit.dart';
import '../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../features/internal_services/presentation/cubit/loading_dashboard/loading_dashboard_cubit.dart';
import '../../../../../../features/internal_services/presentation/cubit/loading_dashboard/loading_dashboard_state.dart';
import '../../../../../../features/order_services/presentation/pages/order_services_statistics/screens/big_container_of_new_order_services_statistics/container_new_order_in_list_data_first_screen_order_services_statistics.dart';
import '../../../../../../features/order_services/presentation/pages/order_services_statistics/screens/container_image_title_with_sub_title_order_services_statistics/first_row_with_two_container_image_and_two_text_order_services_statistics.dart';

class ListDataOrderServicesStatistics extends StatelessWidget {
  const ListDataOrderServicesStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobileCustom = size.width <= 720;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth+200&&
        size.width>720;
    bool isTabletCustom = size.width > ValuesOfAllApp.mobileWidth &&
        size.width <= ValuesOfAllApp.customTabWidth;
    bool isTab = size.width > ValuesOfAllApp.tabWidth;
    return BlocBuilder<AdminDashboardStatisticsCubit, AdminDashboardStatisticsState>(
      builder: (context, state) {
        return  Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const FirstRowWithTwoContainerImageAndTwoTextOrderServicesStatistics(),
            ContainerNewOrderInListDataFirstScreenOrderServicesStatistics(
              onTap: () {
                AppCubit.get(context).navigateToPage(PagesOfAllApp.dashboardOrderPageNumber);
              },
              serviceId:1,
            ),

            if ((isMobile&&!isMobileCustom))
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

            if ((!isMobile&&isMobileCustom))
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
