import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_model.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/widgets/container_invoice_widget.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/widgets/title_with_sub_title_in_order_details_emp.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/pages/order_details_new_order_emp/screens/custom_container_order.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/pages/order_details_order_received_emp/screens/part_left_screen/container_contact_with_customer_order_details_order_received_emp.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/pages/order_details_order_received_emp/screens/part_left_screen/data_time_line_tile_order_details_order_received_emp.dart';

class DataContainerInListOrderDetailsOrderReceivedEmp extends StatelessWidget {
  final OrderModel order;
  const DataContainerInListOrderDetailsOrderReceivedEmp(
      {super.key, required this.order});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= 960;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 30,
        children: [
          // if(isMobile)
          //   ContainerReturnToPageSetting(
          //     text: LocaleKeys.back,
          //     onTap: (){
          //       Navigator.pop(context);
          //     },
          //   ),
          const TitleWithSubTitleInOrderDetailsEmp(),
          CustomContainerOrder(
            order: order,
          ),
          if (isMobile)
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 30,
              children: [
                ContainerContactWithCustomerOrderDetailsOrderReceivedEmp(),
                DataTimeLineTileOrderDetailsOrderReceivedEmp()
              ],
            ),
          //  ContainerInvoiceWidget(
          //   priceInsuranceInstallment: order.totalPrice.toString(),
          //   priceTaxes: order.totalPrice.toString(),
          //   priceTotal: order.totalPrice.toString(),
          // ),
        ],
      ),
    );
  }
}
