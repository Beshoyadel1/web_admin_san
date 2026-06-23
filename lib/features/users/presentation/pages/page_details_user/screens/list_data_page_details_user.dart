import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/features/internal_services/presentation/cubit/order_funcations/order_functions.dart';
import 'package:web_admin_san/features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import 'package:web_admin_san/features/providers/presentation/custom_widget/custom_view_all_provider_list_widget.dart';
import 'package:web_admin_san/features/order_services/presentation/custom_widget/app_pagination.dart';
import 'package:web_admin_san/features/users/presentation/bloc/get_all_users_cubit/get_all_users_cubit.dart';
import 'package:web_admin_san/features/users/presentation/bloc/get_all_users_cubit/get_all_users_state.dart';
import 'package:web_admin_san/features/users/presentation/bloc/user_details_cubit/user_details_cubit.dart';
import 'package:web_admin_san/features/users/presentation/custom_widget/custom_view_all_users_list_widget.dart';
import 'package:web_admin_san/features/users/presentation/pages/page_details_user/screens/view_car_data_user.dart';
import 'package:web_admin_san/features/users/presentation/pages/page_details_user/screens/view_data_user.dart';
import 'package:web_admin_san/features/users/presentation/pages/page_details_user/screens/view_order_user.dart';

class ListDataPageDetailsUser extends StatelessWidget {
  final int userId;

  const ListDataPageDetailsUser({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserDetailsCubit()
        ..getUserDetails(
          userId: userId,
        ),
      child: const Column(
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
}
