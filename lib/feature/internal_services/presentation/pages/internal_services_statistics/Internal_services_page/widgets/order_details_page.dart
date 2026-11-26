import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/feature/internal_services/data/model/new_order_steps_model/new_order_steps_model.dart';
import 'package:web_admin_san/feature/internal_services/view_model/new_orders_cubit/new_orders_cubit.dart';
import 'package:web_admin_san/feature/internal_services/view_model/new_orders_cubit/new_orders_state.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/widgets/custom_container.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';
import 'order_time_line.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => NewOrdersCubit(),
        child: Center(
            child: BlocBuilder<NewOrdersCubit, NewOrdersState>(
                buildWhen: (previous, current) => current is ChangeIndexState,
                builder: (context, state) {
                  final cubit = context.read<NewOrdersCubit>();
                  final currentIndex = cubit.selectedIndex;
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Column(
                              children: [
                                TextInAppWidget(
                                    text: LocaleKeys.orderDetailsTitleKey,
                                    textSize: 20,
                                    textColor: AppColors.darkColor,
                                    fontWeightIndex:
                                        FontSelectionData.mediumFontFamily),
                                TextInAppWidget(
                                  text: LocaleKeys.viewAllOrderDetailsKey,
                                  textSize: 14,
                                  textColor: AppColors.darkGreyColor,
                                  fontWeightIndex:
                                      FontSelectionData.regularFontFamily,
                                ),
                              ],
                            ),
                            const Spacer(),
                            if (currentIndex > 0)
                              CustomContainer(
                                containerWidth: 120,
                                containerHeight: 40,
                                padding: const EdgeInsets.all(0),
                                containerColor: AppColors.darkGreyColor,
                                isSelected: false,
                                onTap: () {
                                  cubit.selectTab(currentIndex - 1);
                                },
                                typeWidget: const Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        color: AppColors.whiteColor,
                                        size: 14,
                                      ),
                                      TextInAppWidget(
                                          text: LocaleKeys.backKey,
                                          textSize: 13,
                                          fontWeightIndex: FontSelectionData
                                              .regularFontFamily,
                                          textColor: AppColors.whiteColor),
                                    ],
                                  ),
                                ),
                              )
                          ]),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Wrap(
                                spacing: 30,
                                runSpacing: 20,
                                children: [
                                  steps[currentIndex].content,
                                  const OrderTimeline(),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                })));
  }
}
