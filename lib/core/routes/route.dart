import 'dart:developer';

import 'package:flutter/material.dart';

String currentRouteName = '';

void _updateCurrentRoute(String? routeName) {
  currentRouteName = routeName ?? '';
  log('current route -> $currentRouteName');
}

void pushTo(BuildContext context, {required Widget screen, String? routeName}) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => screen,
          settings: RouteSettings(name: routeName)));

  _updateCurrentRoute(routeName);
}

void pushReplacement(BuildContext context,
    {required Widget screen, String? routeName}) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => screen,
          settings: RouteSettings(name: routeName)));

  _updateCurrentRoute(routeName);
}

void pushAndRemoveUntil(BuildContext context,
    {required Widget screen, String? routeName}) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
        builder: (context) => screen, settings: RouteSettings(name: routeName)),
    (route) => false,
  );

  _updateCurrentRoute(routeName);
}
