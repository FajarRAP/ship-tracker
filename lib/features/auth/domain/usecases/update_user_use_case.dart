import 'package:dartz/dartz.dart';
import 'package:ship_tracker/core/failure/failure.dart';
import 'package:ship_tracker/features/auth/domain/entities/user_entity.dart';
import 'package:ship_tracker/features/auth/domain/repositories/auth_repositories.dart';

class UpdateUserUseCase {
  final AuthRepositories authRepo;

  UpdateUserUseCase(this.authRepo);

  Future<Either<Failure, UserEntity>> call(
          Map<String, dynamic> metadata) async =>
      await authRepo.updateUser(metadata);
}
