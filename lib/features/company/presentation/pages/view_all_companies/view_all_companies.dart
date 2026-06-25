import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/bloc/get_harage_providers_cubit/get_harage_providers_cubit.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/ui/view_car_harag/screens/list_view_car_harag.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_all_companies_cubit/get_all_companies_cubit.dart';
import 'package:web_admin_san/features/company/presentation/pages/view_all_companies/list_view_all_companies.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/get_all_providers_cubit/get_all_providers_cubit.dart';
import 'package:web_admin_san/features/providers/presentation/pages/view_all_providers/screens/list_data_view_all_provider.dart';
import 'package:web_admin_san/features/rates/presentation/bloc/providers_rate_cubit/providers_rate_cubit.dart';
import 'package:web_admin_san/features/users/presentation/bloc/get_all_users_cubit/get_all_users_cubit.dart';
import 'package:web_admin_san/features/users/presentation/pages/view_all_users/screens/list_data_view_all_users.dart';
import '../../../../../../core/theming/colors.dart';

class ViewAllCompanies extends StatelessWidget {
  const ViewAllCompanies({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocProvider(
            create: (_) => GetAllCompaniesCubit()
              ..getAllCompanies(currentPage: 1),
            child: const ListViewAllCompanies(),
          ),
        ),
      ),
    );
  }
}
