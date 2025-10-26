import 'package:anilist/modules/ads/data/admob_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobBannerWidget extends StatefulWidget {
  const AdMobBannerWidget({
    super.key,
  });

  @override
  State<AdMobBannerWidget> createState() => _AdMobBannerWidgetState();
}

class _AdMobBannerWidgetState extends State<AdMobBannerWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  Future<void> _initAd() async {
    if (kIsWeb) {
      return;
    }

    _bannerAd = await AdMobService.initBannerAd(
      onAdLoaded: () {
        setState(() {
          _isAdLoaded = true;
        });
      },
      onFailed: () {
        return;
      },
    );
    _bannerAd!.load();
  }

  @override
  void initState() {
    super.initState();
    _initAd();
  }

  @override
  Widget build(BuildContext context) {
    return _isAdLoaded
        ? SizedBox(
            height: 40,
            width: _bannerAd!.size.width.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          )
        : const SizedBox();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
