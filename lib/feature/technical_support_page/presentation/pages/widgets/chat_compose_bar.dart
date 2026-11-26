import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';

class ChatComposeBar extends StatefulWidget {
  final bool isSending;
  final ValueChanged<String> onSend;
  final bool isClosed;
  final bool isAssigned;
  final bool isPerformingAction;
  final VoidCallback? onAcceptTicket;

  const ChatComposeBar({
    super.key,
    required this.isSending,
    required this.onSend,
    this.isClosed = false,
    this.isAssigned = true,
    this.isPerformingAction = false,
    this.onAcceptTicket,
  });

  @override
  State<ChatComposeBar> createState() => _ChatComposeBarState();
}

class _ChatComposeBarState extends State<ChatComposeBar> {
  late final TextEditingController _controller;
  bool _hasContent = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasContent) {
        setState(() {
          _hasContent = has;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isSending) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isClosed) {
      return const _ClosedTicketBanner();
    }

    if (!widget.isAssigned) {
      return _PendingAcceptBanner(
        isPerformingAction: widget.isPerformingAction,
        onAcceptTicket: widget.onAcceptTicket,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        border: Border(top: BorderSide(color: AppColors.cardStroke)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.cardStroke),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  minLines: 1,
                  maxLines: 4,
                  onSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    hintText: LocaleKeys.writeYourMessageHere.tr(),
                    hintStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            MouseRegion(
              cursor: (_hasContent && !widget.isSending)
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (_hasContent && !widget.isSending)
                      ? AppColors.mainColor
                      : AppColors.scaffoldBackground,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cardStroke),
                ),
                child: IconButton(
                  icon: widget.isSending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.mainColor,
                          ),
                        )
                      : Icon(
                          Icons.send_rounded,
                          size: 20,
                          color: _hasContent
                              ? AppColors.whiteColor
                              : AppColors.appGrey,
                        ),
                  onPressed:
                      (_hasContent && !widget.isSending) ? _submit : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClosedTicketBanner extends StatelessWidget {
  const _ClosedTicketBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.scaffoldBackground,
        border: Border(top: BorderSide(color: AppColors.cardStroke)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                LocaleKeys.chatClosedNote.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingAcceptBanner extends StatelessWidget {
  final bool isPerformingAction;
  final VoidCallback? onAcceptTicket;

  const _PendingAcceptBanner({
    required this.isPerformingAction,
    this.onAcceptTicket,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.orangeColor.withValues(alpha: 0.05),
        border: const Border(top: BorderSide(color: AppColors.cardStroke)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              size: 20,
              color: AppColors.orangeColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                LocaleKeys.chatPendingAcceptanceNote.tr(),
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.appBlackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 12),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  foregroundColor: AppColors.whiteColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: isPerformingAction ? null : onAcceptTicket,
                icon: isPerformingAction
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.whiteColor,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline, size: 16),
                label: Text(
                  LocaleKeys.acceptAndReply.tr(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
