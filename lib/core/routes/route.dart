import 'dart:developer';
import 'package:anilist/global/screen/not_found_screen.dart';
import 'package:anilist/modules/detail_anime/screen/detail_anime_screen.dart';
import 'package:anilist/modules/my_list/screen/shared_my_list_screen.dart';
import 'package:anilist/modules/search/screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:anilist/modules/dashboard/screen/dashboard_screen.dart';
import 'package:anilist/modules/auth/screen/login_screen.dart';

class RouteConfig {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    var argument = settings.arguments;
    log('current route name: ${settings.name}');

    switch (settings.name) {
      case DashboardScreen.path:
        return _routeTo(const DashboardScreen(), settings);

      case LoginScreen.path:
        return _routeTo(const LoginScreen(), settings);

      case SearchScreen.path:
        return _routeTo(
            SearchScreen(argument: argument as SearchArgument), settings);

      case DetailAnimeScreen.path:
        return _routeTo(
            DetailAnimeScreen(argument: argument as DetailAnimeArgument),
            settings);

      case SharedMyListScreen.path:
        return _routeTo(
            SharedMyListScreen(argument: argument as SharedMyListArgument),
            settings);

      default:
        return _routeTo(const NotFoundScreen(), settings);
    }
  }

  static MaterialPageRoute _routeTo(Widget screen, RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => screen,
    );
  }
}
