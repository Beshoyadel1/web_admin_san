import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/features/users/presentation/pages/page_details_user/screens/view_car_data_user.dart';
import 'package:web_admin_san/features/users/presentation/pages/page_details_user/screens/view_data_user.dart';
import 'package:web_admin_san/features/users/presentation/pages/page_details_user/screens/view_order_user.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/features/users/presentation/bloc/user_details_cubit/user_details_cubit.dart';
import 'package:web_admin_san/features/users/presentation/bloc/user_details_cubit/user_details_state.dart';
import 'package:web_admin_san/features/users/presentation/pages/page_details_user/screens/view_car_data_user.dart';
import 'package:web_admin_san/features/users/presentation/pages/page_details_user/screens/view_data_user.dart';
import 'package:web_admin_san/features/users/presentation/pages/page_details_user/screens/view_order_user.dart';

class ListDataPageDetailsUser extends StatelessWidget {
  const ListDataPageDetailsUser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDetailsCubit, UserDetailsState>(
      builder: (context, state) {

        // =====================================================
        // ONE LOADING ONLY
        // =====================================================

        if (state is UserDetailsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // =====================================================
        // ONE ERROR ONLY
        // =====================================================

        if (state is UserDetailsFailure) {
          return Center(
            child: Text(state.error),
          );
        }

        // =====================================================
        // SUCCESS
        // =====================================================

        if (state is UserDetailsSuccess) {
          return CustomContainer(
            isSelected: false,
            onTap: () {},
            typeWidget: const Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ViewDataUser(),
                ViewCarDataUser(),
                ViewOrderUser(),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}