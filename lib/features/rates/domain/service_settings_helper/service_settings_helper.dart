import 'package:web_admin_san/features/rates/data/model/get_services_model/service_setting_model.dart';

class ServiceSettingsHelper {
  static List<ServiceSettingModel> filterByParentId({
    required List<ServiceSettingModel> services,
    required int parentId,
  }) {
    return services.where((e) => e.parentId == parentId).toList();
  }

  static String getServiceName({
    required ServiceSettingModel service,
    required bool isArabic,
  }) {
    return isArabic ? service.name ?? '' : service.latinName ?? '';
  }

}
