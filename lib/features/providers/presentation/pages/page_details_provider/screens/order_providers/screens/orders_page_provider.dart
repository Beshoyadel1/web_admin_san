import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/cubit/new_orders_cubit/new_orders_cubit.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/order_providers/screens/filters_tabs_provider_widget.dart';
import '../../../../../../../../../features/cars_haraj_page/data/model/filter_orders_model/filter_orders_model.dart';
import '../../../../../../../../../features/cars_haraj_page/data/model/internal_orders_filter/internal_orders_filter.dart';
import '../../../../../../../../../features/internal_services/presentation/cubit/get_provider_internal_order/get_provider_internal_order_state.dart';
import '../../../../../../../../../features/internal_services/presentation/cubit/tabs_cubit/tabs_cubit.dart';
import '../../../../../../../../../features/internal_services/presentation/pages/internal_services_statistics/Internal_services_page/widgets/filters_tabs_widget.dart';



class OrdersPageProvider extends StatelessWidget {
  final int providerId;
  const OrdersPageProvider({super.key, required this.cubit,required this.providerId});

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
                      text: AppLanguageKeys.allOrdersKey,
                      textSize: 20,
                      textColor: AppColors.darkColor,
                    ),
                    TextInAppWidget(
                      text: AppLanguageKeys.ordersListFromServicesKey,
                      textSize: 16,
                      textColor: AppColors.darkGreyColor,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 900,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => TabsCubit()),
                  BlocProvider(
                    create: (_) => GetProviderInternalOrderCubit()
                      ..loadInternalOrders(
                        orderType: mapOrderType(0),
                        providerId:providerId
                      ),
                  ),
                ],
                child: FiltersTabsProviderWidget(
                  filterOptions: filterOrders,
                    providerId:providerId
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
