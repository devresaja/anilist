import 'package:anilist/core/config/app_info.dart';
import 'package:anilist/core/routes/navigator_key.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  RemoteConfigService._privateConstructor();

  static final RemoteConfigService _instance =
      RemoteConfigService._privateConstructor();
  static RemoteConfigService get instance => _instance;

  final _remoteConfig = FirebaseRemoteConfig.instance;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    await _remoteConfig.ensureInitialized();

    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 12),
    ));

    await _remoteConfig.fetchAndActivate();
    _checkForUpdate();

    _remoteConfig.onConfigUpdated.listen(
      (event) async {
        await _remoteConfig.activate();
        _checkForUpdate();
      },
    );
  }

  void _checkForUpdate() {
    String currentVersion =
        AppInfo.version.replaceAll('v', '').split('-').first;
    String latestVersion = _remoteConfig.getString('version');
    bool isForceUpdate = _remoteConfig.getBool('force_update');

    if (currentVersion != latestVersion) {
      _showDialog(
        isForceUpdate: isForceUpdate,
        newVersion: latestVersion,
      );
    }
  }

  void _showDialog({
    required bool isForceUpdate,
    required String newVersion,
  }) {
    if (navigatorKey.currentState?.context != null) {
      showConfirmationDialog(
        context: navigatorKey.currentState!.context,
        barrierDismissible: !isForceUpdate,
        title: 'Update Available',
        description:
            'Version $newVersion is now available. Please update for better experience.',
        okText: 'Update',
        onTapOk: () {
          customLaunchUrl(
              'https://play.google.com/store/apps/details?id=com.anilist.android');
        },
        hideCancel: isForceUpdate,
      );
    }
  }
}
