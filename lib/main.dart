import 'dart:async';
import 'package:web_admin_san/generated/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/bloc_observer.dart';
import 'package:web_admin_san/core/di/sl.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/services/audio_service/audio_service.dart';
import 'package:web_admin_san/core/services/fcm_service.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_cubit.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/splash_page/splash_page.dart';
import 'package:web_admin_san/feature/layout/view_model/layout_cubit/app_cubit.dart';
import 'package:web_admin_san/feature/notifications/view_model/notification_cubit/notification_cubit.dart';
import 'package:web_admin_san/firebase_options.dart';

final GlobalKey<ScaffoldState> scaffoldKeyDrawer = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldMessengerState> scaffoldKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await EasyLocalization.ensureInitialized();
  try {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.windows &&
            defaultTargetPlatform != TargetPlatform.linux)) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (!kIsWeb) {
        FirebaseMessaging.onBackgroundMessage(
            firebaseMessagingBackgroundHandler);
      }
    }
  } catch (e) {
    debugPrint("Firebase init note: $e");
  }

  setupGetIt();

  // Initialize FCM service early so listeners (foreground and service worker) are registered immediately
  try {
    await FcmService.instance.init();
    unawaited(FcmService.instance.syncCurrentToken());
  } catch (e) {
    debugPrint("FCM early init note: $e");
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      assetLoader: const CodegenLoader(),
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      useOnlyLangCode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NotificationCubit>.value(
            value: getIt<NotificationCubit>()..getUserNotification(),
          ),
          BlocProvider<AuthCubit>(
            create: (_) => AuthCubit()..init(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void reassemble() {
    super.reassemble();
    AudioService.instance.stopNotificationSound();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => getIt<AppCubit>(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldKey,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        localizationsDelegates: context.localizationDelegates,
        title: 'San Admin System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: AppFonts.readexProFontFamily,
          useMaterial3: true,
        ),
        home: const SplashPage(),
      ),
    );
  }
}
