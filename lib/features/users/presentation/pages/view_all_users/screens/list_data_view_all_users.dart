import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/features/internal_services/presentation/cubit/order_funcations/order_functions.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import 'package:web_admin_san/features/order_services/presentation/custom_widget/app_pagination.dart';
import 'package:web_admin_san/features/users/presentation/bloc/get_all_users_cubit/get_all_users_cubit.dart';
import 'package:web_admin_san/features/users/presentation/bloc/get_all_users_cubit/get_all_users_state.dart';
import 'package:web_admin_san/features/users/presentation/custom_widget/custom_view_all_users_list_widget.dart';
import 'package:web_admin_san/features/users/presentation/pages/page_details_user/page_details_user.dart';

class ListDataViewAllUsers extends StatelessWidget {
  const ListDataViewAllUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllUsersCubit, GetAllUsersState>(
      builder: (context, state) {
        if (state is GetAllUsersLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is GetAllUsersError) {
          return Center(
            child: Text(
              state.error,
            ),
          );
        }

        if (state is GetAllUsersSuccess) {
          if (state.users.isEmpty) {
            return const Center(
              child: TextEmptyViewData(),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: state.users.length,
                  separatorBuilder: (_, __) => const SizedBox(
                    height: 20,
                  ),
                  itemBuilder: (context, index) {
                    final user = state.users[index];

                    return CustomViewAllUsersListWidget(
                      id: user.userId.toString(),
                      nameProvider: user.userName ?? '',
                      nameButton: AppLanguageKeys.details,
                      imageProvider: user.image,
                      lastOrderDate: user.lastOrderProvider != null
                          ? OrderFunctions.formatDateFromDateTime(
                              user.lastOrderProvider,
                            )
                          : '-',
                      joinDate: user.joinDate != null
                          ? OrderFunctions.formatDateFromDateTime(
                        user.joinDate,
                      )
                          : '-',
                      onTapViewRates: () {
                        Navigator.push(
                          context,
                          NavigateToPageWidget(
                            PageDetailsUser(
                              userId: user.userId,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              AppPagination(
                currentPage: state.currentPage,
                totalPages: state.pageCount,
                onPageChanged: (page) {
                  context.read<GetAllUsersCubit>().getAllUsers(
                        currentPage: page,
                      );
                },
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
