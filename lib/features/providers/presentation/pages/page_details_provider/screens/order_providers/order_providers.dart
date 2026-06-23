import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/order_providers/screens/orders_page_provider.dart';
import '../../../../../../../../../core/cubit/new_orders_cubit/new_orders_cubit.dart';
import '../../../../../../../../../core/cubit/new_orders_cubit/new_orders_state.dart';


class OrderProviders extends StatelessWidget {
  final int providerId;
  const OrderProviders({super.key,required this.providerId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewOrdersCubit(),
      child: BlocBuilder<NewOrdersCubit, NewOrdersState>(
        buildWhen: (previous, current) {
          return current is NewOrdersInitial ||
              current is NewOrderDetails;
        },
        builder: (context, state) {
          final cubit = context.read<NewOrdersCubit>();

          // if (state is NewOrderDetails) {
          //   return const OrderDetailsPage();
          // }

          return OrdersPageProvider(cubit: cubit,providerId: providerId,);
        },
      ),
    );
  }
}
