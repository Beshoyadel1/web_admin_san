import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Helper to localize chart date labels (months and date strings) across all charts.
class ChartDateLocalizer {
  static const Map<String, String> _months = {
    'january': 'يناير',
    'february': 'فبراير',
    'march': 'مارس',
    'april': 'أبريل',
    'may': 'مايو',
    'june': 'يونيو',
    'july': 'يوليو',
    'august': 'أغسطس',
    'september': 'سبتمبر',
    'october': 'أكتوبر',
    'november': 'نوفمبر',
    'december': 'ديسمبر',
    'jan': 'يناير',
    'feb': 'فبراير',
    'mar': 'مارس',
    'apr': 'أبريل',
    'jun': 'يونيو',
    'jul': 'يوليو',
    'aug': 'أغسطس',
    'sep': 'سبتمبر',
    'oct': 'أكتوبر',
    'nov': 'نوفمبر',
    'dec': 'ديسمبر',
  };

  /// Localizes month names inside [label] if current locale in [context] is Arabic.
  static String localize(String label, BuildContext context) {
    try {
      final lang = context.locale.languageCode;
      return localizeForLanguage(label, lang);
    } catch (_) {
      return label;
    }
  }

  /// Localizes month names inside [label] for the given [languageCode].
  static String localizeForLanguage(String label, String languageCode) {
    if (languageCode != 'ar') return label;
    String result = label;
    _months.forEach((en, ar) {
      result = result.replaceAll(RegExp('\\b$en\\b', caseSensitive: false), ar);
    });
    return result;
  }
}
