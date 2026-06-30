import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/rates/data/model/get_providers_basic_rate_models/get_providers_basic_rate_models.dart';
import 'package:web_admin_san/features/rates/presentation/bloc/service_settings_cubit/service_settings_cubit.dart';
import 'package:web_admin_san/features/rates/presentation/pages/view_all_service_rates/screens/list_data_view_all_service_rates.dart';
import '../../../../../../core/theming/colors.dart';

class ViewAllServiceRates extends StatelessWidget {
  final ProviderModel providerModel;

  const ViewAllServiceRates({
    super.key,
    required this.providerModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceSettingsCubit()..getChildServices(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            appBar: AppBar(),
            body: SafeArea(
              child: RefreshIndicator(
                color: AppColors.orangeColor,
                onRefresh: () async {
                  await context
                      .read<ServiceSettingsCubit>()
                      .getChildServices();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: ListDataViewAllServiceRates(
                    providerModel: providerModel,
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