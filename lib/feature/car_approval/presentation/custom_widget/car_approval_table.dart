import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/car_approval/data/model/car_approval_request_item_model.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'car_approval_status_badge.dart';
import 'car_approval_type_badge.dart';

class CarApprovalTable extends StatefulWidget {
  final List<CarApprovalRequestItemModel> requests;
  final Function(CarApprovalRequestItemModel item) onInspect;

  const CarApprovalTable({
    super.key,
    required this.requests,
    required this.onInspect,
  });

  @override
  State<CarApprovalTable> createState() => _CarApprovalTableState();
}

class _CarApprovalTableState extends State<CarApprovalTable> {
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardStroke),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Scrollbar(
          controller: _horizontalController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 1050),
              child: Scrollbar(
                controller: _verticalController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _verticalController,
                  child: DataTable(
                    headingRowColor:
                        WidgetStateProperty.all(AppColors.scaffoldColor),
                    headingTextStyle: const TextStyle(
                      color: AppColors.darkColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    dataRowMinHeight: 60,
                    dataRowMaxHeight: 68,
                    horizontalMargin: 20,
                    columnSpacing: 24,
                    columns: [
                      DataColumn(label: Text(LocaleKeys.requestNumber.tr())),
                      DataColumn(label: Text(LocaleKeys.requestType.tr())),
                      DataColumn(label: Text(LocaleKeys.car.tr())),
                      DataColumn(label: Text(LocaleKeys.plateNo.tr())),
                      DataColumn(label: Text(LocaleKeys.applicantOwner.tr())),
                      DataColumn(label: Text(LocaleKeys.submissionDate.tr())),
                      DataColumn(label: Text(LocaleKeys.status.tr())),
                      DataColumn(label: Text(LocaleKeys.action.tr())),
                    ],
                    rows: widget.requests.map((item) {
                      return DataRow(
                        cells: [
                          // Request ID
                          DataCell(
                            Text(
                              '#${item.requestId}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkColor,
                              ),
                            ),
                          ),

                          // Request Type
                          DataCell(
                            CarApprovalTypeBadge(requestType: item.requestType),
                          ),

                          // Car Info
                          DataCell(
                            CarCellWidget(item: item),
                          ),

                          // Plate Number
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.scaffoldColor,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.cardStroke),
                              ),
                              child: Text(
                                item.plateNo ?? '—',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),

                          // Owner
                          DataCell(
                            OwnerCellWidget(item: item),
                          ),

                          // Submission Date
                          DataCell(
                            DateCellWidget(date: item.requestDate),
                          ),

                          // Status
                          DataCell(
                            CarApprovalStatusBadge(status: item.status),
                          ),

                          // Actions
                          DataCell(
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: item.isPending
                                      ? AppColors.orangeColor
                                      : AppColors.seaBlueColor,
                                  foregroundColor: AppColors.whiteColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () => widget.onInspect(item),
                                icon: Icon(
                                  item.isPending
                                      ? Icons.rate_review_outlined
                                      : Icons.visibility_outlined,
                                  size: 16,
                                ),
                                label: Text(
                                  item.isPending
                                      ? LocaleKeys.inspectAndReview.tr()
                                      : LocaleKeys.viewDetails.tr(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
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

class CarCellWidget extends StatelessWidget {
  final CarApprovalRequestItemModel item;

  const CarCellWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${item.brandName} ${item.modelName}'.trim(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.darkColor,
            fontSize: 13,
          ),
        ),
        if (item.carName != null && item.carName!.isNotEmpty)
          Text(
            item.carName!,
            style: const TextStyle(
              color: AppColors.darkGreyColor,
              fontSize: 11,
            ),
          ),
      ],
    );
  }
}

class OwnerCellWidget extends StatelessWidget {
  final CarApprovalRequestItemModel item;

  const OwnerCellWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.ownerName.isEmpty
              ? '${LocaleKeys.userPrefix.tr()}${item.ownerId}'
              : item.ownerName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.darkColor,
            fontSize: 13,
          ),
        ),
        if (item.ownerPhone.isNotEmpty)
          Text(
            item.ownerPhone,
            style: const TextStyle(
              color: AppColors.darkGreyColor,
              fontSize: 11,
            ),
          ),
      ],
    );
  }
}

class DateCellWidget extends StatelessWidget {
  final DateTime? date;

  const DateCellWidget({super.key, this.date});

  @override
  Widget build(BuildContext context) {
    if (date == null) {
      return const Text('—', style: TextStyle(color: AppColors.darkGreyColor));
    }

    final year = date!.year;
    final month = date!.month.toString().padLeft(2, '0');
    final day = date!.day.toString().padLeft(2, '0');
    final hour = date!.hour.toString().padLeft(2, '0');
    final minute = date!.minute.toString().padLeft(2, '0');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$year-$month-$day',
          style: const TextStyle(
            color: AppColors.darkColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '$hour:$minute',
          style: const TextStyle(
            color: AppColors.darkGreyColor,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
