import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';

import 'package:web_admin_san/feature/order_status_design/presentation/pages/order_details_on_the_way_emp/screens/part_left_screen/container_contact_with_customer_order_details_on_the_way_emp.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/pages/order_details_on_the_way_emp/screens/part_left_screen/data_time_line_tile_order_details_on_the_way_emp.dart';

class DataPartLeftScreenOrderDetailsOnTheWayEmp extends StatelessWidget {
  const DataPartLeftScreenOrderDetailsOnTheWayEmp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        // ContainerReturnToPageSetting(
        //   text: LocaleKeys.back,
        //   onTap: (){
        //       Navigator.pop(context);
        //   },
        // ),
        const ContainerContactWithCustomerOrderDetailsOnTheWayEmp(),
        const DataTimeLineTileOrderDetailsOnTheWayEmp()
      ],
    );
  }
}
