import 'package:anilist/core/env/env.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

enum AdUnit { mylist, trailer, banner }

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();

  AdMobService._internal();

  factory AdMobService() {
    return _instance;
  }

  static final String _bannerAdUnitId = _formatAdUnitId('3440151201');
  static final String _trailerAdUnitId = _formatAdUnitId('6862620964');
  static final String _mylistAdUnitId = _formatAdUnitId('9242071365');

  static Future<void> init() async {
    await MobileAds.instance.initialize();
  }

  static Future<void> showRewardedAd({
    required AdUnit adUnit,
    required Function(RewardItem) onComplete,
    Function(String)? onFailed,
    Function()? onSkipped,
  }) async {
    await RewardedAd.load(
      adUnitId: _getAdUnitId(adUnit),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) async {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              if (onSkipped != null) onSkipped();
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              if (onFailed != null) onFailed(error.message);
              ad.dispose();
            },
          );

          await ad.show(
            onUserEarnedReward: (ad, reward) {
              onComplete(reward);
            },
          );
        },
        onAdFailedToLoad: (error) {
          if (onFailed != null) onFailed(error.message);
        },
      ),
    );
  }

  static Future<BannerAd> initBannerAd({
    required Function() onAdLoaded,
    Function()? onFailed,
  }) async {
    return BannerAd(
      adUnitId: _getAdUnitId(AdUnit.banner),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          onAdLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (onFailed != null) onFailed();
        },
      ),
    );
  }

  static String _getAdUnitId(AdUnit adUnit) {
    switch (adUnit) {
      case AdUnit.trailer:
        return _trailerAdUnitId;
      case AdUnit.mylist:
        return _mylistAdUnitId;
      case AdUnit.banner:
        return _bannerAdUnitId;
    }
  }

  static String _formatAdUnitId(String id) =>
      '${Env.admobAppId.split('~').first}/$id';
}
