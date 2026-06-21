import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/providers/data/model/facility_provider_model/facility_model_provider/facility_model_provider.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/facility_provider_cubit/facility_tab_provider_cubit/facility_tab_provider_cubit.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/facility_provider_cubit/facility_tab_provider_cubit/facility_tab_provider_state.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/tabs_widget_provider.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/pages_widgets/general_widgets/custom_container.dart';


class PageDetailsProvider extends StatelessWidget {
  final int providerID;
  const PageDetailsProvider({super.key,required this.providerID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: AppColors.scaffoldColor,
      body: BlocProvider(
        create: (context) => FacilityTabProviderCubit(),
        child: BlocBuilder<FacilityTabProviderCubit, FacilityTabProviderState>(
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
                      border: const Border(
                        top: BorderSide(color: AppColors.lightGreyColor),
                        left: BorderSide(color: AppColors.lightGreyColor),
                        right: BorderSide(color: AppColors.lightGreyColor),
                      ),
                      // borderRadius: const BorderRadius.only(
                      //   topLeft: Radius.circular(10),
                      //   topRight: Radius.circular(10),
                      // ),
                      typeWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           TabsWidgetProvider(
                            providerID: providerID,
                          ),
                          const SizedBox(height: 30),
                          facilityTabsProviders(providerID)[
                          context.read<FacilityTabProviderCubit>().selectedIndex
                          ].content,
                        ],
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
