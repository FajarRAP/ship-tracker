import 'package:dartz/dartz.dart';
import 'package:ship_tracker/core/failure/failure.dart';
import 'package:ship_tracker/features/auth/domain/entities/user_entity.dart';
import 'package:ship_tracker/features/auth/domain/repositories/auth_repositories.dart';

class ResetPasswordUseCase {
  final AuthRepositories authRepo;

  ResetPasswordUseCase(this.authRepo);

  Future<Either<Failure, UserEntity>> call(
          String token, String email, String password) async =>
      await authRepo.resetPassword(token, email, password);
}
