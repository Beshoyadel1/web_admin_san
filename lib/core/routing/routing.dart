import 'package:flutter/material.dart';

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String layout = '/layout';
  static const String dashboard = '/dashboard';
}

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        return null;
    }
  }
}
