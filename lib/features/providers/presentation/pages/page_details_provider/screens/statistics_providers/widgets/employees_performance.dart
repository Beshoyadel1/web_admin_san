import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/theming/assets.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/statistics_providers_cubit/get_provider_total_rate_and_employee_and_balance_cubit/get_provider_total_rate_and_employee_and_balance_cubit.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/statistics_providers_cubit/get_provider_total_rate_and_employee_and_balance_cubit/get_provider_total_rate_and_employee_and_balance_state.dart';
import '../../../../../../../../core/theming/fonts.dart';
import 'employe_widget.dart';

class EmployeesPerformance extends StatelessWidget {
  const EmployeesPerformance({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= 1320;
    return CustomContainer(
      containerWidth:isMobile?double.infinity: 500,
      containerHeight: 504,
      borderRadius: BorderRadius.circular(20),
      isSelected: false,
      onTap: () {},
      typeWidget: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            const TextInAppWidget(
              text: AppLanguageKeys.topEmployeesKey,
              textSize: 14,
            ),
            const TextInAppWidget(
              text: AppLanguageKeys.topOrderReceiversKey,
              textSize: 10,
              textColor: AppColors.darkGreyColor,
            ),
            const SizedBox(height: 10),
            BlocBuilder<GetProviderTotalRateAndEmployeeAndBalanceCubit,
                GetProviderTotalRateAndEmployeeAndBalanceState>(
              builder: (context, state) {
                if (state is GetProviderTotalRateAndEmployeeAndBalanceLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is GetProviderTotalRateAndEmployeeAndBalanceError) {
                  return const Text("Error");
                }

                if (state is GetProviderTotalRateAndEmployeeAndBalanceSuccess) {
                  final employees = state.data.topEmployees;

                  if (employees.isEmpty) {
                    return const TextEmptyViewData();
                  }

                  return Column(
                    children: List.generate(
                      employees.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: EmployeWidget(
                          employee: employees[index],
                        ),
                      ),
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
