import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  FirebaseAuth auth = FirebaseAuth.instance;
  AuthBloc() : super(AuthStateLogout()) {
    on<AuthEventLogin>((event, emit) async {
      try {
        emit(AuthStateLoading());
        await auth.signInWithEmailAndPassword(
            email: event.email, password: event.pass);
        emit(AuthStateLogin());
      } on FirebaseAuthException {
        emit(AuthStateError("Email or Password Salah"));
      } catch (e) {
        emit(AuthStateError(e.toString()));
      }
    });
    on<AuthEventLogout>((event, emit) {
      try {
        emit(AuthStateLoading());
        auth.signOut();
        emit(AuthStateLogout());
      } on FirebaseAuthException catch (e) {
        emit(AuthStateError(e.message.toString()));
      } catch (e) {
        emit(AuthStateError(e.toString()));
      }
    });
  }
}
