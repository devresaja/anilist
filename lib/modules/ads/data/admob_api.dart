import 'package:anilist/core/env/env.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();

  AdMobService._internal();

  factory AdMobService() {
    return _instance;
  }

  static Future<void> init() async {
    await MobileAds.instance.initialize();
  }

  static Future<void> showRewardedAd({
    required Function(RewardItem) onComplete,
    Function(String)? onFailed,
    Function()? onSkipped,
  }) async {
    await RewardedAd.load(
      adUnitId: _formatAdUnitId('6862620964'),
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
      adUnitId: _formatAdUnitId('3440151201'),
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

  static String _formatAdUnitId(String id) =>
      '${Env.admobAppId.split('~').first}/$id';
}
