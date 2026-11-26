import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/accounts_management_page/data/model/get_provider_balance_details_model/provider_balance_details_model.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/provider_balances_cubit/provider_balances_cubit.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/provider_balances_cubit/provider_balances_state.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/wallet_balance_cubit/wallet_balance_cubit.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/wallet_balance_cubit/wallet_balance_state.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class FinancialKpiGrid extends StatelessWidget {
  const FinancialKpiGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderBalanceCubit, ProviderBalanceState>(
      builder: (context, balanceState) {
        ProviderBalanceDetailsModel? detailsModel;
        if (balanceState is ProviderBalanceSuccess) {
          detailsModel = balanceState.model;
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;
            final isTablet =
                constraints.maxWidth >= 550 && constraints.maxWidth < 900;

            final totalBalance = detailsModel?.totalBalance ?? 0.0;
            final cashBalance = detailsModel?.cashBalance ?? 0.0;
            final electronicBalance = detailsModel?.electronicBalance ?? 0.0;

            final cards = [
              // 1. Net Wallet Balance
              BlocBuilder<WalletBalanceCubit, WalletBalanceState>(
                builder: (context, walletState) {
                  final walletBalance = walletState is WalletBalanceSuccess
                      ? walletState.balance
                      : 0.0;
                  final isLoading = walletState is WalletBalanceLoading;

                  return FinancialCardItem(
                    title: LocaleKeys.netBalance.tr(),
                    amount:
                        isLoading ? '...' : walletBalance.toStringAsFixed(2),
                    icon: Icons.account_balance_wallet_rounded,
                    iconBgColor: AppColors.orangeColor.withValues(alpha: 0.12),
                    iconColor: AppColors.orangeColor,
                    subtitle: 'رصيد المحفظة الحالي',
                    isHighlighted: true,
                  );
                },
              ),

              // 2. Total Balance
              FinancialCardItem(
                title: LocaleKeys.allPayments.tr(),
                amount: totalBalance.toStringAsFixed(2),
                icon: Icons.payments_outlined,
                iconBgColor: AppColors.darkColor.withValues(alpha: 0.08),
                iconColor: AppColors.darkColor,
                subtitle: 'إجمالي قيمة جميع الطلبات',
              ),

              // 3. Cash on Delivery
              FinancialCardItem(
                title: LocaleKeys.cashOnDeliveryPayments.tr(),
                amount: cashBalance.toStringAsFixed(2),
                icon: Icons.point_of_sale_outlined,
                iconBgColor: AppColors.amberColor.withValues(alpha: 0.15),
                iconColor: AppColors.amberColor,
                subtitle: 'مقبوضات المزود نقداً باليد',
              ),

              // 4. Electronic Payments
              FinancialCardItem(
                title: LocaleKeys.cardPayments.tr(),
                amount: electronicBalance.toStringAsFixed(2),
                icon: Icons.credit_card_outlined,
                iconBgColor: AppColors.lightOrangeColor.withValues(alpha: 0.25),
                iconColor: AppColors.orangeColor,
                subtitle: 'المدفوعات الإلكترونية عبر التطبيق',
              ),
            ];

            if (isDesktop) {
              return Row(
                children: cards
                    .map((c) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: c,
                          ),
                        ))
                    .toList(),
              );
            }

            if (isTablet) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: cards[0]),
                      const SizedBox(width: 12),
                      Expanded(child: cards[1]),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: cards[2]),
                      const SizedBox(width: 12),
                      Expanded(child: cards[3]),
                    ],
                  ),
                ],
              );
            }

            return Column(
              children: cards
                  .map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: c,
                      ))
                  .toList(),
            );
          },
        );
      },
    );
  }
}

class FinancialCardItem extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String subtitle;
  final bool isHighlighted;

  const FinancialCardItem({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.subtitle,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted
              ? AppColors.orangeColor.withValues(alpha: 0.5)
              : AppColors.cardStroke,
          width: isHighlighted ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isHighlighted
                ? AppColors.orangeColor.withValues(alpha: 0.06)
                : AppColors.blackColor.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              Image.asset(
                AppImageKeys.coin,
                width: 20,
                height: 20,
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextInAppWidget(
            text: title,
            textSize: 13,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
            textColor: AppColors.darkGreyColor,
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              TextInAppWidget(
                text: amount,
                textSize: 22,
                fontWeightIndex: FontSelectionData.boldFontFamily,
                textColor:
                    isHighlighted ? AppColors.orangeColor : AppColors.darkColor,
              ),
              const SizedBox(width: 4),
              const TextInAppWidget(
                text: 'ر.س',
                textSize: 12,
                fontWeightIndex: FontSelectionData.mediumFontFamily,
                textColor: AppColors.darkGreyColor,
              ),
            ],
          ),
          const SizedBox(height: 4),
          TextInAppWidget(
            text: subtitle,
            textSize: 11,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.greyColor,
          ),
        ],
      ),
    );
  }
}
