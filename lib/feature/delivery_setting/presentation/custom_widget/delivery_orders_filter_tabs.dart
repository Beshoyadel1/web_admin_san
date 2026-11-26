import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class DeliveryOrderFilterTabItem {
  final String? statusKey;
  final String title;

  const DeliveryOrderFilterTabItem({
    required this.statusKey,
    required this.title,
  });
}

class DeliveryOrdersFilterTabs extends StatelessWidget {
  final String? selectedStatus;
  final void Function(String? status) onStatusChanged;

  const DeliveryOrdersFilterTabs({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  List<DeliveryOrderFilterTabItem> _buildTabs() {
    return [
      DeliveryOrderFilterTabItem(
        statusKey: null,
        title: LocaleKeys.allStatuses.tr(),
      ),
      DeliveryOrderFilterTabItem(
        statusKey: 'newOrder',
        title: LocaleKeys.deliveryStatusNew.tr(),
      ),
      DeliveryOrderFilterTabItem(
        statusKey: 'accepted',
        title: LocaleKeys.deliveryStatusAccepted.tr(),
      ),
      DeliveryOrderFilterTabItem(
        statusKey: 'arrived_to_store',
        title: LocaleKeys.deliveryStatusArrivedStore.tr(),
      ),
      DeliveryOrderFilterTabItem(
        statusKey: 'picked',
        title: LocaleKeys.deliveryStatusPicked.tr(),
      ),
      DeliveryOrderFilterTabItem(
        statusKey: 'delivered',
        title: LocaleKeys.deliveryStatusDelivered.tr(),
      ),
      DeliveryOrderFilterTabItem(
        statusKey: 'cancelled',
        title: LocaleKeys.deliveryStatusCancelled.tr(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _buildTabs();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          final isSelected = selectedStatus == tab.statusKey;

          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: InkWell(
                onTap: () => onStatusChanged(tab.statusKey),
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.orangeColor
                        : AppColors.whiteGreyColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.orangeColor
                          : AppColors.cardStroke,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      tab.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.whiteColor
                            : AppColors.darkColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
