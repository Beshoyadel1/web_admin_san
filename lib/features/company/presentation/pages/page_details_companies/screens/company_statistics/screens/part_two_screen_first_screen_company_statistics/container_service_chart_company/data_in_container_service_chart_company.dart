import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/features/company/presentation/custom_widget/text_expended_widget.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/company_statistics/screens/part_two_screen_first_screen_company_statistics/container_service_chart_company/second_row_in_data_in_container_profits_from_ministry_of_interior_services.dart';

class DataInContainerServiceChartCompany extends StatelessWidget {
  const DataInContainerServiceChartCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 20,
      children: [
        TextExpendedWidget(
          text: AppLanguageKeys.carServicesAndMaintenanceStatistics,
        ),
        SecondRowInDataInContainerProfitsFromMinistryOfInteriorServices()
      ],
    );
  }
}
