part of 'auth_bloc.dart';

sealed class AuthState {}

class AuthStateLoading extends AuthState {}

class AuthStateLogin extends AuthState {}

class AuthStateLogout extends AuthState {}

class AuthStateError extends AuthState {
  final String message;

  AuthStateError(this.message);
}
