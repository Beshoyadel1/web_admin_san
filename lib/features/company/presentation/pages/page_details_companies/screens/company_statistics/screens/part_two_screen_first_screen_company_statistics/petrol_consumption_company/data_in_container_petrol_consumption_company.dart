import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/assets.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';

import 'package:web_admin_san/features/company/presentation/bloc/get_company_general_statistics_cubit/get_company_general_statistics_cubit.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_company_general_statistics_cubit/get_company_general_statistics_state.dart';

import 'package:web_admin_san/features/company/presentation/custom_widget/text_expended_widget.dart';

import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/company_statistics/screens/part_two_screen_first_screen_company_statistics/petrol_consumption_company/arc_diagram.dart';

import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/row_circle_color_text_percentage_widget.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/row_number_coin_widget.dart';

class DataInContainerPetrolConsumptionCompany extends StatelessWidget {
  const DataInContainerPetrolConsumptionCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
        GetCompanyGeneralStatisticsCubit,
        GetCompanyGeneralStatisticsState>(
      builder: (context, state) {

        if (state is GetCompanyGeneralStatisticsLoading) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        if (state is! GetCompanyGeneralStatisticsSuccess) {
          return const SizedBox();
        }

        final petrol = state.data.petrolConsumption;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            const TextExpendedWidget(
              text: AppLanguageKeys.fuelConsumptionStatistics,
            ),

            const SizedBox(height: 15),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const TextInAppWidget(
                            text: AppLanguageKeys.totalConsumption,
                            textSize: 15,
                            fontWeightIndex:
                            FontSelectionData.regularFontFamily,
                            textColor: AppColors.greyColor,
                          ),

                          const SizedBox(height: 5),

                          RowNumberCoinWidget(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            numberText:
                            petrol.totalConsumption.toString(),
                            sizeText: 15,
                            imageSrc: AppImageKeys.coin,
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      RowCircleColorTextPercentageWidget(
                        colorCircle: AppColors.greyColor,
                        text: AppLanguageKeys.petroleum,
                        percentage:
                        petrol.expectedSpend.toString(),
                      ),

                      const SizedBox(height: 12),

                      RowCircleColorTextPercentageWidget(
                        colorCircle: AppColors.orangeColor,
                        text: AppLanguageKeys.consumptionPercentage,
                        percentage:
                        "${petrol.consumptionPercentage.toStringAsFixed(0)}%",
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: ArcDiagram(
                    percentage:
                    petrol.consumptionPercentage.toDouble(),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}