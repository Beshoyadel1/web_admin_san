import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_company_general_statistics_cubit/get_company_general_statistics_cubit.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/company_statistics/screens/list_data_company_statistics.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/company_statistics/screens/part_two_screen_first_screen_company_statistics/container_service_chart_company/container_service_chart_company.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/company_statistics/screens/part_two_screen_first_screen_company_statistics/petrol_consumption_company/container_petrol_consumption_company.dart';
import '../../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../../core/utilies/map_of_all_app.dart';

class CompanyStatistics extends StatelessWidget {
  final int companyId;
  const CompanyStatistics({super.key,required this.companyId});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth + 200;
    return BlocProvider(
      create: (_) => GetCompanyGeneralStatisticsCubit()..getCompanyGeneralStatistics(companyId: companyId),
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Expanded(
                flex: 2,
                child: Padding(
                  padding:const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: ListDataCompanyStatistics(
                      companyId:companyId,
                    ),
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
                          spacing: 20,
                          children: [
                            ContainerPetrolConsumptionCompany(),
                            ContainerServiceChartCompany(),
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
  }
}
