import 'package:anilist/modules/account/screen/account_deletion_guide_screen.dart';
import 'package:anilist/modules/account/screen/privacy_policy_screen.dart';

class AppConstant {
  static const String webUrl = 'https://anilist-433306.firebaseapp.com';
  static const String playstoreUrl =
      'https://play.google.com/store/apps/details?id=com.anilist.android';
  static const String privacyPolicy = '$webUrl${PrivacyPolicyScreen.path}';
  static const String accountDeletionGuide =
      '$webUrl${AccountDeletionGuideScreen.path}';
  static const String supportEmail = 'lowpriorityservice@gmail.com';
}
