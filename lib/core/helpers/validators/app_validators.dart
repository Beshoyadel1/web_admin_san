import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class AppValidators {
  static String? nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.userName.tr();
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.authEmailRequired.tr();
    } else if (!isValidEmail(value)) {
      return LocaleKeys.pleaseEnterValidEmail.tr();
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.authPasswordRequired.tr();
    } else if (value.length < 6) {
      return LocaleKeys.passwordAtLeastKey.tr();
    }
    return null;
  }

  static String? confirmPasswordValidator(
    String? value,
    String? passwordToMatch,
  ) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.confirmPasswordKey.tr();
    } else if (value != passwordToMatch) {
      return LocaleKeys.passwordsDoNotMatch.tr();
    }
    return null;
  }

  static String? phoneRequiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.authPhoneNumberRequired.tr();
    }
    return null;
  }

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegex.hasMatch(email.trim());
  }

  static String removePlusFromPhone(String phone) {
    if (phone.startsWith('+')) {
      return phone.substring(1);
    }
    return phone;
  }
}
