import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/statistics_providers/widgets/services_statistics.dart';
import '../../../../../../../../../features/cars_haraj_page/presentation/bloc/harag_cubit/harag_cubit.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../features/cars_haraj_page/presentation/bloc/provider_harage_monthly_sales_cubit/provider_harage_monthly_sales_cubit.dart';
import 'screens/create_harag_dialog.dart';
import '../../../../../../../../features/internal_services/presentation/pages/internal_services_statistics/Internal_services_page/widgets/profits_services.dart';
import 'screens/list_of_cars.dart';
import 'screens/monthly_bar_chart.dart';

class CarsHarajStatisticsPage extends StatelessWidget {
  final int providerId;
  const CarsHarajStatisticsPage({super.key,required this.providerId});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= 1042;
    bool isTabletCustom = size.width > 1042 && size.width <= 1300;
    bool isTab = size.width > 1300;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProviderHarageStatisticsCubit()..loadStatistics(
            providerId: providerId
          ),
        ),
        BlocProvider(
          create: (_) => HaragCubit()..getUserHarages(currentPage: 1,userId: providerId),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            body: SafeArea(
                child: Row(spacing: 10, children: [
              Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 10,
                      children: [
                        const MonthlyBarChart(),
                         ListOfCars(
                          providerId: providerId,
                        ),
                        if (isTabletCustom)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 10,
                            children: [
                              Flexible(child: ServicesStatistics(providerId: providerId)),
                              const Flexible(child: ProfitsServices()),
                            ],
                          ),
                        if (isMobile)
                           Column(
                            spacing: 10,
                            children: [
                              ServicesStatistics(providerId: providerId),
                              const  ProfitsServices(),
                            ],
                          )
                      ],
                    ),
                  )),
              if (isTab)
                 Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 10,
                      children: [
                        ServicesStatistics(providerId: providerId,),
                        const  ProfitsServices(),
                      ],
                    ),
                  ),
                )
            ])),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.orangeColor,
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<HaragCubit>(),
                    child: const CreateHaragDialog(),
                  ),
                );

                if (result == true) {
                 await context.read<HaragCubit>().getUserHarages(currentPage: 1,userId:providerId);
                }
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
          );
        }
      ),
    );
  }
}
