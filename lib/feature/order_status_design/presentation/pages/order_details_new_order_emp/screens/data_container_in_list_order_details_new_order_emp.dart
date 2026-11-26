import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_model.dart';
import 'package:web_admin_san/feature/order_status_design/view_model/order_status_cubit/order_status_cubit.dart';
import 'package:web_admin_san/feature/order_status_design/view_model/order_status_cubit/order_status_state.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/widgets/title_with_sub_title_in_order_details_emp.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/pages/order_details_new_order_emp/screens/custom_container_order.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/pages/order_details_new_order_emp/screens/part_left_screen/container_contact_with_customer_order_details_new_order_emp.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/pages/order_details_new_order_emp/screens/part_left_screen/data_time_line_tile_order_details_new_order_emp.dart';

class DataContainerInListOrderDetailsNewOrderEmp extends StatelessWidget {
  final OrderModel order;
  const DataContainerInListOrderDetailsNewOrderEmp(
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
          CustomContainerOrder(order: order),
          if (isMobile)
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 30,
              children: [
                ContainerContactWithCustomerOrderDetailsNewOrderEmp(),
                DataTimeLineTileOrderDetailsNewOrderEmp()
              ],
            ),
          BlocProvider(
            create: (_) => OrderStatusCubit(),
            child: BlocListener<OrderStatusCubit, OrderStatusState>(
              listener: (context, state) {
                if (!context.mounted) return;

                if (state is OrderStatusSuccess) {
                  AppSnackBar.showSuccess(
                    LocaleKeys.updateOrderStatusSuccessfully,
                  );

                  Navigator.pop(context, true);
                }

                if (state is OrderStatusError) {
                  AppSnackBar.showError(state.message);
                }
              },
              child: BlocBuilder<OrderStatusCubit, OrderStatusState>(
                builder: (context, state) {
                  return Stack(
                    children: [
                      BlocProvider(
                        create: (_) => OrderStatusCubit(),
                        child: BlocListener<OrderStatusCubit, OrderStatusState>(
                          listener: (context, state) {
                            if (!context.mounted) return;

                            if (state is OrderStatusSuccess) {
                              AppSnackBar.showSuccess(
                                LocaleKeys.updateOrderStatusSuccessfully,
                              );

                              /// 🔥 أهم سطر
                              Navigator.pop(context, true);
                            }

                            if (state is OrderStatusError) {
                              AppSnackBar.showError(state.message);
                            }
                          },
                          child:
                              BlocBuilder<OrderStatusCubit, OrderStatusState>(
                            builder: (context, state) {
                              return Stack(
                                children: [
                                  //  ButtonAcceptRejectOrder(order: order),

                                  if (state is OrderStatusLoading)
                                    const Center(
                                        child: CircularProgressIndicator()),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      if (state is OrderStatusLoading)
                        const Center(child: CircularProgressIndicator()),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
