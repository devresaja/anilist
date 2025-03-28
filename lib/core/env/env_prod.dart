import 'package:anilist/core/env/env.dart';
import 'package:envied/envied.dart';

part 'env_prod.g.dart';

@Envied(path: '.env', allowOptionalFields: false, obfuscate: Env.obfuscate)
abstract class EnvProd {
  // Private environment
  @EnviedField(varName: 'firebaseApiKey')
  static String firebaseApiKey = _EnvProd.firebaseApiKey;
  @EnviedField(varName: 'firebaseAppId')
  static String firebaseAppId = _EnvProd.firebaseAppId;
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
