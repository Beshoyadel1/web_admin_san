import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/helpers/colors/app_colors.dart';

import 'package:web_admin_san/feature/approved_centers_page/view_model/get_approved_providers_cubit/get_approved_providers_cubit.dart';

import 'package:web_admin_san/feature/approved_centers_page/presentation/pages/view_all_approved_centers/screens/list_data_view_all_approved_centers.dart';

class ApprovedCentersPage extends StatelessWidget {
  const ApprovedCentersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocProvider(
            create: (_) => GetApprovedProvidersCubit()
              ..getApprovedProviders(
                pageNumber: 1,
              ),
            child: Builder(
              builder: (context) {
                return RefreshIndicator(
                  color: AppColors.orangeColor,
                  onRefresh: () async {
                    await context.read<GetApprovedProvidersCubit>().refresh();
                  },
                  child: const ListDataApprovedCentersPage(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
