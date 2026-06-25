import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/bloc/get_harage_providers_cubit/get_harage_providers_cubit.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_all_companies_cubit/get_all_companies_cubit.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_all_companies_cubit/get_all_companies_state.dart';
import 'package:web_admin_san/features/company/presentation/custom_widget/widget_design_list_company.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/page_details_companies.dart';
import 'package:web_admin_san/features/internal_services/presentation/cubit/order_funcations/order_functions.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import 'package:web_admin_san/features/order_services/presentation/custom_widget/app_pagination.dart';

class ListViewAllCompanies extends StatelessWidget {
  const ListViewAllCompanies({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllCompaniesCubit, GetAllCompaniesState>(
      builder: (context, state) {
        if (state is GetAllCompaniesLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is GetAllCompaniesError) {
          return Center(
            child: Text(
              state.error,
            ),
          );
        }

        if (state is GetAllCompaniesSuccess) {
          if (state.companies.isEmpty) {
            return const Center(
              child: TextEmptyViewData(),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: state.companies.length,
                  separatorBuilder: (_, __) => const SizedBox(
                    height: 20,
                  ),
                  itemBuilder: (context, index) {
                    final companies = state.companies[index];

                    return WidgetDesignListCompany(
                      companyId: companies.companyId.toString(),
                      name: companies.name ?? '',
                      nameButton: AppLanguageKeys.details,
                      image: companies.image,
                      lastOrderDate: companies.lastOrderProvider != null
                          ? OrderFunctions.formatDateFromDateTime(
                        companies.lastOrderProvider,
                      )
                          : '-',
                      joiningDate: companies.joinDate != null
                          ? OrderFunctions.formatDateFromDateTime(
                        companies.joinDate,
                      )
                          : '-',
                      onTabDetails: () {
                        Navigator.push(
                          context,
                          NavigateToPageWidget(
                            PageDetailsCompanies(
                              companyId: companies.companyId??5,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              AppPagination(
                currentPage: state.currentPage,
                totalPages: state.pageCount,
                onPageChanged: (page) {
                  context.read<GetHarageProvidersCubit>().getAllHarahProviders(
                    currentPage: page,
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
