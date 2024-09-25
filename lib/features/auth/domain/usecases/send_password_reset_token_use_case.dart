import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../repositories/auth_repositories.dart';

class SendPasswordResetTokenUseCase {
  final AuthRepositories authRepo;

  SendPasswordResetTokenUseCase(this.authRepo);

  Future<Either<Failure, String>> call(String email) async =>
      await authRepo.sendPasswordResetToken(email);
}
