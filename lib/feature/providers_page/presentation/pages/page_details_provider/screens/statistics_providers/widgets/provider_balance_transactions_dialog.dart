import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_provider_total_rate_and_employee_and_balance_model/get_provider_total_rate_and_employee_and_balance_model.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class ProviderBalanceTransactionsDialog extends StatelessWidget {
  final double totalBalance;
  final List<AccountBalance> accountsBalance;

  const ProviderBalanceTransactionsDialog({
    super.key,
    required this.totalBalance,
    required this.accountsBalance,
  });

  IconData _getServiceIcon(String? serviceName) {
    final name = (serviceName ?? '').toLowerCase();
    if (name.contains('صيان') || name.contains('repair')) {
      return Icons.build_rounded;
    } else if (name.contains('زيت') || name.contains('oil')) {
      return Icons.local_gas_station_rounded;
    } else if (name.contains('غيار') || name.contains('spare')) {
      return Icons.settings_suggest_rounded;
    }
    return Icons.handyman_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.whiteColor,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.accountBalanceDetails.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkColor,
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Total Summary Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.orangeColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.orangeColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.totalBalance.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkColor,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          totalBalance.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.orangeColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Image.asset(
                          AppImageKeys.coin,
                          width: 15,
                          height: 15,
                          color: AppColors.orangeColor,
                          colorBlendMode: BlendMode.srcIn,
                          errorBuilder: (_, __, ___) => Text(
                            LocaleKeys.sarCurrency.tr(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.orangeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Text(
                LocaleKeys.recentTransactions.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreyColor,
                ),
              ),

              const SizedBox(height: 8),

              // List of transactions
              Flexible(
                child: accountsBalance.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Text(
                            LocaleKeys.noRecordedBalanceTransactions.tr(),
                            style: const TextStyle(
                              color: AppColors.darkGreyColor,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                    : Scrollbar(
                        thumbVisibility: true,
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: accountsBalance.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final item = accountsBalance[index];
                            final icon = _getServiceIcon(item.getName(context));

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.cardStroke),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Amount
                                  Text(
                                    '+${(item.amount ?? 0).toStringAsFixed(2)} ${LocaleKeys.sarCurrency.tr()}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.greenColor,
                                    ),
                                  ),

                                  // Details & Icon
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            item.getName(context).isNotEmpty
                                                ? item.getName(context)
                                                : LocaleKeys.serviceDefault
                                                    .tr(),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.orangeColor,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${LocaleKeys.revenueFromOrder.tr()} ${item.recentOrderId ?? 0}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: AppColors.darkGreyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 8),
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppColors.orangeColor
                                            .withValues(alpha: 0.1),
                                        child: Icon(
                                          icon,
                                          size: 16,
                                          color: AppColors.orangeColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
