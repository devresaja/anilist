part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class LoginByGoogleLoadingState extends AuthState {}

final class LoginByGoogleLoadedState extends AuthState {
  final UserData userData;

  LoginByGoogleLoadedState({required this.userData});
}

final class LoginByGoogleFailedState extends AuthState {
  final String message;

  LoginByGoogleFailedState(this.message);
}
