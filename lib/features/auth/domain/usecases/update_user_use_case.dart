import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repositories.dart';

class UpdateUserUseCase {
  final AuthRepositories authRepo;

  UpdateUserUseCase(this.authRepo);

  Future<Either<Failure, UserEntity>> call(
          Map<String, dynamic> metadata) async =>
      await authRepo.updateUser(metadata);
}
