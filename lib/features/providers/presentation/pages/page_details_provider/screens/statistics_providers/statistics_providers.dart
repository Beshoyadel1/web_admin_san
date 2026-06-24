import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/statistics_providers_cubit/get_provider_service_statistics_cubit/get_provider_service_statistics_cubit.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/statistics_providers_cubit/get_provider_total_rate_and_employee_and_balance_cubit/get_provider_total_rate_and_employee_and_balance_cubit.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/statistics_providers/widgets/chart_order.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/statistics_providers/widgets/employees_performance.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/statistics_providers/widgets/list_custom_chart.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/statistics_providers/widgets/services_evaluation.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/statistics_providers/widgets/services_statistics.dart';
class StatisticsProviders extends StatelessWidget {
  final int providerID;
  const StatisticsProviders({super.key,required this.providerID});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetProviderServiceStatisticsCubit()
            ..getProviderServiceStatistics(
              providerId: 5
            ),
        ),
        BlocProvider(
          create: (_) => GetProviderTotalRateAndEmployeeAndBalanceCubit()
            ..getProviderTotalRateAndEmployeeAndBalance(
              providerId: 5
            ),
        )
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                const ListCustomChart(),
                ChartOrder(
                  providerId: providerID,
                ),
                const EmployeesPerformance(),
                 Column(
                  spacing: 5,
                  children: [
                    const ServicesEvaluation(),
                    ServicesStatistics(
                      providerId:providerID,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

