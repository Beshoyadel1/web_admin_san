import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/tabs_widget_details_companies.dart';
import 'package:web_admin_san/features/providers/data/model/facility_provider_model/facility_model_provider/facility_model_provider.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/facility_provider_cubit/facility_tab_provider_cubit/facility_tab_provider_cubit.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/facility_provider_cubit/facility_tab_provider_cubit/facility_tab_provider_state.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/pages_widgets/general_widgets/custom_container.dart';


class PageDetailsCompanies extends StatelessWidget {
  final int companyId;
  const PageDetailsCompanies({super.key,required this.companyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: AppColors.scaffoldColor,
      body: BlocProvider(
        create: (context) => FacilityTabProviderCubit(),
        child: BlocBuilder<FacilityTabProviderCubit, FacilityTabProviderState>(
          buildWhen: (previous, current) => current is ChangeIndexState,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(

                children: [
                  Expanded(
                    child: CustomContainer(
                      containerWidth: double.infinity,
                      isSelected: false,
                      border: const Border(
                        top: BorderSide(color: AppColors.lightGreyColor),
                        left: BorderSide(color: AppColors.lightGreyColor),
                        right: BorderSide(color: AppColors.lightGreyColor),
                      ),
                      typeWidget: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TabsWidgetDetailsCompanies(
                            companyId: companyId,
                          ),
                          Expanded(
                            child: facilityTabsCompany(companyId)[
                            context.read<FacilityTabProviderCubit>().selectedIndex
                            ].content,
                          ),

                        ],
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
