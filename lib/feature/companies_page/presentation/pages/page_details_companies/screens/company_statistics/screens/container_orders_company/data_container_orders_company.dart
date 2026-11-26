import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/company_statistics/screens/container_orders_company/list_data_container_order_company.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/facility_tab_provider_cubit/facility_tab_provider_cubit.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/first_row_in_data_container_in_list_data_first_screen_internal_orders.dart';

class DataContainerOrdersCompany extends StatelessWidget {
  const DataContainerOrdersCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FirstRowInDataContainerInListDataFirstScreenInternalOrders(
            onTap: () => context.read<FacilityTabProviderCubit>().selectTab(2),
          ),
          const ListDataContainerOrderCompany()
        ],
      ),
    );
  }
}
