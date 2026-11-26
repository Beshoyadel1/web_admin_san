import 'package:web_admin_san/feature/layout/view_model/layout_cubit/app_cubit.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import '../../../../../../main.dart';

class NotificationNavigationService {
  const NotificationNavigationService();

  void openDashboardOrders() {
    final context = navigatorKey.currentContext;

    if (context == null) return;

    AppCubit.get(context).navigateToPage(
      PagesOfAllApp.dashboardOrderPageNumber,
    );
  }

  void openChat() {
    final context = navigatorKey.currentContext;

    if (context == null) return;

    AppCubit.get(context).navigateToPage(
      PagesOfAllApp.technicalSupportPageNumber,
    );
  }
}
