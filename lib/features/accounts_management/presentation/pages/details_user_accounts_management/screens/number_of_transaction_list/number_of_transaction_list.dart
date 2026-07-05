import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/custom_widget/title_with_sub_title.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';
import '../../../../../../../features/accounts_management/presentation/bloc/provider_balances_cubit/provider_balances_cubit.dart';
import '../../../../../../../features/accounts_management/presentation/bloc/provider_balances_cubit/provider_balances_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../features/internal_services/presentation/cubit/order_funcations/order_functions.dart';
import '../../../../../../../features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import '../../../../../../../features/internal_services/presentation/pages/internal_orders/custom_widget/text_with_container_status.dart';

class NumberOfTransactionList extends StatelessWidget {
  const NumberOfTransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        const TextInAppWidget(
          text: AppLanguageKeys.payBill,
          textSize: 18,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          textColor: AppColors.blackColor,
        ),

        BlocBuilder<ProviderBalanceCubit, ProviderBalanceState>(
          builder: (context, state) {
            if (state is ProviderBalanceLoading) {
              return const CupertinoActivityIndicator();
            }

            if (state is ProviderBalanceError) {
              return const Text("Error loading transactions");
            }

            if (state is ProviderBalanceSuccess) {
              final orders = state.model.recentOrders;
              if (orders.isEmpty) {
                return const TextEmptyViewData();
              }
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final order = orders[index];

                    return CustomContainer(
                      isSelected: false,
                      onTap: () {},
                      borderRadius: BorderRadius.circular(12),
                      typeWidget: Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          TitleWithSubTitle(
                            title: AppLanguageKeys.transactionNumber,
                            textSizeTitle: 13,
                            titleColor: AppColors.greyColor,
                            subTitle: "${order.orderId}",
                            textSizeSubTitle: 12,
                          ),
                          TitleWithSubTitle(
                            title: AppLanguageKeys.total,
                            textSizeTitle: 13,
                            titleColor: AppColors.greyColor,
                            subTitle: "${order.totalAmount}",
                            textSizeSubTitle: 12,
                          ),
                          TitleWithSubTitle(
                            title: AppLanguageKeys.invoiceDate,
                            textSizeTitle: 13,
                            titleColor: AppColors.greyColor,
                            subTitle: OrderFunctions.formatDate(order.date.toIso8601String()),
                            textSizeSubTitle: 12,
                          ),
                          TextWithContainerStatus(
                            text: AppLanguageKeys.orderStatusKey,
                            status: order.status,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }
}