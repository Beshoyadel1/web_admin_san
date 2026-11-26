import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/provider_balances_cubit/provider_balances_cubit.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/provider_balances_cubit/provider_balances_state.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/text_with_container_status.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class NumberOfTransactionList extends StatefulWidget {
  const NumberOfTransactionList({super.key});

  @override
  State<NumberOfTransactionList> createState() =>
      _NumberOfTransactionListState();
}

class _NumberOfTransactionListState extends State<NumberOfTransactionList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
                  Icons.receipt_outlined,
                  color: AppColors.orangeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const TextInAppWidget(
                text: 'سجل الفواتير والعمليات الأخيرة',
                textSize: 16,
                fontWeightIndex: FontSelectionData.boldFontFamily,
                textColor: AppColors.darkColor,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Content
          BlocBuilder<ProviderBalanceCubit, ProviderBalanceState>(
            builder: (context, state) {
              if (state is ProviderBalanceLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child:
                        CircularProgressIndicator(color: AppColors.orangeColor),
                  ),
                );
              }

              if (state is ProviderBalanceError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: TextInAppWidget(
                      text: LocaleKeys.errorLoadingTransactions.tr(),
                      textSize: 14,
                      textColor: AppColors.errorRedColor,
                    ),
                  ),
                );
              }

              if (state is ProviderBalanceSuccess) {
                final orders = state.model.recentOrders;
                if (orders.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: TextInAppWidget(
                        text: LocaleKeys.common_noData.tr(),
                        textSize: 14,
                        textColor: AppColors.darkGreyColor,
                      ),
                    ),
                  );
                }

                return Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 700),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                          AppColors.scaffoldColor,
                        ),
                        dataRowMinHeight: 48,
                        dataRowMaxHeight: 56,
                        columns: [
                          DataColumn(
                            label: TextInAppWidget(
                              text: LocaleKeys.transactionNumber.tr(),
                              textSize: 13,
                              fontWeightIndex: FontSelectionData.boldFontFamily,
                              textColor: AppColors.darkColor,
                            ),
                          ),
                          DataColumn(
                            label: TextInAppWidget(
                              text: LocaleKeys.invoiceDate.tr(),
                              textSize: 13,
                              fontWeightIndex: FontSelectionData.boldFontFamily,
                              textColor: AppColors.darkColor,
                            ),
                          ),
                          DataColumn(
                            label: TextInAppWidget(
                              text: LocaleKeys.total.tr(),
                              textSize: 13,
                              fontWeightIndex: FontSelectionData.boldFontFamily,
                              textColor: AppColors.darkColor,
                            ),
                          ),
                          DataColumn(
                            label: TextInAppWidget(
                              text: LocaleKeys.orderStatusKey.tr(),
                              textSize: 13,
                              fontWeightIndex: FontSelectionData.boldFontFamily,
                              textColor: AppColors.darkColor,
                            ),
                          ),
                        ],
                        rows: orders.map((order) {
                          return DataRow(
                            cells: [
                              DataCell(
                                TextInAppWidget(
                                  text: '#${order.orderId}',
                                  textSize: 13,
                                  fontWeightIndex:
                                      FontSelectionData.boldFontFamily,
                                  textColor: AppColors.orangeColor,
                                ),
                              ),
                              DataCell(
                                TextInAppWidget(
                                  text: OrderFunctions.formatDate(
                                      order.date.toIso8601String()),
                                  textSize: 12,
                                  textColor: AppColors.darkColor,
                                ),
                              ),
                              DataCell(
                                TextInAppWidget(
                                  text:
                                      '${order.totalAmount.toStringAsFixed(2)} ر.س',
                                  textSize: 13,
                                  fontWeightIndex:
                                      FontSelectionData.boldFontFamily,
                                  textColor: AppColors.darkColor,
                                ),
                              ),
                              DataCell(
                                TextWithContainerStatus(
                                  text: LocaleKeys.orderStatusKey,
                                  status: order.status,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
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
    );
  }
}
