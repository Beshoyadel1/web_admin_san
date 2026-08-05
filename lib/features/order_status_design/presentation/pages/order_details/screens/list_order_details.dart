import 'package:flutter/material.dart';
import 'package:web_admin_san/features/order_status_design/presentation/custom_widget/data_time_line_tile_order_details_widget.dart';
import 'package:web_admin_san/features/order_status_design/presentation/pages/order_details/screens/container_contact_with_customer_order_details.dart';
import 'package:web_admin_san/features/order_status_design/presentation/pages/order_details/screens/design_bill_order.dart';
import 'package:web_admin_san/features/order_status_design/presentation/pages/order_details/screens/design_car_data_orders.dart';
import 'package:web_admin_san/features/order_status_design/presentation/pages/order_details/screens/design_notes_order.dart';
import 'package:web_admin_san/features/order_status_design/presentation/pages/order_details/screens/view_list_data_order.dart';
import '../../../../../../features/order_status_design/presentation/pages/order_details/screens/title_order_id_with_stats.dart';

class ListOrderDetails extends StatelessWidget {
  const ListOrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 800;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleOrderIdWithStats(),
            const SizedBox(height: 10),

            const ViewListDataOrder(),
            const SizedBox(height: 10),

            if (!isMobile)
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: DesignCarDataOrders(),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DataTimeLineTileOrderDetailsWidget(),
                        SizedBox(height: 10),
                        DesignNotesOrder(),
                        SizedBox(height: 10),
                        ContainerContactWithCustomerOrderDetails(),
                        SizedBox(height: 10),
                        DesignBillOrder(),
                      ],
                    ),
                  ),
                ],
              )
            else
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DesignCarDataOrders(),
                  SizedBox(height: 10),

                  DataTimeLineTileOrderDetailsWidget(),
                  SizedBox(height: 10),

                  DesignNotesOrder(),
                  SizedBox(height: 10),

                  ContainerContactWithCustomerOrderDetails(),
                  SizedBox(height: 10),

                  DesignBillOrder(),
                ],
              ),
          ],
        );
      },
    );
  }
}