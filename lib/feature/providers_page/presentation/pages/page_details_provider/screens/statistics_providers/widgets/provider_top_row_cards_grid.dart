import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_provider_service_statistics_model/summary_card.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'provider_service_kpi_card.dart';

class ProviderTopRowCardsGrid extends StatelessWidget {
  final List<SummaryCard> summaryCards;

  const ProviderTopRowCardsGrid({
    super.key,
    required this.summaryCards,
  });

  Color _getServiceColor(String name, int index) {
    final lower = name.toLowerCase();
    if (lower.contains('صيان') || lower.contains('repair')) {
      return AppColors.orangeColor;
    } else if (lower.contains('نقل') ||
        lower.contains('متنقل') ||
        lower.contains('transport')) {
      return AppColors.seaBlueColor;
    } else if (lower.contains('غيار') || lower.contains('spare')) {
      return AppColors.darkGreyColor;
    } else if (lower.contains('باق') || lower.contains('package')) {
      return AppColors.chartTeal;
    } else if (lower.contains('بترول') ||
        lower.contains('petrol') ||
        lower.contains('زيت') ||
        lower.contains('oil')) {
      return AppColors.darkorangeColor;
    }

    final colors = [
      AppColors.orangeColor,
      AppColors.seaBlueColor,
      AppColors.darkGreyColor,
      AppColors.chartTeal,
      AppColors.darkorangeColor,
    ];
    return colors[index % colors.length];
  }

  String _getServiceImage(String name, int index) {
    final lower = name.toLowerCase();
    if (lower.contains('صيان') || lower.contains('repair')) {
      return AppImageKeys.carServices;
    } else if (lower.contains('نقل') ||
        lower.contains('متنقل') ||
        lower.contains('transport')) {
      return AppImageKeys.truckBox;
    } else if (lower.contains('غيار') || lower.contains('spare')) {
      return AppImageKeys.spare;
    } else if (lower.contains('باق') || lower.contains('package')) {
      return AppImageKeys.packages;
    } else if (lower.contains('بترول') ||
        lower.contains('petrol') ||
        lower.contains('زيت') ||
        lower.contains('oil')) {
      return AppImageKeys.oils;
    }

    final images = [
      AppImageKeys.carServices,
      AppImageKeys.truckBox,
      AppImageKeys.spare,
      AppImageKeys.packages,
      AppImageKeys.oils,
    ];
    return images[index % images.length];
  }

  String _getServiceCountUnit(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('قطع') ||
        lower.contains('غيار') ||
        lower.contains('spare')) {
      return LocaleKeys.piece.tr();
    } else if (lower.contains('باق') || lower.contains('package')) {
      return LocaleKeys.packageUnit.tr();
    }
    return LocaleKeys.order.tr();
  }

  @override
  Widget build(BuildContext context) {
    if (summaryCards.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        const double spacing = 12.0;

        int itemsPerRow;
        if (totalWidth >= 1200) {
          itemsPerRow = summaryCards.length <= 5 ? summaryCards.length : 5;
        } else if (totalWidth >= 800) {
          itemsPerRow = 3;
        } else if (totalWidth >= 550) {
          itemsPerRow = 2;
        } else {
          itemsPerRow = 1;
        }

        if (itemsPerRow <= 0) itemsPerRow = 1;

        final cardWidth =
            (totalWidth - ((itemsPerRow - 1) * spacing)) / itemsPerRow;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(summaryCards.length, (i) {
            final card = summaryCards[i];
            final title = card.serviceName ??
                '${LocaleKeys.serviceDefault.tr()} ${i + 1}';
            final color = _getServiceColor(title, i);
            final image = _getServiceImage(title, i);
            final countUnit = _getServiceCountUnit(title);

            return SizedBox(
              width: cardWidth,
              child: ProviderServiceKpiCard(
                title: title,
                orderCount: card.orderCount ?? 0,
                totalAmount: card.totalAmount ?? 0.0,
                percentage: card.percentageChange ?? 0.0,
                isIncrease: card.isIncrease ?? true,
                primaryColor: color,
                image: image,
                countUnit: countUnit,
              ),
            );
          }),
        );
      },
    );
  }
}
