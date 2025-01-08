import 'package:anilist/global/model/user_data.dart';
import 'package:anilist/services/local_storage_service.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginByGoogleEvent>(_loginByGoogle);
  }

  _loginByGoogle(AuthEvent event, Emitter<AuthState> emit) async {
    emit(LoginByGoogleLoadingState());

    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser != null) {
        final GoogleSignInAuthentication gAuth = await gUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken,
          idToken: gAuth.idToken,
        );

        final data =
            await FirebaseAuth.instance.signInWithCredential(credential);

        FirebaseAuth.instance.currentUser;

        final userData = UserData(
            name: data.user!.displayName!,
            email: data.user!.email!,
            avatar: data.user!.photoURL!);

        LocalStorageService.setUserData(userData);

        emit(LoginByGoogleLoadedState(userData: userData));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(LoginByGoogleFailedState(e.toString()));
    }
  }
}
