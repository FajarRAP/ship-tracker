import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ship_tracker/features/auth/domain/usecases/update_user_use_case.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../service_container.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/register_use_case.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.updateUserUseCase,
  }) : super(AuthInitial());

  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final UpdateUserUseCase updateUserUseCase;

  User? user = getIt.get<SupabaseClient>().auth.currentUser;

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    final result = await loginUseCase(email, password);

    result.fold(
      (l) => emit(AuthError(l.message)),
      (r) => emit(AuthLoaded()),
    );
  }

  Future<void> register(String email, String password) async {
    emit(AuthLoading());

    final result = await registerUseCase(email, password);

    result.fold(
      (l) => emit(AuthError(l.message)),
      (r) => emit(AuthLoaded()),
    );
  }

  Future<void> updateUser(Map<String, dynamic> metadata) async {
    emit(UpdatingUser());

    final result = await updateUserUseCase(metadata);

    result.fold(
      (l) => emit(AuthError(l.message)),
      (r) {
        user = r;
        emit(UserUpdated());
      },
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await logoutUseCase();
    emit(AuthSignedOut());
  }
}
