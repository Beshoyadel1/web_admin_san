import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/assets.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/internal_services/data/model/get_provider_orders_model/order_model.dart';
import 'package:web_admin_san/features/internal_services/presentation/cubit/order_funcations/order_functions.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/Container_of_second_part_data_container_in_list_data_first_screen_internal_orders_widget.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import 'package:web_admin_san/features/users/presentation/bloc/user_details_cubit/user_details_cubit.dart';
import 'package:web_admin_san/features/users/presentation/bloc/user_details_cubit/user_details_state.dart';

class ViewOrderUser extends StatelessWidget {
  const ViewOrderUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextInAppWidget(
          text: AppLanguageKeys.allOrders,
          textSize: 15,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.orangeColor,
        ),
        BlocBuilder<UserDetailsCubit, UserDetailsState>(
          builder: (context, state) {
            if (state is UserDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is UserDetailsFailure) {
              return Center(
                child: Text(state.error),
              );
            }

            if (state is UserDetailsSuccess) {
              final orders = state.data.orders;

              if (orders.isEmpty) {
                return const TextEmptyViewData();
              }

              return ListView.separated(
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
                    imagePathPart1: order.providerImage,
                    titlePart1: order.serviceName,
                    subTitlePart1: order.serviceLatinName,
                    imagePathPart2: AppImageKeys.car501,
                    textCarPart2: order.providerName,
                    titlePart2: order.providerLatinName,
                    imagePathPart3: order.providerImage,
                    titlePart3: AppLanguageKeys.name,
                    subTitlePart3: order.providerName,
                    status: order.orderStatus,
                    timePart5: OrderFunctions.formatDate(order.orderDate),
                    pricePart6: order.totalPrice.toString(),
                    order: order,
                    serviceId: null,
                  );
                },
              );
            }

            return const SizedBox();
          },
        )
      ],
    );
  }
}
