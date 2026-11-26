import 'package:web_admin_san/generated/locale_keys.g.dart';
String responseOfStatusCode(int? statusCode) {
  switch (statusCode) {
    case 400:
      return LocaleKeys.badRequestError;

    case 401:
      return LocaleKeys.unauthorizedError;

    case 403:
      return LocaleKeys.forbiddenError;

    case 404:
      return LocaleKeys.requestNotFound;

    case 405:
      return LocaleKeys.methodNotAllowed;

    case 408:
      return LocaleKeys.requestTimeout;

    case 409:
      return LocaleKeys.conflictError;

    case 422:
      return LocaleKeys.validationError;

    case 429:
      return LocaleKeys.tooManyRequests;

    case 500:
      return LocaleKeys.internalServerError;

    case 502:
      return LocaleKeys.badGateway;

    case 503:
      return LocaleKeys.serviceUnavailable;

    case 504:
      return LocaleKeys.gatewayTimeout;
    //  No internet / unknown
    case null:
      return LocaleKeys.noInternetConnection;

    default:
      return LocaleKeys.oopsErrorTryAgain;
  }
}
