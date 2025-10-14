import 'package:anilist/core/config/app_info.dart';
import 'package:anilist/core/theme/theme.config.dart';
import 'package:anilist/core/routes/navigator_key.dart';
import 'package:anilist/core/routes/route.dart';
import 'package:anilist/global/bloc/app_bloc/app_bloc.dart';
import 'package:anilist/global/model/user_data.dart';
import 'package:anilist/modules/auth/screen/login_screen.dart';
import 'package:anilist/modules/dashboard/screen/dashboard_screen.dart';
import 'package:anilist/modules/my_list/bloc/my_list_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

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
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.noScaling),
                child: child!,
              ),
            ),
            initialRoute: widget.userData != null
                ? DashboardScreen.path
                : LoginScreen.path,
            onGenerateRoute: RouteConfig.onGenerateRoute,
          );
        },
      ),
    );
  }
}
