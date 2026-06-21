import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/providers/presentation/pages/view_all_providers/screens/list_data_view_all_provider.dart';
import 'package:web_admin_san/features/rates/presentation/bloc/providers_rate_cubit/providers_rate_cubit.dart';
import '../../../../../../core/theming/colors.dart';

class ViewAllProvider extends StatelessWidget {
  const ViewAllProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(child: BlocProvider(
            create: (_) => ProvidersRateCubit()..getProvidersRates(),
            child: const ListDataViewAllProvider(),
          )),
        ),
      ),
    );
  }
}
