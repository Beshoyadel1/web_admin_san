import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/rates/data/model/get_providers_basic_rate_models/get_providers_basic_rate_models.dart';
import 'package:web_admin_san/features/rates/presentation/bloc/service_settings_cubit/service_settings_cubit.dart';
import 'package:web_admin_san/features/rates/presentation/pages/view_all_service_rates/screens/first_title_in_view_all_service_rate.dart';
import 'package:web_admin_san/features/rates/presentation/pages/view_all_service_rates/screens/tab_data_design_rate_service.dart';

class ListDataViewAllServiceRates extends StatelessWidget {
  final ProviderModel providerModel;
  const ListDataViewAllServiceRates({super.key,required this.providerModel});

  @override
  Widget build(BuildContext context) {
    return  Column(
      spacing: 30,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FirstTitleInViewAllServiceRate(),
        BlocProvider(
          create: (_) => ServiceSettingsCubit()..getChildServices(),
          child: TabDataDesignRateService(
              providerModel:providerModel
          ),
        ),
      ],
    );
  }
}