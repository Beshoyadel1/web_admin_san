import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_company_cars_with_drivers_cubit/get_company_cars_with_drivers_cubit.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_company_cars_with_drivers_cubit/get_company_cars_with_drivers_state.dart';
import 'package:web_admin_san/features/company/presentation/custom_widget/widget_design_list_car_company.dart';

class CarsCompanies extends StatelessWidget {
  final int companyId;

  const CarsCompanies({
    super.key,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<GetCompanyCarsWithDriversCubit,
          GetCompanyCarsWithDriversState>(
        builder: (context, state) {
          if (state is GetCompanyCarsWithDriversLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is GetCompanyCarsWithDriversFailure) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is GetCompanyCarsWithDriversSuccess) {
            final employeeCars =
                state.model.cars.where((e) => e.isHasDriver).toList();

            final salesCars =
                state.model.cars.where((e) => !e.isHasDriver).toList();

            final isMobile = MediaQuery.of(context).size.width < 700;

            return SingleChildScrollView(
              child: isMobile
                  ? Column(
                spacing: 10,
                      children: [
                        WidgetDesignListCarCompany(
                          isHasDriver: true,
                          cars: employeeCars,
                        ),
                        const SizedBox(height: 10),
                        WidgetDesignListCarCompany(
                          isHasDriver: false,
                          cars: salesCars,
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: WidgetDesignListCarCompany(
                            isHasDriver: true,
                            cars: employeeCars,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: WidgetDesignListCarCompany(
                            isHasDriver: false,
                            cars: salesCars,
                          ),
                        ),
                      ],
                    ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
