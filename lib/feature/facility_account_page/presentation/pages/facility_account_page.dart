import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/facility_account_page/presentation/tabs/facility_data_content.dart';

import 'package:web_admin_san/feature/store_page/view_model/facility_cubit/facility_tab_cubit/facility_tab_cubit.dart';
import 'package:web_admin_san/feature/store_page/view_model/facility_cubit/facility_tab_cubit/facility_tab_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/widgets/custom_container.dart';

class FacilityAccountPage extends StatelessWidget {
  const FacilityAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FacilityTabCubit(),
      child: BlocBuilder<FacilityTabCubit, FacilityTabState>(
        buildWhen: (previous, current) => current is ChangeIndexState,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomContainer(
                    containerWidth: double.infinity,
                    isSelected: false,
                    typeWidget: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //  TextInAppWidget(
                        //   text: LocaleKeys.continueFacilityDataKey,
                        //   textSize: 22,
                        //   fontWeightIndex: FontSelectionData.mediumFontFamily,
                        // ),
                        //  SizedBox(height: 10),
                        FacilityDataContent()
                      ],
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
