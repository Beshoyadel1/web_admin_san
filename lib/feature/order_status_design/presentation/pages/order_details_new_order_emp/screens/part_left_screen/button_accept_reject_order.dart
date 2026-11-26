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

class ButtonAcceptRejectOrder extends StatelessWidget {
  final OrderModel order;

  const ButtonAcceptRejectOrder({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: [
        // ContainerSold(
        //   text: LocaleKeys.workInProgress,
        //   backGroundColor: AppColors.lightRedColor,
        //   onTap: () {
        //     context.read<OrderStatusCubit>().updateOrderStatus(
        //       updateOrderStatusRequest: UpdateOrderStatusRequest(
        //         orderId: order.id ?? 0,
        //         status: OrderStatus.workInProgress,
        //       ),
        //     );
        //   },
        // ),
        //
        // const SizedBox(width: 20),
        //
        // ContainerSold(
        //   text: LocaleKeys.waitingAppointment,
        //   backGroundColor: AppColors.yelloContainerLoadingColor,
        //   onTap: () {
        //     final request = UpdateOrderStatusRequest(
        //       orderId: order.id ?? 0,
        //       status: OrderStatus.waitingAppointment,
        //     );
        //
        //
        //     context.read<OrderStatusCubit>().updateOrderStatus(
        //       updateOrderStatusRequest: request,
        //     );
        //   },
        // ),
        //
        // const SizedBox(width: 20),
        // ContainerSold(
        //   text: LocaleKeys.rejectRequest,
        //   backGroundColor: AppColors.redColor,
        //   onTap: () {
        //
        //     final request = UpdateOrderStatusRequest(
        //       orderId: order.id ?? 0,
        //       status: OrderStatus.rejectedByProvider,
        //     );
        //
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
