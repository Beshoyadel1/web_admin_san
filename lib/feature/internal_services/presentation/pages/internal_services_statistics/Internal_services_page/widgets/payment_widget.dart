import 'package:flutter/material.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/widgets/custom_container.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';

class PaymentWidget extends StatelessWidget {
  const PaymentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      containerWidth: 438,
      padding: const EdgeInsets.all(16),
      border: const Border(),
      borderRadius: BorderRadius.circular(0),
      isSelected: false,
      onTap: () {},
      typeWidget: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextInAppWidget(
            text: LocaleKeys.invoiceKey,
            textSize: 18,
            textColor: AppColors.darkColor,
          ),
          const SizedBox(
            height: 10,
          ),
          const CustomRow(text: LocaleKeys.insuranceAgainKey, value: '1000'),
          const CustomRow(text: LocaleKeys.taxesKey, value: '1000'),
          const CustomRow(text: LocaleKeys.totalKey, value: '1000'),
          const CustomRow(text: LocaleKeys.insuranceAgainKey, value: '1000.00'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextInAppWidget(
                text: LocaleKeys.paidByKey,
                textSize: 16,
                textColor: AppColors.darkColor,
              ),
              // Image.asset(
              //   AppImageKeys.payIcon,
              //   width: 53,
              //   height: 21,
              //   fit: BoxFit.fill,
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomRow extends StatelessWidget {
  const CustomRow({super.key, required this.text, required this.value});

  final String text;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextInAppWidget(
              text: text,
              textSize: 16,
              textColor: AppColors.darkColor,
            ),
            TextInAppWidget(
              text: value,
              textSize: 16,
              textColor: AppColors.orangeColor,
            ),
          ],
        ),
        const Divider(
          thickness: 1,
          color: AppColors.greyColor,
        ),
      ],
    );
  }
}
