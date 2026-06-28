import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/company_statistics/screens/container_image_title_with_sub_title_order_services_statistics/first_row_with_two_container_image_and_two_text_company_statistics.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/company_statistics/screens/container_orders_company/container_orders_company.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/company_statistics/screens/part_two_screen_first_screen_company_statistics/container_service_chart_company/container_service_chart_company.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/company_statistics/screens/part_two_screen_first_screen_company_statistics/petrol_consumption_company/container_petrol_consumption_company.dart';
import 'package:web_admin_san/features/internal_services/presentation/cubit/get_provider_internal_order/get_provider_internal_order_state.dart';
import 'package:web_admin_san/features/order_services/presentation/cubit/admin_dashboard_statistics_cubit/admin_dashboard_statistics_cubit.dart';
import 'package:web_admin_san/features/order_services/presentation/cubit/admin_dashboard_statistics_cubit/admin_dashboard_statistics_state.dart';
import '../../../../../../../../core/utilies/map_of_all_app.dart';

class ListDataCompanyStatistics extends StatelessWidget {
  final int companyId;
  const ListDataCompanyStatistics({super.key,required this.companyId});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobileCustom = size.width <= 720;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth+200&&
        size.width>720;

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const FirstRowWithTwoContainerImageAndTwoTextCompanyStatistics(),
        BlocProvider(
          create: (_) => GetProviderInternalOrderCubit()
            ..getCompanyOrders(
                companyId:companyId
            ),
          child: const ContainerOrdersCompany(),
        ),

        if ((isMobile&&!isMobileCustom))
          const Column(
            spacing: 10,
            children: [
              Row(
                spacing: 10,
                children: [
                  Expanded(child: ContainerPetrolConsumptionCompany()),
                  Expanded(child: ContainerServiceChartCompany())
                ],
              ),
            ],
          ),

        if ((!isMobile&&isMobileCustom))
          const Column(
            spacing: 10,
            children: [
              ContainerPetrolConsumptionCompany(),
              ContainerServiceChartCompany(),
            ],
          ),
      ],
    );
  }
}
