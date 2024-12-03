part of 'auth_bloc.dart';

sealed class AuthEvent {}

class AuthEventLogin extends AuthEvent {
  final String email;
  final String pass;

  AuthEventLogin(this.email, this.pass);
}

class AuthEventLogout extends AuthEvent {}
