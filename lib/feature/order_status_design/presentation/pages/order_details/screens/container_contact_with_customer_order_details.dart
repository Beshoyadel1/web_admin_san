import 'package:flutter/material.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_details_model.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/widgets/container_contact_with_customer_order_details_widget.dart';

class ContainerContactWithCustomerOrderDetails extends StatelessWidget {
  final OrderDetailsModel orderDetailsModel;
  const ContainerContactWithCustomerOrderDetails(
      {super.key, required this.orderDetailsModel});

  @override
  Widget build(BuildContext context) {
    return ContainerContactWithCustomerOrderDetailsWidget(
      imageUser: orderDetailsModel.providerInfo?.image,
      nameCustomer: orderDetailsModel.providerInfo?.name,
    );
  }
}
