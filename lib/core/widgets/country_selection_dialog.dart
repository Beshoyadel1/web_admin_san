import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';

class CountrySelectionDialog extends StatefulWidget {
  final String? initialCountryCode;
  final String? title;
  final bool showDialCode;

  const CountrySelectionDialog({
    super.key,
    this.initialCountryCode,
    this.title,
    this.showDialCode = true,
  });

  @override
  State<CountrySelectionDialog> createState() => _CountrySelectionDialogState();
}

class _CountrySelectionDialogState extends State<CountrySelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Country> _filtered = [];

  static const List<String> _priorityCodes = [
    'SA',
    'EG',
    'AE',
    'KW',
    'OM',
    'QA',
    'BH',
    'JO',
    'LB',
    'SY',
    'IQ',
    'YE',
    'SD',
    'MA',
    'TN',
    'DZ',
  ];

  static List<Country> _getSortedCountries() {
    final priority = <Country>[];
    final others = <Country>[];

    for (final c in countries) {
      if (_priorityCodes.contains(c.code.toUpperCase())) {
        priority.add(c);
      } else {
        others.add(c);
      }
    }

    return [...priority, ...others];
  }

  @override
  void initState() {
    super.initState();
    _filtered = _getSortedCountries();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    final lang = context.locale.languageCode;

    setState(() {
      if (query.isEmpty) {
        _filtered = _getSortedCountries();
      } else {
        _filtered = countries.where((c) {
          final name = c.name.toLowerCase();
          final localized = c.localizedName(lang).toLowerCase();
          final dialCode = c.dialCode.toLowerCase();
          final code = c.code.toLowerCase();

          return name.contains(query) ||
              localized.contains(query) ||
              dialCode.contains(query) ||
              code.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;

    return Dialog(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 460,
          maxHeight: 560,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextInAppWidget(
                    text: widget.title ?? LocaleKeys.selectCountry,
                    textSize: 17,
                    fontWeightIndex: FontSelectionData.boldFontFamily,
                    textColor: AppColors.darkColor,
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.darkGreyColor,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Search field
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: LocaleKeys.searchCountry.tr(),
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.darkGreyColor,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 20,
                    color: AppColors.darkGreyColor,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            size: 18,
                            color: AppColors.darkGreyColor,
                          ),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.greyColorSearch,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.cardStroke,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.orangeColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Countries List
              Expanded(
                child: _filtered.isEmpty
                    ? const Center(
                        child: TextInAppWidget(
                          text: LocaleKeys.notFound,
                          textSize: 14,
                          textColor: AppColors.darkGreyColor,
                        ),
                      )
                    : Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: ListView.separated(
                          controller: _scrollController,
                          itemCount: _filtered.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 1,
                            color: AppColors.cardStroke,
                          ),
                          itemBuilder: (context, index) {
                            final country = _filtered[index];
                            final isSelected =
                                _isCountrySelected(country, lang);

                            return MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 2,
                                ),
                                onTap: () => Navigator.of(context).pop(country),
                                leading: Text(
                                  country.flag,
                                  style: const TextStyle(fontSize: 22),
                                ),
                                title: Text(
                                  country.localizedName(lang),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? AppColors.orangeColor
                                        : AppColors.darkColor,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (widget.showDialCode)
                                      Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Text(
                                          '+${country.dialCode}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.darkGreyColor,
                                          ),
                                        ),
                                      ),
                                    if (isSelected) ...[
                                      if (widget.showDialCode)
                                        const SizedBox(width: 8),
                                      const Icon(
                                        Icons.check_circle,
                                        size: 18,
                                        color: AppColors.orangeColor,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isCountrySelected(Country country, String lang) {
    if (widget.initialCountryCode == null ||
        widget.initialCountryCode!.trim().isEmpty) {
      return false;
    }
    final clean = widget.initialCountryCode!.trim().toLowerCase();
    if (clean == country.code.toLowerCase()) return true;
    if (clean == country.dialCode.toLowerCase()) return true;
    if (clean == '+${country.dialCode}'.toLowerCase()) return true;
    if (clean == country.name.toLowerCase()) return true;
    if (clean == country.localizedName(lang).toLowerCase()) return true;
    for (final trans in country.nameTranslations.values) {
      if (clean == trans.toLowerCase()) return true;
    }
    return false;
  }
}
