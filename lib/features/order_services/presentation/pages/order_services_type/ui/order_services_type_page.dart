import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/cars_haraj_page/data/model/internal_orders_filter/internal_orders_filter.dart';
import 'package:web_admin_san/features/internal_services/presentation/cubit/tabs_cubit/tabs_cubit.dart';
import 'package:web_admin_san/features/order_services/presentation/cubit/get_order_cubit/get_order_cubit.dart';
import '../../../../../../../../../../core/cubit/new_orders_cubit/new_orders_cubit.dart';
import '../../../../../../../../../../core/cubit/new_orders_cubit/new_orders_state.dart';
import '../widgets/orders_page_order_services_type.dart';

class OrderServicesTypePage extends StatelessWidget {
  const OrderServicesTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TabsCubit()),
        BlocProvider(create: (_) => NewOrdersCubit()),
        BlocProvider(
          create: (_) => GetOrderCubit()
            ..getOrders(
              orderType: mapOrderType(0),
            ),
        ),
      ],
      child:BlocBuilder<NewOrdersCubit, NewOrdersState>(
        buildWhen: (previous, current) {
          return current is NewOrdersInitial ||
              current is NewOrderDetails;
        },
        builder: (context, state) {
          final cubit = context.read<NewOrdersCubit>();

          return OrdersPageMobileServicesStatistics(
            cubit: cubit,
          );
        },
      ),
    );
  }
}