import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_provider_total_rate_and_employee_and_balance_model/get_provider_total_rate_and_employee_and_balance_model.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'provider_balance_transactions_dialog.dart';

class ProviderAccountBalanceCard extends StatelessWidget {
  final double totalBalance;
  final List<AccountBalance> accountsBalance;

  const ProviderAccountBalanceCard({
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

  void _showTransactionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ProviderBalanceTransactionsDialog(
        totalBalance: totalBalance,
        accountsBalance: accountsBalance,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardStroke),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title and "تفاصيل" Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _showTransactionsDialog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.orangeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      LocaleKeys.details.tr(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                LocaleKeys.accountBalanceKey.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Total Balance Amount
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  totalBalance.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.orangeColor,
                  ),
                ),
                const SizedBox(width: 6),
                Image.asset(
                  AppImageKeys.coin,
                  width: 20,
                  height: 20,
                  color: AppColors.orangeColor,
                  colorBlendMode: BlendMode.srcIn,
                  errorBuilder: (_, __, ___) => Text(
                    LocaleKeys.sarCurrency.tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.orangeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Transactions List
          if (accountsBalance.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Text(
                  LocaleKeys.noBalanceTransactions.tr(),
                  style: const TextStyle(
                    color: AppColors.darkGreyColor,
                    fontSize: 12,
                  ),
                ),
              ),
            )
          else
            ...accountsBalance.take(3).map(
              (item) {
                final icon = _getServiceIcon(item.getName(context));

                return Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                      // Service info & Icon
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    item.getName(context).isNotEmpty
                                        ? item.getName(context)
                                        : LocaleKeys.serviceDefault.tr(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.orangeColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${LocaleKeys.revenueFromOrder.tr()} ${item.recentOrderId ?? 0}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.darkGreyColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 16,
                              backgroundColor:
                                  AppColors.orangeColor.withValues(alpha: 0.1),
                              child: Icon(
                                icon,
                                size: 16,
                                color: AppColors.orangeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
