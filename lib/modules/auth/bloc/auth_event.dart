part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class LoginByGoogleEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
