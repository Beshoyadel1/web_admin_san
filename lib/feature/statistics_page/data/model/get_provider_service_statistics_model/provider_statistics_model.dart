import 'provider_service_chart_item.dart';
import 'summary_card.dart';

class ProviderStatisticsModel {
  final List<SummaryCard> summaryCards;
  final List<ProviderServiceChartItem> chart;

  ProviderStatisticsModel({
    required this.summaryCards,
    this.chart = const [],
  });

  factory ProviderStatisticsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return ProviderStatisticsModel(
      summaryCards: (data['summaryCards'] as List<dynamic>? ?? [])
          .map((e) => SummaryCard.fromJson(e))
          .toList(),
      chart: (data['chart'] as List<dynamic>? ?? [])
          .map((e) => ProviderServiceChartItem.fromJson(e))
          .toList(),
    );
  }
}
