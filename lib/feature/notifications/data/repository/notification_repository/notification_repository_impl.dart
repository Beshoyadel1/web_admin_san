import 'package:web_admin_san/core/networking/local_services.dart';
import 'package:web_admin_san/feature/notifications/domain/repository/notification_repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  @override
  Future<dynamic> getCurrentUser() async {
    return await AuthLocalStorage.getUser();
  }
}
