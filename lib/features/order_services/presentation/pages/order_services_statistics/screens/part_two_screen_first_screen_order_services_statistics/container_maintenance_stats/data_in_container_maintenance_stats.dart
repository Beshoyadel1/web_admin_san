import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/features/order_services/presentation/custom_widget/color_title_sub_title_widget.dart';
import 'package:web_admin_san/features/order_services/presentation/pages/order_services_statistics/screens/part_two_screen_first_screen_order_services_statistics/container_maintenance_stats/first_row_in_data_in_container_maintenance_stats.dart';
import 'package:web_admin_san/features/order_services/presentation/pages/order_services_statistics/screens/part_two_screen_first_screen_order_services_statistics/container_maintenance_stats/second_row_in_data_in_container_maintenance_stats.dart';

class DataInContainerMaintenanceStats extends StatelessWidget {
  const DataInContainerMaintenanceStats({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 20,
      children: [
         FirstRowInDataInContainerMaintenanceStats(),
        SecondRowInDataInContainerMaintenanceStats()
      ],
    );
  }
}
