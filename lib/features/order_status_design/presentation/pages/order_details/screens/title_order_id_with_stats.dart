import 'package:flutter/cupertino.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../features/cars_haraj_page/presentation/custom_widget/title_with_sub_title.dart';
import '../../../../../../features/internal_services/presentation/pages/internal_orders/custom_widget/container_status.dart';
import '../../../../../../features/order_status_design/presentation/custom_widget/container_return_to_page_setting.dart';

class TitleOrderIdWithStats extends StatelessWidget {
  const TitleOrderIdWithStats({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 450;

        const titleWidget = TitleWithSubTitle(
          spacing: 5,
          title:AppLanguageKeys.orderDetailsNumber,
          numberOrderTitle:"55",
          titleColor: AppColors.darkColor,
          textSizeTitle: 20,
          subTitle:AppLanguageKeys.viewAllOrderDetails,
          subTitleColor: AppColors.greyColor,
          textSizeSubTitle: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
        );

        const actionsWidget = Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: [
            ContainerStatus(
              status: -2,
            ),
            ContainerReturnToPageSetting(
              text: AppLanguageKeys.back,
            ),
          ],
        );

        // Mobile
        if (isMobile) {
          return const Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            children: [
              titleWidget,
              actionsWidget,
            ],
          );
        }

        // Desktop / Tablet
        return const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 10,
          children: [
            titleWidget,
            actionsWidget,
          ],
        );
      },
    );
  }
}