
import 'package:web_admin_san/features/providers/data/model/facility_provider_model/facility_model_provider/facility_model_provider.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/facility_provider_cubit/facility_tab_provider_cubit/facility_tab_provider_cubit.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/facility_provider_cubit/facility_tab_provider_cubit/facility_tab_provider_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/pages_widgets/general_widgets/custom_container.dart';

class TabsWidgetDetailsCompanies extends StatelessWidget {
  final int companyId;

  const TabsWidgetDetailsCompanies({
    super.key,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = facilityTabsCompany(companyId);

    return BlocBuilder<FacilityTabProviderCubit, FacilityTabProviderState>(
      builder: (context, state) {
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(
            tabs.length,
                (index) {

              final isSelected =
                  context.read<FacilityTabProviderCubit>().selectedIndex == index;

              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: CustomContainer(
                  isSelected: isSelected,
                  onTap: () => context
                      .read<FacilityTabProviderCubit>()
                      .selectTab(index),
                  text: tabs[index].title,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  containerColor: isSelected
                      ? AppColors.orangeColor
                      : AppColors.greyColor,
                  border: const Border(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}