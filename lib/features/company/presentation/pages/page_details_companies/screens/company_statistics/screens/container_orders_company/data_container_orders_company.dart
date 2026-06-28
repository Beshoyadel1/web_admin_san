import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/company_statistics/screens/container_orders_company/list_data_container_order_company.dart';
import '../../../../../../../../../../features/internal_services/presentation/pages/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/first_row_in_data_container_in_list_data_first_screen_internal_orders.dart';
import '../../../../../../../../../../features/order_services/presentation/pages/order_services_statistics/screens/big_container_of_new_order_services_statistics/part_container_big_container_of_new_orders_order_services_statistics/second_part_data_container_in_list_data_first_screen_order_services_statistics.dart';

class DataContainerOrdersCompany extends StatelessWidget {
  const DataContainerOrdersCompany(
      {super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           FirstRowInDataContainerInListDataFirstScreenInternalOrders(),
           ListDataContainerOrderCompany()

        ],
      ),
    );
  }
}