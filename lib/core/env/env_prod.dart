import 'package:anilist/core/env/env.dart';
import 'package:envied/envied.dart';

part 'env_prod.g.dart';

@Envied(path: '.env', allowOptionalFields: false, obfuscate: Env.obfuscate)
abstract class EnvProd {
  // Private environment
  @EnviedField(varName: 'firebaseAndroidApiKey')
  static String firebaseAndroidApiKey = _EnvProd.firebaseAndroidApiKey;
  @EnviedField(varName: 'firebaseAndroidAppId')
  static String firebaseAndroidAppId = _EnvProd.firebaseAndroidAppId;
  @EnviedField(varName: 'firebaseWebApiKey')
  static String firebaseWebApiKey = _EnvProd.firebaseWebApiKey;
  @EnviedField(varName: 'firebaseWebAppId')
  static String firebaseWebAppId = _EnvProd.firebaseWebAppId;
  @EnviedField(varName: 'firebaseAuthDomain')
  static String firebaseAuthDomain = _EnvProd.firebaseAuthDomain;
  @EnviedField(varName: 'firebaseMeasurementId')
  static String firebaseMeasurementId = _EnvProd.firebaseMeasurementId;
  @EnviedField(varName: 'firebaseMessagingSenderId')
  static String firebaseMessagingSenderId = _EnvProd.firebaseMessagingSenderId;
  @EnviedField(varName: 'firebaseProjectId')
  static String firebaseProjectId = _EnvProd.firebaseProjectId;
  @EnviedField(varName: 'firebaseStorageBucket')
  static String firebaseStorageBucket = _EnvProd.firebaseStorageBucket;
  @EnviedField(varName: 'unityGameId')
  static String unityGameId = _EnvProd.unityGameId;
  @EnviedField(varName: 'admobAppId')
  static String admobAppId = _EnvProd.admobAppId;
}
