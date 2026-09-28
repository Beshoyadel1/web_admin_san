import 'package:get_it/get_it.dart';
import '../../../../core/cubit/app_cubit/app_cubit.dart';
import '../features/technical_support/data/datasource/admin_chat_repository.dart';
import '../features/technical_support/presentation/bloc/admin_chat_cubit/admin_chat_cubit.dart';
import 'language/language_cubit/language_cubit.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<LanguageCubit>(() => LanguageCubit());
  getIt.registerLazySingleton<AppCubit>(() => AppCubit());
  getIt.registerLazySingleton<AdminChatRepository>(
    () => const AdminChatRepository(),
  );
  getIt.registerLazySingleton<AdminChatCubit>(
    () => AdminChatCubit(chatRepository: getIt<AdminChatRepository>()),
  );
}
