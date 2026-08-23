import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';

import 'package:web_admin_san/features/admins/presentation/bloc/admins_cubit/admins_cubit.dart';
import 'package:web_admin_san/features/admins/presentation/pages/page_details_admins/page_details_admins.dart';
import 'package:web_admin_san/features/admins/presentation/pages/view_all_admins/screens/create_admin_dialog.dart';
import 'package:web_admin_san/features/admins/presentation/pages/view_all_admins/screens/list_data_view_all_admins.dart';

import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';

class ViewAllAdmins extends StatelessWidget {
  const ViewAllAdmins({
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
                  child: const ListDataViewAllAdmins(),
                ),
              ),
            ),

            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.orangeColor,

              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  NavigateToPageWidget(
                    const PageDetailsAdmin(),
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
