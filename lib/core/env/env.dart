import 'package:anilist/core/env/env_dev.dart';
import 'package:anilist/core/env/env_prod.dart';

enum EnvType { dev, prod }

const String _flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

const EnvType _envType = _flavor == 'prod' ? EnvType.prod : EnvType.dev;

abstract class Env {
  static const bool obfuscate = true;

  static String get url => 'https://api.jikan.moe/v4';

  static String get version => 'v1.0.2';

  static String get firebaseApiKey {
    switch (_envType) {
      case EnvType.prod:
        return EnvProd.firebaseApiKey;
      case EnvType.dev:
        return EnvDev.firebaseApiKey;
    }
  }

  static String get firebaseAppId {
    switch (_envType) {
      case EnvType.prod:
        return EnvProd.firebaseAppId;
      case EnvType.dev:
        return EnvDev.firebaseAppId;
    }
  }

  static String get firebaseMessagingSenderId {
    switch (_envType) {
      case EnvType.prod:
        return EnvProd.firebaseMessagingSenderId;
      case EnvType.dev:
        return EnvDev.firebaseMessagingSenderId;
    }
  }

  static String get firebaseProjectId {
    switch (_envType) {
      case EnvType.prod:
        return EnvProd.firebaseProjectId;
      case EnvType.dev:
        return EnvDev.firebaseProjectId;
    }
  }

  static String get firebaseStorageBucket {
    switch (_envType) {
      case EnvType.prod:
        return EnvProd.firebaseStorageBucket;
      case EnvType.dev:
        return EnvDev.firebaseStorageBucket;
    }
  }

  static String get unityGameId {
    switch (_envType) {
      case EnvType.prod:
        return EnvProd.unityGameId;
      case EnvType.dev:
        return EnvDev.unityGameId;
    }
  }

  static String get admobAppId {
    switch (_envType) {
      case EnvType.prod:
        return EnvProd.admobAppId;
      case EnvType.dev:
        return EnvDev.admobAppId;
    }
  }
}
