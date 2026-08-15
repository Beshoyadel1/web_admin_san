import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/packages/presentation/pages/view_all_packages/create_package_dialog.dart';
import '../../../../../../features/packages/presentation/pages/view_all_packages/list_view_all_packages.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../features/packages/presentation/bloc/packages_cubit/packages_cubit.dart';

class ViewAllPackages extends StatelessWidget {
  const ViewAllPackages({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PackagesCubit()..getPackages(),

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
                    await context
                        .read<PackagesCubit>()
                        .getPackages();
                  },
                  child: const ListViewAllPackages(),
                ),
              ),
            ),


            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.orangeColor,
             // shape: const CircleBorder(),
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (_) {
                    return BlocProvider.value(
                      value: context.read<PackagesCubit>(),
                      child: const CreatePackageDialog(),
                    );
                  },
                );

                if (result == true && context.mounted) {
                  await context
                      .read<PackagesCubit>()
                      .getPackages();
                }
              },

              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}