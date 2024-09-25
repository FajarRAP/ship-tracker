import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../service_container.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/register_use_case.dart';
import '../../domain/usecases/reset_password_use_case.dart';
import '../../domain/usecases/send_password_reset_token_use_case.dart';
import '../../domain/usecases/update_user_use_case.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.updateUserUseCase,
    required this.sendPasswordResetTokenUseCase,
    required this.resetPasswordUseCase,
  }) : super(AuthInitial());

  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final SendPasswordResetTokenUseCase sendPasswordResetTokenUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  User? user = getIt.get<SupabaseClient>().auth.currentUser;
  int selectedRole = 0;

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    final result = await loginUseCase(email, password);

    result.fold(
      (l) => emit(AuthError(l.message)),
      (r) {
        user = r;
        emit(AuthLoaded());
      },
    );
  }

  Future<void> register(String email, String password) async {
    emit(AuthLoading());

    final result = await registerUseCase(email, password, selectedRole);

    result.fold(
      (l) => emit(AuthError(l.message)),
      (r) => emit(AuthLoaded()),
    );
  }

  Future<void> updateUser(Map<String, dynamic> metadata) async {
    emit(UpdatingUser());

    final result = await updateUserUseCase(metadata);

    result.fold(
      (l) => emit(UpdateUserError(l.message)),
      (r) {
        user = r;
        emit(UserUpdated());
      },
    );
  }

  Future<void> sendPasswordResetToken(String email) async {
    emit(AuthLoading());

    final result = await sendPasswordResetTokenUseCase(email);

    result.fold(
      (l) => emit(AuthError(l.message)),
      (r) => emit(TokenSended(r)),
    );
  }

  Future<void> resetPassword(
      String token, String email, String password) async {
    emit(AuthLoading());

    final result = await resetPasswordUseCase(token, email, password);

    result.fold(
      (l) => emit(AuthError(l.message)),
      (r) => emit(
          PasswordChanged('Password berhasil direset, silakan login kembali')),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await logoutUseCase();

    result.fold(
      (l) => emit(AuthError(l.message)),
      (r) => emit(AuthSignedOut(r)),
    );
  }

  void selectRole(dynamic role) {
    selectedRole = role;
    emit(AuthInitial());
  }
}
