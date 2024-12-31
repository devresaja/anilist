// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

enum RepoType { public, private }

@Envied(path: '.env', allowOptionalFields: false, obfuscate: false)
abstract class Env {
  static const RepoType repoType = RepoType.private;
  static const String url = 'https://api.jikan.moe/v4';

  // Private environment
  @EnviedField(varName: 'firebaseApiKey')
  static const String firebaseApiKey = _Env.firebaseApiKey;
  @EnviedField(varName: 'firebaseAppId')
  static const String firebaseAppId = _Env.firebaseAppId;
  @EnviedField(varName: 'firebaseMessagingSenderId')
  static const String firebaseMessagingSenderId =
      _Env.firebaseMessagingSenderId;
  @EnviedField(varName: 'firebaseProjectId')
  static const String firebaseProjectId = _Env.firebaseProjectId;
  @EnviedField(varName: 'firebaseStorageBucket')
  static const String firebaseStorageBucket = _Env.firebaseStorageBucket;
  @EnviedField(varName: 'unityGameId')
  static const String unityGameId = _Env.unityGameId;
}
