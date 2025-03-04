import 'package:flutter/material.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class UnityBannerAdWidget extends StatelessWidget {
  const UnityBannerAdWidget({
    super.key,
    required this.placementId,
  });

  final String placementId;

  @override
  Widget build(BuildContext context) {
    return UnityBannerAd(
      placementId: placementId,
      onLoad: (placementId) => debugPrint('Banner loaded: $placementId'),
      onClick: (placementId) => debugPrint('Banner clicked: $placementId'),
      onShown: (placementId) => debugPrint('Banner shown: $placementId'),
      onFailed: (placementId, error, message) =>
          debugPrint('Banner Ad $placementId failed: $error $message'),
    );
  }
}
