import 'dart:async';
import 'package:anilist/core/routes/route.dart';
import 'package:anilist/global/bloc/app_bloc/app_bloc.dart';
import 'package:anilist/modules/auth/screen/login_screen.dart';
import 'package:anilist/services/local_storage_service.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionService {
  static final _firebaseAuth = FirebaseAuth.instance;
  static Timer? _sessionTimer;

  static void init(BuildContext context) {
    _checkSession(context);

    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      await _checkSession(context);
    });
  }

  static Future<void> _checkSession(BuildContext context) async {
    // If user is not logged in, return
    if (context.read<AppBloc>().state.user == null) return;

    try {
      await _firebaseAuth.currentUser?.reload();
      final user = _firebaseAuth.currentUser;

      if (user == null && context.mounted) {
        _showDialog(context);
      }
    } catch (e) {
      if (context.mounted) {
        _showDialog(context);
      }
    }
  }

  static Future<dynamic> _showDialog(BuildContext context) async {
    await showConfirmationDialog(
      context: context,
      barrierDismissible: false,
      hideCancel: true,
      title: 'Session Expired',
      description: 'Your session has expired. Please login again.',
      okText: 'Login',
      onTapOk: () async {
        await LocalStorageService.removeValue();
        if (context.mounted) {
          pushAndRemoveUntil(context,
              screen: LoginScreen(), routeName: LoginScreen.path);
        }
      },
    );
  }

  static void dispose() {
    _sessionTimer?.cancel();
  }
}
