import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import 'package:web_admin_san/features/order_services/presentation/custom_widget/app_pagination.dart';
import '../../../../../../../../../features/cars_haraj_page/data/model/internal_orders_filter/internal_orders_filter.dart';
import '../../../../../../../../../features/internal_services/presentation/cubit/get_provider_internal_order/get_provider_internal_order_cubit.dart';
import '../../../../../../../../../features/internal_services/presentation/cubit/get_provider_internal_order/get_provider_internal_order_state.dart';
import '../../../../../../../../../features/internal_services/presentation/cubit/order_funcations/order_functions.dart';
import '../../../../../../../../../features/internal_services/presentation/cubit/tabs_cubit/tabs_cubit.dart';
import '../../../../../../../../features/internal_services/presentation/pages/internal_orders/custom_widget/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';
import '../../../../../../../../core/theming/assets.dart';
import '../../../../../../../../core/language/language_constant.dart';

class FilterDesignProviderOrders extends StatelessWidget {
  final int providerId;
  const FilterDesignProviderOrders({super.key,required this.providerId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetProviderInternalOrderCubit,
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
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.orangeColor,
                  onRefresh: () async {
                    final selectedTab = context.read<TabsCubit>().state;

                    await context.read<GetProviderInternalOrderCubit>().loadInternalOrders(
                      pageNumber: 1,
                      orderType: mapOrderType(selectedTab),
                      providerId: providerId
                    );
                  },
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                        titlePart3: AppLanguageKeys.name,
                        subTitlePart3: order.username ?? "",
                        status: order.orderStatus,
                        timePart5: OrderFunctions.formatDate(order.orderDate),
                        pricePart6: order.totalPrice?.toString() ?? "0",
                        order: order,
                        serviceId: order.services?.first.id,
                      );
                    },
                  ),
                ),
              ),
              AppPagination(
                currentPage: state.currentPage,
                totalPages: state.pageCount,
                onPageChanged: (page) {
                  final selectedTab =
                      context.read<TabsCubit>().state;

                  context
                      .read<GetProviderInternalOrderCubit>()
                      .loadInternalOrders(
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