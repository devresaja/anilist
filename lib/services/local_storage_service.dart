import 'dart:convert';

import 'package:anilist/global/model/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String userData = 'userData';
  static const String isDarkMode = 'isDarkMode';
  static const String notificationSetting = 'notificationSetting';
  static const String remainingTrailerAttempt = 'remainingTrailerAttempt';

  static Future<int> getRemainingTrailerAttempt() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(remainingTrailerAttempt) ?? 5;
  }

  static Future<bool> setRemainingTrailerAttempt(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(remainingTrailerAttempt, value);
  }

  static Future<bool> getNotificationSetting() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(notificationSetting) ?? false;
  }

  static Future<bool> setNotificationSetting(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(notificationSetting, value);
  }

  static Future<bool> getIsDarkMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isDarkMode) ?? true;
  }

  static Future<bool> setIsDarkMode(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(isDarkMode, value);
  }

  static Future<UserData?> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final String message = prefs.getString(userData) ?? 'kosong';

    if (message != 'kosong') {
      final Map<String, dynamic> userData = jsonDecode(message);

      return UserData.fromMap(userData);
    } else {
      return null;
    }
  }

  static Future<bool> setUserData(UserData value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String message = jsonEncode(value.toMap());

    return prefs.setString(userData, message);
  }

  static Future<void> removeValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userData);
  }
}
