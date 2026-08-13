import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/theming/colors.dart';

import 'package:web_admin_san/features/approved_centers/presentation/bloc/get_approved_providers_cubit/get_approved_providers_cubit.dart';

import 'package:web_admin_san/features/approved_centers/presentation/pages/view_all_approved_centers/screens/list_data_view_all_approved_centers.dart';

class ViewAllApprovedCenters extends StatelessWidget {
  const ViewAllApprovedCenters({super.key});

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
                    await context
                        .read<GetApprovedProvidersCubit>()
                        .refresh();
                  },
                  child:
                  const ListDataViewAllApprovedCenters(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}