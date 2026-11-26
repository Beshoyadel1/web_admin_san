import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/create_user_request.dart';

class LoginResult {
  final bool success;
  final String message;
  final CreateUserRequest? user;

  LoginResult({
    required this.success,
    required this.message,
    this.user,
  });
}
