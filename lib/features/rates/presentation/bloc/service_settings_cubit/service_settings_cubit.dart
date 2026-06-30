import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/rates/data/datasource/get_services_datasource/get_services_repository.dart';
import 'package:web_admin_san/features/rates/data/model/get_services_model/service_setting_model.dart';
import 'package:web_admin_san/features/rates/domain/service_settings_helper/service_settings_helper.dart';
import 'package:web_admin_san/features/rates/presentation/bloc/service_settings_cubit/service_settings_state.dart';

class ServiceSettingsCubit extends Cubit<ServiceSettingsState> {
  ServiceSettingsCubit() : super(ServiceSettingsInitial());

  static ServiceSettingsCubit get(context) => BlocProvider.of(context);

  List<ServiceSettingModel> allServices = [];

  List<ServiceSettingModel> allMainServices = [];

  int currentParentId = 0;
  int? selectedServiceId;

  ServiceSettingModel? selectedService;
  bool isAllServicesSelected = true;

  void selectAllServices() {
    isAllServicesSelected = true;
    selectedService = null;

    if (state is ServiceSettingsSuccess) {
      emit(
        ServiceSettingsSuccess(
          (state as ServiceSettingsSuccess).services,
        ),
      );
    }
  }

  void selectService(ServiceSettingModel service) {
    isAllServicesSelected = false;
    selectedService = service;

    if (state is ServiceSettingsSuccess) {
      emit(
        ServiceSettingsSuccess(
          (state as ServiceSettingsSuccess).services,
        ),
      );
    }
  }
  Future<void> getServices({required int parentId}) async {
    emit(ServiceSettingsLoading());

    try {
      currentParentId = parentId;

      if (allServices.isEmpty) {
        allServices = await getServicesFunction();
      }

      final filtered = ServiceSettingsHelper.filterByParentId(
        services: allServices,
        parentId: parentId,
      );

      emit(ServiceSettingsSuccess(filtered));
    } catch (e) {
      emit(ServiceSettingsError(e.toString()));
    }
  }
  Future<void> getMainServices() async {
    emit(ServiceSettingsLoading());

    try {
      if (allServices.isEmpty) {
        allServices = await getServicesFunction();
      }

      final mainServices = allServices.where((e) {
        return (e.parentId ?? 0) == 0 &&
            (e.id ?? 0) != 4;
      }).toList();

      allMainServices=mainServices;
      emit(ServiceSettingsSuccess(mainServices));
    } catch (e) {
      emit(ServiceSettingsError(e.toString()));
    }
  }

  Future<void> getChildServices() async {
    emit(ServiceSettingsLoading());

    try {
      if (allServices.isEmpty) {
        allServices = await getServicesFunction();
      }

      final childServices = allServices
          .where((e) => (e.parentId ?? 0) != 0)
          .toList();

      selectedService = null;
      isAllServicesSelected = true;

      emit(
        ServiceSettingsSuccess(childServices),
      );
    } catch (e) {
      emit(ServiceSettingsError(e.toString()));
    }
  }}