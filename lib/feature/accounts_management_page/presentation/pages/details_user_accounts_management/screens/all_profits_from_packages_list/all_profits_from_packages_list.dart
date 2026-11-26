import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/package_cubit/package_cubit.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/package_cubit/package_state.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/provider_details_request.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class AllProfitsFromPackagesList extends StatelessWidget {
  final ProviderDetailsRequest providerDetailsRequest;

  const AllProfitsFromPackagesList({
    super.key,
    required this.providerDetailsRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardStroke),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.orangeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.card_membership_outlined,
                  color: AppColors.orangeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              TextInAppWidget(
                text: LocaleKeys.packageName.tr(),
                textSize: 16,
                fontWeightIndex: FontSelectionData.boldFontFamily,
                textColor: AppColors.darkColor,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Content
          BlocProvider(
            create: (_) => PackageCubit()
              ..getPackage(providerDetailsRequest: providerDetailsRequest),
            child: BlocBuilder<PackageCubit, PackageState>(
              builder: (context, state) {
                if (state is PackageLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(
                          color: AppColors.orangeColor),
                    ),
                  );
                }

                if (state is PackageError || state is PackageInitial) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardStroke),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 20,
                          color: AppColors.darkGreyColor,
                        ),
                        const SizedBox(width: 12),
                        TextInAppWidget(
                          text: LocaleKeys.packageNotFound.tr(),
                          textSize: 13,
                          fontWeightIndex: FontSelectionData.mediumFontFamily,
                          textColor: AppColors.darkGreyColor,
                        ),
                      ],
                    ),
                  );
                }

                if (state is PackageSuccess) {
                  final package = state.package;

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.cardStroke),
                    ),
                    child: Wrap(
                      spacing: 24,
                      runSpacing: 16,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        PackageDetailItem(
                          label: LocaleKeys.packageName.tr(),
                          value: package.getName(context) ?? '-',
                          isBold: true,
                        ),
                        PackageDetailItem(
                          label: LocaleKeys.packageType.tr(),
                          value: package.getDescription(context) ?? '-',
                        ),
                        PackageDetailItem(
                          label: LocaleKeys.annualPrice.tr(),
                          value: '${package.annualprice} ر.س',
                        ),
                        PackageDetailItem(
                          label: LocaleKeys.monthlyPrice.tr(),
                          value: '${package.monthprice} ر.س',
                        ),
                        PackageDetailItem(
                          label: LocaleKeys.subscriptionStartDate.tr(),
                          value: state.startDate != null
                              ? OrderFunctions.formatDateFromDateTime(
                                  state.startDate)
                              : '-',
                        ),
                        PackageDetailItem(
                          label: LocaleKeys.subscriptionEndDate.tr(),
                          value: state.endDate != null
                              ? OrderFunctions.formatDateFromDateTime(
                                  state.endDate)
                              : '-',
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PackageDetailItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const PackageDetailItem({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextInAppWidget(
          text: label,
          textSize: 12,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.darkGreyColor,
        ),
        const SizedBox(height: 4),
        TextInAppWidget(
          text: value,
          textSize: 13,
          fontWeightIndex: isBold
              ? FontSelectionData.boldFontFamily
              : FontSelectionData.mediumFontFamily,
          textColor: AppColors.darkColor,
        ),
      ],
    );
  }
}
