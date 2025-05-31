import 'package:anilist/core/theme/app_color.dart';
import 'package:anilist/global/model/user_data.dart';
import 'package:anilist/services/local_storage_service.dart';
import 'package:anilist/services/notification_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState()) {
    on<InitAppEvent>(_initApp);
    on<SetUserDataEvent>(_setUserData);
    on<RemoveUserDataEvent>(_removeUserData);
    on<UpdateThemeEvent>(_updateTheme);
    on<UpdateNotificationSettingEvent>(_updateNotificationSetting);
  }

  Future<void> _updateNotificationSetting(
    UpdateNotificationSettingEvent event,
    Emitter<AppState> emit,
  ) async {
    try {
      emit(state.copyWith(
          appStateErrorType: AppStateErrorType.none,
          appStateLoadingType: AppStateLoadingType.notification));
      await Future.delayed(Duration(milliseconds: 600));

      String topic = "announcement";
      bool isEnable = event.isEnable;
      // if enable, check notification permission
      if (isEnable) {
        final notificationSetting =
            await NotificationService.requestNotification();

        switch (notificationSetting.authorizationStatus) {
          case AuthorizationStatus.authorized ||
                AuthorizationStatus.provisional:
            isEnable = true;
            FirebaseMessaging.instance.subscribeToTopic(topic);
            break;

          default:
            isEnable = false;
            emit(state.copyWith(
                appStateErrorType: AppStateErrorType.notification));
        }
      } else {
        FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      }

      await LocalStorageService.setNotificationSetting(isEnable);

      emit(state.copyWith(
          isNotificationEnable: isEnable,
          appStateErrorType: AppStateErrorType.none,
          appStateLoadingType: AppStateLoadingType.none));
    } catch (e) {
      emit(state.copyWith(
          appStateErrorType: AppStateErrorType.notification,
          appStateLoadingType: AppStateLoadingType.none));
    }
  }

  Future<void> _updateTheme(
    UpdateThemeEvent event,
    Emitter<AppState> emit,
  ) async {
    LocalStorageService.setIsDarkMode(event.isDarkMode);
    AppColor.updateTheme();
    emit(state.copyWith(
        isDarkMode: event.isDarkMode,
        appStateErrorType: AppStateErrorType.none,
        appStateLoadingType: AppStateLoadingType.none));
  }

  Future<void> _removeUserData(
    RemoveUserDataEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(replaceUser: true));
  }

  Future<void> _setUserData(
    SetUserDataEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(user: event.userData));
  }

  Future<void> _initApp(
    InitAppEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(AppState(
      user: event.userData,
      isNotificationEnable: event.isNotificationEnable,
      isDarkMode: event.isDarkMode,
    ));
  }
}
