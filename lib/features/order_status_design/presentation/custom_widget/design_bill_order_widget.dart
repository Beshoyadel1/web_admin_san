import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/pages_widgets/text_form_field_widget.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/order_status_design/presentation/custom_widget/button_with_text_icon.dart';
import 'package:web_admin_san/features/order_status_design/presentation/custom_widget/user_wallet_button.dart';

class DesignBillOrderWidget extends StatelessWidget {
  final String? price, tax, totalPrice;
  final int? paymentMethod;

  const DesignBillOrderWidget(
      {
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
            text: AppLanguageKeys.invoice,
            textSize: 15,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.blackColor,
          ),
           Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextInAppWidget(
                text: AppLanguageKeys.servicePrice,
                textSize: 15,
                fontWeightIndex: FontSelectionData.regularFontFamily,
                textColor: AppColors.greyColor,
              ),
              Row(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextInAppWidget(
                    text: price??"1450",
                    textSize: 16,
                    fontWeightIndex: FontSelectionData.regularFontFamily,
                    textColor: AppColors.blackColor,
                  ),
                  const TextInAppWidget(
                    text: AppLanguageKeys.dirham,
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
                text: AppLanguageKeys.valueAddedTax,
                textSize: 15,
                fontWeightIndex: FontSelectionData.regularFontFamily,
                textColor: AppColors.greyColor,
              ),
              TextInAppWidget(
                text:"$tax%"?? "",
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
              const  TextInAppWidget(
                text: AppLanguageKeys.total,
                textSize: 15,
                fontWeightIndex: FontSelectionData.regularFontFamily,
                textColor: AppColors.blackColor,
              ),
              Row(
                spacing: 5,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextInAppWidget(
                    text:totalPrice?? "1450",
                    textSize: 16,
                    fontWeightIndex: FontSelectionData.regularFontFamily,
                    textColor: AppColors.orangeColor,
                  ),
                  const TextInAppWidget(
                    text: AppLanguageKeys.dirham,
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
            paymentMethod:paymentMethod??  -1,
          ),
          const ButtonWithTextIcon(
            text: AppLanguageKeys.downloadInvoice,
          )
        ],
      ),
    );
  }
}
