import 'package:flutter/material.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/features/company/data/model/get_company_general_statistics_model/get_company_general_statistics_model.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/row_circle_color_text_percentage_widget.dart';

class ServicesLegendList extends StatelessWidget {
  final List<ServiceChart> services;

  const ServicesLegendList({
    super.key,
    required this.services,
  });

  List<ServiceChart> get _sortedServices {
    final sorted = List<ServiceChart>.from(services);

    sorted.sort(
          (a, b) => b.value.compareTo(a.value),
    );

    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    if (services.isEmpty) {
      return const SizedBox();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _sortedServices.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final service = _sortedServices[index];

        final title = isArabic
            ? service.serviceName
            : service.serviceLatinName;

        return RowCircleColorTextPercentageWidget(
          colorCircle: legendColor(index),
          text: title,
          percentage: "${service.percentage.toDouble().toStringAsFixed(1)}%",
        );
      },
    );
  }
}