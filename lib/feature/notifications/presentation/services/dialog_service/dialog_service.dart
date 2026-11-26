import 'package:flutter/material.dart';
import 'package:web_admin_san/feature/notifications/presentation/widgets/html_notification_overlay.dart';
import 'package:web_admin_san/feature/notifications/presentation/services/navigation_service/navigation_service.dart';
import 'package:web_admin_san/feature/notifications/presentation/services/notification_audio_service/notification_audio_service.dart';
import '../../../../../../main.dart';

class NotificationDialogService {
  BuildContext? get context => navigatorKey.currentContext;

  NotificationDialogService({
    NotificationAudioService? audioService,
    NotificationNavigationService? navigationService,
  })  : _audio = audioService ?? const NotificationAudioService(),
        _navigation =
            navigationService ?? const NotificationNavigationService();

  final NotificationAudioService _audio;
  final NotificationNavigationService _navigation;

  NotificationNavigationService get navigation => _navigation;

  bool _isShowing = false;

  bool get isShowing => _isShowing;

  Future<void> show({
    required String title,
    required String subtitle,
    required Future<void> Function() onView,
    bool showDialog = true,
  }) async {
    try {
      await _audio.play();
    } catch (_) {}

    if (!showDialog) {
      return;
    }

    _isShowing = true;

    HtmlNotificationOverlayService.show(
      title: title,
      body: subtitle,
      userName: title,
      onClose: () async {
        try {
          await _audio.stop();
        } catch (_) {}
        _isShowing = false;
      },
      onView: () async {
        try {
          await _audio.stop();
        } catch (_) {}
        _isShowing = false;
        await onView();
      },
    );
  }
}
