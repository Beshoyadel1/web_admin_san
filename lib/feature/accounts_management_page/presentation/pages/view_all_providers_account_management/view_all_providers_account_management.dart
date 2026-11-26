import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/accounts_management_page/presentation/pages/view_all_providers_account_management/screens/list_data_view_all_providers_account_management.dart';
import 'package:web_admin_san/feature/auth_page/view_model/get_user_info_cubit/get_user_info_cubit.dart';
import 'package:web_admin_san/feature/providers_page/view_model/get_all_providers_cubit/get_all_providers_cubit.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';

class AccountsManagementPage extends StatelessWidget {
  const AccountsManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    GetAllProvidersCubit()..getAllProviders(currentPage: 1),
              ),
              BlocProvider(
                create: (_) => GetUserInfoCubit(),
              ),
            ],
            child: Builder(
              builder: (context) {
                return RefreshIndicator(
                  color: AppColors.orangeColor,
                  onRefresh: () async {
                    await context.read<GetAllProvidersCubit>().getAllProviders(
                          currentPage: 1,
                        );
                  },
                  child: const ListDataAccountsManagementPage(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
