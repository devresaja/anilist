import 'package:anilist/app.dart';
import 'package:anilist/core/config/app_info.dart';
import 'package:anilist/firebase_options.dart';
import 'package:anilist/services/local_storage_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await AppInfo.init();

  // Use URL path strategy for web
  setUrlStrategy(PathUrlStrategy());

  // Init locale
  await EasyLocalization.ensureInitialized();

  // Loads user preferences
  final userData = await LocalStorageService.getUserData();
  final isDarkMode = await LocalStorageService.getIsDarkMode();
  final isNotificationEnable =
      await LocalStorageService.getNotificationSetting();

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
