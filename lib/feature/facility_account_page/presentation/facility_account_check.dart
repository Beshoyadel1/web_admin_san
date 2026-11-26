import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/facility_account_page/presentation/tabs/facility_data_content.dart';

import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_cubit.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_state.dart';
import 'package:web_admin_san/feature/store_page/view_model/facility_cubit/facility_tab_cubit/facility_tab_cubit.dart';
import 'package:web_admin_san/feature/store_page/view_model/facility_cubit/facility_tab_cubit/facility_tab_state.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/widgets/custom_container.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';

class FacilityAccountCheck extends StatelessWidget {
  const FacilityAccountCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: BlocProvider(
        create: (context) => FacilityTabCubit(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthIncompleteProfile) {
              AppSnackBar.showError(
                state.missing.first,
              );
            }

            if (state is AuthUpdateError) {
              AppSnackBar.showError(state.error);
            }
          },
          builder: (context, authState) {
            return BlocBuilder<FacilityTabCubit, FacilityTabState>(
              buildWhen: (previous, current) => current is ChangeIndexState,
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomContainer(
                          containerWidth: double.infinity,
                          isSelected: false,
                          typeWidget: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextInAppWidget(
                                text: LocaleKeys.continueFacilityDataKey,
                                textSize: 22,
                                fontWeightIndex:
                                    FontSelectionData.mediumFontFamily,
                              ),
                              const FacilityDataContent(),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomContainer(
                                      isSelected: false,
                                      onTap: () {
                                        context
                                            .read<AuthCubit>()
                                            .reCheckFacility();
                                      },
                                      containerColor: AppColors.orangeColor,
                                      containerHeight: 45,
                                      typeWidget: const Center(
                                        child: TextInAppWidget(
                                          text: LocaleKeys.enterSystem,
                                          textSize: 16,
                                          textColor: AppColors.whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: CustomContainer(
                                      isSelected: false,
                                      onTap: () {
                                        context
                                            .read<AuthCubit>()
                                            .logout(context);
                                      },
                                      containerColor: AppColors.redColor,
                                      containerHeight: 45,
                                      typeWidget: const Center(
                                        child: TextInAppWidget(
                                          text: LocaleKeys.logout_dashboard,
                                          textSize: 16,
                                          textColor: AppColors.whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
