import 'package:anilist/global/model/user_data.dart';
import 'package:anilist/modules/auth/data/auth_api.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _api = AuthApi();

  AuthBloc() : super(AuthInitial()) {
    on<LogoutEvent>(_logout);
    on<LoginByGoogleEvent>(_loginByGoogle);
  }

  _logout(AuthEvent event, Emitter<AuthState> emit) async {
    emit(LogoutLoadingState());

    try {
      final response = await _api.logout();

      response.fold((left) => emit(LogoutFailedState(response.left.toString())),
          (right) => emit(LogoutLoadedState()));
    } catch (e) {
      emit(LogoutFailedState(e.toString()));
    }
  }

  _loginByGoogle(AuthEvent event, Emitter<AuthState> emit) async {
    emit(LoginByGoogleLoadingState());

    try {
      final response = await _api.loginByGoogle();

      response.fold((left) {
        if (left == null) {
          emit(AuthInitial());
        } else {
          emit(LoginByGoogleFailedState(response.left.toString()));
        }
      }, (right) => emit(LoginByGoogleLoadedState(userData: response.right)));
    } catch (e) {
      emit(LoginByGoogleFailedState(e.toString()));
    }
  }
}
