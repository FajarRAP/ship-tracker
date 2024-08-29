import '../repositories/auth_repositories.dart';

class LogoutUseCase {
  final AuthRepositories authRepo;

  LogoutUseCase({required this.authRepo});

  Future<void> call() async => await authRepo.logout();
}
