import 'package:get_it/get_it.dart';
import 'package:web_admin_san/feature/car_approval/data/datasource/car_approval_datasource.dart';
import 'package:web_admin_san/feature/car_approval/view_model/car_approval_cubit.dart';
import 'package:web_admin_san/feature/layout/view_model/layout_cubit/app_cubit.dart';
import 'package:web_admin_san/feature/notifications/view_model/notification_cubit/notification_cubit.dart';
import 'package:web_admin_san/feature/technical_support_page/data/datasource/admin_chat_repository.dart';
import 'package:web_admin_san/feature/technical_support_page/view_model/admin_chat_cubit/admin_chat_cubit.dart';

import 'package:web_admin_san/feature/delivery_setting/data/datasource/delivery_setting_datasource.dart';
import 'package:web_admin_san/feature/delivery_setting/presentation/bloc/delivery_setting_cubit.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<AppCubit>(() => AppCubit());
  getIt.registerLazySingleton<NotificationCubit>(() => NotificationCubit());
  getIt.registerLazySingleton<AdminChatRepository>(
    () => const AdminChatRepository(),
  );
  getIt.registerLazySingleton<AdminChatCubit>(
    () => AdminChatCubit(chatRepository: getIt<AdminChatRepository>()),
  );
  getIt.registerLazySingleton<CarApprovalDatasource>(
    () => const CarApprovalDatasource(),
  );
  getIt.registerLazySingleton<CarApprovalCubit>(
    () => CarApprovalCubit(datasource: getIt<CarApprovalDatasource>()),
  );
  getIt.registerLazySingleton<DeliverySettingDatasource>(
    () => const DeliverySettingDatasource(),
  );
  getIt.registerLazySingleton<DeliverySettingCubit>(
    () => DeliverySettingCubit(datasource: getIt<DeliverySettingDatasource>()),
  );
}

