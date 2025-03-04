import 'package:anilist/core/env/env.dart';
import 'package:flutter/widgets.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'dart:async';

class UnityAdsApi {
  static final UnityAdsApi _instance = UnityAdsApi._internal();

  UnityAdsApi._internal();

  factory UnityAdsApi() {
    return _instance;
  }

  static Future<void> init() async {
    await UnityAds.init(
      gameId: Env.unityGameId,
      testMode: true,
      onComplete: () => debugPrint('Initialization Complete'),
      onFailed: (error, message) =>
          debugPrint('Initialization Failed: $error $message'),
    );
  }

  static Future<void> showVideoAd({
    Function()? onComplete,
    Function()? onSkipped,
    Function(String)? onFailed,
  }) async {
    await UnityAds.load(
        placementId: 'Rewarded_Android',
        onComplete: (placementId) async {
          debugPrint('Load Complete $placementId');
          await UnityAds.showVideoAd(
            placementId: 'Rewarded_Android',
            onStart: (placementId) =>
                debugPrint('Video Ad $placementId started'),
            onClick: (placementId) => debugPrint('Video Ad $placementId click'),
            onSkipped: (placementId) {
              debugPrint('Video Ad $placementId skipped');
              if (onSkipped != null) {
                onSkipped();
              }
            },
            onComplete: (placementId) {
              debugPrint('Video Ad $placementId completed');
              if (onComplete != null) {
                onComplete();
              }
            },
            onFailed: (placementId, error, message) {
              debugPrint('Video Ad $placementId failed: $error $message');
              if (onFailed != null) {
                onFailed('$error $message');
              }
            },
          );
        },
        onFailed: (placementId, error, message) {
          debugPrint('Load Failed $placementId: $error $message');
          if (onFailed != null) {
            onFailed('$error $message');
          }
        });
    return;
  }
}
