import 'package:anilist/core/env/env.dart';
import 'package:anilist/firebase_options.dart';
import 'package:anilist/global/bloc/app_bloc/app_bloc.dart';
import 'package:anilist/global/model/user_data.dart';
import 'package:anilist/core/routes/navigator_key.dart';
import 'package:anilist/core/theme/theme.config.dart';
import 'package:anilist/modules/ads/data/unity_ads_api.dart';
import 'package:anilist/modules/auth/screen/login_screen.dart';
import 'package:anilist/modules/dashboard/screen/dashboard_screen.dart';
import 'package:anilist/services/local_storage_service.dart';
import 'package:anilist/services/notification_service.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Env.repoType == RepoType.private) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await NotificationService.initNotification();
    // NOTE: Code below is commented for public due to license policy
    await UnityAdsApi.init();
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 2));
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
