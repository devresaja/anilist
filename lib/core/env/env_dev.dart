import 'package:anilist/core/env/env.dart';
import 'package:envied/envied.dart';

part 'env_dev.g.dart';

@Envied(path: '.env.dev', allowOptionalFields: false, obfuscate: Env.obfuscate)
abstract class EnvDev {
  // Private environment
  @EnviedField(varName: 'firebaseAndroidApiKey')
  static String firebaseAndroidApiKey = _EnvDev.firebaseAndroidApiKey;
  @EnviedField(varName: 'firebaseAndroidAppId')
  static String firebaseAndroidAppId = _EnvDev.firebaseAndroidAppId;
  @EnviedField(varName: 'firebaseWebApiKey')
  static String firebaseWebApiKey = _EnvDev.firebaseWebApiKey;
  @EnviedField(varName: 'firebaseWebAppId')
  static String firebaseWebAppId = _EnvDev.firebaseWebAppId;
  @EnviedField(varName: 'firebaseAuthDomain')
  static String firebaseAuthDomain = _EnvDev.firebaseAuthDomain;
  @EnviedField(varName: 'firebaseMeasurementId')
  static String firebaseMeasurementId = _EnvDev.firebaseMeasurementId;
  @EnviedField(varName: 'firebaseMessagingSenderId')
  static String firebaseMessagingSenderId = _EnvDev.firebaseMessagingSenderId;
  @EnviedField(varName: 'firebaseProjectId')
  static String firebaseProjectId = _EnvDev.firebaseProjectId;
  @EnviedField(varName: 'firebaseStorageBucket')
  static String firebaseStorageBucket = _EnvDev.firebaseStorageBucket;
  @EnviedField(varName: 'unityGameId')
  static String unityGameId = _EnvDev.unityGameId;
  @EnviedField(varName: 'admobAppId')
  static String admobAppId = _EnvDev.admobAppId;
}
