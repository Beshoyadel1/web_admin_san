import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/features/admins/presentation/bloc/admins_cubit/admins_cubit.dart';
import 'package:web_admin_san/features/admins/presentation/bloc/admins_cubit/admins_state.dart';
import 'package:web_admin_san/features/admins/presentation/custom_widget/custom_view_all_admins_list_widget.dart';
import 'package:web_admin_san/features/admins/presentation/pages/page_details_admins/page_details_admins.dart';
import 'package:web_admin_san/features/internal_services/presentation/cubit/order_funcations/order_functions.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import 'package:web_admin_san/features/order_services/presentation/custom_widget/app_pagination.dart';

class ListDataViewAllAdmins extends StatelessWidget {
  const ListDataViewAllAdmins({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminsCubit, AdminsState>(
      builder: (
        context,
        state,
      ) {
        if (state is AdminsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // =========================================
        // ERROR
        // =========================================

        if (state is AdminsError) {
          return Center(
            child: Text(
              state.error,
            ),
          );
        }

        // =========================================
        // SUCCESS
        // =========================================

        if (state is AdminsSuccess) {
          // =======================================
          // EMPTY
          // =======================================

          if (state.admins.isEmpty) {
            return const Center(
              child: TextEmptyViewData(),
            );
          }

          // =======================================
          // DATA
          // =======================================

          return CustomContainer(
            isSelected: false,
            onTap: () {},
            typeWidget: Column(
              children: [
                // ===================================
                // ADMINS LIST
                // ===================================

                Expanded(
                  child: ListView.separated(
                    itemCount: state.admins.length,
                    separatorBuilder: (
                      _,
                      __,
                    ) {
                      return const SizedBox(
                        height: 20,
                      );
                    },
                    itemBuilder: (
                      context,
                      index,
                    ) {
                      final admin = state.admins[index];

                      return CustomViewAllAdminsListWidget(
                        id: admin.adminId?.toString(),
                        nameAdmin: admin.userName ?? '',
                        email: admin.email ?? '',
                        phone: admin.phone ?? '',
                        image: admin.image,
                        isActive: admin.isActive??false,
                        joinDate: OrderFunctions.formatDateFromDateTime(
                            admin.joinDate),
                        onTapDetails: () async {
                          if (admin.adminId == null) return;

                          final result = await Navigator.push(
                            context,
                            NavigateToPageWidget(
                              PageDetailsAdmin(
                                adminId: admin.adminId!,
                              ),
                            ),
                          );

                          if (result == true && context.mounted) {
                            await context.read<AdminsCubit>().getAllAdmins(currentPage: 1);
                          }
                        },
                      );
                    },
                  ),
                ),

                // ===================================
                // PAGINATION
                // ===================================

                AppPagination(
                  currentPage: state.currentPage,
                  totalPages: state.pageCount,
                  onPageChanged: (
                    page,
                  ) {
                    context.read<AdminsCubit>().getAllAdmins(
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
