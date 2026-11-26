import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../../../core/services/web_interop/web_interop.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_details_model.dart';

class OrderTechniciansCard extends StatelessWidget {
  final OrderDetailsModel? orderDetails;

  const OrderTechniciansCard({
    super.key,
    required this.orderDetails,
  });

  @override
  Widget build(BuildContext context) {
    final rawEmployees = orderDetails?.employeeInfos ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.veryLightGreyColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.orangeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.engineering_rounded,
                  color: AppColors.orangeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              TextInAppWidget(
                text: LocaleKeys.assignedTechniciansTeam.tr(),
                textSize: 15,
                textColor: AppColors.darkColor,
                fontWeightIndex: FontSelectionData.boldFontFamily,
              ),
              if (rawEmployees.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.orangeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.orangeColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: TextInAppWidget(
                    text: '${rawEmployees.length}',
                    textSize: 11,
                    textColor: AppColors.orangeColor,
                    fontWeightIndex: FontSelectionData.boldFontFamily,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          if (rawEmployees.isNotEmpty)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final emp in rawEmployees)
                  TechnicianItemCard(employeeData: emp),
              ],
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.scaffoldColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.veryLightGreyColor.withValues(alpha: 0.7),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: AppColors.darkGreyColor,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextInAppWidget(
                      text: LocaleKeys.noTechniciansAssignedYet,
                      textSize: 12,
                      textColor: AppColors.darkGreyColor,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class TechnicianItemCard extends StatelessWidget {
  final dynamic employeeData;

  const TechnicianItemCard({
    super.key,
    required this.employeeData,
  });

  String _extractString(String key, [String fallback = '']) {
    if (employeeData is Map) {
      return (employeeData[key] ?? employeeData[key.toUpperCase()] ?? fallback)
          .toString();
    }
    try {
      final val = (employeeData as dynamic)[key];
      return val?.toString() ?? fallback;
    } catch (_) {
      return fallback;
    }
  }

  Uint8List? _extractImage() {
    dynamic raw;
    if (employeeData is Map) {
      raw = employeeData['image'] ?? employeeData['IMAGE'];
    } else {
      try {
        raw = (employeeData as dynamic).image;
      } catch (_) {}
    }
    if (raw is Uint8List) return raw;
    if (raw is String && raw.isNotEmpty) {
      try {
        return base64Decode(raw);
      } catch (_) {}
    }
    return null;
  }

  void _callPhone(String phone) {
    if (phone.trim().isEmpty) return;
    openExternalUrl('tel:$phone');
  }

  void _openWhatsApp(String phone) {
    if (phone.trim().isEmpty) return;
    var clean = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.startsWith('05')) {
      clean = '966${clean.substring(1)}';
    } else if (clean.startsWith('5') && clean.length == 9) {
      clean = '966$clean';
    }
    openExternalUrl('https://wa.me/$clean');
  }

  @override
  Widget build(BuildContext context) {
    final name = _extractString('name', LocaleKeys.technicianDefault.tr());
    final role = _extractString(
        'jobname',
        _extractString(
            'joblatinname', LocaleKeys.maintenanceTechnicianDefault.tr()));
    final phone = _extractString('phone', '');
    final imageBytes = _extractImage();

    return Container(
      constraints: const BoxConstraints(minWidth: 220, maxWidth: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.veryLightGreyColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.orangeColor.withValues(alpha: 0.15),
            backgroundImage:
                imageBytes != null ? MemoryImage(imageBytes) : null,
            child: imageBytes == null
                ? TextInAppWidget(
                    text: name.isNotEmpty ? name[0] : 'T',
                    textSize: 14,
                    textColor: AppColors.orangeColor,
                    fontWeightIndex: FontSelectionData.boldFontFamily,
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextInAppWidget(
                  text: name,
                  textSize: 13,
                  textColor: AppColors.darkColor,
                  fontWeightIndex: FontSelectionData.boldFontFamily,
                  maxLines: 1,
                  isEllipsisTextOverflow: true,
                ),
                const SizedBox(height: 2),
                TextInAppWidget(
                  text: role,
                  textSize: 11,
                  textColor: AppColors.darkGreyColor,
                  maxLines: 1,
                  isEllipsisTextOverflow: true,
                ),
              ],
            ),
          ),
          if (phone.isNotEmpty) ...[
            const SizedBox(width: 6),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Tooltip(
                message: LocaleKeys.phoneCall.tr(),
                child: InkWell(
                  onTap: () => _callPhone(phone),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.orangeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.phone_outlined,
                      color: AppColors.orangeColor,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Tooltip(
                message: LocaleKeys.whatsappMessage.tr(),
                child: InkWell(
                  onTap: () => _openWhatsApp(phone),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.greenColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.chat_outlined,
                      color: AppColors.greenColor,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
