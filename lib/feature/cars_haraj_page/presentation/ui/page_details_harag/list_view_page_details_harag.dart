import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/get_all_harage_model/harage_data.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/get_all_harage_model/user_model.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/get_car_details_model/get_car_details_model.dart';
import 'package:web_admin_san/feature/cars_haraj_page/view_model/harag_cubit/harag_cubit.dart';
import 'package:web_admin_san/feature/cars_haraj_page/view_model/harag_cubit/harag_state.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/harag_messages_panel_widget.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/harag_status_dropdown_widget.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/widget_design_description_harag.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/widget_design_details_data_harag_car.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/widget_design_fuel_consumption_car.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/widget_design_images_harag.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/widget_design_recent_invoices_car.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/widget_design_service_stats_Car.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/text_empty_view_data.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';

class ListViewPageDetailsHarag extends StatelessWidget {
  final int harageId;

  const ListViewPageDetailsHarag({
    super.key,
    required this.harageId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HaragCubit, HaragState>(
      buildWhen: (previous, current) =>
          current is HaragDetailsLoading ||
          current is HaragDetailsSuccess ||
          current is HaragDetailsError ||
          current is ChangeHarageStatusLoading ||
          current is ChangeHarageStatusSuccess ||
          current is ChangeHarageStatusError,
      builder: (context, state) {
        final cubit = context.read<HaragCubit>();

        // Loading
        if (state is HaragDetailsLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(50),
              child: CircularProgressIndicator(
                color: AppColors.orangeColor,
              ),
            ),
          );
        }

        // Error
        if (state is HaragDetailsError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.redColor,
                    size: 45,
                  ),
                  const SizedBox(height: 12),
                  TextInAppWidget(
                    text: state.message,
                    textSize: 15,
                    textColor: AppColors.darkGreyColor,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orangeColor,
                      foregroundColor: AppColors.whiteColor,
                    ),
                    onPressed: () {
                      cubit.getHarageDetails(harageId: harageId);
                    },
                    child: TextInAppWidget(
                      text: LocaleKeys.retry.tr(),
                      textSize: 13,
                      textColor: AppColors.whiteColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final harage = cubit.harageDetailsResponse?.data;
        if (harage == null) {
          return const Center(
            child: TextEmptyViewData(),
          );
        }

        final carDetails = cubit.carDetailsResponse;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ========================================================
            // HEADER BAR: Title, Subtitle, and Status Dropdown
            // ========================================================
            _HaragDetailsHeaderBar(
              harage: harage,
            ),

            const SizedBox(height: 20),

            // ========================================================
            // MAIN CONTENT: Car Details + Messages Side Panel
            // ========================================================
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 950;

                final messagesPanel = HaragMessagesPanelWidget(
                  harage: harage,
                  liveMessages: cubit.harageChatResponse?.data?.messages ?? [],
                );

                final carDetailsColumn = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    WidgetDesignDetailsDataHaragCar(
                      harage: harage,
                    ),
                    const SizedBox(height: 20),
                    WidgetDesignDescriptionHarag(
                      harage: harage,
                    ),
                    if (harage.images.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      WidgetDesignImagesHarag(
                        harage: harage,
                      ),
                    ],
                  ],
                );

                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Car Details & Specs on the right (start in RTL)
                      Expanded(
                        child: carDetailsColumn,
                      ),
                      const SizedBox(width: 20),
                      // Messages Panel on the left (end in RTL)
                      SizedBox(
                        width: 350,
                        child: messagesPanel,
                      ),
                    ],
                  );
                }

                // Tablet / Mobile: Stacked vertically
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    carDetailsColumn,
                    const SizedBox(height: 20),
                    messagesPanel,
                  ],
                );
              },
            ),

            // ========================================================
            // PREVIOUS ORDERS & MAINTENANCE SECTION
            // ========================================================
            if (carDetails != null) ...[
              const SizedBox(height: 35),
              _HaragServicesSection(
                carDetails: carDetails,
              ),
            ],
          ],
        );
      },
    );
  }
}

class _HaragDetailsHeaderBar extends StatelessWidget {
  final HarageData harage;

  const _HaragDetailsHeaderBar({
    required this.harage,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 12,
      children: [
        // Owner Info: placed on the right side in RTL
        _HaragOwnerHeaderInfo(
          user: harage.user,
        ),

        // Status Dropdown: placed on the other side (left in RTL)
        HaragStatusDropdownWidget(
          harageId: harage.id ?? 0,
          currentStatus: harage.currentStatus?.status ?? 1,
        ),
      ],
    );
  }
}

class _HaragOwnerHeaderInfo extends StatelessWidget {
  final UserModel? user;

  const _HaragOwnerHeaderInfo({
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const SizedBox.shrink();
    }
    final name = user!.getName(context);
    final branch = user!.getBranch(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        user!.image != null
            ? CircleAvatar(
                radius: 22,
                backgroundImage: MemoryImage(user!.image!),
              )
            : CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.lightOrangeColor.withOpacity(0.2),
                child: const Icon(
                  Icons.person_outline,
                  color: AppColors.orangeColor,
                  size: 22,
                ),
              ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextInAppWidget(
              text: LocaleKeys.listingOwner.tr(),
              textSize: 11,
              textColor: AppColors.greyColor,
              maxLines: 1,
            ),
            const SizedBox(height: 2),
            TextInAppWidget(
              text: name.isNotEmpty ? name : '---',
              textSize: 15,
              fontWeightIndex: FontSelectionData.boldFontFamily,
              textColor: AppColors.darkColor,
              maxLines: 1,
            ),
            if (branch.isNotEmpty) ...[
              const SizedBox(height: 2),
              TextInAppWidget(
                text: branch,
                textSize: 12,
                textColor: AppColors.greyColor,
                maxLines: 1,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _HaragServicesSection extends StatelessWidget {
  final GetCarDetailsModel carDetails;

  const _HaragServicesSection({
    required this.carDetails,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      typeWidget: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextInAppWidget(
              text: LocaleKeys.previousOrdersAndMaintenance,
              textSize: 20,
              fontWeightIndex: FontSelectionData.boldFontFamily,
              textColor: AppColors.darkColor,
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                if (width < 900) {
                  return Column(
                    children: [
                      WidgetDesignFuelConsumptionCar(
                        fuelConsumption: carDetails.fuelConsumption,
                        summary: carDetails.summary,
                      ),
                      const SizedBox(height: 20),
                      WidgetDesignServiceStatsCar(
                        serviceStats: carDetails.serviceStats,
                        summary: carDetails.summary,
                      ),
                      const SizedBox(height: 20),
                      WidgetDesignRecentInvoicesCar(
                        invoices: carDetails.recentInvoices,
                      ),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: WidgetDesignRecentInvoicesCar(
                        invoices: carDetails.recentInvoices,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: WidgetDesignServiceStatsCar(
                        serviceStats: carDetails.serviceStats,
                        summary: carDetails.summary,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: WidgetDesignFuelConsumptionCar(
                        fuelConsumption: carDetails.fuelConsumption,
                        summary: carDetails.summary,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
