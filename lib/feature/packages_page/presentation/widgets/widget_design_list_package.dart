import 'package:flutter/material.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/packages_page/presentation/widgets/package_card_action_button.dart';
import 'package:web_admin_san/feature/packages_page/presentation/widgets/package_column_data.dart';
import 'package:web_admin_san/feature/packages_page/presentation/widgets/package_tablet_mobile_card.dart';

class WidgetDesignListPackage extends StatefulWidget {
  const WidgetDesignListPackage({
    super.key,
    this.packageId,
    this.packageName,
    this.packageLatinName,
    this.monthlyPrice,
    this.annualPrice,
    this.description,
    this.latinDescription,
    this.onTapDetails,
    this.onTapEdit,
    this.onTapDelete,
  });

  final String? packageId;
  final String? packageName;
  final String? packageLatinName;
  final double? monthlyPrice;
  final double? annualPrice;
  final String? description;
  final String? latinDescription;
  final VoidCallback? onTapDetails;
  final VoidCallback? onTapEdit;
  final VoidCallback? onTapDelete;

  @override
  State<WidgetDesignListPackage> createState() =>
      _WidgetDesignListPackageState();
}

class _WidgetDesignListPackageState extends State<WidgetDesignListPackage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatPrice(double? price) {
    if (price == null) return '0';
    return price.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Tablet & Mobile View (< 1100px)
        if (constraints.maxWidth < 1100) {
          return PackageTabletMobileCard(
            packageId: widget.packageId,
            packageName: widget.packageName,
            packageLatinName: widget.packageLatinName,
            monthlyPrice: widget.monthlyPrice,
            annualPrice: widget.annualPrice,
            description: widget.description,
            latinDescription: widget.latinDescription,
            onTapDetails: widget.onTapDetails,
            onTapEdit: widget.onTapEdit,
            onTapDelete: widget.onTapDelete,
          );
        }

        // Large Desktop View (≥ 1100px)
        return CustomContainer(
          isSelected: false,
          onTap: () {},
          borderRadius: BorderRadius.circular(14),
          containerWidth: double.infinity,
          typeWidget: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1. Package Identifier (المعرف)
                    PackageColumnData(
                      title: LocaleKeys.identifier,
                      value: widget.packageId != null
                          ? '#${widget.packageId}'
                          : '---',
                      width: 80,
                    ),
                    const SizedBox(width: 16),

                    // 2. Arabic Name
                    PackageColumnData(
                      title: LocaleKeys.packageName,
                      value: widget.packageName ?? '---',
                      width: 150,
                    ),
                    const SizedBox(width: 16),

                    // 3. English Name
                    PackageColumnData(
                      title: LocaleKeys.packageLatinName,
                      value: widget.packageLatinName ?? '---',
                      width: 150,
                    ),
                    const SizedBox(width: 16),

                    // 4. Monthly Price
                    PackageColumnData(
                      title: LocaleKeys.monthlyPrice,
                      value: _formatPrice(widget.monthlyPrice),
                      width: 110,
                    ),
                    const SizedBox(width: 16),

                    // 5. Annual Price
                    PackageColumnData(
                      title: LocaleKeys.annualPrice,
                      value: _formatPrice(widget.annualPrice),
                      width: 110,
                    ),
                    const SizedBox(width: 16),

                    // 6. Arabic Description
                    PackageColumnData(
                      title: LocaleKeys.packageDescription,
                      value: widget.description ?? '---',
                      width: 220,
                      isDescription: true,
                    ),
                    const SizedBox(width: 16),

                    // 7. English Description
                    PackageColumnData(
                      title: LocaleKeys.packageLatinDisc,
                      value: widget.latinDescription ?? '---',
                      width: 220,
                      isDescription: true,
                    ),
                    const SizedBox(width: 24),

                    // 8. Actions
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PackageCardActionButton(
                          text: LocaleKeys.details,
                          icon: Icons.visibility_outlined,
                          color: AppColors.seaBlueColor,
                          onTap: widget.onTapDetails,
                          width: 85,
                        ),
                        const SizedBox(width: 8),
                        PackageCardActionButton(
                          text: LocaleKeys.edit,
                          icon: Icons.edit_outlined,
                          color: AppColors.orangeColor,
                          onTap: widget.onTapEdit,
                          width: 80,
                        ),
                        const SizedBox(width: 8),
                        PackageCardActionButton(
                          text: LocaleKeys.delete,
                          icon: Icons.delete_outline,
                          color: AppColors.redColor,
                          onTap: widget.onTapDelete,
                          width: 80,
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
