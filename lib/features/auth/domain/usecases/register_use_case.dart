import 'package:dartz/dartz.dart';
import 'package:ship_tracker/core/failure/failure.dart';
import 'package:ship_tracker/features/auth/domain/entities/user_entity.dart';

import '../repositories/auth_repositories.dart';

class RegisterUseCase {
  final AuthRepositories authRepo;

  RegisterUseCase({required this.authRepo});

  Future<Either<Failure, UserEntity>> call(String email, String password) async =>
      await authRepo.register(email, password);
}
