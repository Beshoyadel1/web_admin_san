import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/networking/api_link.dart';
import '../../../../../../core/services/web_interop/web_interop.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_details_model.dart';

class OrderCustomerCard extends StatelessWidget {
  final OrderDetailsModel? orderDetails;

  const OrderCustomerCard({
    super.key,
    required this.orderDetails,
  });

  String _getUserRoleName(int? userType) {
    return switch (userType) {
      UserType.driverUser => LocaleKeys.driverRole.tr(),
      UserType.companyUser => LocaleKeys.companyRole.tr(),
      UserType.employeeUser => LocaleKeys.employeeRole.tr(),
      UserType.adminUser => LocaleKeys.adminRole.tr(),
      UserType.providerUser => LocaleKeys.providerRole.tr(),
      _ => LocaleKeys.clientRole.tr(),
    };
  }

  void _openWhatsApp(String? phone) {
    if (phone == null || phone.trim().isEmpty) return;
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
    final user = orderDetails?.user;
    final userName = user?.username ?? LocaleKeys.unregisteredCustomer.tr();
    final userPhone = user?.phone ?? '--';
    final userEmail = user?.email ?? '';
    final address = orderDetails?.nationaladdress ?? '--';
    final int? userType = user?.usertype ?? orderDetails?.usertype;
    final String roleName = _getUserRoleName(userType);

    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Icons.person_outline_rounded,
                      color: AppColors.orangeColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextInAppWidget(
                    text: '${LocaleKeys.customerDataWithRole.tr()} ($roleName)',
                    textSize: 15,
                    fontWeightIndex: FontSelectionData.boldFontFamily,
                    textColor: AppColors.darkColor,
                  ),
                ],
              ),
              if (user?.phone != null && user!.phone!.isNotEmpty)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InkWell(
                    onTap: () => _openWhatsApp(user.phone),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.greenColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: AppColors.greenColor,
                        size: 18,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor:
                    AppColors.veryLightOrangeColor.withValues(alpha: 0.3),
                backgroundImage: user?.image != null && user!.image!.isNotEmpty
                    ? MemoryImage(user.image!)
                    : null,
                child: (user?.image == null || user!.image!.isEmpty)
                    ? const Icon(
                        Icons.person,
                        color: AppColors.orangeColor,
                        size: 24,
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInAppWidget(
                      text: userName,
                      textSize: 14,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                      textColor: AppColors.darkColor,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    TextInAppWidget(
                      text: userPhone,
                      textSize: 12,
                      textColor: AppColors.darkGreyColor,
                      fontWeightIndex: FontSelectionData.regularFontFamily,
                      maxLines: 1,
                    ),
                    if (userEmail.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      TextInAppWidget(
                        text: userEmail,
                        textSize: 11,
                        textColor: AppColors.darkGreyColor,
                        fontWeightIndex: FontSelectionData.regularFontFamily,
                        maxLines: 1,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (address.isNotEmpty && address != '--') ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.scaffoldColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.veryLightGreyColor),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.darkGreyColor,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextInAppWidget(
                      text: address,
                      textSize: 12,
                      textColor: AppColors.darkGreyColor,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
