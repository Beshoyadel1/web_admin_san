import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';

class ContainerListContainerAllRateServiceWidget
    extends StatelessWidget {
  final String username;
  final String message;
  final Uint8List? imagePath;
  final double rate;

  const ContainerListContainerAllRateServiceWidget({
    super.key,
    this.imagePath,
    required this.username,
    required this.message,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.greyColor.withOpacity(.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              imagePath != null
                  ? CircleAvatar(
                radius: 22,
                backgroundImage:
                MemoryImage(imagePath!),
              )
                  : CircleAvatar(
                radius: 22,
                backgroundColor:
                AppColors.orangeColor,
                child: TextInAppWidget(
                  text: username.isNotEmpty
                      ? username[0]
                      .toUpperCase()
                      : '?',
                  textSize: 14,
                  textColor:
                  AppColors.whiteColor,
                  fontWeightIndex:
                  FontSelectionData
                      .mediumFontFamily,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    TextInAppWidget(
                      text: username,
                      textSize: 14,
                      textColor:
                      AppColors.blackColor,
                      fontWeightIndex:
                      FontSelectionData
                          .mediumFontFamily,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 4),

                    RatingBarIndicator(
                      rating: rate,
                      itemBuilder:
                          (context, index) =>
                      const Icon(
                        Icons.star,
                        color: AppColors.orangeColor,
                      ),
                      itemCount: 5,
                      itemSize: 18,
                    ),
                  ],
                ),
              ),

              TextInAppWidget(
                text: rate.toStringAsFixed(1),
                textSize: 13,
                textColor: AppColors.orangeColor,
                fontWeightIndex:
                FontSelectionData
                    .mediumFontFamily,
              ),
            ],
          ),

          const SizedBox(height: 12),

          TextInAppWidget(
            text: message,
            textSize: 13,
            textColor: AppColors.darkColor,
            fontWeightIndex:
            FontSelectionData.regularFontFamily,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}