part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class InitAppEvent extends AppEvent {
  final UserData? userData;
  final bool isDarkMode;
  final bool isNotificationEnable;

  const InitAppEvent({
    required this.userData,
    required this.isDarkMode,
    required this.isNotificationEnable,
  });
}

class SetUserDataEvent extends AppEvent {
  final UserData? userData;

  const SetUserDataEvent({required this.userData});
}

class RemoveUserDataEvent extends AppEvent {}

class UpdateThemeEvent extends AppEvent {
  final bool isDarkMode;

  const UpdateThemeEvent({this.isDarkMode = true});
}

class UpdateNotificationSettingEvent extends AppEvent {
  final bool isEnable;

  const UpdateNotificationSettingEvent({this.isEnable = true});
}
