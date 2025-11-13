import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final AnalyticsService instance = AnalyticsService._internal();
  factory AnalyticsService() => instance;
  AnalyticsService._internal();

  final _analytics = FirebaseAnalytics.instance;

  Future<void> logScreenView({required String screenName}) async =>
      await _analytics.logScreenView(screenName: screenName);

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async => await _analytics.logEvent(name: name, parameters: parameters);

  Future<void> logLogin({required String loginMethod}) async =>
      await _analytics.logLogin(loginMethod: loginMethod);

  Future<void> logSearch({required String search}) async =>
      await _analytics.logSearch(searchTerm: search);

  Future<void> logShare({
    required String contentType,
    required String id,
    required String method,
  }) async => await _analytics.logShare(
    contentType: contentType,
    itemId: id,
    method: method,
  );

  Future<void> logAdImpression({
    required String adUnitName,
    required String adFormat,
    required String? adSource,
  }) async => await _analytics.logAdImpression(
    adUnitName: adUnitName,
    adFormat: adFormat,
    adSource: adSource,
  );
}
