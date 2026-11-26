import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/providers_page/data/model/get_all_providers_models/get_all_providers_models/get_all_providers_models.dart';

class MultiSelectProviderDropdown extends StatefulWidget {
  final List<GetAllProvidersModels> providers;
  final List<int> selectedProviderIds;
  final ValueChanged<List<int>> onSelectionChanged;
  final bool isLoading;
  final String? title;

  const MultiSelectProviderDropdown({
    super.key,
    required this.providers,
    required this.selectedProviderIds,
    required this.onSelectionChanged,
    this.isLoading = false,
    this.title,
  });

  @override
  State<MultiSelectProviderDropdown> createState() =>
      _MultiSelectProviderDropdownState();
}

class _MultiSelectProviderDropdownState
    extends State<MultiSelectProviderDropdown> {
  bool _isExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<GetAllProvidersModels> get _filteredProviders {
    if (_searchQuery.trim().isEmpty) {
      return widget.providers;
    }
    final query = _searchQuery.trim().toLowerCase();
    return widget.providers.where((provider) {
      final nameMatches = provider.name?.toLowerCase().contains(query) ?? false;
      final latinMatches =
          provider.latinName?.toLowerCase().contains(query) ?? false;
      final idMatches = provider.providerId.toString().contains(query);
      return nameMatches || latinMatches || idMatches;
    }).toList();
  }

  bool get _isAllSelected {
    if (widget.providers.isEmpty) return false;
    return widget.selectedProviderIds.length == widget.providers.length;
  }

  void _toggleSelectAll() {
    if (_isAllSelected) {
      widget.onSelectionChanged([]);
    } else {
      final allIds = widget.providers.map((p) => p.providerId).toList();
      widget.onSelectionChanged(allIds);
    }
  }

  void _toggleProvider(int providerId) {
    final updated = List<int>.from(widget.selectedProviderIds);
    if (updated.contains(providerId)) {
      updated.remove(providerId);
    } else {
      updated.add(providerId);
    }
    widget.onSelectionChanged(updated);
  }

  void _removeProvider(int providerId) {
    final updated = List<int>.from(widget.selectedProviderIds)
      ..remove(providerId);
    widget.onSelectionChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = widget.selectedProviderIds.length;
    final totalCount = widget.providers.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null) ...[
          TextInAppWidget(
            text: widget.title!,
            textSize: 13,
            textColor: AppColors.darkGreyColor,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
          ),
          const SizedBox(height: 6),
        ],

        // Trigger Button / Header
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _isExpanded
                      ? AppColors.orangeColor
                      : AppColors.darkColor.withValues(alpha: 0.2),
                  width: _isExpanded ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.store_mall_directory_outlined,
                    size: 20,
                    color: AppColors.orangeColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: widget.isLoading
                        ? Row(
                            children: [
                              const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.orangeColor,
                                ),
                              ),
                              SizedBox(width: 8),
                              TextInAppWidget(
                                text: LocaleKeys.loadingProviders.tr(),
                                textSize: 13,
                                textColor: AppColors.greyColor,
                              ),
                            ],
                          )
                        : TextInAppWidget(
                            text: selectedCount == 0
                                ? LocaleKeys.allProvidersCouponGeneral.tr()
                                : selectedCount == totalCount && totalCount > 0
                                    ? LocaleKeys.allProvidersSelected
                                        .tr(args: [totalCount.toString()])
                                    : LocaleKeys.someProvidersSelected.tr(
                                        args: [
                                            selectedCount.toString(),
                                            totalCount.toString()
                                          ]),
                            textSize: 13,
                            textColor: selectedCount == 0
                                ? AppColors.darkGreyColor
                                : AppColors.darkColor,
                            fontWeightIndex: selectedCount > 0
                                ? FontSelectionData.mediumFontFamily
                                : FontSelectionData.regularFontFamily,
                          ),
                  ),
                  if (selectedCount > 0)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.orangeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextInAppWidget(
                        text: '$selectedCount',
                        textSize: 12,
                        textColor: AppColors.orangeColor,
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                      ),
                    ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.darkGreyColor,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Expanded Dropdown Panel
        if (_isExpanded) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 280),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.darkColor.withValues(alpha: 0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkColor.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Search Field & Quick Select All
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.darkColor.withValues(alpha: 0.1),
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: LocaleKeys.searchByNameOrId.tr(),
                            hintStyle: TextStyle(
                              fontSize: 12,
                              color: AppColors.darkGreyColor
                                  .withValues(alpha: 0.6),
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 18,
                              color: AppColors.orangeColor,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      size: 16,
                                      color: AppColors.greyColor,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Select All Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: _toggleSelectAll,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Checkbox(
                                      value: _isAllSelected,
                                      activeColor: AppColors.orangeColor,
                                      onChanged: (_) => _toggleSelectAll(),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  TextInAppWidget(
                                    text: LocaleKeys.selectAll.tr(),
                                    textSize: 12,
                                    textColor: AppColors.darkColor,
                                    fontWeightIndex:
                                        FontSelectionData.mediumFontFamily,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (selectedCount > 0)
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => widget.onSelectionChanged([]),
                                child: TextInAppWidget(
                                  text: LocaleKeys.deselectAll.tr(),
                                  textSize: 11,
                                  textColor: AppColors.redColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1, thickness: 1),

                // Providers Scroll List
                Flexible(
                  child: _filteredProviders.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: TextInAppWidget(
                              text: LocaleKeys.noMatchingSearchResults.tr(),
                              textSize: 12,
                              textColor: AppColors.greyColor,
                            ),
                          ),
                        )
                      : Scrollbar(
                          thumbVisibility: true,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filteredProviders.length,
                            itemBuilder: (context, index) {
                              final provider = _filteredProviders[index];
                              final isSelected = widget.selectedProviderIds
                                  .contains(provider.providerId);

                              return ProviderSelectionTile(
                                provider: provider,
                                isSelected: isSelected,
                                onToggle: () =>
                                    _toggleProvider(provider.providerId),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],

        // Selected Chips Wrap
        if (selectedCount > 0 && selectedCount <= 12) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.selectedProviderIds.map((id) {
              final provider = widget.providers.firstWhere(
                (p) => p.providerId == id,
                orElse: () => GetAllProvidersModels(
                  providerId: id,
                  name: LocaleKeys.providerNumbered.tr(args: ['$id']),
                  totalOrders: 0,
                  isActive: true,
                ),
              );
              final displayName = provider.name ??
                  LocaleKeys.providerNumbered.tr(args: ['$id']);

              return SelectedProviderChip(
                providerId: id,
                name: displayName,
                onRemove: () => _removeProvider(id),
              );
            }).toList(),
          ),
        ] else if (selectedCount > 12) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.orangeColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextInAppWidget(
              text: LocaleKeys.someProvidersSelected.tr(args: [
                selectedCount.toString(),
                widget.providers.length.toString()
              ]),
              textSize: 11,
              textColor: AppColors.orangeColor,
              fontWeightIndex: FontSelectionData.mediumFontFamily,
            ),
          ),
        ],
      ],
    );
  }
}

class ProviderSelectionTile extends StatelessWidget {
  final GetAllProvidersModels provider;
  final bool isSelected;
  final VoidCallback onToggle;

  const ProviderSelectionTile({
    super.key,
    required this.provider,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = provider.name?.isNotEmpty == true
        ? provider.name!
        : (provider.latinName ??
            LocaleKeys.providerNumbered.tr(args: ['${provider.providerId}']));

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onToggle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.orangeColor.withValues(alpha: 0.05)
                : AppColors.transparent,
            border: Border(
              bottom: BorderSide(
                color: AppColors.darkColor.withValues(alpha: 0.05),
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: Checkbox(
                  value: isSelected,
                  activeColor: AppColors.orangeColor,
                  onChanged: (_) => onToggle(),
                ),
              ),
              const SizedBox(width: 8),
              // Provider Avatar or Icon
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.scaffoldColor,
                backgroundImage: provider.image != null
                    ? MemoryImage(provider.image!)
                    : null,
                child: provider.image == null
                    ? const Icon(
                        Icons.business,
                        size: 14,
                        color: AppColors.darkGreyColor,
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              // Name & Latin Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInAppWidget(
                      text: displayName,
                      textSize: 13,
                      textColor: AppColors.darkColor,
                      fontWeightIndex: isSelected
                          ? FontSelectionData.mediumFontFamily
                          : FontSelectionData.regularFontFamily,
                    ),
                    if (provider.latinName != null &&
                        provider.latinName != provider.name)
                      TextInAppWidget(
                        text: provider.latinName!,
                        textSize: 11,
                        textColor: AppColors.greyColor,
                      ),
                  ],
                ),
              ),
              // ID Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextInAppWidget(
                  text: '#${provider.providerId}',
                  textSize: 11,
                  textColor: AppColors.darkGreyColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectedProviderChip extends StatelessWidget {
  final int providerId;
  final String name;
  final VoidCallback onRemove;

  const SelectedProviderChip({
    super.key,
    required this.providerId,
    required this.name,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 4, right: 8, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.orangeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.orangeColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.store,
            size: 13,
            color: AppColors.orangeColor,
          ),
          const SizedBox(width: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 130),
            child: TextInAppWidget(
              text: name,
              textSize: 11,
              textColor: AppColors.orangeColor,
              fontWeightIndex: FontSelectionData.mediumFontFamily,
              isEllipsisTextOverflow: true,
            ),
          ),
          const SizedBox(width: 4),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: AppColors.orangeColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 10,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
