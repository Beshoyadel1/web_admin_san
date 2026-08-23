import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';

import 'package:web_admin_san/features/cars_haraj_page/presentation/bloc/harag_cubit/harag_cubit.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/bloc/harag_cubit/harag_state.dart';

import 'package:web_admin_san/features/cars_haraj_page/presentation/custom_widget/widget_design_list_harag.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/ui/page_details_harag/page_details_harag.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/ui/page_details_provider_harag/page_details_provider_harag.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import 'package:web_admin_san/features/order_services/presentation/custom_widget/app_pagination.dart';

class ListViewCarHarag extends StatelessWidget {
  const ListViewCarHarag({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HaragCubit, HaragState>(
      builder: (context, state) {
        if (state is HaragLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is HaragError) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is HaragSuccess) {
          final response = state.response;
          final data = response.data;

          if (data.isEmpty) {
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
                    itemCount: data.length,
                    separatorBuilder: (_, __) {
                      return const SizedBox(
                        height: 20,
                      );
                    },
                    itemBuilder: (context, index) {
                      final harag = data[index];

                      return WidgetDesignListHarag(
                        haragId: harag.id?.toString() ?? '-',
                        name: harag.user?.getName(context) ?? '-',
                        nameButton: AppLanguageKeys.details,
                        image: harag.car?.carImage ?? harag.user?.image,
                        kilometers: harag.kilometers?.toString() ?? '0',
                        isNew: harag.isNew,
                        releaseDate: harag.releaseDate ?? '-',
                        isSold: harag.isSold,
                        sellDate: harag.sellDate ?? '-',
                        onTabDetails: () {
                          Navigator.push(
                            context,
                            NavigateToPageWidget(
                              PageDetailsHarag(
                                harageId: harag.id ?? 0,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                AppPagination(
                  currentPage: response.currentPage,
                  totalPages: response.pageCount,
                  onPageChanged: (page) {
                    context.read<HaragCubit>().getAllHarages(
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