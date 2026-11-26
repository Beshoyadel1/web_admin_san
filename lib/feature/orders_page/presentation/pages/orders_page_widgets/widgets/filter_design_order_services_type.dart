import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/text_empty_view_data.dart';
import 'package:web_admin_san/feature/orders_page/view_model/get_order_cubit/get_order_cubit.dart';
import 'package:web_admin_san/feature/orders_page/view_model/get_order_cubit/get_order_state.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/internal_orders_filter/internal_orders_filter.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/feature/internal_services/view_model/tabs_cubit/tabs_cubit.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';
import 'package:web_admin_san/core/widgets/app_pagination.dart';
import '../../../../../../../core/networking/api_link.dart';
import '../../../../../../../core/helpers/constants/assets.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class FilterDesignOrderServicesType extends StatelessWidget {
  const FilterDesignOrderServicesType({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetOrderCubit, GetOrderState>(
      builder: (context, state) {
        if (state is GetOrderLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetOrderSuccess) {
          return Column(
            children: [
              Expanded(
                  child: state.orders.isEmpty
                      ? const TextEmptyViewData()
                      : RefreshIndicator(
                          color: AppColors.orangeColor,
                          onRefresh: () async {
                            final selectedTab = context.read<TabsCubit>().state;

                            await context.read<GetOrderCubit>().getOrders(
                                  pageNumber: 1,
                                  orderType: mapOrderType(selectedTab),
                                );
                          },
                          child: ListView.separated(
                            itemCount: state.orders.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 5),
                            itemBuilder: (context, index) {
                              final order = state.orders[index];

                              final service = order.services?.isNotEmpty == true
                                  ? order.services!.first
                                  : null;

                              final serviceTitle =
                                  OrderFunctions.getServiceTitle(
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
                                timePart5:
                                    OrderFunctions.formatDate(order.orderDate),
                                pricePart6: order.totalPrice?.toString() ?? "0",
                                order: order,
                                serviceId: CategoryConstants.mobileServices,
                                id: order.id.toString(),
                              );
                            },
                          ),
                        )),
              AppPagination(
                currentPage: state.currentPage,
                totalPages: state.pageCount,
                onPageChanged: (page) {
                  final selectedTab = context.read<TabsCubit>().state;

                  context.read<GetOrderCubit>().getOrders(
                        pageNumber: page,
                        orderType: mapOrderType(selectedTab),
                      );
                },
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
