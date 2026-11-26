import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/networking/local_services.dart';

import 'package:web_admin_san/feature/auth_page/data/datasource/login_datasource/login_repository.dart';
import 'package:web_admin_san/feature/store_page/view_model/facility_cubit/facility_tab_cubit/facility_tab_cubit.dart';
import 'package:web_admin_san/feature/store_page/view_model/facility_cubit/facility_tab_cubit/facility_tab_state.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';

class AttachImage extends StatelessWidget {
  const AttachImage({
    super.key,
    required this.title,
    required this.type,
    required this.isEditMode,
  });

  final String title;
  final String type;
  final bool isEditMode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FacilityTabCubit, FacilityTabState>(
      builder: (context, state) {
        final cubit = FacilityTabCubit.get(context);

        return FutureBuilder(
          future: AuthLocalStorage.getUser(),
          builder: (context, snapshot) {
            final user = snapshot.data;

            Uint8List? image = cubit.images[type];

            if (image == null &&
                user != null &&
                !cubit.deletedImages.contains(type)) {
              if (type == 'image') {
                image = user.image;
              } else if (type == 'crimage') {
                image = user.providerDetails?.crimage;
              } else if (type == 'vatnoimage') {
                image = user.providerDetails?.vatnoimage;
              }
            }

            final isUploaded = image != null;

            return Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextInAppWidget(text: title, textSize: 13),
                isUploaded
                    ? Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: MemoryImage(image),
                          ),
                          if (isEditMode)
                            IconButton(
                              onPressed: () => cubit.uploadImage(type),
                              icon: const Icon(Icons.edit),
                            ),
                        ],
                      )
                    : GestureDetector(
                        onTap:
                            isEditMode ? () => cubit.uploadImage(type) : null,
                        child: Container(
                          width: 250,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: TextInAppWidget(
                              text: LocaleKeys.uploadImage,
                              textSize: 13,
                              textColor: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
              ],
            );
          },
        );
      },
    );
  }
}
