import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';

import 'package:web_admin_san/features/cars_haraj_page/presentation/bloc/harag_cubit/harag_cubit.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/bloc/harag_cubit/harag_state.dart';
import 'package:web_admin_san/features/cars_haraj_page/data/model/get_all_harage_model/chat_harag_model.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/custom_widget/title_with_sub_title.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/ui/page_details_harag/list_view_page_details_harag.dart';

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
      child:Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: ListViewPageDetailsHarag(
                harageId:harageId ,
              ),
            ),
            )
          ),
        ),
      );
  }}