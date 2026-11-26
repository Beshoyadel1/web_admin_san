import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/cars_haraj_page/view_model/harag_cubit/harag_cubit.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/ui/page_details_harag/list_view_page_details_harag.dart';

class PageDetailsHarag extends StatelessWidget {
  const PageDetailsHarag({
    super.key,
    required this.harageId,
  });

  final int harageId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HaragCubit()
        ..getHarageDetails(
          harageId: harageId,
        ),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(
            color: AppColors.darkColor,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: SingleChildScrollView(
              child: ListViewPageDetailsHarag(
                harageId: harageId,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
