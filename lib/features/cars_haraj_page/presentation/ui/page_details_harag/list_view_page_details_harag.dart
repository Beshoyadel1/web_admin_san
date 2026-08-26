import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';
import '../../../../../../../features/cars_haraj_page/data/model/get_car_details_model/get_car_details_model.dart';
import '../../../../../../../features/cars_haraj_page/presentation/bloc/harag_cubit/harag_cubit.dart';
import '../../../../../../../features/cars_haraj_page/presentation/bloc/harag_cubit/harag_state.dart';
import '../../../../../../../features/cars_haraj_page/presentation/custom_widget/widget_design_chats_harag.dart';
import '../../../../../../../features/cars_haraj_page/presentation/custom_widget/widget_design_description_harag.dart';
import '../../../../../../../features/cars_haraj_page/presentation/custom_widget/widget_design_details_data_harag_car.dart';
import '../../../../../../../features/cars_haraj_page/presentation/custom_widget/widget_design_fuel_consumption_car.dart';
import '../../../../../../../features/cars_haraj_page/presentation/custom_widget/widget_design_images_harag.dart';
import '../../../../../../../features/cars_haraj_page/presentation/custom_widget/widget_design_recent_invoices_car.dart';
import '../../../../../../../features/cars_haraj_page/presentation/custom_widget/widget_design_service_stats_Car.dart';
import '../../../../../../../features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import '../../../../../../../core/language/language_constant.dart';

class ListViewPageDetailsHarag extends StatelessWidget {
  final int harageId;

  const ListViewPageDetailsHarag({
    super.key,
    required this.harageId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HaragCubit, HaragState>(
      builder: (context, state) {
        final cubit = context.read<HaragCubit>();

        // ==========================================================
        // LOADING
        // ==========================================================

        if (state is HaragDetailsLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // ==========================================================
        // ERROR
        // ==========================================================

        if (state is HaragDetailsError) {
          return Center(
            child: Text(
              state.message,
            ),
          );
        }

        // ==========================================================
        // GET HARAG DATA
        // ==========================================================

        final harage = cubit.harageDetailsResponse?.data;

        if (harage == null) {
          return const Center(
            child: TextEmptyViewData(),
          );
        }

        // ==========================================================
        // GET CAR DETAILS
        // ==========================================================

        final GetCarDetailsModel? carDetails =
            cubit.carDetailsResponse;

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            if (width >= 1000) {
              return _buildDesktop(
                context,
                harage,
                carDetails,
              );
            }

            return _buildMobile(
              context,
              harage,
              carDetails,
            );
          },
        );
      },
    );
  }

  // ==============================================================
  // DESKTOP
  // ==============================================================

  Widget _buildDesktop(
      BuildContext context,
      dynamic harage,
      GetCarDetailsModel? carDetails,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ==========================================================
        // HARAG DETAILS + CHAT
        // ==========================================================

        CustomContainer(isSelected: false, onTap: (){},typeWidget: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  WidgetDesignDetailsDataHaragCar(
                    harage: harage,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  WidgetDesignDescriptionHarag(
                    harage: harage,
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  WidgetDesignImagesHarag(
                    harage: harage,
                  ),
                ],
              ),
            ),

            const SizedBox(
              width: 20,
            ),

            Expanded(
              flex: 1,
              child: SizedBox(
                height: 550,
                child: WidgetDesignChatsHarag(
                  harage: harage,
                ),
              ),
            ),
          ],
        ),),

        // ==========================================================
        // CAR STATISTICS
        // ==========================================================

        if (carDetails != null) ...[
          const SizedBox(
            height: 35,
          ),

          _buildCarServicesSection(
            context,
            carDetails,
          ),
        ],
      ],
    );
  }

  // ==============================================================
  // CAR SERVICES
  // ==============================================================

  Widget _buildCarServicesSection(
      BuildContext context,
      GetCarDetailsModel carDetails,
      ) {
    return CustomContainer(
      isSelected: false,
     onTap: (){},
     typeWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TextInAppWidget(
            text: AppLanguageKeys.previousOrdersAndMaintenance,
            textSize: 20,
            fontWeightIndex: FontSelectionData.boldFontFamily,
            textAlign: TextAlign.right,
          ),

          const SizedBox(
            height: 25,
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              if (width < 850) {
                return Column(
                  children: [
                    WidgetDesignFuelConsumptionCar(
                      fuelConsumption:
                      carDetails.fuelConsumption,
                      summary: carDetails.summary,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    WidgetDesignServiceStatsCar(
                      serviceStats:
                      carDetails.serviceStats,
                      summary:
                      carDetails.summary,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    WidgetDesignRecentInvoicesCar(
                      invoices:
                      carDetails.recentInvoices,
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: WidgetDesignRecentInvoicesCar(
                      invoices:
                      carDetails.recentInvoices,
                    ),
                  ),

                  const SizedBox(
                    width: 20,
                  ),

                  Expanded(
                    child: WidgetDesignServiceStatsCar(
                      serviceStats:
                      carDetails.serviceStats,
                      summary:
                      carDetails.summary,
                    ),
                  ),

                  const SizedBox(
                    width: 20,
                  ),

                  Expanded(
                    child: WidgetDesignFuelConsumptionCar(
                      fuelConsumption:
                      carDetails.fuelConsumption,
                      summary:
                      carDetails.summary,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // MOBILE / TABLET
  // ==============================================================

  Widget _buildMobile(
      BuildContext context,
      dynamic harage,
      GetCarDetailsModel? carDetails,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.stretch,
      children: [
        WidgetDesignDetailsDataHaragCar(
          harage: harage,
        ),

        const SizedBox(
          height: 15,
        ),

        WidgetDesignDescriptionHarag(
          harage: harage,
        ),

        const SizedBox(
          height: 15,
        ),

        WidgetDesignImagesHarag(
          harage: harage,
        ),

        const SizedBox(
          height: 15,
        ),

        SizedBox(
          height: 450,
          child: WidgetDesignChatsHarag(
            harage: harage,
          ),
        ),

        if (carDetails != null) ...[
          const SizedBox(
            height: 25,
          ),

          _buildCarServicesSection(
            context,
            carDetails,
          ),
        ],
      ],
    );
  }
}