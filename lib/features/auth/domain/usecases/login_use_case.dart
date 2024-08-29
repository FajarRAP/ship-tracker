import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repositories.dart';

class LoginUseCase {
  final AuthRepositories authRepo;

  LoginUseCase({required this.authRepo});

  Future<Either<Failure, UserEntity>> call(String email, String password) async => await authRepo.login(email, password);
}
