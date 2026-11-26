import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/cars_haraj_page/view_model/harag_cubit/harag_cubit.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/get_all_harage_model/harage_data.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/harage_chat_dialog.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';

class WidgetDesignDetailsDataHaragCar extends StatelessWidget {
  final HarageData harage;

  const WidgetDesignDetailsDataHaragCar({
    super.key,
    required this.harage,
  });

  @override
  Widget build(BuildContext context) {
    final title =
        '${harage.releaseDate ?? ''} ${harage.car?.brandName ?? ''} ${harage.car?.modelName ?? ''}'
            .trim();
    final carTitle = title.isNotEmpty ? title : LocaleKeys.carDetails.tr();

    return CustomContainer(
      containerWidth: double.infinity,
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      typeWidget: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ========================================================
            // CAR HEADER PREVIEW ROW
            // ========================================================
            _HaragCarHeaderPreview(
              harage: harage,
              carTitle: carTitle,
            ),

            const SizedBox(height: 24),
            const Divider(color: AppColors.whiteColorF4, height: 1),
            const SizedBox(height: 24),

            // ========================================================
            // CAR SPECIFICATIONS GRID
            // ========================================================
            Wrap(
              spacing: 24,
              runSpacing: 20,
              alignment: WrapAlignment.spaceBetween,
              children: [
                _HaragInfoItem(
                  title: LocaleKeys.orderDate.tr(),
                  value: harage.releaseDate ?? '-',
                  icon: Icons.calendar_today_outlined,
                  iconColor: AppColors.orangeColor,
                ),
                _HaragInfoItem(
                  title: LocaleKeys.transmissionTypeLabel.tr(),
                  value: _getTransmissionName(harage.transmissionType),
                  icon: Icons.settings_suggest_outlined,
                  iconColor: AppColors.blueAccentColor,
                ),
                _HaragMessagesBadgeItem(
                  harageId: harage.id ?? 0,
                  messagesCount: harage.commentsNumber ?? 0,
                  carTitle: carTitle,
                ),
                _HaragInfoItem(
                  title: LocaleKeys.carPrice.tr(),
                  value: '${harage.price ?? 0} ${LocaleKeys.sarCurrency.tr()}',
                  icon: Icons.payments_outlined,
                  iconColor: AppColors.orangeColor,
                ),
                _HaragInfoItem(
                  title: LocaleKeys.fuelType.tr(),
                  value: _getFuelTypeName(harage.fuelType),
                  icon: Icons.local_gas_station_outlined,
                  iconColor: AppColors.amberColor,
                ),
                _HaragInfoItem(
                  title: LocaleKeys.speedometer.tr(),
                  value: '${harage.kilometers ?? 0} KM',
                  icon: Icons.speed_outlined,
                  iconColor: AppColors.seaBlueColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _getTransmissionName(int? type) {
    if (type == 1) return LocaleKeys.automaticTransmission.tr();
    if (type == 2) return LocaleKeys.manualTransmission.tr();
    return type?.toString() ?? '-';
  }

  static String _getFuelTypeName(dynamic fuelType) {
    if (fuelType == null) return '-';
    final id = int.tryParse(fuelType.toString());
    if (id == 1) return LocaleKeys.petrol.tr();
    if (id == 2) return LocaleKeys.dieselFuel.tr();
    if (id == 3) return LocaleKeys.electricFuel.tr();
    if (id == 4) return LocaleKeys.hybridFuel.tr();
    return fuelType.toString();
  }
}

class _HaragCarHeaderPreview extends StatelessWidget {
  final HarageData harage;
  final String carTitle;

  const _HaragCarHeaderPreview({
    required this.harage,
    required this.carTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Car Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: harage.car?.carImage != null
              ? Image.memory(
                  harage.car!.carImage!,
                  width: 130,
                  height: 85,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 130,
                  height: 85,
                  color: AppColors.greyColor.withOpacity(0.12),
                  child: const Icon(
                    Icons.directions_car_outlined,
                    size: 38,
                    color: AppColors.greyColor,
                  ),
                ),
        ),
        const SizedBox(width: 16),

        // Brand & Title
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (harage.car?.brandImage != null) ...[
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.whiteColorF4,
                      backgroundImage: MemoryImage(harage.car!.brandImage!),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: TextInAppWidget(
                      text: carTitle,
                      textSize: 18,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                      textColor: AppColors.darkColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _HaragConditionBadge(
                    isNew: harage.isNew,
                  ),
                  const SizedBox(width: 10),
                  _HaragStatusBadge(
                    status: harage.currentStatus?.status,
                    isSold: harage.isSold,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HaragConditionBadge extends StatelessWidget {
  final bool? isNew;

  const _HaragConditionBadge({
    required this.isNew,
  });

  @override
  Widget build(BuildContext context) {
    final isNewCar = isNew == true;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isNewCar
            ? AppColors.greenColor.withOpacity(0.12)
            : AppColors.orangeColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isNewCar ? Icons.auto_awesome : Icons.directions_car_outlined,
            size: 14,
            color: isNewCar ? AppColors.greenColor : AppColors.orangeColor,
          ),
          const SizedBox(width: 6),
          TextInAppWidget(
            text: isNewCar ? LocaleKeys.newCar.tr() : LocaleKeys.usedCar.tr(),
            textSize: 12,
            fontWeightIndex: FontSelectionData.boldFontFamily,
            textColor: isNewCar ? AppColors.greenColor : AppColors.orangeColor,
          ),
        ],
      ),
    );
  }
}

class _HaragStatusBadge extends StatelessWidget {
  final int? status;
  final bool? isSold;

  const _HaragStatusBadge({
    required this.status,
    required this.isSold,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStatus = status ?? (isSold == true ? 3 : 1);

    Color bg;
    Color fg;
    String label;
    IconData icon;

    switch (effectiveStatus) {
      case 2:
        label = LocaleKeys.pending.tr();
        bg = AppColors.lightAmberColor;
        fg = AppColors.amberColor;
        icon = Icons.pause_circle_outline;
        break;
      case 3:
        label = LocaleKeys.sold.tr();
        bg = AppColors.redColor.withOpacity(0.1);
        fg = AppColors.redColor;
        icon = Icons.sell_outlined;
        break;
      case 4:
        label = LocaleKeys.deleted.tr();
        bg = AppColors.greyColor.withOpacity(0.12);
        fg = AppColors.greyColor;
        icon = Icons.delete_outline;
        break;
      case 1:
      default:
        label = LocaleKeys.active.tr();
        bg = AppColors.lightBlueSoft;
        fg = AppColors.blueAccentColor;
        icon = Icons.inventory_2_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          TextInAppWidget(
            text: label,
            textSize: 12,
            fontWeightIndex: FontSelectionData.boldFontFamily,
            textColor: fg,
          ),
        ],
      ),
    );
  }
}

class _HaragInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _HaragInfoItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 145,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextInAppWidget(
                  text: title,
                  textSize: 11,
                  textColor: AppColors.greyColor,
                  maxLines: 1,
                ),
                const SizedBox(height: 3),
                TextInAppWidget(
                  text: value,
                  textSize: 14,
                  fontWeightIndex: FontSelectionData.boldFontFamily,
                  textColor: AppColors.darkColor,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HaragMessagesBadgeItem extends StatelessWidget {
  final int harageId;
  final int messagesCount;
  final String carTitle;

  const _HaragMessagesBadgeItem({
    required this.harageId,
    required this.messagesCount,
    required this.carTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 155,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            final cubit = context.read<HaragCubit>();
            showDialog(
              context: context,
              builder: (ctx) => BlocProvider.value(
                value: cubit,
                child: HarageChatDialog(
                  harageId: harageId,
                  title: carTitle,
                ),
              ),
            );
          },
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.orangeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 20,
                  color: AppColors.orangeColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextInAppWidget(
                      text: LocaleKeys.messagesCount.tr(),
                      textSize: 11,
                      textColor: AppColors.greyColor,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.orangeColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextInAppWidget(
                            text: '$messagesCount',
                            textSize: 11,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                            textColor: AppColors.whiteColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextInAppWidget(
                            text: LocaleKeys.viewMessages.tr(),
                            textSize: 12,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                            textColor: AppColors.orangeColor,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
