import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/widgets/navigate_to_page_widget.dart';

import 'package:web_admin_san/feature/admins_page/view_model/admins_cubit/admins_cubit.dart';
import 'package:web_admin_san/feature/admins_page/presentation/pages/create_admin_page/create_admin_page.dart';
import 'package:web_admin_san/feature/admins_page/presentation/pages/view_all_admins/screens/list_data_view_all_admins.dart';

import '../../../../../../core/helpers/colors/app_colors.dart';

class AdminsPage extends StatelessWidget {
  const AdminsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminsCubit()
        ..getAllAdmins(
          currentPage: 1,
        ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: RefreshIndicator(
                  color: AppColors.orangeColor,
                  onRefresh: () async {
                    await context.read<AdminsCubit>().getAllAdmins(
                          currentPage: 1,
                        );
                  },
                  child: const ListDataAdminsPage(),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.orangeColor,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  NavigateToPageWidget(
                    const CreateAdminPage(),
                  ),
                );

                if (result == true && context.mounted) {
                  await context.read<AdminsCubit>().getAllAdmins(
                        currentPage: 1,
                      );
                }
              },
              child: const Icon(
                Icons.add,
                color: AppColors.whiteColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
