import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/create_user_request.dart';

class AuthLocalStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String userKey = "user_data";
  static const String passwordKey = "password";

  static Future<void> saveUser(CreateUserRequest user) async {
    await _storage.write(
      key: userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  static Future<CreateUserRequest?> getUser() async {
    final data = await _storage.read(key: userKey);

    if (data == null || data.isEmpty) return null;

    return CreateUserRequest.fromJson(jsonDecode(data));
  }

  static Future<bool> isLoggedIn() async {
    final data = await _storage.read(key: userKey);
    return data != null && data.isNotEmpty;
  }

  static Future<void> clearUser() async {
    await _storage.delete(key: userKey);
  }

  static Future<void> savePassword(String password) async {
    await _storage.write(
      key: passwordKey,
      value: password,
    );
  }

  static Future<String?> getPassword() async {
    return await _storage.read(
      key: passwordKey,
    );
  }

  static Future<void> clearPassword() async {
    await _storage.delete(
      key: passwordKey,
    );
  }

  static const String fcmTokenKey = "fcm_token";
  static const String manualLoginTimeKey = "manual_login_time";

  static Future<void> saveManualLoginDate(DateTime date) async {
    await _storage.write(
      key: manualLoginTimeKey,
      value: date.toIso8601String(),
    );
  }

  static Future<DateTime?> getManualLoginDate() async {
    final data = await _storage.read(key: manualLoginTimeKey);
    if (data == null || data.isEmpty) return null;
    return DateTime.tryParse(data);
  }

  static Future<void> clearManualLoginDate() async {
    await _storage.delete(key: manualLoginTimeKey);
  }

  static Future<bool> isSessionExpired({
    Duration maxDuration = const Duration(hours: 24),
  }) async {
    final loginDate = await getManualLoginDate();
    if (loginDate == null) return true;
    return DateTime.now().difference(loginDate) >= maxDuration;
  }

  static Future<void> saveFcmToken(String token) async {
    await _storage.write(
      key: fcmTokenKey,
      value: token,
    );
  }

  static Future<String?> getFcmToken() async {
    return await _storage.read(
      key: fcmTokenKey,
    );
  }

  static Future<void> deleteFcmToken() async {
    await _storage.delete(
      key: fcmTokenKey,
    );
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
