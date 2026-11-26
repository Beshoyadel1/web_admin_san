import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:web_admin_san/feature/layout/view_model/layout_cubit/app_cubit.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import '../../../../../../main.dart';
import 'package:web_admin_san/core/di/sl.dart';
import 'package:web_admin_san/feature/technical_support_page/data/model/chat_events/chat_events.dart';
import 'package:web_admin_san/feature/technical_support_page/view_model/admin_chat_cubit/admin_chat_cubit.dart';
import 'package:web_admin_san/feature/notifications/data/datasource/parsers/receive_message_parser/receive_message_parser.dart';
import 'package:web_admin_san/feature/notifications/presentation/services/dialog_service/dialog_service.dart';
import 'package:web_admin_san/feature/notifications/presentation/services/navigation_service/navigation_service.dart';

class ReceiveMessageHandler {
  ReceiveMessageHandler({
    required ReceiveMessageParser parser,
    required NotificationDialogService dialogService,
    required NotificationNavigationService navigationService,
  })  : _parser = parser,
        _dialogService = dialogService,
        _navigationService = navigationService;

  final ReceiveMessageParser _parser;
  final NotificationDialogService _dialogService;
  final NotificationNavigationService _navigationService;

  Future<void> handle(List<Object?>? arguments) async {
    try {
      final model = _parser.parse(arguments);

      if (model?.data?.data != null) {
        ChatEvents.instance.add(model!.data!.data!);
      }
      if (model == null) {
        return;
      }

      if (!await model.canView()) {
        return;
      }
      final context = navigatorKey.currentContext;

      if (context != null && context.mounted) {
        final appCubit = AppCubit.get(context);
        final isTechnicalSupportOpen = appCubit.selectedPageIndex ==
            PagesOfAllApp.technicalSupportPageNumber;

        final incomingSenderId = model.data?.data?.fromUser;
        final isActiveChatWithSameSender = isTechnicalSupportOpen &&
            ChatEvents.instance.activeChatUserId != null &&
            incomingSenderId != null &&
            ChatEvents.instance.activeChatUserId.toString() == incomingSenderId;

        if (isActiveChatWithSameSender) {
          return;
        }
      }

      final displayTitle = model.data?.data?.fromUserName?.isNotEmpty == true
          ? model.data!.data!.fromUserName!
          : (model.data?.title?.isNotEmpty == true
              ? model.data!.title!
              : LocaleKeys.newTechnicalSupportMessage.tr());
      final displayMessage = model.data?.data?.message?.isNotEmpty == true
          ? model.data!.data!.message!
          : (model.data?.body?.isNotEmpty == true ? model.data!.body! : '');

      await _dialogService.show(
        title: displayTitle,
        subtitle: displayMessage,
        onView: () async {
          _navigationService.openChat();
          final fromId = int.tryParse(model.data?.data?.fromUser ?? '') ?? 0;
          final fromType =
              int.tryParse(model.data?.data?.fromUserType ?? '') ?? 0;
          if (fromId > 0) {
            try {
              getIt<AdminChatCubit>().selectChatBySender(fromId, fromType);
            } catch (_) {}
          }
        },
      );
    } catch (e, s) {
      debugPrint("ReceiveMessage Error => $e");
      debugPrintStack(stackTrace: s);
    }
  }
}
