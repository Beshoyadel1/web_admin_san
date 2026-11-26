import 'package:flutter/material.dart';
import 'package:web_admin_san/feature/accounts_management_page/presentation/pages/details_user_accounts_management/screens/list_data_details_user_accounts_management.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/provider_details_request.dart';

class ContainerDetailsUserAccountsManagement extends StatelessWidget {
  final ProviderDetailsRequest providerDetailsRequest;

  const ContainerDetailsUserAccountsManagement({
    super.key,
    required this.providerDetailsRequest,
  });

  @override
  Widget build(BuildContext context) {
    return ListDataDetailsUserAccountsManagement(
      providerDetailsRequest: providerDetailsRequest,
    );
  }
}
