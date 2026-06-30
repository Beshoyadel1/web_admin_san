import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_all_companies_cubit/get_all_companies_cubit.dart';
import 'package:web_admin_san/features/company/presentation/pages/view_all_companies/list_view_all_companies.dart';
import '../../../../../../core/theming/colors.dart';

class ViewAllCompanies extends StatelessWidget {
  const ViewAllCompanies({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocProvider(
            create: (_) => GetAllCompaniesCubit()
              ..getAllCompanies(currentPage: 1),
            child: Builder(
              builder: (context) {
                return RefreshIndicator(
                  color: AppColors.orangeColor,
                  onRefresh: () async {
                    await context.read<GetAllCompaniesCubit>()
                        .getAllCompanies(currentPage: 1);
                  },
                  child: const ListViewAllCompanies(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
