import 'package:flutter/foundation.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/feature/notifications/data/datasource/parsers/update_order_status_parser/update_order_status_parser.dart';
import 'package:web_admin_san/feature/notifications/presentation/services/dialog_service/dialog_service.dart';
import 'package:web_admin_san/feature/notifications/presentation/services/navigation_service/navigation_service.dart';

class UpdateOrderStatusHandler {
  UpdateOrderStatusHandler({
    required UpdateOrderStatusParser parser,
    required NotificationDialogService dialogService,
    required NotificationNavigationService navigationService,
  })  : _parser = parser,
        _dialogService = dialogService,
        _navigationService = navigationService;

  final UpdateOrderStatusParser _parser;
  final NotificationDialogService _dialogService;
  final NotificationNavigationService _navigationService;

  Future<void> handle(List<Object?>? arguments) async {
    try {
      final model = _parser.parse(arguments);

      if (model == null) {
        return;
      }

      if (!await model.canView()) {
        return;
      }
      // final context = navigatorKey.currentContext;
      //
      // if (context != null) {
      //   final appCubit = AppCubit.get(context);
      //
      //   if (appCubit.selectedPageIndex ==
      //       PagesOfAllApp.dashboardPageNumber) {
      //     return;
      //   }
      // }
      await _dialogService.show(
        title: OrderFunctions.formatDate(
          model.data?.data?.orderInfo?.orderDate?.toString() ?? "",
        ),
        subtitle: LocaleKeys.youHaveOrderUpdate,
        onView: () async {
          _navigationService.openDashboardOrders();
        },
      );
    } catch (e, s) {
      debugPrint("UpdateOrderStatus Error => $e");
      debugPrintStack(stackTrace: s);
    }
  }
}
