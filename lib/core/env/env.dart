import 'package:anilist/core/env/env_dev.dart';
import 'package:anilist/core/env/env_prod.dart';

enum EnvType { dev, prod }

const String _flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

const EnvType _envType = _flavor == 'prod' ? EnvType.prod : EnvType.dev;

abstract class Env {
  static const bool obfuscate = true;

  static String get url => 'https://api.jikan.moe/v4';

  static String get firebaseAndroidApiKey {
    switch (_envType) {
      case EnvType.prod:
        return EnvProd.firebaseAndroidApiKey;
      case EnvType.dev:
        return EnvDev.firebaseAndroidApiKey;
    }
  }

  static String get firebaseAndroidAppId {
    switch (_envType) {
      case EnvType.prod:
        return EnvProd.firebaseAndroidAppId;
      case EnvType.dev:
        return EnvDev.firebaseAndroidAppId;
    }
  }

  static String get firebaseWebApiKey {
    switch (_envType) {
      case EnvType.prod:
        return EnvProd.firebaseWebApiKey;
      case EnvType.dev:
        return EnvDev.firebaseWebApiKey;
    }
  }

  static String get firebaseWebAppId {
    switch (_envType) {
      case EnvType.prod:
        return EnvProd.firebaseWebAppId;
      case EnvType.dev:
        return EnvDev.firebaseWebAppId;
    }
  }

  static String get firebaseAuthDomain {
    switch (_envType) {
      case EnvType.prod:
        return EnvProd.firebaseAuthDomain;
      case EnvType.dev:
        return EnvDev.firebaseAuthDomain;
    }
  }

  static String get firebaseMeasurementId {
    switch (_envType) {
      case EnvType.prod:
        return EnvProd.firebaseMeasurementId;
      case EnvType.dev:
        return EnvDev.firebaseMeasurementId;
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
