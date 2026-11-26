import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/constants/gender_constants.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/service_model.dart';

class OrderFunctions {
  static bool isEnglish(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'en';
  }

  static String getServiceTitle({
    required BuildContext context,
    required ServiceModel? service,
  }) {
    if (service == null) return "";

    return isEnglish(context)
        ? (service.latinName ?? "")
        : (service.name ?? "");
  }

  static String formatDate(String? date) {
    if (date == null || date.isEmpty) return "";

    final parsed = DateTime.tryParse(date)?.toLocal();
    if (parsed == null) return date;

    return "${parsed.day}/${parsed.month}/${parsed.year}";
  }

  static String formatDateFromDateTime(DateTime? date) {
    if (date == null) return "";
    final local = date.toLocal();
    return "${local.year}/${local.month}/${local.day}";
  }

  static String formatTime(DateTime? date) {
    if (date == null) return "";
    final local = date.toLocal();
    return "${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}";
  }

  static String valueOrEmpty(dynamic value, BuildContext context) {
    if (value == null || value.toString().trim().isEmpty) {
      return LocaleKeys.empty.tr();
    }
    return value.toString();
  }

  static String getGenderText(dynamic gender, [BuildContext? context]) {
    if (gender == null) {
      return LocaleKeys.empty.tr();
    }
    final text = gender.toString().toGenderText();
    return text.isNotEmpty ? text : LocaleKeys.empty.tr();
  }
}
