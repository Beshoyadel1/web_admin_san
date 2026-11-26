import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/widgets/lazy_indexed_stack.dart';
import 'package:web_admin_san/feature/auth_page/data/request/get_user_inf_request/get_user_info_datasource.dart';
import 'package:web_admin_san/feature/auth_page/view_model/get_user_info_cubit/get_user_info_cubit.dart';
import 'package:web_admin_san/feature/providers_page/data/model/facility_provider_model/facility_model_provider/facility_model_provider.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/facility_tab_provider_cubit/facility_tab_provider_cubit.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/facility_tab_provider_cubit/facility_tab_provider_state.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/tabs_widget_provider.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/provider_details_header.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/widgets/custom_container.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';

class PageDetailsProvider extends StatelessWidget {
  final int providerID;
  const PageDetailsProvider({super.key, required this.providerID});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FacilityTabProviderCubit(),
        ),
        BlocProvider(
          create: (context) => GetUserInfoCubit()
            ..getUserInfo(
              request: GetUserInfoRequest(
                userId: providerID,
                userType: 4,
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
          title: Text(
            LocaleKeys.serviceProviderDetails.tr(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
            ),
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
                  padding: const EdgeInsets.all(20),
                  border: const Border(
                    top: BorderSide(color: AppColors.lightGreyColor),
                    left: BorderSide(color: AppColors.lightGreyColor),
                    right: BorderSide(color: AppColors.lightGreyColor),
                  ),
                  typeWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: ProviderDetailsHeader(
                          providerID: providerID,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TabsWidgetProvider(
                        providerID: providerID,
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: BlocBuilder<FacilityTabProviderCubit,
                            FacilityTabProviderState>(
                          buildWhen: (previous, current) =>
                              current is ChangeIndexState,
                          builder: (context, state) {
                            final selectedIndex = context
                                .read<FacilityTabProviderCubit>()
                                .selectedIndex;

                            return LazyIndexedStack(
                              index: selectedIndex,
                              itemCount: providerTabTitles.length,
                              itemBuilder: (context, index) =>
                                  buildProviderTabContent(
                                context,
                                index,
                                providerID,
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
