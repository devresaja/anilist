import 'dart:async';
import 'package:anilist/core/locale/locale_keys.g.dart';
import 'package:anilist/global/bloc/app_bloc/app_bloc.dart';
import 'package:anilist/modules/auth/screen/login_screen.dart';
import 'package:anilist/modules/my_list/data/my_list_local_api.dart';
import 'package:anilist/services/internet_connection_service.dart';
import 'package:anilist/services/local_storage_service.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SessionService {
  static final SessionService instance = SessionService._internal();
  factory SessionService() => instance;
  SessionService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Timer? _sessionTimer;
  StreamSubscription<bool>? _internetListener;

  void init(BuildContext context) {
    _internetListener = InternetConnectionService.instance.connectionStatus
        .listen((isConnected) {
          if (isConnected) {
            if (context.mounted) {
              _startSession(context);
            }
          } else {
            _sessionTimer?.cancel();
          }
        });
  }

  void _startSession(BuildContext context) {
    _sessionTimer?.cancel();

    _sessionTimer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      await _checkSession(context);
    });
  }

  Future<void> _checkSession(BuildContext context) async {
    if (context.read<AppBloc>().state.user == null) return;

    if (context.read<AppBloc>().state.user?.userId == null) {
      _showDialog(context);
      return;
    }

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

  Future<void> _showDialog(BuildContext context) async {
    await showConfirmationDialog(
      context: context,
      barrierDismissible: false,
      hideCancel: true,
      title: LocaleKeys.session_expired,
      description: LocaleKeys.session_expired_message,
      okText: LocaleKeys.login,
      onTapOk: () async {
        await MyListLocalApi().clear();
        await LocalStorageService.removeValue();
        if (context.mounted) {
          context.go(LoginScreen.path);
        }
      },
    );
  }

  void dispose() {
    _sessionTimer?.cancel();
    _internetListener?.cancel();
  }
}
