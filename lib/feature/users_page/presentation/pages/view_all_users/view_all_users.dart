import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/users_page/view_model/get_all_users_cubit/get_all_users_cubit.dart';
import 'package:web_admin_san/feature/users_page/presentation/pages/view_all_users/screens/list_data_view_all_users.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocProvider(
            create: (_) => GetAllUsersCubit()..getAllUsers(currentPage: 1),
            child: Builder(
              builder: (context) {
                return RefreshIndicator(
                  color: AppColors.orangeColor,
                  onRefresh: () async {
                    await context
                        .read<GetAllUsersCubit>()
                        .getAllUsers(currentPage: 1);
                  },
                  child: const ListDataUsersPage(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
