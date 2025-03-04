import 'package:anilist/core/env/env.dart';
import 'package:anilist/firebase_options.dart';
import 'package:anilist/global/bloc/app_bloc/app_bloc.dart';
import 'package:anilist/global/model/user_data.dart';
import 'package:anilist/core/routes/navigator_key.dart';
import 'package:anilist/core/theme/theme.config.dart';
import 'package:anilist/modules/ads/data/admob_api.dart';
import 'package:anilist/modules/auth/screen/login_screen.dart';
import 'package:anilist/modules/dashboard/screen/dashboard_screen.dart';
import 'package:anilist/services/local_storage_service.dart';
import 'package:anilist/services/notification_service.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // START Initializes services for private environment.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService.initNotification();

  // Sets up error handling with Firebase Crashlytics
  final patchNumber = await ShorebirdCodePush().currentPatchNumber();
  FirebaseCrashlytics.instance.setCustomKey(
    'shorebird_patch_number',
    '$patchNumber',
  );
  FirebaseCrashlytics.instance.setCustomKey(
    'app_version',
    Env.version,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // NOTE: This line must be commented out due to commercial purposes
  await AdMobService.init();
  // END Initializes services for private environment.

  // Locks screen orientation to portrait mode only.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configures image caching with 2-day retention period
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 2));

  // Loads user preferences
  UserData? userData = await LocalStorageService.getUserData();
  bool isDarkMode = await LocalStorageService.getIsDarkMode();
  bool isNotificationEnable =
      await LocalStorageService.getNotificationSetting();

  runApp(MyApp(
    userData: userData,
    isDarkMode: isDarkMode,
    isNotificationEnable: isNotificationEnable,
  ));
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
    return BlocProvider(
      create: (context) => _appBloc,
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: false,
        child: MaterialApp(
          title: 'Anilist',
          theme: themeConfig(),
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: kDebugMode,
          home: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.noScaling),
            child: widget.userData != null
                ? const DashboardScreen()
                : const LoginScreen(),
          ),
        ),
      ),
    );
  }
}
