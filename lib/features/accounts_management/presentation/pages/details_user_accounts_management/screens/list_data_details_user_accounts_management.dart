import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/accounts_management/presentation/pages/details_user_accounts_management/screens/account_balance.dart';
import 'package:web_admin_san/features/accounts_management/presentation/pages/details_user_accounts_management/screens/all_profits_from_packages_list/all_profits_from_packages_list.dart';
import 'package:web_admin_san/features/accounts_management/presentation/pages/details_user_accounts_management/screens/number_of_transaction_list/number_of_transaction_list.dart';
import 'package:web_admin_san/features/accounts_management/presentation/pages/details_user_accounts_management/screens/part_of_list_container_all_profit_from_package_list.dart';
import 'package:web_admin_san/features/auth_page/data/model/create_user_model/provider_details_request.dart';
import '../../../../../../features/accounts_management/presentation/bloc/provider_balances_cubit/provider_balances_cubit.dart';

class ListDataDetailsUserAccountsManagement extends StatelessWidget {
  final ProviderDetailsRequest providerDetailsRequest;
  const ListDataDetailsUserAccountsManagement({super.key,required this.providerDetailsRequest});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProviderBalanceCubit()..getBalanceDetails(
        providerDetailsRequest: providerDetailsRequest
      ),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 30,
        children: [
          AccountBalance(
            providerDetailsRequest: providerDetailsRequest,
          ),
          const PartOfListContainerInFirstScreenAccountsManagementAdminSun(),
          AllProfitsFromPackagesList(
            providerDetailsRequest: providerDetailsRequest,
          ),
           const  NumberOfTransactionList()
        ],
      ),
    );
  }
}
