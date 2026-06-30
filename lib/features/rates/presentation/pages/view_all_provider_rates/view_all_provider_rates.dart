import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/rates/presentation/bloc/providers_rate_cubit/providers_rate_cubit.dart';
import 'package:web_admin_san/features/rates/presentation/pages/view_all_provider_rates/screens/list_data_view_all_provider_rate.dart';
import '../../../../../../core/theming/colors.dart';

class ViewAllProviderRates extends StatelessWidget {
  const ViewAllProviderRates({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProvidersRateCubit()..getProvidersRates(),
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
                        .read<ProvidersRateCubit>()
                        .getProvidersRates();
                  },
                  child: const SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: ListDataViewAllProviderRate(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}