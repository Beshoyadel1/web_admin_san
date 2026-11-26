import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/pages/order_details_cancel_order_emp/screens/part_left_screen/container_contact_with_customer_order_details_cancel_order_emp.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/pages/order_details_cancel_order_emp/screens/part_left_screen/data_time_line_tile_order_details_cancel_order_emp.dart';

class DataPartLeftScreenOrderDetailsCancelOrderEmp extends StatelessWidget {
  const DataPartLeftScreenOrderDetailsCancelOrderEmp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 20,
      children: [
        // ContainerReturnToPageSetting(
        //   text: LocaleKeys.back,
        //   onTap: (){
        //       Navigator.pop(context);
        //   },
        // ),
        ContainerContactWithCustomerOrderDetailsCancelOrderEmp(),
        DataTimeLineTileOrderDetailsCancelOrderEmp()
      ],
    );
  }
}
