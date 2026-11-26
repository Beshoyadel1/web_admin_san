import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/feature/insurance_page/presentation/widgets/widget_design_list_company_insurance.dart';
import 'package:web_admin_san/core/widgets/app_pagination.dart';

class ListInsurancePage extends StatelessWidget {
  const ListInsurancePage({super.key});

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
            currentPage: 1, //state.currentPage,
            totalPages: 1, //state.pageCount,
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
