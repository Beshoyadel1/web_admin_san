import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/networking/api_link.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/technical_support_page/view_model/admin_chat_cubit/admin_chat_cubit.dart';
import 'package:web_admin_san/feature/technical_support_page/view_model/admin_chat_cubit/admin_chat_state.dart';
import '../../../data/model/admin_chat_model.dart';

class ChatThreadHeader extends StatelessWidget {
  final GetAllMessagesModel chat;
  final bool showBackButton;
  final VoidCallback? onBack;

  const ChatThreadHeader({
    super.key,
    required this.chat,
    this.showBackButton = false,
    this.onBack,
  });

  String _getDisplayName(BuildContext context) {
    if (chat.userName != null && chat.userName!.trim().isNotEmpty) {
      return chat.userName!;
    }
    return LocaleKeys.chatConversation.tr();
  }

  String _getRoleLabel(BuildContext context) {
    final userType = chat.fromUserType ?? chat.tousertype;
    switch (userType) {
      case UserType.adminUser:
        return LocaleKeys.systemAdminRole.tr();
      case UserType.providerUser:
        return LocaleKeys.serviceProviderRole.tr();
      case UserType.driverUser:
        return LocaleKeys.driverRole.tr();
      case UserType.appUser:
        return LocaleKeys.customerRole.tr();
      case UserType.companyUser:
        return LocaleKeys.companyRole.tr();
      case UserType.employeeUser:
        return LocaleKeys.employeeRole.tr();
      default:
        return LocaleKeys.userRole.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminChatCubit, AdminChatState>(
      builder: (context, state) {
        final cubit = context.read<AdminChatCubit>();

        return LayoutBuilder(
          builder: (context, constraints) {
            final bool isCompact = constraints.maxWidth < 420;

            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 8 : 12,
                vertical: 10,
              ),
              decoration: const BoxDecoration(
                color: AppColors.whiteColor,
                border: Border(bottom: BorderSide(color: AppColors.cardStroke)),
              ),
              child: Row(
                children: [
                  if (showBackButton) ...[
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.appBlackColor,
                      ),
                      onPressed: onBack ?? () => cubit.clearSelectedChat(),
                    ),
                    const SizedBox(width: 4),
                  ],
                  _HeaderAvatar(
                    image: chat.image,
                    userType: chat.fromUserType ?? chat.tousertype,
                  ),
                  SizedBox(width: isCompact ? 8 : 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getDisplayName(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isCompact ? 14 : 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.appBlackColor,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          runSpacing: 2,
                          children: [
                            _TicketStatusChip(
                              isClosed: chat.isClosed,
                              isAssigned: chat.isAssigned,
                            ),
                            Text(
                              _getRoleLabel(context),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (chat.linkedOrderId != null &&
                      chat.linkedOrderId! > 0) ...[
                    const SizedBox(width: 6),
                    _LinkedOrderBadge(
                      orderId: chat.linkedOrderId!,
                      isCompact: isCompact,
                    ),
                  ],
                  const SizedBox(width: 6),
                  if (!chat.isClosed && !chat.isAssigned) ...[
                    _AcceptTicketButton(
                      isLoading: state.isPerformingTicketAction,
                      isCompact: isCompact,
                      onPressed: () => cubit.acceptTicket(chat),
                    ),
                  ] else if (!chat.isClosed && chat.isAssigned) ...[
                    _CloseTicketButton(
                      isLoading: state.isPerformingTicketAction,
                      isCompact: isCompact,
                      onPressed: () =>
                          _confirmCloseTicket(context, cubit, chat),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _confirmCloseTicket(
    BuildContext context,
    AdminChatCubit cubit,
    GetAllMessagesModel chat,
  ) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(LocaleKeys.closeTicket.tr()),
        content: Text(
          LocaleKeys.confirmCloseTicketMessage.tr(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
              foregroundColor: AppColors.whiteColor,
            ),
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              cubit.closeTicket(chat);
            },
            child: Text(LocaleKeys.confirmCloseTicket.tr()),
          ),
        ],
      ),
    );
  }
}

class _TicketStatusChip extends StatelessWidget {
  final bool isClosed;
  final bool isAssigned;

  const _TicketStatusChip({
    required this.isClosed,
    required this.isAssigned,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color contentColor;
    final IconData icon;
    final String label;

    if (isClosed) {
      bgColor = AppColors.veryLightGreyColor;
      contentColor = AppColors.textSecondary;
      icon = Icons.lock_rounded;
      label = LocaleKeys.conversationClosedBadge.tr();
    } else if (!isAssigned) {
      bgColor = AppColors.orangeColor.withValues(alpha: 0.12);
      contentColor = AppColors.orangeColor;
      icon = Icons.hourglass_top_rounded;
      label = LocaleKeys.conversationPendingBadge.tr();
    } else {
      bgColor = AppColors.greenColor.withValues(alpha: 0.12);
      contentColor = AppColors.greenColor;
      icon = Icons.check_circle_outline;
      label = LocaleKeys.conversationInProgressBadge.tr();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 11,
            color: contentColor,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 11,
                  color: contentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AcceptTicketButton extends StatelessWidget {
  final bool isLoading;
  final bool isCompact;
  final VoidCallback onPressed;

  const _AcceptTicketButton({
    required this.isLoading,
    this.isCompact = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final labelText = LocaleKeys.acceptTicket.tr();

    if (isCompact) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Tooltip(
          message: labelText,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.whiteColor,
                        ),
                      )
                    : const Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: AppColors.whiteColor,
                      ),
              ),
            ),
          ),
        ),
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainColor,
          foregroundColor: AppColors.whiteColor,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.whiteColor,
                ),
              )
            : const Icon(Icons.check_circle_outline, size: 15),
        label: Text(
          labelText,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _CloseTicketButton extends StatelessWidget {
  final bool isLoading;
  final bool isCompact;
  final VoidCallback onPressed;

  const _CloseTicketButton({
    required this.isLoading,
    this.isCompact = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final labelText = LocaleKeys.closeTicket.tr();

    if (isCompact) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Tooltip(
          message: labelText,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.cardStroke),
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.mainColor,
                        ),
                      )
                    : const Icon(
                        Icons.lock_outline,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
              ),
            ),
          ),
        ),
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          side: const BorderSide(color: AppColors.cardStroke),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.mainColor,
                ),
              )
            : const Icon(Icons.lock_outline, size: 15),
        label: Text(
          labelText,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _LinkedOrderBadge extends StatelessWidget {
  final int orderId;
  final bool isCompact;

  const _LinkedOrderBadge({
    required this.orderId,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: LocaleKeys.linkedOrderNumber.tr(args: [orderId.toString()]),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 8 : 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.orangeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(color: AppColors.orangeColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.receipt_long,
                size: 16,
                color: AppColors.orangeColor,
              ),
              if (!isCompact) ...[
                const SizedBox(width: 6),
                Text(
                  '#$orderId',
                  style: const TextStyle(
                    color: AppColors.orangeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  final dynamic image;
  final int? userType;

  const _HeaderAvatar({this.image, this.userType});

  @override
  Widget build(BuildContext context) {
    if (image != null && image.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          image,
          width: 42,
          height: 42,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _HeaderFallback(userType: userType),
        ),
      );
    }
    return _HeaderFallback(userType: userType);
  }
}

class _HeaderFallback extends StatelessWidget {
  final int? userType;

  const _HeaderFallback({this.userType});

  IconData _getIcon() {
    switch (userType) {
      case UserType.adminUser:
        return Icons.support_agent;
      case UserType.providerUser:
        return Icons.storefront;
      case UserType.driverUser:
        return Icons.directions_car;
      case UserType.companyUser:
        return Icons.business;
      case UserType.employeeUser:
        return Icons.badge;
      case UserType.appUser:
        return Icons.person;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.mainColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          _getIcon(),
          color: AppColors.mainColor,
          size: 22,
        ),
      ),
    );
  }
}
