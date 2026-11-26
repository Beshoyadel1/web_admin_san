import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/orders_page/view_model/get_order_cubit/get_order_cubit.dart';
import 'package:web_admin_san/feature/orders_page/view_model/get_order_cubit/get_order_state.dart';

import '../../../../../../../../../../core/networking/api_link.dart';
import '../../../../../../../../../../core/widgets/app_pagination.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../../../../core/helpers/constants/assets.dart';
import '../../../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/internal_services/view_model/get_provider_internal_order/get_provider_internal_order_cubit.dart';
import 'package:web_admin_san/feature/internal_services/view_model/get_provider_internal_order/get_provider_internal_order_state.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';
import 'package:web_admin_san/feature/order_status_design/view_model/order_status_cubit/order_status_cubit.dart';
import 'package:web_admin_san/feature/order_status_design/view_model/order_status_cubit/order_status_state.dart';

class SecondPartDataContainerInListDataFirstScreenStatisticsPage
    extends StatefulWidget {
  final int serviceId;
  const SecondPartDataContainerInListDataFirstScreenStatisticsPage(
      {super.key, required this.serviceId});

  @override
  State<SecondPartDataContainerInListDataFirstScreenStatisticsPage>
      createState() =>
          _SecondPartDataContainerInListDataFirstScreenStatisticsPageState();
}

class _SecondPartDataContainerInListDataFirstScreenStatisticsPageState
    extends State<SecondPartDataContainerInListDataFirstScreenStatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => GetOrderCubit()
              ..getOrders(
                pageNumber: 1,
              ),
          ),
          BlocProvider(
            create: (_) => OrderStatusCubit(),
          ),
        ],
        child: BlocListener<OrderStatusCubit, OrderStatusState>(
          listener: (context, state) {
            if (state is OrderStatusSuccess) {
              context.read<GetProviderInternalOrderCubit>().loadInternalOrders(
                    serviceId:
                        MainCategoryConstants.mobileServicesAndTransportationID,
                  );
            }
          },
          child: BlocBuilder<GetOrderCubit, GetOrderState>(
            builder: (context, state) {
              if (state is GetProviderInternalOrderLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is GetOrderSuccess) {
                final orders = state.orders
                    .where(
                      (order) =>
                          order.orderStatus ==
                              OrderStatus.newOrderForProvider ||
                          order.orderStatus == OrderStatus.newOrderForCompany,
                    )
                    .toList()
                  ..sort(
                    (a, b) => DateTime.parse(b.orderDate!)
                        .compareTo(DateTime.parse(a.orderDate!)),
                  );

                if (state.orders.isEmpty) {
                  return const Center(
                    child: TextInAppWidget(
                      text: LocaleKeys.empty,
                      textSize: 15,
                      textColor: AppColors.greyColor,
                    ),
                  );
                }
                return Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 5),
                      itemBuilder: (context, index) {
                        final order = orders[index];

                        final service = order.services?.isNotEmpty == true
                            ? order.services!.first
                            : null;

                        final serviceTitle = OrderFunctions.getServiceTitle(
                          context: context,
                          service: service,
                        );

                        return ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget(
                          imagePathPart1: service?.image,
                          titlePart1: serviceTitle,
                          subTitlePart1: '',
                          imagePathPart2: AppImageKeys.car501,
                          textCarPart2: order.branchName ?? "",
                          titlePart2: order.providerName ?? "",
                          imagePathPart3: order.providerImage,
                          titlePart3: LocaleKeys.name,
                          subTitlePart3: order.username ?? "",
                          status: order.orderStatus,
                          timePart5: OrderFunctions.formatDate(order.orderDate),
                          pricePart6: order.totalPrice?.toString() ?? "0",
                          order: order,
                          serviceId: MainCategoryConstants
                              .mobileServicesAndTransportationID,
                          id: order.id.toString(),
                        );
                      },
                    ),
                    AppPagination(
                      currentPage: state.currentPage,
                      totalPages: state.pageCount,
                      onPageChanged: (page) {
                        context.read<GetOrderCubit>().getOrders(
                              pageNumber: page,
                            );
                      },
                    ),
                  ],
                );
              }

              if (state is GetOrderError) {
                return Center(child: Text(state.message));
              }

              return const SizedBox();
            },
          ),
        ));
  }
}
