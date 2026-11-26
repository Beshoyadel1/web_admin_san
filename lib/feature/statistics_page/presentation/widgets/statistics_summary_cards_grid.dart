import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_admin_dashboard_statistics_model/get_admin_dashboard_statistics_model.dart';

class StatisticsSummaryCardsGrid extends StatelessWidget {
  final Summary summary;

  const StatisticsSummaryCardsGrid({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _CardItemData(
        title: 'عدد الطلبات',
        value: '${summary.totalOrders} طلب',
        icon: Icons.bar_chart_rounded,
      ),
      _CardItemData(
        title: 'عدد العملاء',
        value: '${summary.totalCustomers} عميل',
        icon: Icons.bar_chart_rounded,
      ),
      _CardItemData(
        title: 'عدد الشركات',
        value: '${summary.totalCompanies} شركة',
        icon: Icons.bar_chart_rounded,
      ),
      _CardItemData(
        title: 'مزودي الخدمة',
        value: '${summary.totalServiceProviders} مراكز الخدمة',
        icon: Icons.bar_chart_rounded,
      ),
      _CardItemData(
        title: 'مبيعات الطلبات',
        value: '${summary.totalOrderSales} ريال',
        icon: Icons.bar_chart_rounded,
      ),
      _CardItemData(
        title: 'تأمينات السيارات',
        value: '${summary.totalCarInsurances} تأمين',
        icon: Icons.bar_chart_rounded,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;
        final cardWidth =
            isNarrow ? constraints.maxWidth : (constraints.maxWidth - 24) / 3;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items.map((item) {
            return SizedBox(
              width: cardWidth,
              child: _StatisticsKpiCard(data: item),
            );
          }).toList(),
        );
      },
    );
  }
}

class _CardItemData {
  final String title;
  final String value;
  final IconData icon;

  const _CardItemData({
    required this.title,
    required this.value,
    required this.icon,
  });
}

class _StatisticsKpiCard extends StatelessWidget {
  final _CardItemData data;

  const _StatisticsKpiCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppColors.lightGreyColor.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkColor.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGreyColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.orangeColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.orangeColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                data.icon,
                color: AppColors.whiteColor,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
