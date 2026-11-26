import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/widgets/app_pagination.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/widgets/custom_container.dart';
import '../../../../../../../core/widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/feature/cars_haraj_page/view_model/harag_cubit/harag_cubit.dart';
import 'package:web_admin_san/feature/cars_haraj_page/view_model/harag_cubit/harag_state.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/widget_design_list_harag.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/ui/page_details_harag/page_details_harag.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/text_empty_view_data.dart';

class ListCarsHarajPage extends StatelessWidget {
  final int userId;
  const ListCarsHarajPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HaragCubit, HaragState>(
      builder: (context, state) {
        if (state is UserHaragesLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is UserHaragesError) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is UserHaragesSuccess) {
          final data = state.response?.data;

          if (data == null) {
            return const Center(
              child: TextEmptyViewData(),
            );
          }

          final harages = data.data;

          if (harages.isEmpty) {
            return const Center(
              child: TextEmptyViewData(),
            );
          }

          return CustomContainer(
            isSelected: false,
            onTap: () {},
            typeWidget: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: harages.length,
                    separatorBuilder: (_, __) {
                      return const SizedBox(
                        height: 20,
                      );
                    },
                    itemBuilder: (context, index) {
                      final harag = harages[index];

                      return WidgetDesignListHarag(
                        haragId: harag.id?.toString() ?? '-',
                        name: harag.user?.getName(context) ?? '-',
                        nameButton: LocaleKeys.details,
                        image: harag.car?.carImage ?? harag.user?.image,
                        kilometers: harag.kilometers?.toString() ?? '0',
                        isNew: harag.isNew,
                        releaseDate: harag.releaseDate ?? '-',
                        isSold: harag.isSold,
                        sellDate: harag.sellDate ?? '-',
                        onTabDetails: () async {
                          final result = await Navigator.push(
                            context,
                            NavigateToPageWidget(
                              PageDetailsHarag(
                                harageId: harag.id ?? 0,
                              ),
                            ),
                          );

                          if (result == true && context.mounted) {
                            await context.read<HaragCubit>().getUserHarages(
                                  userId: userId,
                                  currentPage: 1,
                                );
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                AppPagination(
                  currentPage: data.currentPage ?? state.currentPage,
                  totalPages: data.pageCount ?? state.pageCount,
                  onPageChanged: (page) {
                    context.read<HaragCubit>().getUserHarages(
                          userId: userId,
                          currentPage: page,
                        );
                  },
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
