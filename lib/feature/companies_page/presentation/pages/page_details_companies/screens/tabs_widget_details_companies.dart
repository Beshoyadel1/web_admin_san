import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/providers_page/data/model/facility_provider_model/facility_model_provider/facility_model_provider.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/facility_tab_provider_cubit/facility_tab_provider_cubit.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/facility_tab_provider_cubit/facility_tab_provider_state.dart';

class TabsWidgetDetailsCompanies extends StatelessWidget {
  final int? companyId;

  const TabsWidgetDetailsCompanies({
    super.key,
    this.companyId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FacilityTabProviderCubit, FacilityTabProviderState>(
      buildWhen: (previous, current) => current is ChangeIndexState,
      builder: (context, state) {
        final selectedIndex =
            context.read<FacilityTabProviderCubit>().selectedIndex;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(
            companyTabTitles.length,
            (index) {
              final isSelected = selectedIndex == index;

              return ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 160),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => context
                        .read<FacilityTabProviderCubit>()
                        .selectTab(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.orangeColor
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.orangeColor
                              : AppColors.lightGreyColor,
                        ),
                      ),
                      child: Text(
                        companyTabTitles[index].tr(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.whiteColor
                              : AppColors.darkGreyColor,
                        ),
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
