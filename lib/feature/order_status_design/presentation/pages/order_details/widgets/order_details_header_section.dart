import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/networking/api_link.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_details_model.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/delivery_order_badge_widget.dart';
import 'on_site_badge_widget.dart';
import 'stat_card.dart';

class OrderDetailsHeaderSection extends StatelessWidget {
  final OrderDetailsModel? orderDetails;

  const OrderDetailsHeaderSection({
    super.key,
    required this.orderDetails,
  });

  String _formatDate(DateTime? dt) {
    if (dt == null) return '--:--';
    final local = dt.toLocal();
    return '${local.year}/${local.month.toString().padLeft(2, '0')}/${local.day.toString().padLeft(2, '0')} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final status = orderDetails?.effectiveStatus ?? orderDetails?.status ?? 0;
    final orderId = orderDetails?.id?.toString() ?? '--';
    final totalPrice = orderDetails?.totalprice != null
        ? (orderDetails!.totalprice!.truncateToDouble() ==
                orderDetails!.totalprice!
            ? orderDetails!.totalprice!.toInt().toString()
            : orderDetails!.totalprice!.toStringAsFixed(2))
        : '0';
    final orderDate = _formatDate(orderDetails?.date);
    final appointmentDate = _formatDate(orderDetails?.appointment);
    final services = orderDetails?.services ?? [];

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final isCompact = totalWidth < 700;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar: Order ID, Special Offer Badge, and Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      TextInAppWidget(
                        text: '${LocaleKeys.orderDetailsHeader.tr()} #$orderId',
                        textSize: isCompact ? 18 : 22,
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                        textColor: AppColors.darkColor,
                      ),
                      if (orderDetails?.hasGenuineSpecialOffer == true)
                        const SpecialOfferBadge(),
                      if (orderDetails?.isDeliveryOrder == true)
                        const DeliveryOrderBadgeWidget(
                          fontSize: 11,
                          iconSize: 13,
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        ),
                      if (orderDetails?.isOnSite != null)
                        OnSiteBadgeWidget(isOnSite: orderDetails!.isOnSite!),
                    ],
                  ),
                ),
                OrderStatusBadge(status: status),
              ],
            ),
            const SizedBox(height: 6),
            TextInAppWidget(
              text: LocaleKeys.orderDetailsHeaderSubtitle.tr(),
              textSize: 13,
              textColor: AppColors.darkGreyColor,
              fontWeightIndex: FontSelectionData.regularFontFamily,
            ),
            const SizedBox(height: 20),

            // 4 Quick Stats Cards matching Company layout
            if (totalWidth >= 950) ...[
              // 4 Cards in 1 Row
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      width: double.infinity,
                      title: LocaleKeys.servicesType.tr(),
                      icon: Icons.grid_view_rounded,
                      iconBgColor:
                          AppColors.orangeColor.withValues(alpha: 0.12),
                      iconColor: AppColors.orangeColor,
                      child: services.isNotEmpty
                          ? FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: AlignmentDirectional.centerStart,
                              child: Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: services
                                    .take(3)
                                    .map((s) => ServiceTypeChip(service: s))
                                    .toList(),
                              ),
                            )
                          : const TextInAppWidget(
                              text: '--',
                              textSize: 14,
                              textColor: AppColors.darkGreyColor,
                              fontWeightIndex: FontSelectionData.boldFontFamily,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      width: double.infinity,
                      title: LocaleKeys.servicesPriceTotal.tr(),
                      icon: Icons.confirmation_number_outlined,
                      iconBgColor:
                          AppColors.orangeColor.withValues(alpha: 0.12),
                      iconColor: AppColors.orangeColor,
                      child: TextInAppWidget(
                        text: '$totalPrice ${LocaleKeys.sarCurrency.tr()}',
                        textSize: 17,
                        textColor: AppColors.orangeColor,
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      width: double.infinity,
                      title: LocaleKeys.orderDate.tr(),
                      icon: Icons.calendar_today_outlined,
                      iconBgColor: AppColors.blueColor.withValues(alpha: 0.12),
                      iconColor: AppColors.blueColor,
                      child: TextInAppWidget(
                        text: orderDate,
                        textSize: 14,
                        textColor: AppColors.darkColor,
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      width: double.infinity,
                      title: LocaleKeys.deliveryDateOrSchedule.tr(),
                      icon: Icons.access_time_outlined,
                      iconBgColor: AppColors.greenColor.withValues(alpha: 0.12),
                      iconColor: AppColors.greenColor,
                      child: TextInAppWidget(
                        text: appointmentDate,
                        textSize: 14,
                        textColor: AppColors.darkColor,
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (totalWidth >= 550) ...[
              // 2x2 Grid
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          width: double.infinity,
                          title: LocaleKeys.servicesType.tr(),
                          icon: Icons.grid_view_rounded,
                          iconBgColor:
                              AppColors.orangeColor.withValues(alpha: 0.12),
                          iconColor: AppColors.orangeColor,
                          child: services.isNotEmpty
                              ? FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Wrap(
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: services
                                        .take(2)
                                        .map((s) => ServiceTypeChip(service: s))
                                        .toList(),
                                  ),
                                )
                              : const TextInAppWidget(
                                  text: '--',
                                  textSize: 13,
                                  textColor: AppColors.darkGreyColor,
                                  fontWeightIndex:
                                      FontSelectionData.boldFontFamily,
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          width: double.infinity,
                          title: LocaleKeys.servicesPriceTotal.tr(),
                          icon: Icons.confirmation_number_outlined,
                          iconBgColor:
                              AppColors.orangeColor.withValues(alpha: 0.12),
                          iconColor: AppColors.orangeColor,
                          child: TextInAppWidget(
                            text: '$totalPrice ${LocaleKeys.sarCurrency.tr()}',
                            textSize: 16,
                            textColor: AppColors.orangeColor,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          width: double.infinity,
                          title: LocaleKeys.orderDate.tr(),
                          icon: Icons.calendar_today_outlined,
                          iconBgColor:
                              AppColors.blueColor.withValues(alpha: 0.12),
                          iconColor: AppColors.blueColor,
                          child: TextInAppWidget(
                            text: orderDate,
                            textSize: 13,
                            textColor: AppColors.darkColor,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          width: double.infinity,
                          title: LocaleKeys.deliveryDateOrSchedule.tr(),
                          icon: Icons.access_time_outlined,
                          iconBgColor:
                              AppColors.greenColor.withValues(alpha: 0.12),
                          iconColor: AppColors.greenColor,
                          child: TextInAppWidget(
                            text: appointmentDate,
                            textSize: 13,
                            textColor: AppColors.darkColor,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ] else ...[
              // 1 Column Stack
              Column(
                children: [
                  StatCard(
                    width: double.infinity,
                    title: LocaleKeys.servicesType.tr(),
                    icon: Icons.grid_view_rounded,
                    iconBgColor: AppColors.orangeColor.withValues(alpha: 0.12),
                    iconColor: AppColors.orangeColor,
                    child: services.isNotEmpty
                        ? FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.centerStart,
                            child: Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: services
                                  .take(2)
                                  .map((s) => ServiceTypeChip(service: s))
                                  .toList(),
                            ),
                          )
                        : const TextInAppWidget(
                            text: '--',
                            textSize: 13,
                            textColor: AppColors.darkGreyColor,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                          ),
                  ),
                  const SizedBox(height: 10),
                  StatCard(
                    width: double.infinity,
                    title: LocaleKeys.servicesPriceTotal.tr(),
                    icon: Icons.confirmation_number_outlined,
                    iconBgColor: AppColors.orangeColor.withValues(alpha: 0.12),
                    iconColor: AppColors.orangeColor,
                    child: TextInAppWidget(
                      text: '$totalPrice ${LocaleKeys.sarCurrency.tr()}',
                      textSize: 16,
                      textColor: AppColors.orangeColor,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                    ),
                  ),
                  const SizedBox(height: 10),
                  StatCard(
                    width: double.infinity,
                    title: LocaleKeys.orderDate.tr(),
                    icon: Icons.calendar_today_outlined,
                    iconBgColor: AppColors.blueColor.withValues(alpha: 0.12),
                    iconColor: AppColors.blueColor,
                    child: TextInAppWidget(
                      text: orderDate,
                      textSize: 13,
                      textColor: AppColors.darkColor,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                    ),
                  ),
                  const SizedBox(height: 10),
                  StatCard(
                    width: double.infinity,
                    title: LocaleKeys.deliveryDateOrSchedule.tr(),
                    icon: Icons.access_time_outlined,
                    iconBgColor: AppColors.greenColor.withValues(alpha: 0.12),
                    iconColor: AppColors.greenColor,
                    child: TextInAppWidget(
                      text: appointmentDate,
                      textSize: 13,
                      textColor: AppColors.darkColor,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

class OrderStatusBadge extends StatelessWidget {
  final int status;

  const OrderStatusBadge({
    super.key,
    required this.status,
  });

  Color _getStatusColor(int status) {
    return switch (status) {
      OrderStatus.newOrderForCompany ||
      OrderStatus.newOrderForProvider =>
        AppColors.orangeColor,
      OrderStatus.waitingAppointment ||
      OrderStatus.employeeInRoad =>
        AppColors.blueColor,
      OrderStatus.workInProgress => AppColors.defaultColor,
      OrderStatus.orderCompleted => AppColors.greenColor,
      OrderStatus.rejectedByCompany ||
      OrderStatus.rejectedByProvider ||
      OrderStatus.cancelledByUser =>
        AppColors.redColor,
      _ => AppColors.darkGreyColor,
    };
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(status);
    final statusText = OrderStatusToString.toLocalized(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
            ),
          ),
          const SizedBox(width: 6),
          TextInAppWidget(
            text: statusText,
            textSize: 12,
            textColor: statusColor,
            fontWeightIndex: FontSelectionData.boldFontFamily,
          ),
        ],
      ),
    );
  }
}

class ServiceTypeChip extends StatelessWidget {
  final Service service;

  const ServiceTypeChip({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.maybeLocaleOf(context)?.languageCode == 'ar';
    final String name = (isAr ? service.name : service.latinname) ??
        service.name ??
        service.latinname ??
        '';
    final hasImage = service.image != null && service.image!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.veryLightGreyColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.veryLightGreyColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasImage) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.memory(
                service.image!,
                width: 16,
                height: 16,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.build_outlined,
                  size: 13,
                  color: AppColors.orangeColor,
                ),
              ),
            ),
            const SizedBox(width: 4),
          ] else ...[
            const Icon(
              Icons.build_outlined,
              size: 13,
              color: AppColors.orangeColor,
            ),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: TextInAppWidget(
              text: name,
              textSize: 11,
              textColor: AppColors.darkGreyColor,
              fontWeightIndex: FontSelectionData.boldFontFamily,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class SpecialOfferBadge extends StatelessWidget {
  const SpecialOfferBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.defaultColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.defaultColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_offer_outlined,
            size: 13,
            color: AppColors.defaultColor,
          ),
          const SizedBox(width: 4),
          TextInAppWidget(
            text: LocaleKeys.specialOffer.tr(),
            textSize: 11,
            textColor: AppColors.defaultColor,
            fontWeightIndex: FontSelectionData.boldFontFamily,
          ),
        ],
      ),
    );
  }
}
