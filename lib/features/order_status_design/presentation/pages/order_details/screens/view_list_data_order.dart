import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/features/order_status_design/presentation/custom_widget/design_view_other_service_widget.dart';
import 'package:web_admin_san/features/order_status_design/presentation/custom_widget/design_view_type_service_widget.dart';

class ViewListDataOrder extends StatelessWidget {
  const ViewListDataOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int count = 4;

        if (constraints.maxWidth < 500) {
          count = 1;
        } else if (constraints.maxWidth < 700) {
          count = 2;
        } else if (constraints.maxWidth < 1000) {
          count = 3;
        }

        final width = (constraints.maxWidth - ((count - 1) * 10)) / count;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            SizedBox(
              width: width,
              child: const DesignViewTypeServiceWidget(),
            ),
            SizedBox(
              width: width,
              child: const DesignViewOtherServiceWidget(
                title: AppLanguageKeys.servicePrice,
                iconData: Icons.monetization_on,
                subTitle: "1910",
                subTitleColor: AppColors.orangeColor,
              ),
            ),
            SizedBox(
              width: width,
              child: const DesignViewOtherServiceWidget(
                title: AppLanguageKeys.orderDate,
                iconData: Icons.calendar_month,
                iconDataColor: AppColors.blueColor,
                iconDataBackGroundColor: AppColors.lightCyanColor,
                subTitle: "3/11/2000",
              ),
            ),
            SizedBox(
              width: width,
              child: const DesignViewOtherServiceWidget(
                title: AppLanguageKeys.expectedDeliveryDate,
                iconData: Icons.access_time,
                iconDataColor: AppColors.greenColor,
                iconDataBackGroundColor: AppColors.lightGreenColor,
                subTitle: "3/11/2000",
              ),
            ),
          ],
        );
      },
    );
  }
}