import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/features/auth_page/data/model/create_user_model/provider_details_request.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/custom_widget/title_with_sub_title.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';

import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';

import '../../../../../../../features/accounts_management/presentation/bloc/package_cubit/package_cubit.dart';
import '../../../../../../../features/accounts_management/presentation/bloc/package_cubit/package_state.dart';

import '../../../../../../../features/internal_services/presentation/cubit/order_funcations/order_functions.dart';

class AllProfitsFromPackagesList extends StatelessWidget {
  final ProviderDetailsRequest providerDetailsRequest;

  const AllProfitsFromPackagesList({
    super.key,
    required this.providerDetailsRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        const TextInAppWidget(
          text: AppLanguageKeys.packageName,
          textSize: 18,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          textColor: AppColors.blackColor,
        ),

        BlocProvider(
          create: (_) => PackageCubit()
            ..getPackage(
              providerDetailsRequest: providerDetailsRequest,
            ),
          child: BlocBuilder<PackageCubit, PackageState>(
            builder: (context, state) {

              if (state is PackageLoading) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }

              if (state is PackageError) {
                return const TextEmptyViewData(
                  text: AppLanguageKeys.packageNotFound,
                );
              }

              if (state is PackageSuccess) {
                final package = state.package;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    border: Border.all(
                      color: AppColors.greyColor.withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.darkColor.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CustomContainer(
                    isSelected: false,
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    typeWidget: Wrap(
                      spacing: 30,
                      runSpacing: 15,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.spaceBetween,
                      children: [

                        SizedBox(
                          width: 180,
                          child: TitleWithSubTitle(
                            title: AppLanguageKeys.packageName,
                            textSizeTitle: 13,
                            titleColor: AppColors.greyColor,
                            subTitle: package.getName(context),
                            textSizeSubTitle: 12,
                          ),
                        ),

                        // =========================
                        // PACKAGE DESCRIPTION
                        // =========================

                        SizedBox(
                          width: 250,
                          child: TitleWithSubTitle(
                            title: AppLanguageKeys.packageType,
                            textSizeTitle: 13,
                            titleColor: AppColors.greyColor,
                            subTitle: package.getDescription(context),
                            textSizeSubTitle: 12,
                          ),
                        ),


                        SizedBox(
                          width: 130,
                          child: TitleWithSubTitle(
                            title: AppLanguageKeys.annualPrice,
                            textSizeTitle: 13,
                            titleColor: AppColors.greyColor,
                            subTitle: package.annualprice.toString(),
                            textSizeSubTitle: 12,
                          ),
                        ),


                        SizedBox(
                          width: 130,
                          child: TitleWithSubTitle(
                            title: AppLanguageKeys.monthlyPrice,
                            textSizeTitle: 13,
                            titleColor: AppColors.greyColor,
                            subTitle: package.monthprice.toString(),
                            textSizeSubTitle: 12,
                          ),
                        ),


                        SizedBox(
                          width: 170,
                          child: TitleWithSubTitle(
                            title: AppLanguageKeys.subscriptionStartDate,
                            textSizeTitle: 13,
                            titleColor: AppColors.greyColor,
                            subTitle:
                            state.startDate != null
                                ? OrderFunctions.formatDateFromDateTime(
                              state.startDate,
                            )
                                : '-',
                            textSizeSubTitle: 12,
                          ),
                        ),


                        SizedBox(
                          width: 170,
                          child: TitleWithSubTitle(
                            title: AppLanguageKeys.subscriptionEndDate,
                            textSizeTitle: 13,
                            titleColor: AppColors.greyColor,
                            subTitle:
                            state.endDate != null
                                ? OrderFunctions.formatDateFromDateTime(
                              state.endDate,
                            )
                                : '-',
                            textSizeSubTitle: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}