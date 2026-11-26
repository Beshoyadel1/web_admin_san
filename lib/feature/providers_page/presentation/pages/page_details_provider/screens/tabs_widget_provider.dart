import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/providers_page/data/model/facility_provider_model/facility_model_provider/facility_model_provider.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/facility_tab_provider_cubit/facility_tab_provider_cubit.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/facility_tab_provider_cubit/facility_tab_provider_state.dart';

class TabsWidgetProvider extends StatelessWidget {
  final int? providerID;

  const TabsWidgetProvider({
    super.key,
    this.providerID,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FacilityTabProviderCubit, FacilityTabProviderState>(
      buildWhen: (previous, current) => current is ChangeIndexState,
      builder: (context, state) {
        final selectedIndex =
            context.read<FacilityTabProviderCubit>().selectedIndex;

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            providerTabTitles.length,
            (index) {
              final isSelected = selectedIndex == index;

              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () =>
                      context.read<FacilityTabProviderCubit>().selectTab(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.orangeColor
                          : AppColors.chartGrey.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      providerTabTitles[index].tr(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
