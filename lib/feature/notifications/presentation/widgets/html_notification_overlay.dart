import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import '../../../../../../main.dart';

/// Service that manages displaying floating HTML notification banners
/// directly via Flutter's [OverlayState] without pushing routes or blocking interactions.
class HtmlNotificationOverlayService {
  static OverlayEntry? _activeEntry;
  static Timer? _autoDismissTimer;

  static void show({
    BuildContext? context,
    required String? body,
    String? userName,
    String? title,
    VoidCallback? onView,
    VoidCallback? onClose,
    Duration duration = const Duration(seconds: 4),
  }) {
    final overlayState = context != null
        ? Overlay.maybeOf(context) ?? navigatorKey.currentState?.overlay
        : navigatorKey.currentState?.overlay;

    if (overlayState == null) return;

    _autoDismissTimer?.cancel();
    _autoDismissTimer = null;

    if (_activeEntry != null) {
      try {
        _activeEntry!.remove();
      } catch (_) {}
      _activeEntry = null;
    }

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => HtmlNotificationBanner(
        title: title,
        body: body,
        userName: userName,
        duration: duration,
        onClose: () {
          _autoDismissTimer?.cancel();
          if (_activeEntry == entry) {
            try {
              entry.remove();
            } catch (_) {}
            _activeEntry = null;
          }
          onClose?.call();
        },
        onView: () {
          _autoDismissTimer?.cancel();
          if (_activeEntry == entry) {
            try {
              entry.remove();
            } catch (_) {}
            _activeEntry = null;
          }
          onView?.call();
        },
      ),
    );

    _activeEntry = entry;
    overlayState.insert(entry);

    _autoDismissTimer = Timer(duration + const Duration(milliseconds: 350), () {
      if (_activeEntry == entry) {
        try {
          entry.remove();
        } catch (_) {}
        _activeEntry = null;
      }
    });
  }
}

class HtmlNotificationBanner extends StatefulWidget {
  final String? title;
  final String? body;
  final String? userName;
  final Duration duration;
  final VoidCallback? onView;
  final VoidCallback? onClose;

  const HtmlNotificationBanner({
    super.key,
    this.title,
    required this.body,
    this.userName,
    this.duration = const Duration(seconds: 4),
    this.onView,
    this.onClose,
  });

  @override
  State<HtmlNotificationBanner> createState() => _HtmlNotificationBannerState();
}

class _HtmlNotificationBannerState extends State<HtmlNotificationBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  bool _isDismissed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted && !_isDismissed) {
        _dismiss(onAfterDismiss: widget.onClose);
      }
    });
  }

  void _dismiss({VoidCallback? onAfterDismiss}) {
    if (_isDismissed) return;
    _isDismissed = true;
    _controller.reverse().then((_) {
      if (mounted) {
        onAfterDismiss?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = widget.title?.isNotEmpty == true
        ? widget.title!
        : LocaleKeys.newNotification.tr();

    return SafeArea(
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Material(
                color: AppColors.transparent,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      _dismiss(onAfterDismiss: widget.onView);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      constraints: const BoxConstraints(maxWidth: 420),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkColor.withValues(alpha: 0.15),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.orangeColor.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.orangeColor
                                      .withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.notifications_active,
                                  color: AppColors.orangeColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  displayTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: AppColors.darkColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    size: 18,
                                    color: AppColors.darkGreyColor,
                                  ),
                                  onPressed: () {
                                    _dismiss(onAfterDismiss: widget.onClose);
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                            ],
                          ),
                          if (widget.userName != null &&
                              widget.userName!.isNotEmpty &&
                              widget.userName != displayTitle) ...[
                            const SizedBox(height: 8),
                            Text(
                              widget.userName!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: AppColors.orangeColor,
                              ),
                            ),
                          ],
                          if (widget.body != null &&
                              widget.body!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              widget.body!,
                              style: const TextStyle(
                                fontSize: 13.5,
                                color: AppColors.darkColor,
                                height: 1.35,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Convenience aliases matching the company dashboard standard
typedef HtmlNotificationOverlay = HtmlNotificationBanner;

void showHtmlNotification({
  BuildContext? context,
  required String? body,
  String? userName,
  String? title,
  VoidCallback? onView,
  VoidCallback? onClose,
  Duration duration = const Duration(seconds: 4),
}) {
  HtmlNotificationOverlayService.show(
    context: context,
    body: body,
    userName: userName,
    title: title,
    onView: onView,
    onClose: onClose,
    duration: duration,
  );
}

void triggerHtmlNotification({
  BuildContext? context,
  required String? body,
  String? userName,
  String? title,
  VoidCallback? onView,
  VoidCallback? onClose,
  Duration duration = const Duration(seconds: 4),
}) =>
    showHtmlNotification(
      context: context,
      body: body,
      userName: userName,
      title: title,
      onView: onView,
      onClose: onClose,
      duration: duration,
    );
