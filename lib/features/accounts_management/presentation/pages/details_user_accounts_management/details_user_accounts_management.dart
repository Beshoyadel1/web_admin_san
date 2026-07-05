import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/features/accounts_management/presentation/pages/details_user_accounts_management/screens/container_details_user_accounts_management.dart';
import 'package:web_admin_san/features/auth_page/data/model/create_user_model/provider_details_request.dart';
import 'package:web_admin_san/features/providers/data/model/get_all_providers_models/get_all_providers_models/get_all_providers_models.dart';
import '../../../../../core/theming/colors.dart';


class DetailsUserAccountsManagement extends StatelessWidget {
  final GetAllProvidersModels providerDetailsRequest;
  const DetailsUserAccountsManagement({super.key,required this.providerDetailsRequest});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: ContainerDetailsUserAccountsManagement(
                      providerDetailsRequest: providerDetailsRequest,
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
