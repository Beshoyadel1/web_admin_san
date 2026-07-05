import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/bloc/get_harage_providers_cubit/get_harage_providers_cubit.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_all_companies_cubit/get_all_companies_cubit.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_all_companies_cubit/get_all_companies_state.dart';
import 'package:web_admin_san/features/company/presentation/custom_widget/widget_design_list_company.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/page_details_companies.dart';
import 'package:web_admin_san/features/insurance/presentation/custom_widget/widget_design_list_company_insurance.dart';
import 'package:web_admin_san/features/internal_services/presentation/cubit/order_funcations/order_functions.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import 'package:web_admin_san/features/order_services/presentation/custom_widget/app_pagination.dart';

class ListViewAllCompaniesInsurance extends StatelessWidget {
  const ListViewAllCompaniesInsurance({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      onTap: () {},
      typeWidget: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: 10,
              separatorBuilder: (_, __) => const SizedBox(
                height: 20,
              ),
              itemBuilder: (context, index) {

                return const WidgetDesignListCompanyInsurance(

                  // onTabDetails: () {
                  //   Navigator.push(
                  //     context,
                  //     NavigateToPageWidget(
                  //       PageDetailsCompanies(
                  //         companyId: companies.companyId ?? 5,
                  //       ),
                  //     ),
                  //   );
                  // },
                );
              },
            ),
          ),
          AppPagination(
            currentPage:1, //state.currentPage,
            totalPages:1, //state.pageCount,
            onPageChanged: (page) {
              // context
              //     .read<GetHarageProvidersCubit>()
              //     .getAllHarahProviders(
              //   currentPage: page,
              // );
            },
          ),
        ],
      ),
    );
  }
}
