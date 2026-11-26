import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

export 'package:web_admin_san/core/helpers/constants/gender_constants.dart';

extension ContextExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;

  bool get isArabic => locale.languageCode == 'ar';

  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop(result);

  Future<T?> push<T extends Object?>(Route<T> route) =>
      Navigator.of(this).push(route);

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) =>
      Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
}
