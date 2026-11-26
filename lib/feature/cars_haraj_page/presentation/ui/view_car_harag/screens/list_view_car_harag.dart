import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/widgets/app_active_filter_chip.dart';
import 'package:web_admin_san/core/widgets/app_pagination.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/core/widgets/empty_state_view.dart';
import 'package:web_admin_san/core/widgets/entity_filter_toolbar.dart';
import 'package:web_admin_san/core/widgets/error_state_view.dart';
import 'package:web_admin_san/core/widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/haraj_filter_criteria.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/ui/page_details_harag/page_details_harag.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/harag_filter_tabs_widget.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/haraj_filter_dialog.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/widget_design_list_harag.dart';
import 'package:web_admin_san/feature/cars_haraj_page/view_model/harag_cubit/harag_cubit.dart';
import 'package:web_admin_san/feature/cars_haraj_page/view_model/harag_cubit/harag_state.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class ListCarsHarajPage extends StatefulWidget {
  const ListCarsHarajPage({super.key});

  @override
  State<ListCarsHarajPage> createState() => _ListCarsHarajPageState();
}

class _ListCarsHarajPageState extends State<ListCarsHarajPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  HaragFilterTab _selectedTab = HaragFilterTab.all;
  HarajFilterCriteria _criteria = HarajFilterCriteria.empty;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _applyFiltersAndSearch({
    HarajFilterCriteria? newCriteria,
    int page = 1,
  }) {
    if (newCriteria != null) {
      setState(() {
        _criteria = newCriteria;
      });
    }

    bool? isNew = _criteria.isNew;
    int? status = _criteria.status;

    if (isNew == null && status == null) {
      switch (_selectedTab) {
        case HaragFilterTab.newCars:
          isNew = true;
          break;
        case HaragFilterTab.usedCars:
          isNew = false;
          break;
        case HaragFilterTab.soldCars:
          status = 3;
          break;
        case HaragFilterTab.all:
          break;
      }
    }

    context.read<HaragCubit>().getAllHarages(
          currentPage: page,
          isNew: isNew,
          status: status,
          search: _searchController.text.trim(),
          minPrice: _criteria.minPrice,
          maxPrice: _criteria.maxPrice,
          updateFilters: true,
        );
  }

  void _onTabSelected(HaragFilterTab tab) {
    if (_selectedTab == tab) return;

    setState(() {
      _selectedTab = tab;
      _criteria = HarajFilterCriteria.empty;
    });

    _applyFiltersAndSearch(page: 1);
  }

  void _openFilterDialog() {
    HarajFilterDialog.show(
      context,
      initialCriteria: _criteria,
      onApply: (newCriteria) {
        _applyFiltersAndSearch(newCriteria: newCriteria, page: 1);
      },
    );
  }

  void _clearConditionFilter() {
    _applyFiltersAndSearch(
      newCriteria: _criteria.copyWith(clearIsNew: true),
      page: 1,
    );
  }

  void _clearStatusFilter() {
    _applyFiltersAndSearch(
      newCriteria: _criteria.copyWith(clearStatus: true),
      page: 1,
    );
  }

  void _clearPriceFilter() {
    _applyFiltersAndSearch(
      newCriteria: _criteria.copyWith(
        clearMinPrice: true,
        clearMaxPrice: true,
      ),
      page: 1,
    );
  }

  void _clearAllFilters() {
    _applyFiltersAndSearch(
      newCriteria: HarajFilterCriteria.empty,
      page: 1,
    );
  }

  List<Widget> _buildActiveChips() {
    final chips = <Widget>[];

    if (_criteria.isNew != null) {
      chips.add(
        AppActiveFilterChip(
          label: _criteria.isNew! ? 'الحالة: جديدة' : 'الحالة: مستعملة',
          icon: Icons.directions_car_outlined,
          onDeleted: _clearConditionFilter,
        ),
      );
    }

    if (_criteria.status != null) {
      String statusText;
      switch (_criteria.status) {
        case 1:
          statusText = 'الاعتماد: بانتظار الموافقة';
          break;
        case 2:
          statusText = 'الاعتماد: مقبولة';
          break;
        case 3:
          statusText = 'الاعتماد: مرفوضة';
          break;
        default:
          statusText = 'الاعتماد: ${_criteria.status}';
      }
      chips.add(
        AppActiveFilterChip(
          label: statusText,
          icon: Icons.verified_outlined,
          onDeleted: _clearStatusFilter,
        ),
      );
    }

    if (_criteria.minPrice != null || _criteria.maxPrice != null) {
      String priceText;
      if (_criteria.minPrice != null && _criteria.maxPrice != null) {
        priceText = 'السعر: ${_criteria.minPrice!.toInt()} - ${_criteria.maxPrice!.toInt()} ر.س';
      } else if (_criteria.minPrice != null) {
        priceText = 'من: ${_criteria.minPrice!.toInt()} ر.س';
      } else {
        priceText = 'إلى: ${_criteria.maxPrice!.toInt()} ر.س';
      }

      chips.add(
        AppActiveFilterChip(
          label: priceText,
          icon: Icons.payments_outlined,
          onDeleted: _clearPriceFilter,
        ),
      );
    }

    if (_criteria.isNotEmpty) {
      chips.add(
        AppClearAllFiltersChip(onClearAll: _clearAllFilters),
      );
    }

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HaragCubit, HaragState>(
      builder: (context, state) {
        final totalCount =
            state is HaragSuccess ? state.response.totalCount : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EntityFilterToolbar(
              searchController: _searchController,
              searchHint: 'البحث باسم السيارة، الماركة، رقم اللوحة...',
              onSearchChanged: (val) => _applyFiltersAndSearch(page: 1),
              onSearchSubmitted: () => _applyFiltersAndSearch(page: 1),
              onSearchCleared: () => _applyFiltersAndSearch(page: 1),
              onOpenFilterDialog: _openFilterDialog,
              activeFiltersCount: _criteria.activeFiltersCount,
              activeChips: _buildActiveChips(),
              totalCount: totalCount,
              countLabel: 'إجمالي سيارات الحراج',
              countIcon: Icons.directions_car_outlined,
            ),
            HaragFilterTabsWidget(
              selectedTab: _selectedTab,
              onTabChanged: _onTabSelected,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (state is HaragLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is HaragError) {
                    return ErrorStateView(
                      message: state.message,
                      onRetry: () => _applyFiltersAndSearch(page: 1),
                    );
                  }

                  if (state is HaragSuccess) {
                    final response = state.response;
                    final data = response.data;

                    if (data.isEmpty) {
                      return const EmptyStateView(
                        message: LocaleKeys.no_haraj_ads_currently,
                        icon: Icons.directions_car_outlined,
                      );
                    }

                    return CustomContainer(
                      isSelected: false,
                      onTap: () {},
                      typeWidget: Column(
                        children: [
                          Expanded(
                            child: Scrollbar(
                              controller: _scrollController,
                              thumbVisibility: true,
                              child: ListView.separated(
                                controller: _scrollController,
                                itemCount: data.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  final item = data[index];
                                  return MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: WidgetDesignListHarag(
                                      haragId: item.id?.toString(),
                                      name: item.car?.name ??
                                          item.car?.modelName ??
                                          '',
                                      releaseDate: item.releaseDate?.toString(),
                                      kilometers: item.kilometers?.toString(),
                                      sellDate: item.sellDate,
                                      isNew: item.isNew,
                                      status: item.status,
                                      isSold: item.isSold,
                                      image: item.images.isNotEmpty
                                          ? item.images.first
                                          : null,
                                      nameButton: LocaleKeys.details,
                                      onTabDetails: () async {
                                        final itemId = item.id;
                                        if (itemId == null) return;
                                        await Navigator.push(
                                          context,
                                          NavigateToPageWidget(
                                            PageDetailsHarag(
                                              harageId: itemId.toInt(),
                                            ),
                                          ),
                                        );

                                        if (context.mounted) {
                                          _applyFiltersAndSearch(
                                            page: response.currentPage,
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppPagination(
                            currentPage: response.currentPage,
                            totalPages: response.pageCount,
                            onPageChanged: (page) {
                              _applyFiltersAndSearch(page: page);
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
