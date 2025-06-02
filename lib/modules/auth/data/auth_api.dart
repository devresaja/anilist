import 'dart:async';

import 'package:anilist/global/model/user_data.dart';
import 'package:anilist/modules/my_list/data/my_list_local_api.dart';
import 'package:anilist/services/local_storage_service.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthApi {
  Future<Either<String, bool>> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      await LocalStorageService.removeValue();
      if (!kIsWeb) {
        await MyListLocalApi().clear();
      }
      return Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String?, UserData>> loginByGoogle() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        return Left(null);
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final data = await FirebaseAuth.instance.signInWithCredential(credential);

      final userData = UserData(
          userId: data.user!.uid,
          name: data.user!.displayName ?? '-',
          email: data.user!.email ?? '-',
          avatar: data.user!.photoURL);

      await LocalStorageService.setUserData(userData);

      return Right(userData);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
