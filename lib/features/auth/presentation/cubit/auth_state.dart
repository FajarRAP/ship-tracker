part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {}

class AuthSignedOut extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class UpdatingUser extends AuthState {}

class UserUpdated extends AuthState {}
