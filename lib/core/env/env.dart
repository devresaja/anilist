// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

enum RepoType { public, private }

@Envied(path: '.env', allowOptionalFields: false, obfuscate: false)
abstract class Env {
  static const RepoType repoType = RepoType.private;
  static const String url = 'https://api.jikan.moe/v4';
  static const String version = 'v1.0.0';

  // Private environment
  @EnviedField(varName: 'firebaseApiKey')
  static String firebaseApiKey = _Env.firebaseApiKey;
  @EnviedField(varName: 'firebaseAppId')
  static String firebaseAppId = _Env.firebaseAppId;
  @EnviedField(varName: 'firebaseMessagingSenderId')
  static String firebaseMessagingSenderId = _Env.firebaseMessagingSenderId;
  @EnviedField(varName: 'firebaseProjectId')
  static String firebaseProjectId = _Env.firebaseProjectId;
  @EnviedField(varName: 'firebaseStorageBucket')
  static String firebaseStorageBucket = _Env.firebaseStorageBucket;
  @EnviedField(varName: 'unityGameId')
  static String unityGameId = _Env.unityGameId;
}
