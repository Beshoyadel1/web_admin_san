import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/theming/assets.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/statistics_providers_cubit/get_provider_total_rate_and_employee_and_balance_cubit/get_provider_total_rate_and_employee_and_balance_cubit.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/statistics_providers_cubit/get_provider_total_rate_and_employee_and_balance_cubit/get_provider_total_rate_and_employee_and_balance_state.dart';
import '../../../../../../../../core/theming/fonts.dart';

class ServicesEvaluation extends StatelessWidget {
  const ServicesEvaluation({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= 1280;
    return CustomContainer(
      padding: const EdgeInsets.all(10),
      containerHeight: 100,
      containerWidth:isMobile?double.infinity: 1000,
      borderRadius: BorderRadius.circular(20),
      isSelected: false,
      onTap: () {},
      typeWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 20,
        children: [
          Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TextInAppWidget(
                text: AppLanguageKeys.servicesRatingKey,
                textSize: 16,
                fontWeightIndex: FontSelectionData.regularFontFamily,
              ),
              Row(
                spacing: 5,
                children: [
                  const Icon(
                    Icons.star,
                    color: AppColors.orangeColor,
                    size: 35,
                  ),
                  BlocBuilder<GetProviderTotalRateAndEmployeeAndBalanceCubit,
                      GetProviderTotalRateAndEmployeeAndBalanceState>(
                    builder: (context, state) {
                      double rate = 0;

                      if (state
                          is GetProviderTotalRateAndEmployeeAndBalanceSuccess) {
                        rate = state.data.averageRate ?? 0;
                      }

                      return TextInAppWidget(
                        text: rate.toStringAsFixed(1),
                        textSize: 16,
                        fontWeightIndex: FontSelectionData.regularFontFamily,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          Image.asset(
            AppImageKeys.starsIcons,
            height: 98,
            width: 79,
            color: AppColors.orangeColor,
          ),
        ],
      ),
    );
  }
}
