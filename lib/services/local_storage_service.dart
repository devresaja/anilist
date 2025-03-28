import 'dart:convert';

import 'package:anilist/global/model/user_data.dart';
import 'package:anilist/modules/ads/data/admob_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String userData = 'userData';
  static const String isDarkMode = 'isDarkMode';
  static const String notificationSetting = 'notificationSetting';
  static const String remainingTrailerAttempt = 'remainingTrailerAttempt';
  static const String remainingMylistAttempt = 'remainingMylistAttempt';

  static Future<int> getRemainingAdsAttempt({
    required AdsType adsType,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    late String key;
    switch (adsType) {
      case AdsType.trailer:
        key = remainingTrailerAttempt;
      case AdsType.mylist:
        key = remainingMylistAttempt;
    }

    late int initialValue;
    switch (adsType) {
      case AdsType.trailer:
        initialValue = 5;
      case AdsType.mylist:
        initialValue = 2;
    }

    return prefs.getInt(key) ?? initialValue;
  }

  static Future<bool> setRemainingAdsAttempt({
    required AdsType adsType,
    required int value,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    late String key;
    switch (adsType) {
      case AdsType.trailer:
        key = remainingTrailerAttempt;
      case AdsType.mylist:
        key = remainingMylistAttempt;
    }

    return prefs.setInt(key, value);
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
