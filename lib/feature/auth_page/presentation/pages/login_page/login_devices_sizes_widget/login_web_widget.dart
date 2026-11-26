import 'package:flutter/material.dart';

import '../../../../../../core/helpers/constants/assets.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import '../login_widgets/login_image.dart';
import '../login_widgets/login_language_button_widget.dart';
import '../login_widgets/login_widget.dart';

class LoginWebWidget extends StatelessWidget {
  const LoginWebWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        color: AppColors.orangeColor,
                        height: 30,
                        width: double.infinity,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0, top: 50),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const LoginLanguageButtonWidget(),
                                      Image.asset(
                                        AppImageKeys.sarLogo,
                                        height: 50,
                                        width: 170,
                                        fit: BoxFit.fill,
                                      ),
                                      const SizedBox(height: 30),
                                      const LoginWidget(),
                                    ],
                                  ),
                                ),
                              ),
                              // const NewUserWidget(),
                              // const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (MediaQuery.of(context).size.width > ValuesOfAllApp.mobileWidth)
          const LoginImage(),
      ],
    );
  }
}
