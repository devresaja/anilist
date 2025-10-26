import 'package:anilist/app.dart';
import 'package:anilist/core/theme/app_color.dart';
import 'package:anilist/core/config/app_info.dart';
import 'package:anilist/firebase_options.dart';
import 'package:anilist/modules/ads/data/admob_api.dart';
import 'package:anilist/services/local_database_service.dart';
import 'package:anilist/services/local_storage_service.dart';
import 'package:anilist/services/notification_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await AppInfo.init();

  // Sets up error handling with Firebase Crashlytics
  FirebaseCrashlytics.instance.setCustomKey(
    'shorebird_patch_number',
    '${await ShorebirdCodePush().currentPatchNumber()}',
  );

  FirebaseCrashlytics.instance.setCustomKey(
    'app_version',
    AppInfo.version,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Init notification
  await NotificationService.initNotification();

  // NOTE: This line must be commented out due to commercial purposes
  await AdMobService.init();

  // Init local db
  await LocalDatabaseService().init();

  // Init locale
  await EasyLocalization.ensureInitialized();

  // Loads user preferences
  final userData = await LocalStorageService.getUserData();
  final isDarkMode = await LocalStorageService.getIsDarkMode();
  final isNotificationEnable =
      await LocalStorageService.getNotificationSetting();

  AppColor.init(isDarkMode);

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('id'),
      ],
      path: 'assets/i18n',
      fallbackLocale: const Locale('en'),
      saveLocale: true,
      useOnlyLangCode: true,
      child: MyApp(
        userData: userData,
        isDarkMode: isDarkMode,
        isNotificationEnable: isNotificationEnable,
      ),
    ),
  );
}
