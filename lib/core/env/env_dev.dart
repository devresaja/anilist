import 'package:anilist/core/env/env.dart';
import 'package:envied/envied.dart';

part 'env_dev.g.dart';

@Envied(path: '.env.dev', allowOptionalFields: false, obfuscate: Env.obfuscate)
abstract class EnvDev {
  // Private environment
  @EnviedField(varName: 'firebaseApiKey')
  static String firebaseApiKey = _EnvDev.firebaseApiKey;
  @EnviedField(varName: 'firebaseAppId')
  static String firebaseAppId = _EnvDev.firebaseAppId;
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
