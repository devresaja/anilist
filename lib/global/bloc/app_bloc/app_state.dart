part of 'app_bloc.dart';

enum AppStateLoadingType {
  none,
  darkMode,
  notification,
}

enum AppStateErrorType {
  none,
  darkMode,
  notification,
}

class AppState extends Equatable {
  final UserData? user;
  final bool isDarkMode;
  final bool isNotificationEnable;
  final AppStateLoadingType appStateLoadingType;
  final AppStateErrorType appStateErrorType;

  const AppState({
    this.user,
    this.isDarkMode = true,
    this.isNotificationEnable = true,
    this.appStateLoadingType = AppStateLoadingType.none,
    this.appStateErrorType = AppStateErrorType.none,
  });

  AppState copyWith({
    UserData? user,
    bool? isDarkMode,
    bool? isNotificationEnable,
    AppStateLoadingType? appStateLoadingType,
    AppStateErrorType? appStateErrorType,
    bool replaceUser = false,
  }) {
    return AppState(
      user: replaceUser ? user : user ?? this.user,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isNotificationEnable: isNotificationEnable ?? this.isNotificationEnable,
      appStateLoadingType: appStateLoadingType ?? this.appStateLoadingType,
      appStateErrorType: appStateErrorType ?? this.appStateErrorType,
    );
  }

  @override
  List<Object?> get props => [
        user,
        isDarkMode,
        isNotificationEnable,
        appStateLoadingType,
        appStateErrorType
      ];
}
