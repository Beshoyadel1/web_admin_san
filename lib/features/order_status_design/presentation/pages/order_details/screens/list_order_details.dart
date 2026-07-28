import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../features/order_status_design/presentation/pages/order_details/screens/title_order_id_with_stats.dart';

class ListOrderDetails extends StatelessWidget {
 // final OrderModel order;

  const ListOrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= 960;

    return const Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleOrderIdWithStats()
      ],
    );
  }
}