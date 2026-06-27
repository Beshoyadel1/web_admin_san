import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_driver_details_cubit/get_driver_details_cubit.dart';
import 'package:web_admin_san/features/company/presentation/custom_widget/widget_design_list_drivers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_company_drivers_cubit/get_company_drivers_cubit.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_company_drivers_cubit/get_company_drivers_state.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/drivers_companies/driver_details_page.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';

class DriversCompanies extends StatelessWidget {
  const DriversCompanies({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCompanyDriversCubit, GetCompanyDriversState>(
      builder: (context, state) {
        if (state is GetCompanyDriversLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is GetCompanyDriversFailure) {
          return Center(
            child: Text(state.error),
          );
        }

        if (state is GetCompanyDriversSuccess) {
          final drivers = state.data.drivers;

          if (drivers.isEmpty) {
            return const TextEmptyViewData();
          }

          final isArabic =
              Directionality.of(context) == TextDirection.rtl;

          return SingleChildScrollView(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                drivers.length,
                    (index) {
                  final driver = drivers[index];

                  final brandName = isArabic
                      ? (driver.car?.brandName ?? "")
                      : (driver.car?.brandLatinName ?? "");

                  return WidgetDesignListDrivers(
                    id: driver.id.toString(),
                    name: driver.name,
                    phone: driver.phone,
                    email: driver.email,
                    imageUser: driver.image,
                    imageBrand: driver.car?.image,
                    plateNo: driver.car?.plateNo,
                    nameBrandModel:
                    "$brandName - ${driver.car?.modelName ?? ""}",
                    onTabDetails: () {
                      Navigator.push(
                        context,
                        NavigateToPageWidget(
                          BlocProvider(
                            create: (_) => GetDriverDetailsCubit()
                              ..getDriverDetails(driverId: driver.id),
                            child: const DriverDetailsPage(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}