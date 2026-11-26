import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/accounts_management_page/presentation/pages/details_user_accounts_management/screens/all_profits_from_packages_list/all_profits_from_packages_list.dart';
import 'package:web_admin_san/feature/accounts_management_page/presentation/pages/details_user_accounts_management/screens/number_of_transaction_list/number_of_transaction_list.dart';
import 'package:web_admin_san/feature/accounts_management_page/presentation/widgets/finance_header_bar.dart';
import 'package:web_admin_san/feature/accounts_management_page/presentation/widgets/financial_kpi_grid.dart';
import 'package:web_admin_san/feature/accounts_management_page/presentation/widgets/provider_settlements_section.dart';
import 'package:web_admin_san/feature/accounts_management_page/presentation/widgets/start_settlement_dialog.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/provider_balances_cubit/provider_balances_cubit.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/settlement_cubit/settlement_cubit.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/wallet_balance_cubit/wallet_balance_cubit.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/wallet_balance_cubit/wallet_balance_state.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/provider_details_request.dart';

class ListDataDetailsUserAccountsManagement extends StatefulWidget {
  final ProviderDetailsRequest providerDetailsRequest;

  const ListDataDetailsUserAccountsManagement({
    super.key,
    required this.providerDetailsRequest,
  });

  @override
  State<ListDataDetailsUserAccountsManagement> createState() =>
      _ListDataDetailsUserAccountsManagementState();
}

class _ListDataDetailsUserAccountsManagementState
    extends State<ListDataDetailsUserAccountsManagement> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openStartSettlementDialog(BuildContext context) {
    final walletState = context.read<WalletBalanceCubit>().state;
    final currentBalance =
        walletState is WalletBalanceSuccess ? walletState.balance : 0.0;

    final providerId = widget.providerDetailsRequest.id ?? 0;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<SettlementCubit>()),
          BlocProvider.value(value: context.read<ProviderBalanceCubit>()),
          BlocProvider.value(value: context.read<WalletBalanceCubit>()),
        ],
        child: StartSettlementDialog(
          providerDetailsRequest: widget.providerDetailsRequest,
          currentBalance: currentBalance,
          onSettlementCompleted: () {
            context.read<ProviderBalanceCubit>().getBalanceDetails(
                  providerDetailsRequest: widget.providerDetailsRequest,
                );
            context.read<WalletBalanceCubit>().getWalletBalance(
                  providerDetailsRequest: widget.providerDetailsRequest,
                );
            context.read<SettlementCubit>().loadProviderSettlements(
                  providerId: providerId,
                );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final providerId = widget.providerDetailsRequest.id ?? 0;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProviderBalanceCubit()
            ..getBalanceDetails(
              providerDetailsRequest: widget.providerDetailsRequest,
            ),
        ),
        BlocProvider(
          create: (_) => WalletBalanceCubit()
            ..getWalletBalance(
              providerDetailsRequest: widget.providerDetailsRequest,
            ),
        ),
        BlocProvider(
          create: (_) => SettlementCubit()
            ..loadProviderSettlements(
              providerId: providerId,
            ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Header Bar with Provider Info & "Start Settlement" action
                  FinanceHeaderBar(
                    providerDetailsRequest: widget.providerDetailsRequest,
                    onStartSettlement: () =>
                        _openStartSettlementDialog(context),
                  ),
                  const SizedBox(height: 20),

                  // 2. Financial KPI Grid (Net Wallet, Total, Cash on Delivery, Electronic)
                  const FinancialKpiGrid(),
                  const SizedBox(height: 20),

                  // 3. New Section: Provider Settlement History Table
                  ProviderSettlementsSection(providerId: providerId),
                  const SizedBox(height: 20),

                  // 4. Subscription Package Section
                  AllProfitsFromPackagesList(
                    providerDetailsRequest: widget.providerDetailsRequest,
                  ),
                  const SizedBox(height: 20),

                  // 5. Recent Invoices & Orders Transactions Table
                  const NumberOfTransactionList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
