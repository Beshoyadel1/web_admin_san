import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/branches_providers/screens/add_branch_ui.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/branches_providers/screens/branches_added_ui.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/branch_cubit/branch_cubit.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/branch_cubit/branch_state.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/location_provider_cubit/location_provider_cubit.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class BranchesProviders extends StatelessWidget {
  final int providerID;

  const BranchesProviders({
    super.key,
    required this.providerID,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocationProviderCubit(),
      child: Builder(
        builder: (context) {
          return RefreshIndicator(
            color: AppColors.orangeColor,
            onRefresh: () async {
              await context.read<BranchCubit>().getProviderBranches(
                    providerId: providerID,
                  );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              child: BlocBuilder<BranchCubit, BranchState>(
                builder: (context, state) {
                  if (state is BranchLoading) {
                    return const SizedBox(
                      height: 400,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.orangeColor,
                        ),
                      ),
                    );
                  }

                  if (state is BranchError) {
                    return SizedBox(
                      height: 400,
                      child: Center(
                        child: BranchesErrorWidget(
                          message: state.message,
                          onRetry: () {
                            context.read<BranchCubit>().getProviderBranches(
                                  providerId: providerID,
                                );
                          },
                        ),
                      ),
                    );
                  }

                  if (state is BranchSuccess) {
                    return state.isAdding
                        ? AddBranchUI(
                            providerId: providerID,
                          )
                        : BranchesAddedUi(
                            state: state,
                            providerId: providerID,
                          );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class BranchesErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const BranchesErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.error_outline_rounded,
          size: 48,
          color: AppColors.redColor,
        ),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.darkColor,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: onRetry,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orangeColor,
            foregroundColor: AppColors.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: Text(LocaleKeys.retry.tr()),
        ),
      ],
    );
  }
}
