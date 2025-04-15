import 'package:anilist/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData themeConfig({bool? useMaterial3}) {
  return ThemeData(
    useMaterial3: useMaterial3 ?? false,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    fontFamily: 'NunitoSans',
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColor.primary,
    ),
  );
}

Theme disableMaterial3({required Widget child}) {
  return Theme(data: themeConfig(useMaterial3: false), child: child);
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    color: Colors.white,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    surfaceTintColor: Colors.white,
    elevation: 0,
  );
}

TextTheme textTheme() {
  return TextTheme(
    bodyLarge: TextStyle(
      color: AppColor.secondary,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
  );
}

InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.primary,
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8))));
}
