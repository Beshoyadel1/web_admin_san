import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/widgets/app_pagination.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/text_empty_view_data.dart';
import 'package:web_admin_san/feature/users_page/view_model/user_details_cubit/user_details_cubit.dart';
import 'package:web_admin_san/feature/users_page/view_model/user_details_cubit/user_details_state.dart';
import 'package:web_admin_san/core/networking/api_link.dart';

class ViewOrderUser extends StatefulWidget {
  const ViewOrderUser({super.key});

  @override
  State<ViewOrderUser> createState() => _ViewOrderUserState();
}

class _ViewOrderUserState extends State<ViewOrderUser> {
  int _currentPage = 1;
  static const int _pageSize = 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextInAppWidget(
          text: LocaleKeys.allOrders,
          textSize: 15,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.orangeColor,
        ),
        BlocBuilder<UserDetailsCubit, UserDetailsState>(
          builder: (context, state) {
            if (state is UserDetailsSuccess) {
              final orders = state.data.orders;

              if (orders.isEmpty) {
                return const TextEmptyViewData();
              }

              final totalPages = (orders.length / _pageSize).ceil();
              final safePage =
                  _currentPage.clamp(1, totalPages > 0 ? totalPages : 1);
              final pagedOrders = orders
                  .skip((safePage - 1) * _pageSize)
                  .take(_pageSize)
                  .toList();

              return Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pagedOrders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 5),
                    itemBuilder: (context, index) {
                      final order = pagedOrders[index];

                      final service = order.services?.isNotEmpty == true
                          ? order.services!.first
                          : null;

                      final serviceTitle = OrderFunctions.getServiceTitle(
                        context: context,
                        service: service,
                      );

                      return ContainerOfSecondPartDataContainerInListDataFirstScreenInternalOrdersWidget(
                        imagePathPart1: service?.image ?? order.providerImage,
                        titlePart1: serviceTitle.isNotEmpty
                            ? serviceTitle
                            : (order.serviceName ?? ''),
                        subTitlePart1: '',
                        imagePathPart2: AppImageKeys.car501,
                        textCarPart2: order.branchName ?? "",
                        titlePart2: order.providerName ?? "",
                        imagePathPart3: order.providerImage,
                        titlePart3: LocaleKeys.serviceProvider,
                        subTitlePart3: order.providerName ?? "",
                        status: order.orderStatus,
                        timePart5: OrderFunctions.formatDate(order.orderDate),
                        pricePart6: order.totalPrice?.toString() ?? "0",
                        order: order,
                        serviceId: service?.id ??
                            MainCategoryConstants
                                .maintenanceAndInternalServicesID,
                        id: order.id.toString(),
                      );
                    },
                  ),
                  AppPagination(
                    currentPage: safePage,
                    totalPages: totalPages,
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        )
      ],
    );
  }
}
