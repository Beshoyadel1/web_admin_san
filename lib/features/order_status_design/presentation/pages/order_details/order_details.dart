import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../features/order_status_design/presentation/pages/order_details/screens/list_order_details.dart';
import '../../../../../core/theming/colors.dart';

class OrderDetails extends StatelessWidget {
  // final OrderModel order;

  const OrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: SingleChildScrollView(
              child: ListOrderDetails(),
            ),
          ),
        ));
  }
}
