import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/features/rates/data/model/get_providers_basic_rate_models/get_providers_basic_rate_models.dart';
import 'package:web_admin_san/features/rates/presentation/pages/view_all_service_rates/screens/list_data_view_all_service_rates.dart';
import '../../../../../../core/theming/colors.dart';

class ViewAllServiceRates extends StatelessWidget {
  final ProviderModel providerModel;
  const ViewAllServiceRates({super.key,required this.providerModel});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: ListDataViewAllServiceRates(
                providerModel:providerModel
            ),
          ),
        ),
      ),
    );
  }
}
