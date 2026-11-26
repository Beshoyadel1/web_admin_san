import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/internal_orders_filter/internal_orders_filter.dart';
import 'package:web_admin_san/feature/internal_services/view_model/get_provider_internal_order/get_provider_internal_order_cubit.dart';
import 'package:web_admin_san/feature/internal_services/view_model/get_provider_internal_order/get_provider_internal_order_state.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/feature/internal_services/view_model/tabs_cubit/tabs_cubit.dart';
import '../../../../../../../../core/networking/api_link.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../../core/helpers/constants/assets.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';
import 'package:web_admin_san/core/widgets/app_pagination.dart';

class FilterDesignInternalOrders extends StatelessWidget {
  const FilterDesignInternalOrders({super.key});

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
              Expanded(
                child: ListView.separated(
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
                    );
                  },
                ),
              ),
              AppPagination(
                currentPage: state.currentPage,
                totalPages: state.pageCount,
                onPageChanged: (page) {
                  final selectedTab = context.read<TabsCubit>().state;

                  context
                      .read<GetProviderInternalOrderCubit>()
                      .loadInternalOrders(
                        serviceId: MainCategoryConstants
                            .maintenanceAndInternalServicesID,
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
