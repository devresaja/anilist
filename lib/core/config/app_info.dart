import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static late final String _appName;
  static late final String _version;
  static late final String _buildNumber;

  static String get version => 'v$_version';
  static String get fullVersion => 'v$_version+$_buildNumber';
  static String get appName => _appName;

  static Future<void> init() async {
    final info = await PackageInfo.fromPlatform();
    _appName = info.appName;
    _version = info.version;
    _buildNumber = info.buildNumber;
  }
}
