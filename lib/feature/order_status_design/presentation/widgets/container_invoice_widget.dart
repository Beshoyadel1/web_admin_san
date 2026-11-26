import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../core/helpers/constants/assets.dart';
import '../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../core/helpers/themes/fonts.dart';
import '../../../../../core/helpers/themes/text_styles.dart';

class ContainerInvoiceWidget extends StatelessWidget {
  final bool? isFinished;
  final String priceInsuranceInstallment, priceTaxes, priceTotal;
  final String? textTimeFinishPay;
  final String? selectedImage;

  const ContainerInvoiceWidget({
    this.selectedImage,
    this.textTimeFinishPay,
    this.isFinished = false,
    required this.priceInsuranceInstallment,
    required this.priceTaxes,
    required this.priceTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInAppWidget(
            text: LocaleKeys.invoice,
            textSize: 12,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.darkColor,
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextInAppWidget(
                      text: LocaleKeys.insuranceInstallment,
                      textSize: 10,
                      fontWeightIndex: FontSelectionData.regularFontFamily,
                      textColor: AppColors.darkColor,
                    ),
                    Row(
                      children: [
                        TextInAppWidget(
                          text: priceInsuranceInstallment,
                          textSize: 10,
                          fontWeightIndex: FontSelectionData.regularFontFamily,
                          textColor: AppColors.darkColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Image.asset(
                          AppImageKeys.coin,
                          color: AppColors.darkColor,
                          width: 11,
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextInAppWidget(
                      text: LocaleKeys.taxes,
                      textSize: 10,
                      fontWeightIndex: FontSelectionData.regularFontFamily,
                      textColor: AppColors.darkColor,
                    ),
                    Row(
                      children: [
                        TextInAppWidget(
                          text: priceTaxes,
                          textSize: 10,
                          fontWeightIndex: FontSelectionData.regularFontFamily,
                          textColor: AppColors.darkColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Image.asset(
                          AppImageKeys.coin,
                          color: AppColors.darkColor,
                          width: 11,
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 1,
                  color: AppColors.greyColor,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextInAppWidget(
                      text: LocaleKeys.total,
                      textSize: 12,
                      fontWeightIndex: FontSelectionData.regularFontFamily,
                      textColor: AppColors.darkColor,
                    ),
                    Row(
                      children: [
                        TextInAppWidget(
                          text: priceTotal,
                          textSize: 14,
                          fontWeightIndex: FontSelectionData.mediumFontFamily,
                          textColor: AppColors.orangeColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Image.asset(
                          AppImageKeys.coin,
                          color: AppColors.orangeColor,
                          width: 13,
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                if (isFinished! && selectedImage != null)
                  Column(
                    children: [
                      Divider(
                        thickness: 1,
                        color: AppColors.greyColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              TextInAppWidget(
                                text: LocaleKeys.paidBy,
                                textSize: 10,
                                fontWeightIndex:
                                    FontSelectionData.regularFontFamily,
                                textColor: AppColors.darkColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Image.asset(
                                selectedImage!,
                                width: 50,
                              )
                            ],
                          ),
                          TextInAppWidget(
                            text: textTimeFinishPay!,
                            textSize: 10,
                            fontWeightIndex: FontSelectionData.mediumFontFamily,
                            textColor: AppColors.orangeColor,
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
