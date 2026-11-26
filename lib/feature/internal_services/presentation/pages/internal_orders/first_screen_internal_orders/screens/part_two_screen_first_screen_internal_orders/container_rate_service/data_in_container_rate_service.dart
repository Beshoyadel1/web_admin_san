import 'package:flutter/cupertino.dart';

import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/first_screen_internal_orders/screens/part_two_screen_first_screen_internal_orders/container_rate_service/first_row_in_data_in_container_rate_service.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/first_screen_internal_orders/screens/part_two_screen_first_screen_internal_orders/container_rate_service/second_row_in_data_in_container_rate_service.dart';

class DataInContainerRateService extends StatelessWidget {
  const DataInContainerRateService({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FirstRowInDataInContainerRateService(),
        SecondRowInDataInContainerRateService()
      ],
    );
  }
}
