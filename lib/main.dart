import 'package:anilist/core/theme/app_color.dart';
import 'package:anilist/core/config/app_info.dart';
import 'package:anilist/firebase_options.dart';
import 'package:anilist/global/bloc/app_bloc/app_bloc.dart';
import 'package:anilist/global/model/user_data.dart';
import 'package:anilist/core/routes/navigator_key.dart';
import 'package:anilist/core/theme/theme.config.dart';
import 'package:anilist/modules/ads/data/admob_api.dart';
import 'package:anilist/modules/auth/screen/login_screen.dart';
import 'package:anilist/modules/dashboard/screen/dashboard_screen.dart';
import 'package:anilist/modules/my_list/bloc/my_list_bloc.dart';
import 'package:anilist/services/local_database_service.dart';
import 'package:anilist/services/local_storage_service.dart';
import 'package:anilist/services/notification_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await AppInfo.init();

  if (!kIsWeb) {
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
  }

  // Init locale
  await EasyLocalization.ensureInitialized();

  // Loads user preferences
  UserData? userData = await LocalStorageService.getUserData();
  bool isDarkMode = await LocalStorageService.getIsDarkMode();
  bool isNotificationEnable =
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

class MyApp extends StatefulWidget {
  final UserData? userData;
  final bool isDarkMode;
  final bool isNotificationEnable;
  const MyApp({
    super.key,
    this.userData,
    required this.isDarkMode,
    required this.isNotificationEnable,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appBloc = AppBloc();

  void _initAppBloc() {
    _appBloc.add(InitAppEvent(
      userData: widget.userData,
      isDarkMode: widget.isDarkMode,
      isNotificationEnable: widget.isNotificationEnable,
    ));
  }

  @override
  void initState() {
    super.initState();
    _initAppBloc();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _appBloc,
        ),
        BlocProvider(
          create: (context) => MyListBloc(),
        ),
      ],
      child: BlocBuilder<AppBloc, AppState>(
        buildWhen: (previous, current) =>
            previous.isDarkMode != current.isDarkMode,
        builder: (context, state) {
          return MaterialApp(
            title: AppInfo.appName,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: themeConfig(isDarkMode: state.isDarkMode),
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: kDebugMode,
            builder: (_, child) => SafeArea(
              top: false,
              child: child!,
            ),
            home: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.noScaling),
              child: widget.userData != null
                  ? const DashboardScreen()
                  : const LoginScreen(),
            ),
          );
        },
      ),
    );
  }
}
