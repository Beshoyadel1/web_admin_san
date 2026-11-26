import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../../core/networking/api_link.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../../../core/helpers/constants/assets.dart';
import '../../../../../../../../../core/widgets/app_pagination.dart';
import 'package:web_admin_san/feature/internal_services/view_model/get_provider_internal_order/get_provider_internal_order_cubit.dart';
import 'package:web_admin_san/feature/internal_services/view_model/get_provider_internal_order/get_provider_internal_order_state.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/feature/order_status_design/view_model/order_status_cubit/order_status_cubit.dart';
import 'package:web_admin_san/feature/order_status_design/view_model/order_status_cubit/order_status_state.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/text_empty_view_data.dart';

class InternalOrdersTable extends StatefulWidget {
  const InternalOrdersTable({super.key});

  @override
  State<InternalOrdersTable> createState() => _InternalOrdersTableState();
}

class _InternalOrdersTableState extends State<InternalOrdersTable> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetProviderInternalOrderCubit()
            ..loadInternalOrders(
              serviceId: MainCategoryConstants.maintenanceAndInternalServicesID,
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
                      MainCategoryConstants.maintenanceAndInternalServicesID,
                );
          }
        },
        child: BlocBuilder<GetProviderInternalOrderCubit,
            GetProviderInternalOrderState>(
          builder: (context, state) {
            if (state is GetProviderInternalOrderLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GetProviderInternalOrderSuccess) {
              final orders = state.orders;

              if (state.orders.isEmpty) {
                return const TextEmptyViewData();
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
                            .maintenanceAndInternalServicesID,
                        id: order.id.toString(),
                      );
                    },
                  ),
                  AppPagination(
                    currentPage: state.currentPage,
                    totalPages: state.pageCount,
                    onPageChanged: (page) {
                      context
                          .read<GetProviderInternalOrderCubit>()
                          .loadInternalOrders(
                            serviceId: MainCategoryConstants
                                .maintenanceAndInternalServicesID,
                            pageNumber: page,
                          );
                    },
                  ),
                ],
              );
            }

            if (state is GetProviderInternalOrderError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

// Backward compatible alias
typedef SecondPartDataContainerInListDataFirstScreenInternalOrders
    = InternalOrdersTable;
