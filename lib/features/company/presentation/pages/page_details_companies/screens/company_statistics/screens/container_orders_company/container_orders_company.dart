import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/company_statistics/screens/container_orders_company/data_container_orders_company.dart';

import '../../../../../../../../../../core/theming/colors.dart';

class ContainerOrdersCompany extends StatelessWidget {
  const ContainerOrdersCompany({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const DataContainerOrdersCompany(),
    );
  }
}
