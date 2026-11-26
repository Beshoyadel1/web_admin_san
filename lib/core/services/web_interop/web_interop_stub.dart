typedef WebNotificationCallback = void Function(Map<String, dynamic> data);

/// No-op implementation for non-web platforms (Mobile, Desktop, Test runners).
void listenToWebMessages({
  required WebNotificationCallback onNotificationClick,
  WebNotificationCallback? onBackgroundMessage,
}) {}

/// Opens an external URL (no-op on stub)
void openExternalUrl(String url) {}
