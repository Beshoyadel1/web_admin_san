import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/company_statistics/screens/company_orders_summary_cards.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/company_statistics/screens/container_orders_company/container_orders_company.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/company_statistics/screens/part_two_screen_first_screen_company_statistics/container_service_chart_company/container_service_chart_company.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/company_statistics/screens/part_two_screen_first_screen_company_statistics/petrol_consumption_company/container_petrol_consumption_company.dart';
import 'package:web_admin_san/feature/internal_services/view_model/get_provider_internal_order/get_provider_internal_order_state.dart';

import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';

class ListDataCompanyStatistics extends StatelessWidget {
  final int companyId;
  const ListDataCompanyStatistics({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobileCustom = size.width <= 720;
    bool isMobile =
        size.width <= ValuesOfAllApp.mobileWidth + 200 && size.width > 720;

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const CompanyOrdersSummaryCards(),
        BlocProvider(
          create: (_) => GetProviderInternalOrderCubit()
            ..getCompanyOrders(companyId: companyId),
          child: const ContainerOrdersCompany(),
        ),
        if ((isMobile && !isMobileCustom))
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
        if ((!isMobile && isMobileCustom))
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
