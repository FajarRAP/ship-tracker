import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repositories.dart';

class ResetPasswordUseCase {
  final AuthRepositories authRepo;

  ResetPasswordUseCase(this.authRepo);

  Future<Either<Failure, UserEntity>> call(
          String token, String email, String password) async =>
      await authRepo.resetPassword(token, email, password);
}
