import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/features/company/presentation/custom_widget/text_expended_widget.dart';
import 'package:web_admin_san/features/order_services/presentation/pages/order_services_statistics/screens/part_two_screen_first_screen_order_services_statistics/container_maintenance_stats/second_row_in_data_in_container_maintenance_stats.dart';

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
        //SecondRowInDataInContainerMaintenanceStats()
      ],
    );
  }
}
