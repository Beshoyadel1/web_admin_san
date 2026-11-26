import 'package:flutter/material.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_provider_total_rate_and_employee_and_balance_model/get_provider_total_rate_and_employee_and_balance_model.dart';
import 'provider_account_balance_card.dart';
import 'provider_rating_card.dart';
import 'provider_top_employees_card.dart';

class ProviderBottomColumnsGrid extends StatelessWidget {
  final double averageRate;
  final List<TopEmployee> topEmployees;
  final double totalBalance;
  final List<AccountBalance> accountsBalance;

  const ProviderBottomColumnsGrid({
    super.key,
    required this.averageRate,
    required this.topEmployees,
    required this.totalBalance,
    required this.accountsBalance,
  });

  @override
  Widget build(BuildContext context) {
    final ratingCard = ProviderRatingCard(
      averageRate: averageRate,
    );

    final topEmployeesCard = ProviderTopEmployeesCard(
      topEmployees: topEmployees,
    );

    final balanceCard = ProviderAccountBalanceCard(
      totalBalance: totalBalance,
      accountsBalance: accountsBalance,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= 850) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rating + Top Employees Column
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    ratingCard,
                    const SizedBox(height: 14),
                    topEmployeesCard,
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Account Balance Column
              Expanded(
                flex: 5,
                child: balanceCard,
              ),
            ],
          );
        } else {
          return Column(
            children: [
              ratingCard,
              const SizedBox(height: 14),
              topEmployeesCard,
              const SizedBox(height: 14),
              balanceCard,
            ],
          );
        }
      },
    );
  }
}
