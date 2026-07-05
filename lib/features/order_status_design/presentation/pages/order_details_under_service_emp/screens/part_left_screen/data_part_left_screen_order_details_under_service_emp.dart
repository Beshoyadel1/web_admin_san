import 'package:flutter/material.dart';

import '../../../../../../../../features/order_status_design/presentation/pages/order_details_under_service_emp/screens/part_left_screen/container_contact_with_customer_order_details_under_service_emp.dart';
import '../../../../../../../../features/order_status_design/presentation/pages/order_details_under_service_emp/screens/part_left_screen/data_time_line_tile_order_details_under_service_emp.dart';

class DataPartLeftScreenOrderDetailsUnderServiceEmp extends StatelessWidget {
  const DataPartLeftScreenOrderDetailsUnderServiceEmp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        // ContainerReturnToPageSetting(
        //   text: AppLanguageKeys.back,
        //   onTap: (){
        //       Navigator.pop(context);
        //   },
        // ),
        const ContainerContactWithCustomerOrderDetailsUnderServiceEmp(),
        const DataTimeLineTileOrderDetailsUnderServiceEmp()
    ],
    );
  }
}