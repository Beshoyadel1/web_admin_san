import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/facility_provider_cubit/branch_cubit/branch_cubit.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/facility_provider_cubit/branch_cubit/branch_state.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/facility_provider_cubit/location_provider_cubit/location_provider_cubit.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/branches_providers/screens/add_branch_ui.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/branches_providers/screens/branches_added_ui.dart';

class BranchesProviders extends StatelessWidget {
  final int providerID;
  const BranchesProviders({super.key,required this.providerID});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocationProviderCubit(),
      child: BlocBuilder<BranchCubit, BranchState>(
        builder: (context, state) {
          if (state is BranchLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BranchError) {
            return Center(child: Text(state.message));
          }

          if (state is BranchSuccess) {
            return state.isAdding
                ?  AddBranchUI(
              providerId:providerID ,
            )
                : BranchesAddedUi(state:state,providerId: providerID,);
          }

          return const SizedBox();
        },
      ),
    );
  }
}
