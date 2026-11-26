import 'package:flutter/cupertino.dart';

import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/first_row_in_data_container_in_list_data_first_screen_internal_orders.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/pages/statistics_page/screens/big_container_of_new_order_services_statistics/part_container_big_container_of_new_orders_order_services_statistics/second_part_data_container_in_list_data_first_screen_order_services_statistics.dart';

class DataContainerInListDataFirstScreenStatisticsPage extends StatelessWidget {
  final void Function()? onTap;
  final bool? isLoading;
  final int serviceId;
  const DataContainerInListDataFirstScreenStatisticsPage(
      {super.key, this.onTap, this.isLoading = false, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FirstRowInDataContainerInListDataFirstScreenInternalOrders(
            onTap: onTap,
          ),
          SecondPartDataContainerInListDataFirstScreenStatisticsPage(
            serviceId: serviceId,
          )
        ],
      ),
    );
  }
}
