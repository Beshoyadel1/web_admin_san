import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/companies_page/view_model/get_all_companies_cubit/get_all_companies_cubit.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/view_all_companies/list_view_all_companies.dart';

import '../../../../../../core/helpers/colors/app_colors.dart';

class CompaniesPage extends StatelessWidget {
  const CompaniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocProvider(
            create: (_) =>
                GetAllCompaniesCubit()..getAllCompanies(currentPage: 1),
            child: Builder(
              builder: (context) {
                return RefreshIndicator(
                  color: AppColors.orangeColor,
                  onRefresh: () async {
                    await context
                        .read<GetAllCompaniesCubit>()
                        .getAllCompanies(currentPage: 1);
                  },
                  child: const ListCompaniesPage(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
