import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/networking/api_link.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../../core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_model.dart';
import 'package:web_admin_san/feature/order_status_design/view_model/order_status_cubit/order_status_cubit.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/widgets/container_sold.dart';
import '../../../../../data/request/update_order_status_request/update_order_status_request.dart';

class ContainerReceivedRejectUser extends StatelessWidget {
  final OrderModel order;

  const ContainerReceivedRejectUser({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: [
        // /// Work in progress
        // ContainerSold(
        //   text: LocaleKeys.completedOrders,
        //   backGroundColor: AppColors.greenColor,
        //   onTap: () {
        //     context.read<OrderStatusCubit>().updateOrderStatus(
        //       updateOrderStatusRequest: UpdateOrderStatusRequest(
        //         orderId: order.id ?? 0,
        //         status: OrderStatus.orderCompleted,
        //       ),
        //     );
        //   },
        // ),
        //
        // const SizedBox(width: 20),
        //
        // /// Waiting appointment
        // ContainerSold(
        //   text: LocaleKeys.cancelledByUser,
        //   backGroundColor: AppColors.redColor,
        //   onTap: () {
        //     final request = UpdateOrderStatusRequest(
        //       orderId: order.id ?? 0,
        //       status: OrderStatus.cancelledByUser,
        //     );
        //
        //     // print("========== BUTTON CLICK ==========");
        //     // print("Order ID: ${request.orderId}");
        //     // print("Status: ${request.status}");
        //     // print("=================================");
        //
        //     context.read<OrderStatusCubit>().updateOrderStatus(
        //       updateOrderStatusRequest: request,
        //     );
        //   },
        // ),
      ],
    );
  }
}
