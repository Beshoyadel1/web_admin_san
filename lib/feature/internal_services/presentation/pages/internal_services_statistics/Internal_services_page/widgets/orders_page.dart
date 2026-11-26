import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/filter_orders_model/filter_orders_model.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/internal_orders_filter/internal_orders_filter.dart';
import 'package:web_admin_san/feature/internal_services/view_model/get_provider_internal_order/get_provider_internal_order_state.dart';
import 'package:web_admin_san/feature/internal_services/view_model/tabs_cubit/tabs_cubit.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_services_statistics/Internal_services_page/widgets/filters_tabs_widget.dart';
import '../../../../../../../core/networking/api_link.dart';
import 'package:web_admin_san/feature/internal_services/view_model/new_orders_cubit/new_orders_cubit.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/widgets/custom_container.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key, required this.cubit});

  final NewOrdersCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      onTap: () {},
      typeWidget: Center(
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Wrap(
              alignment: WrapAlignment.spaceBetween,
              runAlignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInAppWidget(
                      text: LocaleKeys.allOrdersKey,
                      textSize: 20,
                      textColor: AppColors.darkColor,
                    ),
                    TextInAppWidget(
                      text: LocaleKeys.ordersListFromServicesKey,
                      textSize: 16,
                      textColor: AppColors.darkGreyColor,
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => TabsCubit()),
                  BlocProvider(
                    create: (_) => GetProviderInternalOrderCubit()
                      ..loadInternalOrders(
                        serviceId: MainCategoryConstants
                            .maintenanceAndInternalServicesID,
                        orderType: mapOrderType(0),
                      ),
                  ),
                ],
                child: FiltersTabsWidget(
                  filterOptions: filterOrders,
                ),
              ),
            ),
            // Center(child: NumberIndicator())
          ],
        ),
      ),
    );
  }
}
