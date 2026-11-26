import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../../core/widgets/custom_container.dart';
import '../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/widgets/button_with_text_icon.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/widgets/user_wallet_button.dart';

class DesignBillOrderWidget extends StatelessWidget {
  final String? price, tax, totalPrice;
  final int? paymentMethod;

  const DesignBillOrderWidget({
    super.key,
    this.paymentMethod,
    this.price,
    this.tax,
    this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: () {},
      isSelected: true,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.orangeColor.withOpacity(0.4)),
      typeWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          const TextInAppWidget(
            text: LocaleKeys.invoice,
            textSize: 15,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.blackColor,
          ),
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextInAppWidget(
                text: LocaleKeys.servicePrice,
                textSize: 15,
                fontWeightIndex: FontSelectionData.regularFontFamily,
                textColor: AppColors.greyColor,
              ),
              Row(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextInAppWidget(
                    text: price ?? "1450",
                    textSize: 16,
                    fontWeightIndex: FontSelectionData.regularFontFamily,
                    textColor: AppColors.blackColor,
                  ),
                  const TextInAppWidget(
                    text: LocaleKeys.dirham,
                    textSize: 16,
                    fontWeightIndex: FontSelectionData.regularFontFamily,
                    textColor: AppColors.blackColor,
                  ),
                ],
              ),
            ],
          ),
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextInAppWidget(
                text: LocaleKeys.valueAddedTax,
                textSize: 15,
                fontWeightIndex: FontSelectionData.regularFontFamily,
                textColor: AppColors.greyColor,
              ),
              TextInAppWidget(
                text: "$tax%" ?? "",
                textSize: 16,
                fontWeightIndex: FontSelectionData.regularFontFamily,
                textColor: AppColors.blackColor,
              ),
            ],
          ),
          Divider(
            color: AppColors.greyColor.withOpacity(0.5),
          ),
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextInAppWidget(
                text: LocaleKeys.total,
                textSize: 15,
                fontWeightIndex: FontSelectionData.regularFontFamily,
                textColor: AppColors.blackColor,
              ),
              Row(
                spacing: 5,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextInAppWidget(
                    text: totalPrice ?? "1450",
                    textSize: 16,
                    fontWeightIndex: FontSelectionData.regularFontFamily,
                    textColor: AppColors.orangeColor,
                  ),
                  const TextInAppWidget(
                    text: LocaleKeys.dirham,
                    textSize: 16,
                    fontWeightIndex: FontSelectionData.regularFontFamily,
                    textColor: AppColors.orangeColor,
                  ),
                ],
              ),
            ],
          ),
          Divider(
            color: AppColors.greyColor.withOpacity(0.5),
          ),
          UserWalletButton(
            paymentMethod: paymentMethod ?? -1,
          ),
          const ButtonWithTextIcon(
            text: LocaleKeys.downloadInvoice,
          )
        ],
      ),
    );
  }
}
