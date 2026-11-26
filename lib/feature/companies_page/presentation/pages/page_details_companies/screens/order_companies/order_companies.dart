import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/order_companies/screens/orders_page_companies.dart';
import 'package:web_admin_san/feature/internal_services/view_model/new_orders_cubit/new_orders_cubit.dart';
import 'package:web_admin_san/feature/internal_services/view_model/new_orders_cubit/new_orders_state.dart';

class OrderCompanies extends StatelessWidget {
  final int companyId;
  const OrderCompanies({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewOrdersCubit(),
      child: BlocBuilder<NewOrdersCubit, NewOrdersState>(
        buildWhen: (previous, current) {
          return current is NewOrdersInitial || current is NewOrderDetails;
        },
        builder: (context, state) {
          final cubit = context.read<NewOrdersCubit>();
          return OrdersPageCompanies(
            cubit: cubit,
            companyId: companyId,
          );
        },
      ),
    );
  }
}
