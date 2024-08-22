import 'package:ship_tracker/features/auth/domain/repositories/auth_repositories.dart';

class LoginUseCase {
  final AuthRepositories authRepo;

  LoginUseCase({required this.authRepo});

  Future<void> call(String email, String password) async => await authRepo.login(email, password);
}
