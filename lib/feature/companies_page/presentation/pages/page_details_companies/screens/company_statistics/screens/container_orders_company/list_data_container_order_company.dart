import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/text_empty_view_data.dart';
import 'package:web_admin_san/feature/internal_services/view_model/get_provider_internal_order/get_provider_internal_order_cubit.dart';
import 'package:web_admin_san/feature/internal_services/view_model/get_provider_internal_order/get_provider_internal_order_state.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';

class ListDataContainerOrderCompany extends StatelessWidget {
  const ListDataContainerOrderCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetProviderInternalOrderCubit,
        GetProviderInternalOrderState>(
      builder: (context, state) {
        if (state is GetProviderInternalOrderLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetProviderInternalOrderSuccess) {
          final orders = state.orders
              .where(
                (order) =>
                    order.orderStatus == OrderStatus.newOrderForProvider ||
                    order.orderStatus == OrderStatus.newOrderForCompany,
              )
              .toList()
            ..sort((a, b) {
              final dateA = DateTime.tryParse(a.orderDate ?? '');
              final dateB = DateTime.tryParse(b.orderDate ?? '');
              if (dateA == null && dateB == null) return 0;
              if (dateA == null) return 1;
              if (dateB == null) return -1;
              return dateB.compareTo(dateA);
            });

          final latestOrders = orders.take(5).toList();
          if (latestOrders.isEmpty) {
            return const TextEmptyViewData();
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: latestOrders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 5),
            itemBuilder: (context, index) {
              final order = latestOrders[index];

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
                serviceId: service?.id,
                id: order.id.toString(),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
