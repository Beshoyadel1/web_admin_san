import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/text_empty_view_data.dart';
import 'package:web_admin_san/feature/providers_page/view_model/statistics_providers_cubit/get_provider_total_rate_and_employee_and_balance_cubit/get_provider_total_rate_and_employee_and_balance_cubit.dart';
import 'package:web_admin_san/feature/providers_page/view_model/statistics_providers_cubit/get_provider_total_rate_and_employee_and_balance_cubit/get_provider_total_rate_and_employee_and_balance_state.dart';
import 'data_account_balance.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountBalance extends StatelessWidget {
  const AccountBalance({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= 1320;
    return BlocBuilder<GetProviderTotalRateAndEmployeeAndBalanceCubit,
        GetProviderTotalRateAndEmployeeAndBalanceState>(
      builder: (context, state) {
        final data = state is GetProviderTotalRateAndEmployeeAndBalanceSuccess
            ? state.data.accountsBalance
            : [];
        if (data.isEmpty) {
          return const SizedBox();
        }
        return CustomContainer(
          containerWidth: isMobile ? double.infinity : 520,
          containerHeight: 504,
          padding: const EdgeInsets.all(0),
          borderRadius: BorderRadius.circular(20),
          isSelected: false,
          onTap: () {},
          typeWidget: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const TextInAppWidget(
                          text: LocaleKeys.accountBalanceKey,
                          textSize: 18,
                          textColor: AppColors.darkColor,
                        ),
                        Row(
                          spacing: 5,
                          children: [
                            const TextInAppWidget(
                              text: LocaleKeys.total,
                              textSize: 20,
                              textColor: AppColors.orangeColor,
                            ),
                            BlocBuilder<
                                GetProviderTotalRateAndEmployeeAndBalanceCubit,
                                GetProviderTotalRateAndEmployeeAndBalanceState>(
                              builder: (context, state) {
                                double total = 0;

                                if (state
                                    is GetProviderTotalRateAndEmployeeAndBalanceSuccess) {
                                  total = state.data.totalBalance.toDouble();
                                }

                                return TextInAppWidget(
                                  text: ': ${total.toStringAsFixed(0)}',
                                  textSize: 20,
                                  textColor: AppColors.orangeColor,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    // CustomContainer(
                    //   padding: const EdgeInsets.all(0),
                    //   containerWidth: 100,
                    //   containerHeight: 37,
                    //   typeWidget: const Center(
                    //     child: TextInAppWidget(
                    //       text: LocaleKeys.detailsKey,
                    //       textColor: AppColors.whiteColor,
                    //       textSize: 15,
                    //     ),
                    //   ),
                    //   onTap: () {},
                    //   isSelected: false,
                    //   containerColor: AppColors.orangeColor,
                    // )
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: data.isEmpty
                      ? const TextEmptyViewData()
                      : ListView.separated(
                          itemCount: data.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return DataAccountBalance(
                              item: data[index],
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
