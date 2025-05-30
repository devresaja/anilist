import 'dart:developer';

import 'package:flutter/material.dart';

class AppColor {
  static AppColorBase? _theme;
  static final _darkColor = DarkColor();
  static final _lightColor = LightColor();

  AppColor._();

  static AppColorBase get instance {
    _theme ??= DarkColor();
    return _theme!;
  }

  static void init(bool isDarkMode) {
    _theme = isDarkMode ? _darkColor : _lightColor;
  }

  static void updateTheme() {
    final newTheme = _theme is DarkColor ? _lightColor : _darkColor;
    _theme = newTheme;
    log(newTheme.runtimeType.toString());
  }

  static Color get primary => instance.primary;
  static Color get secondary => instance.secondary;
  static Color get secondaryAccent => instance.secondaryAccent;
  static Color get accent => instance.accent;
  static Color get error => instance.error;
  static Color get errorText => instance.errorText;
  static Color get white => instance.white;
  static Color get black => instance.black;
  static Color get whiteAccent => instance.whiteAccent;
}

abstract class AppColorBase {
  Color get primary;
  Color get secondary;
  Color get secondaryAccent;
  Color get accent;
  Color get error;
  Color get errorText;
  Color get white;
  Color get black;
  Color get whiteAccent;
}

class LightColor implements AppColorBase {
  @override
  Color primary = Color.fromARGB(255, 51, 185, 169);
  @override
  Color secondary = const Color.fromARGB(255, 247, 247, 247);
  @override
  Color secondaryAccent = const Color.fromARGB(255, 234, 232, 232);
  @override
  Color accent = const Color.fromARGB(255, 59, 73, 80);
  @override
  Color error = Colors.red;
  @override
  Color errorText = const Color(0xffff3131);
  @override
  Color white = Colors.white;
  @override
  Color black = Colors.black;
  @override
  Color whiteAccent = const Color.fromARGB(255, 114, 110, 110);
}

class DarkColor implements AppColorBase {
  @override
  Color primary = const Color(0xFF3dd8c5);
  @override
  Color secondary = const Color.fromARGB(255, 18, 19, 20);
  @override
  Color secondaryAccent = const Color.fromARGB(255, 24, 24, 24);
  @override
  Color accent = const Color(0xffa7a2a2);
  @override
  Color error = Colors.red;
  @override
  Color errorText = const Color(0xffff3131);
  @override
  Color white = Colors.black;
  @override
  Color black = Colors.white;
  @override
  Color whiteAccent = const Color.fromARGB(255, 232, 225, 225);
}
