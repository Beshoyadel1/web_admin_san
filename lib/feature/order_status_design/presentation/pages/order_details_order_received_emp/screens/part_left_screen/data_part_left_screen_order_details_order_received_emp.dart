import 'package:web_admin_san/feature/order_status_design/presentation/widgets/container_return_to_page_setting.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/pages/order_details_order_received_emp/screens/part_left_screen/container_contact_with_customer_order_details_order_received_emp.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/pages/order_details_order_received_emp/screens/part_left_screen/data_time_line_tile_order_details_order_received_emp.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class DataPartLeftScreenOrderDetailsOrderReceivedEmp extends StatelessWidget {
  const DataPartLeftScreenOrderDetailsOrderReceivedEmp({super.key});

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
        const ContainerContactWithCustomerOrderDetailsOrderReceivedEmp(),
        const DataTimeLineTileOrderDetailsOrderReceivedEmp()
      ],
    );
  }
}
