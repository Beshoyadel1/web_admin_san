import 'dart:js_interop';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

typedef WebNotificationCallback = void Function(Map<String, dynamic> data);

bool _isWebMessageListenerActive = false;

/// Registers a listener on navigator.serviceWorker to capture background
/// notifications and notification click events sent from firebase-messaging-sw.js.
void listenToWebMessages({
  required WebNotificationCallback onNotificationClick,
  WebNotificationCallback? onBackgroundMessage,
}) {
  if (_isWebMessageListenerActive) return;
  _isWebMessageListenerActive = true;

  try {
    final serviceWorker = web.window.navigator.serviceWorker;

    serviceWorker.addEventListener(
      'message',
      ((web.Event event) {
        try {
          final messageEvent = event as web.MessageEvent;
          final dynamic rawData = messageEvent.data?.dartify();

          if (kDebugMode) {
            debugPrint(
                'FCM WebInterop: Received service worker message: $rawData');
          }

          if (rawData is Map) {
            final dataMap = Map<String, dynamic>.from(rawData);
            if (dataMap['isFcmClick'] == true) {
              final payloadData = dataMap['data'] is Map
                  ? Map<String, dynamic>.from(dataMap['data'] as Map)
                  : <String, dynamic>{};
              onNotificationClick(payloadData);
            } else if (dataMap['isFcmBackgroundMessage'] == true) {
              final payloadData = dataMap['data'] is Map
                  ? Map<String, dynamic>.from(dataMap['data'] as Map)
                  : <String, dynamic>{};
              if (dataMap['notification'] is Map) {
                final notifMap =
                    Map<String, dynamic>.from(dataMap['notification'] as Map);
                payloadData['title'] ??= notifMap['title'];
                payloadData['body'] ??= notifMap['body'];
              }
              onBackgroundMessage?.call(payloadData);
            }
          }
        } catch (innerError) {
          if (kDebugMode) {
            debugPrint(
                'FCM WebInterop: Error handling service worker message: $innerError');
          }
        }
      }).toJS,
    );
  } catch (e) {
    if (kDebugMode) {
      debugPrint(
          'FCM WebInterop: ServiceWorker event listener not supported or failed: $e');
    }
  }
}

/// Opens an external URL in a new tab on web
void openExternalUrl(String url) {
  try {
    web.window.open(url, '_blank');
  } catch (e) {
    if (kDebugMode) {
      debugPrint('WebInterop: failed to open URL: $e');
    }
  }
}
