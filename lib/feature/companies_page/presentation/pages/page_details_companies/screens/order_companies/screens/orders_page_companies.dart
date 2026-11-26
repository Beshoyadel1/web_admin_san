import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/internal_services/view_model/new_orders_cubit/new_orders_cubit.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/order_companies/screens/filters_tabs_companies_widget.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/filter_orders_model/filter_orders_model.dart';
import 'package:web_admin_san/feature/internal_services/view_model/get_provider_internal_order/get_provider_internal_order_state.dart';
import 'package:web_admin_san/feature/internal_services/view_model/tabs_cubit/tabs_cubit.dart';

class OrdersPageCompanies extends StatelessWidget {
  final int companyId;
  const OrdersPageCompanies({
    super.key,
    required this.cubit,
    required this.companyId,
  });

  final NewOrdersCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextInAppWidget(
              text: LocaleKeys.allOrdersKey,
              textSize: 20,
              textColor: AppColors.darkColor,
            ),
            SizedBox(height: 4),
            TextInAppWidget(
              text: LocaleKeys.ordersListFromServicesKey,
              textSize: 16,
              textColor: AppColors.darkGreyColor,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => TabsCubit()),
              BlocProvider(
                create: (_) => GetProviderInternalOrderCubit()
                  ..getCompanyOrders(companyId: companyId),
              ),
            ],
            child: FiltersTabsCompaniesWidget(
              filterOptions: filterOrders,
              companyId: companyId,
            ),
          ),
        ),
      ],
    );
  }
}
