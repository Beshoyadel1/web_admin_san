import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/auth_page/data/request/get_user_inf_request/get_user_info_datasource.dart';
import 'package:web_admin_san/feature/auth_page/view_model/get_user_info_cubit/get_user_info_cubit.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/tabs_widget_details_companies.dart';
import 'package:web_admin_san/feature/providers_page/data/model/facility_provider_model/facility_model_provider/facility_model_provider.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/facility_tab_provider_cubit/facility_tab_provider_cubit.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/facility_tab_provider_cubit/facility_tab_provider_state.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/widgets/custom_container.dart';
import '../../../../../../core/widgets/lazy_indexed_stack.dart';

class PageDetailsCompanies extends StatelessWidget {
  final int companyId;
  const PageDetailsCompanies({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FacilityTabProviderCubit()),
        BlocProvider(
          create: (_) => GetUserInfoCubit()
            ..getUserInfo(
              request: GetUserInfoRequest(
                userId: companyId,
                userType: 2,
              ),
            ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.blackColor,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          title: Row(
            children: [
              Text(
                LocaleKeys.details.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.orangeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '#$companyId',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.orangeColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: AppColors.scaffoldColor,
        body: Padding(
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
                        child: BlocBuilder<FacilityTabProviderCubit,
                            FacilityTabProviderState>(
                          buildWhen: (previous, current) =>
                              current is ChangeIndexState,
                          builder: (context, state) {
                            final selectedIndex = context
                                .read<FacilityTabProviderCubit>()
                                .selectedIndex;
                            final safeIndex = (selectedIndex >= 0 &&
                                    selectedIndex < companyTabTitles.length)
                                ? selectedIndex
                                : 0;

                            return LazyIndexedStack(
                              index: safeIndex,
                              itemCount: companyTabTitles.length,
                              itemBuilder: (context, index) =>
                                  buildCompanyTabContent(
                                context,
                                index,
                                companyId,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
