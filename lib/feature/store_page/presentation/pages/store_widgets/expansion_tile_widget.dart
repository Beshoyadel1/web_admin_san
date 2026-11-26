import 'package:flutter/material.dart';
import 'package:web_admin_san/core/di/sl.dart';
import 'column_of_pages_widget.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import 'package:web_admin_san/feature/layout/view_model/layout_cubit/app_cubit.dart';
import '../../../../../core/helpers/models/pages_model.dart';
import '../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../core/helpers/themes/fonts.dart';
import '../../../../../core/helpers/themes/text_styles.dart';

class ExpansionTileWidget extends StatefulWidget {
  const ExpansionTileWidget({super.key, required this.pages});

  final PageNodeModel pages;

  @override
  State<ExpansionTileWidget> createState() => _ExpansionTileWidgetState();
}

class _ExpansionTileWidgetState extends State<ExpansionTileWidget> {
  final AppCubit _appCubit = getIt<AppCubit>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth;
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: Material(
        color: Colors.transparent,
        child: ExpansionTile(
          backgroundColor: AppColors.veryLightOrangeColor.withAlpha(100),
          iconColor: widget.pages.number == _appCubit.selectedPageIndex
              ? AppColors.secondaryColor
              : AppColors.whiteColor,
          collapsedIconColor: widget.pages.number == _appCubit.selectedPageIndex
              ? AppColors.secondaryColor
              : AppColors.whiteColor,
          tilePadding: const EdgeInsetsDirectional.only(start: 5, end: 2),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 5,
            children: [
              if ((widget.pages.image ?? '').isNotEmpty)
                Image.asset(
                  widget.pages.image!,
                  color: widget.pages.number == _appCubit.selectedPageIndex
                      ? AppColors.secondaryColor
                      : AppColors.whiteColor,
                  height: 18,
                  width: 18,
                ),
              if (widget.pages.imageUint8List != null &&
                  widget.pages.imageUint8List!.isNotEmpty)
                Image.memory(
                  widget.pages.imageUint8List!,
                  color: widget.pages.number == _appCubit.selectedPageIndex
                      ? AppColors.secondaryColor
                      : AppColors.whiteColor,
                  height: 18,
                  width: 18,
                ),
              Expanded(
                child: TextInAppWidget(
                  text: widget.pages.name,
                  textSize: 14,
                  textColor: widget.pages.number == _appCubit.selectedPageIndex
                      ? AppColors.secondaryColor
                      : AppColors.whiteColor,
                  fontWeightIndex: FontSelectionData.regularFontFamily,
                ),
              ),
            ],
          ),
          children: widget.pages.children
              .map(
                (e) => ColumnOfPagesWidget(
                  pageNode: e,
                  appCubit: _appCubit,
                  isMobile: isMobile,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
