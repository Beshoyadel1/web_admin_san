import 'package:web_admin_san/features/rates/data/model/get_services_model/service_setting_model.dart';

abstract class ServiceSettingsState {}

class ServiceSettingsInitial extends ServiceSettingsState {}

class ServiceSettingsLoading extends ServiceSettingsState {}

class ServiceSettingsSuccess extends ServiceSettingsState {
  final List<ServiceSettingModel> services;

  ServiceSettingsSuccess(this.services);
}

class ServiceSettingsError extends ServiceSettingsState {
  final String message;

  ServiceSettingsError(this.message);
}