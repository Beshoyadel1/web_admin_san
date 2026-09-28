# دليل الربط والتطوير الشامل: Firebase، تسجيل الدخول، نظام المحادثات، وجرس الإشعارات
## Comprehensive Guide: Firebase, Login, Chat System & Notification Bell for San Admin System (`web_admin_san`)

---

## الفهرس / Table of Contents
1. [نظرة عامة والفرق بين نظام المزود والأدمن (Overview & Admin Architectural Alignment)](#1-نظرة-عامة-والفرق-بين-نظام-المزود-والأدمن)
2. [المرحلة الأولى: تهيئة وربط Firebase والمكتبات المطلوبة (Firebase & Dependencies Setup)](#2-المرحلة-الأولى-تهيئة-وربط-firebase-والمكتبات-المطلوبة)
   - [2.1 تحديث pubspec.yaml](#21-تحديث-pubspecyaml)
   - [2.2 إعدادات الويب (web/firebase-messaging-sw.js و web/index.html)](#22-إعدادات-الويب-webfirebase-messaging-swjs-و-webindexhtml)
   - [2.3 ملف firebase_options.dart](#23-ملف-firebase_optionsdart)
   - [2.4 تعديل وتحديث main.dart](#24-تعديل-وتحديث-maindart)
3. [المرحلة الثانية: البنية التحتية والخدمات الأساسية (Core Infrastructure)](#3-المرحلة-الثانية-البنية-التحتية-والخدمات-الأساسية)
   - [3.1 تحديث روابط وثوابت الـ API (api_constants.dart)](#31-تحديث-روابط-وثوابت-الـ-api-api_constantsdart)
   - [3.2 تحديث التخزين المحلي (auth_local_storage.dart)](#32-تحديث-التخزين-المحلي-auth_local_storagedart)
   - [3.3 خدمات إشعارات المتصفح (Browser Notification Services)](#33-خدمات-إشعارات-المتصفح-browser-notification-services)
   - [3.4 خدمة Firebase Cloud Messaging للأدمن (fcm_service.dart)](#34-خدمة-firebase-cloud-messaging-للأدمن-fcm_servicedart)
4. [المرحلة الثالثة: تسجيل الدخول وتحديث التوكن (Login Flow & Token Sync)](#4-المرحلة-الثالثة-تسجيل-الدخول-وتحديث-التوكن)
   - [4.1 تعديل نموذج LoginRequest](#41-تعديل-نموذج-loginrequest)
   - [4.2 تحديث AuthCubit لدعم FCM والـ Admin Type](#42-تحديث-authcubit-لدعم-fcm-والـ-admin-type)
   - [4.3 تحديث واجهة تسجيل الدخول (login_widget.dart)](#43-تحديث-واجهة-تسجيل-الدخول-login_widgetdart)
5. [المرحلة الرابعة: نظام المحادثات والدعم الفني للأدمن (Modern Responsive Support Chat System)](#5-المرحلة-الرابعة-نظام-المحادثات-والدعم-الفني-للأدمن)
   - [5.1 نماذج المحادثة (admin_chat_model.dart)](#51-نماذج-المحادثة-admin_chat_modeldart)
   - [5.2 تحديث ناقل أحداث الشات الفوري (chat_events.dart)](#52-تحديث-ناقل-أحداث-الشات-الفوري-chat_eventsdart)
   - [5.3 مستودع محادثات الأدمن (admin_chat_repository.dart)](#53-مستودع-محادثات-الأدمن-admin_chat_repositorydart)
   - [5.4 إدارة حالة المحادثات (AdminChatCubit & State)](#54-إدارة-حالة-المحادثات-adminchatcubit--state)
   - [5.5 واجهات المحادثة المتجاوبة (AdminChatPage & Widgets)](#55-واجهات-المحادثة-المتجاوبة-adminchatpage--widgets)
   - [5.6 حقن الاعتماديات وضبط الصلاحيات (setup_git_it.dart & map_of_all_app.dart)](#56-حقن-الاعتماديات-وضبط-الصلاحيات-setup_git_itdart--map_of_all_appdart)
6. [المرحلة الخامسة: جرس الإشعارات وصفحة الإشعارات الشاملة (Notification Bell & Page)](#6-المرحلة-الخامسة-جرس-الإشعارات-وصفحة-الإشعارات-الشاملة)
   - [6.1 ويدجت جرس الإشعارات (NotificationBell)](#61-ويدجت-جرس-الإشعارات-notificationbell)
   - [6.2 صفحة الإشعارات الكاملة (NotificationsPage)](#62-صفحة-الإشعارات-الكاملة-notificationspage)
   - [6.3 تحديث AppBar في لوحة التحكم (app_bar_for_page.dart)](#63-تحديث-appbar-في-لوحة-التحكم-app_bar_for_pagedart)
7. [قائمة الفحص والاختبار (Verification & Testing Checklist)](#7-قائمة-الفحص-والاختبار)

---

## 1. نظرة عامة والفرق بين نظام المزود والأدمن

في نظام لوحة تحكم الإدارة العامة (`web_admin_san`)، يمثل الأدمن السلطة العليا لإدارة المنصة، وله خصوصيات ومسؤوليات تشمل:
1. **استقبال إشعارات النظام الإدارية**: تنبيهات انضمام مزودين جدد، نزاعات العملاء، العمليات المالية، والشكاوى الفنية.
2. **الدعم الفني الشامل (Omni-Support Chat)**: الأدمن يتواصل مع كافة أطراف المنظومة (عملاء، مزودين، موظفين، فنيين، وسائقين).
3. **نظام الصلاحيات (Role-Based Permissions)**: تفعيل المحادثات والدعم الفني مشروط بامتلاك الأدمن لصلاحية `permissions.support`.

### جدول المقارنة بين نظام المزود ونظام الأدمن:
| الميزة / المعيار | نظام المزود (`provider_system_sun`) | نظام الأدمن (`web_admin_san`) |
| :--- | :--- | :--- |
| **نوع المستخدم (`UserType`)** | `UserType.providerUser` (القيمة `4`) | `UserType.adminUser` (القيمة `6`) |
| **قناة الاشتراك (`FCM Topic`)** | `provider` و `all` | `admin` و `all` |
| **بيانات المستخدم الإضافية** | `providerDetails` (سجل تجاري، ضريبة، آيبان) | `adminDetails` (المسمى الوظيفي، مصفوفة الصلاحيات `AdminPermissionsRequest`) |
| **نطاق الدعم والمحادثات** | محادثات عملاء المنشأة وفريق العمل التابع له | مركز دعم فني مركزي لكافة المستخدمين والمزودين وأعضاء الإدارة |
| **التحكم بالظهور** | مفتوح للمزود | محكوم بصلاحية `hasPermission(permissions.support)` |

---

## 2. المرحلة الأولى: تهيئة وربط Firebase والمكتبات المطلوبة

### 2.1 تحديث `pubspec.yaml`
افتح ملف [pubspec.yaml](file:///D:/Flutter-Projects/web_admin_san/pubspec.yaml) وأضف الحزم التالية تحت قسم `dependencies`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # ... الحزم الموجودة مسبقاً ...
  
  # Firebase Packages
  firebase_core: ^3.8.1
  firebase_messaging: ^15.1.6
  
  # Utilities for UI & Formatting
  shimmer: ^3.0.0
  intl: ^0.19.0
```

بعد الحفظ، نفّذ الأمر التالي في مجلد المشروع:
```bash
flutter pub get
```

---

### 2.2 إعدادات الويب (Web Push Notifications)

#### أ) إنشاء ملف Service Worker: `web/firebase-messaging-sw.js`
أنشئ ملفاً جديداً باسم [firebase-messaging-sw.js](file:///D:/Flutter-Projects/web_admin_san/web/firebase-messaging-sw.js) مخصصاً لإشعارات لوحة تحكم الأدمن:

```javascript
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

if (!firebase.apps.length) {
  firebase.initializeApp({
    apiKey: "AIzaSyB8Lixy-XF0V_UCTGCzUz0AEBzLgIP-7ik",
    appId: "1:567407553652:web:d510db5fa139b829b7b521",
    messagingSenderId: "567407553652",
    projectId: "sun-app-6c6af",
    authDomain: "sun-app-6c6af.firebaseapp.com",
    storageBucket: "sun-app-6c6af.firebasestorage.app",
    measurementId: "G-R3BVP1XBXZ",
  });
}

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log("[firebase-messaging-sw.js] Received background message for Admin: ", payload);

  if (payload.notification && (payload.notification.title || payload.notification.body)) {
    return;
  }

  const notificationTitle =
      payload.data?.title || payload.data?.latintitle || "San Admin System";
  const notificationOptions = {
    body:
        payload.data?.body ||
        payload.data?.description ||
        payload.data?.message ||
        "",
    icon: "/favicon.png",
    data: payload.data,
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});

self.addEventListener("notificationclick", (event) => {
  event.notification.close();
  event.waitUntil(
    clients
      .matchAll({ type: "window", includeUncontrolled: true })
      .then((clientList) => {
        for (const client of clientList) {
          if (client.url && "focus" in client) {
            return client.focus();
          }
        }
        if (clients.openWindow) {
          return clients.openWindow("/");
        }
      })
  );
});
```

#### ب) تحديث ملف `web/index.html`
عدّل ملف [index.html](file:///D:/Flutter-Projects/web_admin_san/web/index.html) لإضافة كود تسجيل Service Worker ودالة عرض الإشعارات قبل وسم `</head>` أو في بداية `<body>`:

```html
  <script>
    if ('serviceWorker' in navigator) {
      window.addEventListener('load', function () {
        navigator.serviceWorker.register('/firebase-messaging-sw.js', { scope: '/' }).catch(function (error) {
          console.warn('Firebase Messaging Service Worker registration failed: ', error);
        });
      });
    }

    window.showBrowserNotification = function(title, body) {
      if (!('Notification' in window)) return;
      if (Notification.permission === 'granted') {
        try {
          new Notification(title, { body: body, icon: '/favicon.png' });
        } catch (e) {
          console.warn('Notification display failed: ', e);
        }
      } else if (Notification.permission !== 'denied') {
        Notification.requestPermission().then(function(permission) {
          if (permission === 'granted') {
            try {
              new Notification(title, { body: body, icon: '/favicon.png' });
            } catch (e) {
              console.warn('Notification display failed: ', e);
            }
          }
        });
      }
    };
  </script>
```

---

### 2.3 ملف `lib/firebase_options.dart`
أنشئ ملفاً جديداً باسم [firebase_options.dart](file:///D:/Flutter-Projects/web_admin_san/lib/firebase_options.dart) لمشروع Firebase المشترك (`sun-app-6c6af`):

```dart
// File generated for FlutterFire.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB8Lixy-XF0V_UCTGCzUz0AEBzLgIP-7ik',
    appId: '1:567407553652:web:d510db5fa139b829b7b521',
    messagingSenderId: '567407553652',
    projectId: 'sun-app-6c6af',
    authDomain: 'sun-app-6c6af.firebaseapp.com',
    storageBucket: 'sun-app-6c6af.firebasestorage.app',
    measurementId: 'G-R3BVP1XBXZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAVzMyvPlxSNcr1TNJzmts5XdCg4YKTY40',
    appId: '1:567407553652:android:3bebbf4d3f7bda33b7b521',
    messagingSenderId: '567407553652',
    projectId: 'sun-app-6c6af',
    storageBucket: 'sun-app-6c6af.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyADbYHlqshr5QBhF4EG6wizEhusFJbRRqY',
    appId: '1:567407553652:ios:4f2ed01919ea4797b7b521',
    messagingSenderId: '567407553652',
    projectId: 'sun-app-6c6af',
    storageBucket: 'sun-app-6c6af.firebasestorage.app',
    iosBundleId: 'com.san.app.sanApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyADbYHlqshr5QBhF4EG6wizEhusFJbRRqY',
    appId: '1:567407553652:ios:4f2ed01919ea4797b7b521',
    messagingSenderId: '567407553652',
    projectId: 'sun-app-6c6af',
    storageBucket: 'sun-app-6c6af.firebasestorage.app',
    iosBundleId: 'com.san.app.sanApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB8Lixy-XF0V_UCTGCzUz0AEBzLgIP-7ik',
    appId: '1:567407553652:web:f6d1d4714fdb64abb7b521',
    messagingSenderId: '567407553652',
    projectId: 'sun-app-6c6af',
    authDomain: 'sun-app-6c6af.firebaseapp.com',
    storageBucket: 'sun-app-6c6af.firebasestorage.app',
    measurementId: 'G-VTQJ6BYFWX',
  );
}
```

---

### 2.4 تعديل وتحديث `lib/main.dart`
عدّل ملف [lib/main.dart](file:///D:/Flutter-Projects/web_admin_san/lib/main.dart) لتهيئة Firebase وتشغيل مستمع الرسائل في الخلفية:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:web_admin_san/core/audio_service/audio_service.dart';
import 'package:web_admin_san/core/services/fcm_service.dart';
import 'package:web_admin_san/firebase_options.dart';
import 'package:web_admin_san/features/auth_page/presentation/auth_gate.dart';
import 'package:web_admin_san/features/auth_page/presentation/bloc/auth_cubit/auth_cubit.dart';
import 'package:web_admin_san/features/notifications/presentation/bloc/notification_cubit/notification_cubit.dart';
import 'core/cubit/app_cubit/app_cubit.dart';
import 'core/language/language_cubit/language_cubit.dart';
import 'core/language/language_cubit/language_states.dart';
import 'core/language/language.dart';
import 'core/setup_git_it.dart';

final GlobalKey<ScaffoldState> scaffoldKeyDrawer = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb || (defaultTargetPlatform != TargetPlatform.windows && defaultTargetPlatform != TargetPlatform.linux)) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (!kIsWeb) {
        FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      }
    }
  } catch (e) {
    debugPrint("Firebase init note: $e");
  }

  setupGetIt();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NotificationCubit()..getUserNotification(),
        ),
        BlocProvider<LanguageCubit>(
          create: (_) => getIt<LanguageCubit>()..getLanguageFromSharedPreference(),
        ),
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit()..init(),
        ),
      ],
      child: const MyApp(),
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
      child: BlocBuilder<LanguageCubit, LanguageStates>(
        buildWhen: (previous, current) => current is ChangeAllAppLanguageState,
        builder: (BuildContext context, state) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            scaffoldMessengerKey: scaffoldKey,
            supportedLocales: supportedLocales,
            locale: LanguageCubit.get(context).selectedLanguage,
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            title: 'San Admin System',
            debugShowCheckedModeBanner: false,
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}
```

---

## 3. المرحلة الثانية: البنية التحتية والخدمات الأساسية

### 3.1 تحديث روابط وثوابت الـ API (`lib/core/api/dio_function/api_constants.dart`)
عدّل ملف [api_constants.dart](file:///D:/Flutter-Projects/web_admin_san/lib/core/api/dio_function/api_constants.dart):
أضف نقاط نهاية الإشعارات وكلاس `FcmConfig` ومواضيع الإشعارات:

```dart
// أضف داخل كلاس ApiLink:
  static const String subscribeToTopic =
      "${ApiConfig.baseUrlApi}/${ApiConfig.notification}/SubscribeToTopic";
  static const String unsubscribeFromTopic =
      "${ApiConfig.baseUrlApi}/${ApiConfig.notification}/UnsubscribeFromTopic";
  static const String updateFcmToken =
      "${ApiConfig.baseUrlApi}/${ApiConfig.user}/UpdateFcmToken";

// أضف هذه الكلاسات في نهاية الملف:
class FcmConfig {
  static const String webVapidKey = String.fromEnvironment(
    'FCM_WEB_VAPID_KEY',
    defaultValue:
        'BG3cqTKmSY0BSiXdMxTcitn7rNvFWiQMrevN0TM1_N6h6DBduRg9XGsrIwDVrUDn-E89Itt0GDBBfRyf3YL_dSU',
  );
}

class NotificationTopic {
  static const String customer = "customer";
  static const String company = "company";
  static const String driver = "driver";
  static const String provider = "provider";
  static const String employee = "employee";
  static const String admin = "admin";
}
```

---

### 3.2 تحديث التخزين المحلي (`lib/core/theming/auth_local_storage.dart`)
أضف دوال التخزين لتوكن الـ FCM داخل [auth_local_storage.dart](file:///D:/Flutter-Projects/web_admin_san/lib/core/theming/auth_local_storage.dart):

```dart
  static const String fcmTokenKey = "fcm_token";

  static Future<void> saveFcmToken(String token) async {
    await _storage.write(
      key: fcmTokenKey,
      value: token,
    );
  }

  static Future<String?> getFcmToken() async {
    return await _storage.read(key: fcmTokenKey);
  }

  static Future<void> deleteFcmToken() async {
    await _storage.delete(key: fcmTokenKey);
  }
```

---

### 3.3 خدمات إشعارات المتصفح (`lib/core/services/browser_notification*`)
أنشئ مجلد `lib/core/services` وأنشئ الملفات الثلاثة التالية:

1. **[lib/core/services/browser_notification.dart](file:///D:/Flutter-Projects/web_admin_san/lib/core/services/browser_notification.dart)**:
```dart
import 'browser_notification_stub.dart'
    if (dart.library.js_interop) 'browser_notification_web.dart';

void showBrowserNotification(String title, String body) {
  showNativeBrowserNotification(title, body);
}
```

2. **[lib/core/services/browser_notification_stub.dart](file:///D:/Flutter-Projects/web_admin_san/lib/core/services/browser_notification_stub.dart)**:
```dart
void showNativeBrowserNotification(String title, String body) {}
```

3. **[lib/core/services/browser_notification_web.dart](file:///D:/Flutter-Projects/web_admin_san/lib/core/services/browser_notification_web.dart)**:
```dart
import 'dart:js_interop';

@JS('showBrowserNotification')
external void _showBrowserNotification(JSString title, JSString body);

void showNativeBrowserNotification(String title, String body) {
  try {
    _showBrowserNotification(title.toJS, body.toJS);
  } catch (_) {}
}
```

---

### 3.4 خدمة Firebase Cloud Messaging للأدمن (`lib/core/services/fcm_service.dart`)
أنشئ الملف [lib/core/services/fcm_service.dart](file:///D:/Flutter-Projects/web_admin_san/lib/core/services/fcm_service.dart) مع تخصيص الـ Admin (`UserType.adminUser = 6` والـ Topic `admin`):

```dart
import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/api/dio_function/dio_controller.dart';
import 'package:web_admin_san/core/services/browser_notification.dart';
import 'package:web_admin_san/core/theming/auth_local_storage.dart';
import 'package:web_admin_san/features/notifications/presentation/bloc/notification_cubit/notification_cubit.dart';
import 'package:web_admin_san/features/notifications/presentation/module/notification_module/notification_module.dart';
import 'package:web_admin_san/main.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('FCM Admin: Handling background message: ${message.messageId}');
  }
}

class FcmService {
  FcmService._();

  static final FcmService instance = FcmService._();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  static bool get isSupported {
    if (kIsWeb) return true;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return true;
      default:
        return false;
    }
  }

  Future<void> init() async {
    if (!isSupported) {
      if (kDebugMode) {
        print('FCM: Platform not supported. Skipping init.');
      }
      return;
    }

    if (_isInitialized) return;

    try {
      final messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (kDebugMode) {
        print('FCM Admin: Authorization status: ${settings.authorizationStatus}');
      }

      _fcmToken = await getToken(vapidKey: FcmConfig.webVapidKey);
      if (_fcmToken != null && _fcmToken!.isNotEmpty) {
        await _syncTokenIfUserAvailable(_fcmToken!);
      }

      messaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        _syncTokenIfUserAvailable(newToken);
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _handleRemoteMessage(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleRemoteMessage(message);
      });

      _isInitialized = true;
    } catch (e, stack) {
      if (kDebugMode) {
        print('FCM Admin initialization error: $e\n$stack');
      }
    }
  }

  Future<String>? _pendingGetToken;

  Future<String> getToken({String? vapidKey}) async {
    if (_pendingGetToken != null) return _pendingGetToken!;
    _pendingGetToken = _internalGetToken(vapidKey: vapidKey);
    try {
      return await _pendingGetToken!;
    } finally {
      _pendingGetToken = null;
    }
  }

  Future<String> _internalGetToken({String? vapidKey}) async {
    if (isSupported) {
      try {
        final effectiveVapidKey = (vapidKey != null && vapidKey.trim().isNotEmpty)
            ? vapidKey.trim()
            : FcmConfig.webVapidKey.trim();

        final token = await FirebaseMessaging.instance
            .getToken(
          vapidKey: (kIsWeb && effectiveVapidKey.isNotEmpty) ? effectiveVapidKey : null,
        )
            .timeout(
          const Duration(seconds: 10),
          onTimeout: () => null,
        );

        if (token != null && token.trim().isNotEmpty) {
          _fcmToken = token.trim();
          await AuthLocalStorage.saveFcmToken(_fcmToken!);
          return _fcmToken!;
        }
      } catch (e) {
        if (kDebugMode) print('FCM Admin getToken note: $e');
      }
    }

    if (_fcmToken != null && _fcmToken!.trim().isNotEmpty) return _fcmToken!;

    final savedToken = await AuthLocalStorage.getFcmToken();
    if (savedToken != null && savedToken.trim().isNotEmpty) {
      _fcmToken = savedToken.trim();
      return _fcmToken!;
    }

    final fallbackToken = await _getOrCreateFallbackToken();
    _fcmToken = fallbackToken;
    return fallbackToken;
  }

  Future<String> _getOrCreateFallbackToken() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomSuffix = (Random().nextInt(900000) + 100000).toString();
    final platformTag = kIsWeb ? 'web' : defaultTargetPlatform.name.toLowerCase();
    final generated = 'fcm_${platformTag}_${timestamp}_$randomSuffix';
    await AuthLocalStorage.saveFcmToken(generated);
    return generated;
  }

  Future<void> syncCurrentToken({int? userId, int? userType}) async {
    final user = await AuthLocalStorage.getUser();
    final effectiveUserId = userId ?? user?.userid;
    // تخصيص الأدمن: UserType.adminUser (6)
    final effectiveUserType = userType ?? user?.type ?? UserType.adminUser;

    if (effectiveUserId != null && effectiveUserId > 0) {
      final token = await getToken(vapidKey: FcmConfig.webVapidKey);
      if (token.isNotEmpty) {
        await _syncTokenWithBackend(
          userId: effectiveUserId,
          userType: effectiveUserType,
          token: token,
        );
      }
    }
  }

  Future<void> _syncTokenIfUserAvailable(String token) async {
    if (token.trim().isEmpty) return;
    final user = await AuthLocalStorage.getUser();
    if (user != null && user.userid != null && user.userid! > 0) {
      await _syncTokenWithBackend(
        userId: user.userid!,
        userType: user.type ?? UserType.adminUser,
        token: token,
      );
    }
  }

  Future<void> _syncTokenWithBackend({
    required int userId,
    required int userType,
    required String token,
  }) async {
    final cleanToken = token.trim();
    if (cleanToken.isEmpty) return;

    try {
      final payload = {
        'userId': userId,
        'UserId': userId,
        'userType': userType,
        'UserType': userType,
        'fcmToken': cleanToken,
        'FcmToken': cleanToken,
        'FCMTOKEN': cleanToken,
      };

      await Network.postDataWithBodyAndParams(
        payload,
        payload,
        ApiLink.updateFcmToken,
      );
      await AuthLocalStorage.saveFcmToken(cleanToken);

      if (kDebugMode) {
        print('FCM: Successfully synced token with backend for Admin $userId (type $userType)');
      }

      // اشتراك الأدمن في التوبيك admin و all
      if (isSupported && !cleanToken.startsWith('fcm_')) {
        await subscribeToTopic(NotificationTopic.admin, userType: userType);
        await subscribeToTopic('all', userType: userType);
      }
    } catch (e) {
      if (kDebugMode) print('FCM Admin sync error: $e');
    }
  }

  Future<void> subscribeToTopic(String topic, {int? userType}) async {
    final token = _fcmToken ?? await AuthLocalStorage.getFcmToken();
    if (token == null || token.isEmpty || token.startsWith('fcm_')) return;

    if (!kIsWeb) {
      try {
        await FirebaseMessaging.instance.subscribeToTopic(topic);
      } catch (_) {}
    }

    try {
      final body = jsonEncode({
        'fcmToken': token,
        'topic': topic,
        if (userType != null) 'userType': userType,
      });
      await Network.postDataWithBody(body, ApiLink.subscribeToTopic);
    } catch (_) {}
  }

  void _handleRemoteMessage(RemoteMessage message) {
    try {
      final data = Map<String, dynamic>.from(message.data);
      final rawType = (data['type'] ?? data['eventType'] ?? '').toString();
      final normType = rawType.toLowerCase().replaceAll('_', '');

      final title = message.notification?.title ??
          data['title'] ??
          data['latintitle'] ??
          data['ar_title'] ??
          data['en_title'] ??
          data['fromusername'] ??
          data['sender'] ??
          'إشعار إداري جديد';
      final body = message.notification?.body ??
          data['body'] ??
          data['description'] ??
          data['latindesc'] ??
          data['ar_body'] ??
          data['en_body'] ??
          data['message'] ??
          data['text'] ??
          '';

      showBrowserNotification(title.toString(), body.toString());

      final adaptedPayload = <String, dynamic>{
        'type': rawType,
        'title': title.toString(),
        'body': body.toString(),
        'data': data,
        ...data,
      };

      final isChatPayload = normType == 'chat' ||
          normType == 'receivemessage' ||
          data.containsKey('fromuser') ||
          data.containsKey('fromUser');

      final isNewOrderPayload = normType == 'neworder' ||
          data.containsKey('orderinfo') ||
          data.containsKey('orderInfo');

      final isUpdateOrderStatusPayload = normType == 'updateorderstatus' ||
          normType == 'orderstatus';

      if (isNewOrderPayload) {
        NotificationModule.instance.newOrderHandler.handle([adaptedPayload]);
      } else if (isUpdateOrderStatusPayload) {
        NotificationModule.instance.updateOrderStatusHandler.handle([adaptedPayload]);
        NotificationModule.instance.receiveNotificationHandler.handle([adaptedPayload]);
      } else if (isChatPayload) {
        NotificationModule.instance.receiveMessageHandler.handle([adaptedPayload]);
      } else {
        NotificationModule.instance.receiveNotificationHandler.handle([adaptedPayload]);
      }

      // تحديث فوري لعداد جرس الإشعارات
      final ctx = navigatorKey.currentContext;
      if (ctx != null) {
        BlocProvider.of<NotificationCubit>(ctx, listen: false).getUserNotification();
      }
    } catch (e, stack) {
      if (kDebugMode) print('FCM Admin processing error: $e\n$stack');
    }
  }

  Future<void> disconnect() async {
    _isInitialized = false;
    _fcmToken = null;
    await AuthLocalStorage.deleteFcmToken();
  }
}
```

---

## 4. المرحلة الثالثة: تسجيل الدخول وتحديث التوكن

### 4.1 تعديل نموذج `LoginRequest`
عدّل ملف [lib/features/auth_page/data/request/login_request/login_request.dart](file:///D:/Flutter-Projects/web_admin_san/lib/features/auth_page/data/request/login_request/login_request.dart) ليشمل `fcmToken`:

```dart
class LoginRequest {
  final String user;
  final String password;
  final int type;
  final String? fcmToken;

  LoginRequest({
    required this.user,
    required this.password,
    required this.type,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    final cleanToken = fcmToken?.trim();
    return {
      "USER": user,
      "PASSWORD": password,
      "type": type,
      if (cleanToken != null && cleanToken.isNotEmpty) ...{
        "fcmtoken": cleanToken,
        "fcmToken": cleanToken,
        "FCMTOKEN": cleanToken,
      },
    };
  }
}
```

---

### 4.2 تحديث `AuthCubit` لدعم FCM والـ Admin Type
عدّل ملف [lib/features/auth_page/presentation/bloc/auth_cubit/auth_cubit.dart](file:///D:/Flutter-Projects/web_admin_san/lib/features/auth_page/presentation/bloc/auth_cubit/auth_cubit.dart):

#### أ) دالة `init()` (Auto Login):
```dart
  Future<void> init() async {
    emit(AuthLoading());

    unawaited(FcmService.instance.getToken(vapidKey: FcmConfig.webVapidKey));

    final localUser = await AuthLocalStorage.getUser();
    final password = await AuthLocalStorage.getPassword();

    if (localUser == null || password == null) {
      emit(AuthUnauthenticated());
      return;
    }

    final fcmToken = await FcmService.instance.getToken(vapidKey: FcmConfig.webVapidKey);

    final result = await loginFunction(
      loginRequest: LoginRequest(
        user: localUser.email!,
        password: password,
        type: UserType.adminUser, // تخصيص نوع الأدمن (6)
        fcmToken: fcmToken.isNotEmpty ? fcmToken : null,
      ),
    );

    if (!result.success || result.user == null) {
      await _forceLogout();
      return;
    }

    final apiUser = result.user!;

    // ربط إشعارات FCM للأدمن
    try {
      await FcmService.instance.init();
      await FcmService.instance.syncCurrentToken(
        userId: apiUser.userid,
        userType: apiUser.type ?? UserType.adminUser,
      );
    } catch (e) {
      debugPrint("FCM Admin Init note: $e");
    }

    if (!SignalRService.instance.isConnected) {
      await SignalRService.instance.connect(hubUrl: ApiLink.notificationHub);
    }

    await _checkFacilityCompletion(apiUser);
  }
```

#### ب) دالة `login()`:
```dart
  Future<void> login(LoginRequest request) async {
    emit(AuthLoginLoading());

    final fcmToken = await FcmService.instance.getToken(vapidKey: FcmConfig.webVapidKey);
    final String? tokenToSend = fcmToken.isNotEmpty
        ? fcmToken
        : ((request.fcmToken != null && request.fcmToken!.isNotEmpty)
            ? request.fcmToken
            : null);

    final effectiveRequest = LoginRequest(
      user: request.user,
      password: request.password,
      type: UserType.adminUser, // نوع الأدمن
      fcmToken: tokenToSend,
    );

    final result = await loginFunction(
      loginRequest: effectiveRequest,
    );

    if (!result.success || result.user == null) {
      emit(AuthLoginError(result.message));
      return;
    }

    final apiUser = result.user!;

    await AuthLocalStorage.saveUser(apiUser);
    await AuthLocalStorage.savePassword(effectiveRequest.password);

    try {
      await FcmService.instance.init();
      await FcmService.instance.syncCurrentToken(
        userId: apiUser.userid,
        userType: apiUser.type ?? UserType.adminUser,
      );
    } catch (e) {
      debugPrint("FCM Admin Init note: $e");
    }

    if (!SignalRService.instance.isConnected) {
      await SignalRService.instance.connect(hubUrl: ApiLink.notificationHub);
    }

    emit(AuthLoginSuccess(message: result.message));
    await _checkFacilityCompletion(apiUser);
  }
```

#### ج) دالة `_forceLogout()` و `logout()`:
```dart
  Future<void> _forceLogout() async {
    await AuthLocalStorage.clearUser();
    await AuthLocalStorage.clearPassword();

    try {
      await FcmService.instance.disconnect();
    } catch (_) {}

    await SignalRService.instance.disconnect();
    emit(AuthUnauthenticated());
  }

  Future<void> logout(BuildContext context) async {
    emit(AuthLoading());
    await _forceLogout();
  }
```

---

### 4.3 تحديث واجهة تسجيل الدخول (`login_widget.dart`)
عند النقر على زر الدخول في شاشة الـ Login:
```dart
final fcmToken = await FcmService.instance.getToken(vapidKey: FcmConfig.webVapidKey);

context.read<AuthCubit>().login(
  LoginRequest(
    user: emailController.text.trim(),
    password: passwordController.text,
    type: UserType.adminUser,
    fcmToken: fcmToken.isNotEmpty ? fcmToken : null,
  ),
);
```

---

## 5. المرحلة الرابعة: نظام المحادثات والدعم الفني للأدمن

### 5.1 نماذج المحادثة (`admin_chat_model.dart`)
أنشئ الملف [lib/features/technical_support/data/model/admin_chat_model.dart](file:///D:/Flutter-Projects/web_admin_san/lib/features/technical_support/data/model/admin_chat_model.dart):
* يشتمل على كلاسات `GetAllMessagesModel` و `ChatMessageModel` و `WorkTeamMemberModel` (وهي متوافقة وموحدة مع المزود).

---

### 5.2 تحديث ناقل أحداث الشات الفوري (`chat_events.dart`)
عدّل ملف [lib/features/technical_support/data/model/chat_events/chat_events.dart](file:///D:/Flutter-Projects/web_admin_san/lib/features/technical_support/data/model/chat_events/chat_events.dart):
أضف `activeChatUserId` و `activeChatUserType` لتفادي إظهار الـ Popups المنبثقة إذا كانت نافذة المحادثة مفتوحة حالياً:

```dart
class ChatEvents {
  ChatEvents._();

  static final ChatEvents instance = ChatEvents._();

  int? activeChatUserId;
  int? activeChatUserType;

  final StreamController<ReceiveMessageData> _controller =
      StreamController<ReceiveMessageData>.broadcast();

  Stream<ReceiveMessageData> get stream => _controller.stream;

  void add(ReceiveMessageData data) {
    _controller.add(data);
  }

  Future<void> dispose() async {
    activeChatUserId = null;
    activeChatUserType = null;
    await _controller.close();
  }
}
```

---

### 5.3 مستودع محادثات الأدمن (`admin_chat_repository.dart`)
أنشئ الملف [lib/features/technical_support/data/datasource/admin_chat_repository.dart](file:///D:/Flutter-Projects/web_admin_san/lib/features/technical_support/data/datasource/admin_chat_repository.dart):

```dart
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/api/dio_function/dio_controller.dart';
import '../model/admin_chat_model.dart';

class AdminChatRepository {
  const AdminChatRepository();

  Future<List<GetAllMessagesModel>> getAllMessages({
    required int userId,
    required int userType,
  }) async {
    final response = await Network.postDataWithBodyAndParams(
      {},
      {'userId': userId, 'userType': userType},
      ApiLink.getUserChats,
    );
    final responseData = response.data;
    if (responseData == null) return [];

    List rawList = [];
    if (responseData is List) {
      rawList = responseData;
    } else if (responseData is Map && responseData['data'] is List) {
      rawList = responseData['data'];
    }

    return rawList
        .whereType<Map>()
        .map((item) => GetAllMessagesModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<List<WorkTeamMemberModel>> getWorkTeam({
    required int userId,
    required int userType,
  }) async {
    final response = await Network.postDataWithBodyAndParams(
      {},
      {'userId': userId, 'user': userId, 'userType': userType},
      ApiLink.getWorkTeamChat,
    );
    final responseData = response.data;
    if (responseData == null) return [];

    List rawList = [];
    if (responseData is List) {
      rawList = responseData;
    } else if (responseData is Map && responseData['data'] is List) {
      rawList = responseData['data'];
    }

    return rawList
        .whereType<Map>()
        .map((item) => WorkTeamMemberModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<List<ChatMessageModel>> getChatMessages({
    required int fromUserId,
    required int fromUserType,
    required int toUserId,
    required int toUserType,
  }) async {
    final response = await Network.postDataWithBodyAndParams(
      {},
      {
        'fromUserId': fromUserId,
        'fromUserType': fromUserType,
        'toUserId': toUserId,
        'toUserType': toUserType,
      },
      ApiLink.getChatMessages,
    );
    final responseData = response.data;
    if (responseData == null) return [];

    List rawList = [];
    if (responseData is List) {
      rawList = responseData;
    } else if (responseData is Map && responseData['data'] is List) {
      rawList = responseData['data'];
    }

    return rawList
        .whereType<Map>()
        .map((item) => ChatMessageModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
```

---

### 5.4 إدارة حالة المحادثات (`AdminChatCubit` & `AdminChatState`)
أنشئ المجلد `lib/features/technical_support/presentation/bloc/admin_chat_cubit/`:
* `admin_chat_state.dart`: إدارة حالة المحادثات المفتوحة، شريط البحث، والرسائل غير المقروءة.
* `admin_chat_cubit.dart`:
  - تهيئة المتغيرات بنوع الأدمن `_cachedUserType = UserType.adminUser`.
  - الاستماع لـ `ChatEvents.instance.stream` للتحديث اللحظي للرسائل.
  - تشغيل صوت الإشعار وتحديث الـ Badges تلقائياً.

---

### 5.5 واجهات المحادثة المتجاوبة (`AdminChatPage` & Widgets)
انسخ المجلد المساعد للواجهات [widgets/](file:///d:/Flutter-Projects/provider_system_sun/lib/features/technical_support/presentation/pages/widgets) إلى:
`lib/features/technical_support/presentation/pages/widgets/`

ثم أنشئ الصفحة الرئيسية [lib/features/technical_support/presentation/pages/admin_chat_page.dart](file:///D:/Flutter-Projects/web_admin_san/lib/features/technical_support/presentation/pages/admin_chat_page.dart):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/setup_git_it.dart';
import '../../../../core/theming/colors.dart';
import '../bloc/admin_chat_cubit/admin_chat_cubit.dart';
import '../bloc/admin_chat_cubit/admin_chat_state.dart';
import 'widgets/chat_conversations_panel.dart';
import 'widgets/chat_thread_panel.dart';
import 'widgets/chat_work_team_panel.dart';

class AdminChatPage extends StatefulWidget {
  const AdminChatPage({super.key});

  @override
  State<AdminChatPage> createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
  @override
  void initState() {
    super.initState();
    final cubit = getIt<AdminChatCubit>();
    cubit.clearSelectedChat();
    cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AdminChatCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return const _MobileChatLayout();
            } else if (constraints.maxWidth < 1024) {
              return const _TabletChatLayout();
            } else {
              return const _DesktopChatLayout();
            }
          },
        ),
      ),
    );
  }
}

class _DesktopChatLayout extends StatelessWidget {
  const _DesktopChatLayout();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(width: 340, child: ChatConversationsPanel()),
        Expanded(child: ChatThreadPanel()),
        SizedBox(width: 280, child: ChatWorkTeamPanel()),
      ],
    );
  }
}

class _TabletChatLayout extends StatelessWidget {
  const _TabletChatLayout();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(width: 340, child: ChatConversationsPanel()),
        Expanded(child: ChatThreadPanel()),
      ],
    );
  }
}

class _MobileChatLayout extends StatelessWidget {
  const _MobileChatLayout();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminChatCubit, AdminChatState>(
      buildWhen: (prev, curr) => prev.selectedChat != curr.selectedChat,
      builder: (context, state) {
        if (state.selectedChat != null) {
          return const ChatThreadPanel();
        }
        return const ChatConversationsPanel();
      },
    );
  }
}
```

---

### 5.6 حقن الاعتماديات وضبط الصلاحيات
1. في [lib/core/setup_git_it.dart](file:///D:/Flutter-Projects/web_admin_san/lib/core/setup_git_it.dart):
```dart
  getIt.registerLazySingleton<AdminChatRepository>(
    () => const AdminChatRepository(),
  );
  getIt.registerLazySingleton<AdminChatCubit>(
    () => AdminChatCubit(chatRepository: getIt<AdminChatRepository>()),
  );
```

2. في [lib/core/utilies/map_of_all_app.dart](file:///D:/Flutter-Projects/web_admin_san/lib/core/utilies/map_of_all_app.dart):
استبدل `TechnicalSupportAdminSun()` بـ `AdminChatPage()` مع الحفاظ على شرط الصلاحية:
```dart
    if (hasPermission(permissions.support))
      const PageNodeModel(
        name: AppLanguageKeys.technicalSupport,
        image: AppImageKeys.support,
        number: PagesOfAllApp.technicalSupportPageNumber,
        page: AdminChatPage(),
      ),
```

---

## 6. المرحلة الخامسة: جرس الإشعارات وصفحة الإشعارات الشاملة

### 6.1 ويدجت جرس الإشعارات (`NotificationBell`)
أنشئ الملف [lib/features/notifications/presentation/pages/notification_bell/notification_bell.dart](file:///D:/Flutter-Projects/web_admin_san/lib/features/notifications/presentation/pages/notification_bell/notification_bell.dart):
* يشتمل على أيقونة الجرس مع الـ Badge لعدد الإشعارات غير المقروءة.
* قائمة Overlay منسدلة حديثة تفتح أسفل الجرس بانسيابية.
* زر "عرض الكل" الذي يوجه لصفحة الإشعارات الكاملة.
* تصفير العداد وتحديد كمقروء عند إغلاق القائمة عبر `makeNotificationViewed()`.

---

### 6.2 صفحة الإشعارات الكاملة (`NotificationsPage`)
أنشئ الملف [lib/features/notifications/presentation/pages/notifications_page/notifications_page.dart](file:///D:/Flutter-Projects/web_admin_san/lib/features/notifications/presentation/pages/notifications_page/notifications_page.dart):
* تاريخ الإشعارات الكامل مع دعم الـ Infinite Scroll والتحميل التلقائي (`cubit.loadMore()`).
* مؤثرات الـ Shimmer Skeleton أثناء جلب البيانات.

---

### 6.3 تحديث AppBar في لوحة التحكم (`app_bar_for_page.dart`)
في ملف [lib/features/store_page/presentation/pages/store_widgets/app_bar_for_page.dart](file:///D:/Flutter-Projects/web_admin_san/lib/features/store_page/presentation/pages/store_widgets/app_bar_for_page.dart):
استبدل:
```dart
const NotificationPopup(),
```
بـ:
```dart
const NotificationBell(),
```
مع استيراد:
```dart
import '../../../../notifications/presentation/pages/notification_bell/notification_bell.dart';
```

---

## 7. قائمة الفحص والاختبار (Verification & Testing Checklist)

1. **فحص الـ Dependencies**:
   ```bash
   flutter pub get
   flutter analyze
   ```
2. **اختبار الإشعارات في المتصفح**:
   - شغل المشروع على متصفح Chrome: `flutter run -d chrome`.
   - اسمح بالإشعارات وتأكد من طباعة: `FCM: Successfully obtained new token: ...`.
3. **فحص تسجيل الدخول ومزامنة التوكن**:
   - تسجيل الدخول بحساب الأدمن والتأكد من إرسال `fcmToken` ونوع المستخدم `type: 6`.
   - التحقق من نجاح طلب `UpdateFcmToken` والاشتراك في الـ Topic `admin`.
4. **اختبار جرس الإشعارات**:
   - التأكد من تحديث العداد الأحمر عند وصول إشعار إداري جديد وعزف نغمة التنبيه.
   - فتح القائمة المنسدلة والتأكد من فتح صفحة "عرض الكل" بسلاسة.
5. **اختبار الدعم الفني والمحادثات**:
   - تسجيل الدخول بحساب أدمن يمتلك صلاحية `support`.
   - فتح شاشة "الدعم الفني / Technical Support" والتأكد من تحميل الواجهة الثلاثية الحديثة والمحادثات الفورية.
