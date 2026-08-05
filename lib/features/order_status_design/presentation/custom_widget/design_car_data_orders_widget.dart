import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';

class DesignCarDataOrdersWidget extends StatelessWidget {
  final String? brandName,
      totalPriceCar,
      plateNo,
      nameProServiceCar,
      taxProServiceCar,
      priceProServiceCar;

  const DesignCarDataOrdersWidget({
    super.key,
    this.brandName,
    this.totalPriceCar,
    this.plateNo,
    this.nameProServiceCar,
    this.priceProServiceCar,
    this.taxProServiceCar,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: () {},
      isSelected: true,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        color: AppColors.orangeColor.withOpacity(0.4),
      ),
      typeWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isMobile = constraints.maxWidth < 430;

              final leftWidget = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomContainer(
                    onTap: () {},
                    isSelected: true,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: AppColors.orangeColor.withOpacity(0.4),
                    ),
                    typeWidget: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        CupertinoIcons.car_fill,
                        color: AppColors.orangeColor,
                        //size: 25,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextInAppWidget(
                          text: brandName ?? "Bmw M4 Competition",
                          textSize: 16,
                          fontWeightIndex:
                          FontSelectionData.boldFontFamily,
                          textColor: AppColors.blackColor,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const TextInAppWidget(
                              text: AppLanguageKeys.dubaiPlate,
                              textSize: 12,
                              fontWeightIndex:
                              FontSelectionData.mediumFontFamily,
                              textColor: AppColors.greyColor,
                            ),
                            TextInAppWidget(
                              text: plateNo ?? "5000",
                              textSize: 12,
                              fontWeightIndex:
                              FontSelectionData.mediumFontFamily,
                              textColor: AppColors.greyColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );

              final rightWidget = Column(
                crossAxisAlignment: isMobile
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  const TextInAppWidget(
                    text: AppLanguageKeys.totalVehicle,
                    textSize: 12,
                    fontWeightIndex:
                    FontSelectionData.mediumFontFamily,
                    textColor: AppColors.greyColor,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    spacing: 5,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextInAppWidget(
                        text: totalPriceCar ?? "1450",
                        textSize: 16,
                        fontWeightIndex:
                        FontSelectionData.mediumFontFamily,
                        textColor: AppColors.orangeColor,
                      ),
                      const TextInAppWidget(
                        text: AppLanguageKeys.dirham,
                        textSize: 16,
                        fontWeightIndex:
                        FontSelectionData.mediumFontFamily,
                        textColor: AppColors.orangeColor,
                      ),
                    ],
                  ),
                ],
              );

              if (!isMobile) {
                return Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Expanded(child: leftWidget),
                    const SizedBox(width: 20),
                    rightWidget,
                  ],
                );
              }

              return Wrap(
                spacing: 20,
                runSpacing: 15,
                children: [
                  leftWidget,
                  rightWidget,
                ],
              );
            },
          ),

          const SizedBox(height: 10),

          Divider(
            color: AppColors.orangeColor.withOpacity(0.3),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 500) {
                return const Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    TextInAppWidget(
                      text: AppLanguageKeys.services,
                      textSize: 13,
                      fontWeightIndex:
                      FontSelectionData.mediumFontFamily,
                      textColor: AppColors.greyColor,
                    ),
                    TextInAppWidget(
                      text: AppLanguageKeys.price,
                      textSize: 13,
                      fontWeightIndex:
                      FontSelectionData.mediumFontFamily,
                      textColor: AppColors.greyColor,
                    ),
                  ],
                );
              }

              return const Wrap(
                spacing: 20,
                runSpacing: 10,
                children: [
                  TextInAppWidget(
                    text: AppLanguageKeys.services,
                    textSize: 13,
                    fontWeightIndex:
                    FontSelectionData.mediumFontFamily,
                    textColor: AppColors.greyColor,
                  ),
                  TextInAppWidget(
                    text: AppLanguageKeys.price,
                    textSize: 13,
                    fontWeightIndex:
                    FontSelectionData.mediumFontFamily,
                    textColor: AppColors.greyColor,
                  ),
                ],
              );
            },
          ),

          Divider(
            color: AppColors.orangeColor.withOpacity(0.3),
          ),
          SizedBox(
            height: 200,
            child: ListView.separated(
              itemCount: 3,
              separatorBuilder: (_, __) =>
              const SizedBox(height: 20),
              itemBuilder: (context, index) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isMobile =
                        constraints.maxWidth < 500;

                    final serviceWidget = Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        TextInAppWidget(
                          text: nameProServiceCar ??
                              'تغير الزيت',
                          textSize: 14,
                          fontWeightIndex:
                          FontSelectionData
                              .mediumFontFamily,
                          textColor:
                          AppColors.greyColor,
                        ),
                        Row(
                          mainAxisSize:
                          MainAxisSize.min,
                          children: [
                            TextInAppWidget(
                              text: taxProServiceCar ??
                                  AppLanguageKeys
                                      .taxes,
                              textSize: 12,
                              fontWeightIndex:
                              FontSelectionData
                                  .mediumFontFamily,
                              textColor:
                              AppColors.orangeColor,
                            ),
                            const SizedBox(width: 5),
                            TextInAppWidget(
                              text:
                              priceProServiceCar ??
                                  "15",
                              textSize: 12,
                              fontWeightIndex:
                              FontSelectionData
                                  .mediumFontFamily,
                              textColor:
                              AppColors.orangeColor,
                            ),
                          ],
                        ),
                      ],
                    );

                    final priceWidget = Row(
                      mainAxisSize:
                      MainAxisSize.min,
                      children: [
                        TextInAppWidget(
                          text: totalPriceCar ??
                              "1450",
                          textSize: 16,
                          fontWeightIndex:
                          FontSelectionData
                              .mediumFontFamily,
                          textColor:
                          AppColors.blackColor,
                        ),
                        const SizedBox(width: 3),
                        const TextInAppWidget(
                          text:
                          AppLanguageKeys.dirham,
                          textSize: 16,
                          fontWeightIndex:
                          FontSelectionData
                              .mediumFontFamily,
                          textColor:
                          AppColors.blackColor,
                        ),
                      ],
                    );

                    if (!isMobile) {
                      return Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Expanded(
                            child: serviceWidget,
                          ),
                          const SizedBox(width: 20),
                          priceWidget,
                        ],
                      );
                    }
                    return Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      children: [
                        serviceWidget,
                        priceWidget,
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}