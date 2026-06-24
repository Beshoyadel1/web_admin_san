import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../../core/cubit/new_orders_cubit/new_orders_cubit.dart';
import '../../../../../../../../../core/cubit/new_orders_cubit/new_orders_state.dart';
import 'screens/car_orders_page.dart';

class CarHarajOrdersPage extends StatelessWidget {
  final int providerID;

  const CarHarajOrdersPage({super.key,required this.providerID});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => NewOrdersCubit(),
        child: BlocBuilder<NewOrdersCubit, NewOrdersState>(
            builder: (context, state) {
          final cubit = context.read<NewOrdersCubit>();
          if (state is NewOrdersInitial) {
            return CarOrdersPage(cubit: cubit,providerID: providerID,);
          } else {
            return const SizedBox();
          }
        }));
  }
}
