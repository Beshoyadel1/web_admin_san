import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/multi_select_provider_dropdown.dart';
import 'package:web_admin_san/feature/providers_page/data/model/get_all_providers_models/get_all_providers_models/get_all_providers_models.dart';

class CouponProviderSelectionSection extends StatelessWidget {
  final List<GetAllProvidersModels> providers;
  final List<int> selectedProviderIds;
  final ValueChanged<List<int>> onSelectionChanged;
  final bool isLoading;

  const CouponProviderSelectionSection({
    super.key,
    required this.providers,
    required this.selectedProviderIds,
    required this.onSelectionChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.darkColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.business_center_outlined,
                size: 18,
                color: AppColors.orangeColor,
              ),
              SizedBox(width: 6),
              TextInAppWidget(
                text: LocaleKeys.customizeServiceProviders,
                textSize: 14,
                fontWeightIndex: FontSelectionData.boldFontFamily,
                textColor: AppColors.darkColor,
              ),
            ],
          ),
          const SizedBox(height: 6),
          const TextInAppWidget(
            text: LocaleKeys.customizeProvidersHint,
            textSize: 12,
            textColor: AppColors.darkGreyColor,
          ),
          const SizedBox(height: 12),
          MultiSelectProviderDropdown(
            providers: providers,
            selectedProviderIds: selectedProviderIds,
            onSelectionChanged: onSelectionChanged,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
