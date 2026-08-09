import 'package:flutter/material.dart';
import '../../../../../../../../features/internal_services/data/model/get_provider_orders_model/order_model.dart';
import '../../../../../../../../features/internal_services/presentation/cubit/get_order_details_cubit/get_order_details_state.dart';
import '../../../../../../../../features/order_status_design/presentation/custom_widget/data_time_line_tile_order_details_widget.dart';
import '../../../../../../../../features/order_status_design/presentation/pages/order_details/screens/container_contact_with_customer_order_details.dart';
import '../../../../../../../../features/order_status_design/presentation/pages/order_details/screens/design_bill_order.dart';
import '../../../../../../../../features/order_status_design/presentation/pages/order_details/screens/design_car_data_orders.dart';
import '../../../../../../../../features/order_status_design/presentation/pages/order_details/screens/design_notes_order.dart';
import '../../../../../../../../features/order_status_design/presentation/pages/order_details/screens/view_list_data_order.dart';
import '../../../../../../features/order_status_design/presentation/pages/order_details/screens/title_order_id_with_stats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../features/internal_services/data/request/get_order_details_request/get_order_details_datasource.dart';
import '../../../../../../../../features/internal_services/presentation/cubit/get_order_details_cubit/get_order_details_cubit.dart';

class ListOrderDetails extends StatelessWidget {
  final OrderModel order;

  const ListOrderDetails({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetOrderDetailsCubit(
        getOrderDetailsDatasource: GetOrderDetailsDatasource(
          orderId: order.id??0,
        ),
      )..getOrderDetails(),
      child: BlocBuilder<GetOrderDetailsCubit, GetOrderDetailsState>(
        builder: (context, state) {
          if (state is GetOrderDetailsLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is GetOrderDetailsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state is GetOrderDetailsSuccess) {
            final orderDetails = state.orderDetails;

            return LayoutBuilder(
              builder: (context, constraints) {
                final bool isMobile = constraints.maxWidth < 875;

                return Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     TitleOrderIdWithStats(
                      status:orderDetails.status??0,
                       id: orderDetails.id.toString(),
                    ),
                     ViewListDataOrder(
                         orderDetailsModel:orderDetails
                    ),
                    if (!isMobile)
                       Row(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Expanded(
                            flex: 2,
                            child: DesignCarDataOrders(
                              orderDetailsModel: orderDetails,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DataTimeLineTileOrderDetailsWidget(
                                  orderStatus: orderDetails.status,
                                ),
                                 DesignNotesOrder(
                                   note:orderDetails.notes??"",
                                 ),
                                 ContainerContactWithCustomerOrderDetails(
                                  orderDetailsModel: orderDetails,
                                ),
                                 DesignBillOrder(
                                   orderDetailsModel: orderDetails,
                                 ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           DesignCarDataOrders(
                            orderDetailsModel: orderDetails,
                          ),
                          DataTimeLineTileOrderDetailsWidget(
                            orderStatus: orderDetails.status,
                          ),
                          DesignNotesOrder(
                            note:orderDetails.notes??"",
                          ),
                          ContainerContactWithCustomerOrderDetails(
                            orderDetailsModel: orderDetails,
                          ),
                          DesignBillOrder(
                            orderDetailsModel: orderDetails,
                          ),
                        ],
                      ),
                  ],
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}