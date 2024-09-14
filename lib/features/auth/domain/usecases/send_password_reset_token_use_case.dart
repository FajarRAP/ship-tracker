import '../repositories/auth_repositories.dart';

class SendPasswordResetTokenUseCase {
  final AuthRepositories authRepo;

  SendPasswordResetTokenUseCase(this.authRepo);

  Future<void> call(String email) async =>
      await authRepo.sendPasswordResetToken(email);
}
