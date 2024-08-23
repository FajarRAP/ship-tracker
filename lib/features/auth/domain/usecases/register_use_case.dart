import 'package:ship_tracker/features/auth/domain/repositories/auth_repositories.dart';

class RegisterUseCase {
  final AuthRepositories authRepo;

  RegisterUseCase({required this.authRepo});

  Future<void> call(String email, String password) async =>
      await authRepo.register(email, password);
}
