import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/bloc/harag_cubit/harag_cubit.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/ui/view_car_harag/screens/list_view_car_harag.dart';
import '../../../../../../core/theming/colors.dart';

class ViewCarHarag extends StatelessWidget {
  const ViewCarHarag({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HaragCubit()
        ..getAllHarages(
          currentPage: 1,
        ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            body: SafeArea(
              child: RefreshIndicator(
                color: AppColors.orangeColor,
                onRefresh: () async {
                  await context.read<HaragCubit>().refresh();
                },
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: ListViewCarHarag(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}