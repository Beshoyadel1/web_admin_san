import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/company_statistics/screens/part_two_screen_first_screen_company_statistics/petrol_consumption_company/data_in_container_petrol_consumption_company.dart';
import '../../../../../../../../../../core/helpers/colors/app_colors.dart';

class ContainerPetrolConsumptionCompany extends StatelessWidget {
  const ContainerPetrolConsumptionCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsGeometry.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.greyColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const DataInContainerPetrolConsumptionCompany(),
    );
  }
}
