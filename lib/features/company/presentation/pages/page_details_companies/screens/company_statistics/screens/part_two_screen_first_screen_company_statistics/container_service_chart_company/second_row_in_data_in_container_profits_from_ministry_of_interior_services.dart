import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_company_general_statistics_cubit/get_company_general_statistics_cubit.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_company_general_statistics_cubit/get_company_general_statistics_state.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/company_statistics/screens/part_two_screen_first_screen_company_statistics/container_service_chart_company/FourPartCircle.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/company_statistics/screens/part_two_screen_first_screen_company_statistics/container_service_chart_company/services_legend_list.dart';

class SecondRowInDataInContainerProfitsFromMinistryOfInteriorServices
    extends StatelessWidget {
  const SecondRowInDataInContainerProfitsFromMinistryOfInteriorServices({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCompanyGeneralStatisticsCubit,
        GetCompanyGeneralStatisticsState>(
      builder: (context, state) {
        if (state is GetCompanyGeneralStatisticsSuccess) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: FourPartDoughnut(
                  services: state.data.serviceChart,
                ),
              ),
              Flexible(
                child: ServicesLegendList(
                  services: state.data.serviceChart,
                ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
