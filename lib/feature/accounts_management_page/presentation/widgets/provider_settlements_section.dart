import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/settlement_cubit/settlement_cubit.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/settlement_cubit/settlement_state.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class ProviderSettlementsSection extends StatefulWidget {
  final int providerId;

  const ProviderSettlementsSection({
    super.key,
    required this.providerId,
  });

  @override
  State<ProviderSettlementsSection> createState() =>
      _ProviderSettlementsSectionState();
}

class _ProviderSettlementsSectionState
    extends State<ProviderSettlementsSection> {
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
                  Icons.receipt_long_outlined,
                  color: AppColors.orangeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              TextInAppWidget(
                text: LocaleKeys.settlementHistory.tr(),
                textSize: 16,
                fontWeightIndex: FontSelectionData.boldFontFamily,
                textColor: AppColors.darkColor,
              ),
              const Spacer(),
              BlocBuilder<SettlementCubit, SettlementState>(
                builder: (context, state) {
                  final count =
                      context.read<SettlementCubit>().settlements.length;
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.lightOrangeColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextInAppWidget(
                      text: '$count ${LocaleKeys.settlements.tr()}',
                      textSize: 12,
                      fontWeightIndex: FontSelectionData.mediumFontFamily,
                      textColor: AppColors.orangeColor,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Content
          BlocBuilder<SettlementCubit, SettlementState>(
            builder: (context, state) {
              if (state is SettlementLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child:
                        CircularProgressIndicator(color: AppColors.orangeColor),
                  ),
                );
              }

              if (state is SettlementError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.errorRedColor, size: 36),
                        const SizedBox(height: 8),
                        TextInAppWidget(
                          text: state.message,
                          textSize: 14,
                          textColor: AppColors.errorRedColor,
                        ),
                        const SizedBox(height: 12),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: TextButton.icon(
                            onPressed: () => context
                                .read<SettlementCubit>()
                                .loadProviderSettlements(
                                    providerId: widget.providerId),
                            icon: const Icon(Icons.refresh, size: 16),
                            label: Text(LocaleKeys.retry.tr()),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final settlements = context.read<SettlementCubit>().settlements;

              if (settlements.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.scaffoldColor,
                          ),
                          child: const Icon(
                            Icons.history_toggle_off_outlined,
                            size: 40,
                            color: AppColors.darkGreyColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextInAppWidget(
                          text: LocaleKeys.noSettlementsYet.tr(),
                          textSize: 14,
                          fontWeightIndex: FontSelectionData.mediumFontFamily,
                          textColor: AppColors.darkGreyColor,
                        ),
                      ],
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
                    constraints: const BoxConstraints(minWidth: 800),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        AppColors.scaffoldColor,
                      ),
                      dataRowMinHeight: 48,
                      dataRowMaxHeight: 64,
                      columns: [
                        DataColumn(
                          label: TextInAppWidget(
                            text: LocaleKeys.settlementNumber.tr(),
                            textSize: 13,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                            textColor: AppColors.darkColor,
                          ),
                        ),
                        DataColumn(
                          label: TextInAppWidget(
                            text: LocaleKeys.settlementDate.tr(),
                            textSize: 13,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                            textColor: AppColors.darkColor,
                          ),
                        ),
                        DataColumn(
                          label: TextInAppWidget(
                            text: LocaleKeys.settlementAmount.tr(),
                            textSize: 13,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                            textColor: AppColors.darkColor,
                          ),
                        ),
                        DataColumn(
                          label: TextInAppWidget(
                            text: LocaleKeys.iban.tr(),
                            textSize: 13,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                            textColor: AppColors.darkColor,
                          ),
                        ),
                        DataColumn(
                          label: TextInAppWidget(
                            text: LocaleKeys.settlementPeriod.tr(),
                            textSize: 13,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                            textColor: AppColors.darkColor,
                          ),
                        ),
                        DataColumn(
                          label: TextInAppWidget(
                            text: LocaleKeys.notes.tr(),
                            textSize: 13,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                            textColor: AppColors.darkColor,
                          ),
                        ),
                        DataColumn(
                          label: TextInAppWidget(
                            text: LocaleKeys.status.tr(),
                            textSize: 13,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                            textColor: AppColors.darkColor,
                          ),
                        ),
                      ],
                      rows: settlements.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(
                              TextInAppWidget(
                                text: '#${item.id}',
                                textSize: 13,
                                fontWeightIndex:
                                    FontSelectionData.boldFontFamily,
                                textColor: AppColors.orangeColor,
                              ),
                            ),
                            DataCell(
                              TextInAppWidget(
                                text: item.date != null
                                    ? OrderFunctions.formatDateFromDateTime(
                                        item.date)
                                    : '-',
                                textSize: 12,
                                textColor: AppColors.darkColor,
                              ),
                            ),
                            DataCell(
                              TextInAppWidget(
                                text:
                                    '${item.amount.toStringAsFixed(2)} ${LocaleKeys.sarCurrency.tr()}',
                                textSize: 13,
                                fontWeightIndex:
                                    FontSelectionData.boldFontFamily,
                                textColor: AppColors.greenColor,
                              ),
                            ),
                            DataCell(
                              TextInAppWidget(
                                text: item.iban.isNotEmpty ? item.iban : '-',
                                textSize: 12,
                                textColor: AppColors.darkGreyColor,
                              ),
                            ),
                            DataCell(
                              TextInAppWidget(
                                text:
                                    _formatPeriod(item.startDate, item.endDate),
                                textSize: 12,
                                textColor: AppColors.darkColor,
                              ),
                            ),
                            DataCell(
                              TextInAppWidget(
                                text:
                                    item.notes != null && item.notes!.isNotEmpty
                                        ? item.notes!
                                        : '-',
                                textSize: 12,
                                textColor: AppColors.darkGreyColor,
                              ),
                            ),
                            DataCell(
                              SettlementStatusBadge(status: item.status),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatPeriod(DateTime? start, DateTime? end) {
    if (start == null && end == null) return LocaleKeys.allCompletedOrders.tr();
    final s = start != null
        ? OrderFunctions.formatDateFromDateTime(start)
        : LocaleKeys.startPeriod.tr();
    final e = end != null
        ? OrderFunctions.formatDateFromDateTime(end)
        : LocaleKeys.now.tr();
    return '$s - $e';
  }
}

class SettlementStatusBadge extends StatelessWidget {
  final int status;

  const SettlementStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case 1:
      case 2:
        bg = AppColors.greenColor.withValues(alpha: 0.12);
        fg = AppColors.greenColor;
        label = LocaleKeys.statusCompleted.tr();
        break;
      case 0:
        bg = AppColors.amberColor.withValues(alpha: 0.15);
        fg = AppColors.amberColor;
        label = LocaleKeys.statusUnderProcessing.tr();
        break;
      default:
        bg = AppColors.greenColor.withValues(alpha: 0.12);
        fg = AppColors.greenColor;
        label = LocaleKeys.statusCompleted.tr();
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextInAppWidget(
        text: label,
        textSize: 11,
        fontWeightIndex: FontSelectionData.boldFontFamily,
        textColor: fg,
      ),
    );
  }
}
