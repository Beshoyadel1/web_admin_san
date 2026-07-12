import 'package:web_admin_san/core/cubit/app_cubit/app_cubit.dart';
import 'package:web_admin_san/core/utilies/map_of_all_app.dart';
import 'package:web_admin_san/main.dart';


class NotificationNavigationService {
  const NotificationNavigationService();

  void openDashboardOrders() {
    final context = navigatorKey.currentContext;

    if (context == null) return;

    AppCubit.get(context).navigateToPage(
      PagesOfAllApp.dashboardOrderPageNumber,
    );
  }
}