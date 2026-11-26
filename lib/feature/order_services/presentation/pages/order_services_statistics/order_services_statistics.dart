import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/pages/statistics_page/screens/part_two_screen_first_screen_order_services_statistics/container_current_year_sales/container_current_year_sales.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/pages/statistics_page/screens/part_two_screen_first_screen_order_services_statistics/container_last_year_sales/container_last_year_sales.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/pages/statistics_page/screens/part_two_screen_first_screen_order_services_statistics/container_maintenance_stats/container_maintenance_stats.dart';
import 'package:web_admin_san/feature/statistics_page/view_model/admin_dashboard_statistics_cubit/admin_dashboard_statistics_cubit.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/pages/statistics_page/screens/list_data_order_services_statistics.dart';

class OrderServicesStatistics extends StatelessWidget {
  const OrderServicesStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth + 200;
    return BlocProvider(
      create: (_) => AdminDashboardStatisticsCubit()..getStatistics(),
      child: Builder(
        builder: (context) {
          return RefreshIndicator(
            color: AppColors.orangeColor,
            onRefresh: () async {
              await context
                  .read<AdminDashboardStatisticsCubit>()
                  .getStatistics();
            },
            child: Scaffold(
              backgroundColor: AppColors.scaffoldColor,
              body: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: ListDataOrderServicesStatistics(),
                        ),
                      ),
                    ),
                    if ((!isMobile))
                      const Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: SingleChildScrollView(
                            child: SizedBox(
                              width: 500,
                              child: Column(
                                spacing: 10,
                                children: [
                                  ContainerCurrentYearSales(),
                                  ContainerLastYearSales(),
                                  ContainerMaintenanceStats(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
