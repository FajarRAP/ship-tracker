part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {}

class AuthSignedOut extends AuthState {
  final String message;

  AuthSignedOut(this.message);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class UpdatingUser extends AuthState {}

class UserUpdated extends AuthState {}

class UpdateUserError extends AuthState {
  final String message;

  UpdateUserError(this.message);
}

class TokenSended extends AuthState {
  final String message;

  TokenSended(this.message);
}

class PasswordChanged extends AuthState {
  final String message;

  PasswordChanged(this.message);
}
