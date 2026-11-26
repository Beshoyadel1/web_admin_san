import 'package:flutter/material.dart';
import 'package:web_admin_san/feature/accounts_management_page/presentation/pages/details_user_accounts_management/screens/list_data_details_user_accounts_management.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/provider_details_request.dart';
import '../../../../../core/helpers/colors/app_colors.dart';

class DetailsUserAccountsManagement extends StatelessWidget {
  final ProviderDetailsRequest providerDetailsRequest;

  const DetailsUserAccountsManagement({
    super.key,
    required this.providerDetailsRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ListDataDetailsUserAccountsManagement(
            providerDetailsRequest: providerDetailsRequest,
          ),
        ),
      ),
    );
  }
}
