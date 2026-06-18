import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/features/banner/presentation/custom_widget/container_edit_delete_widget.dart';

import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/theming/colors.dart';

class DesignContainerAdvertisementsUploadedWidget extends StatelessWidget {
  final void Function()? onPressedEdit, onPressedDelete;
  final Uint8List? loadImage;

  const DesignContainerAdvertisementsUploadedWidget({
    super.key,
    this.onPressedDelete,
    this.onPressedEdit,
    this.loadImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.greyColor.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 10,
            children: [
              ContainerEditDeleteWidget(
                isDelete: true,
                onPressed: onPressedDelete,
              ),
              ContainerEditDeleteWidget(
                onPressed: onPressedEdit,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            width: double.infinity,
            child: loadImage != null
                ? Image.memory(
                    loadImage!,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    AppImageKeys.testBanner,
                    fit: BoxFit.cover,
                  ),
          )
        ],
      ),
    );
  }
}
