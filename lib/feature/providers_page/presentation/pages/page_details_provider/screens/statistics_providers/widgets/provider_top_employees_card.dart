import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_provider_total_rate_and_employee_and_balance_model/get_provider_total_rate_and_employee_and_balance_model.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class ProviderTopEmployeesCard extends StatelessWidget {
  final List<TopEmployee> topEmployees;

  const ProviderTopEmployeesCard({
    super.key,
    required this.topEmployees,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardStroke),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.topPerformingEmployees.tr(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.darkColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            LocaleKeys.topEmployeesByOrders.tr(),
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.darkGreyColor,
            ),
          ),
          const SizedBox(height: 12),
          if (topEmployees.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                LocaleKeys.noEmployeesCurrently.tr(),
                style: const TextStyle(
                  color: AppColors.darkGreyColor,
                  fontSize: 12,
                ),
              ),
            )
          else
            ...topEmployees.map((emp) => _EmployeeItemTile(employee: emp)),
        ],
      ),
    );
  }
}

class _EmployeeItemTile extends StatelessWidget {
  final TopEmployee employee;

  const _EmployeeItemTile({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardStroke),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Order Count
          Text(
            '${employee.orderCount ?? 0} ${LocaleKeys.order.tr()}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.orangeColor,
            ),
          ),

          // Employee Profile Details
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        employee.getJobName(context).isNotEmpty
                            ? employee.getJobName(context)
                            : LocaleKeys.jobTitleDefault.tr(),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.darkGreyColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        employee.getName(context).isNotEmpty
                            ? employee.getName(context)
                            : LocaleKeys.employeeDefault.tr(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 18,
                  backgroundColor:
                      AppColors.veryLightOrangeColor.withValues(alpha: 0.25),
                  child: Image.asset(
                    AppImageKeys.profileImage,
                    width: 22,
                    height: 22,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.person_rounded,
                      size: 20,
                      color: AppColors.orangeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
