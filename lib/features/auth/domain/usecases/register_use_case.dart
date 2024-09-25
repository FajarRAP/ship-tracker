import 'package:dartz/dartz.dart';
import '../../../../core/failure/failure.dart';
import '../entities/user_entity.dart';

import '../repositories/auth_repositories.dart';

class RegisterUseCase {
  final AuthRepositories authRepo;

  RegisterUseCase({required this.authRepo});

  Future<Either<Failure, UserEntity>> call(
          String email, String password, int role) async =>
      await authRepo.register(email, password, role);
}
