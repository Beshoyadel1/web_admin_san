import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/packages_page/presentation/pages/create_package_page/create_package_page.dart';
import 'package:web_admin_san/feature/packages_page/presentation/pages/view_all_packages/list_view_all_packages.dart';
import 'package:web_admin_san/feature/packages_page/view_model/packages_cubit/packages_cubit.dart';

class PackagesPage extends StatelessWidget {
  const PackagesPage({super.key});

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
                    await context.read<PackagesCubit>().getPackages();
                  },
                  child: const ListPackagesPage(),
                ),
              ),
            ),
            floatingActionButton: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FloatingActionButton(
                backgroundColor: AppColors.orangeColor,
                onPressed: () async {
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<PackagesCubit>(),
                        child: const CreatePackagePage(),
                      ),
                    ),
                  );

                  if (result == true && context.mounted) {
                    await context.read<PackagesCubit>().getPackages();
                  }
                },
                child: const Icon(
                  Icons.add,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
