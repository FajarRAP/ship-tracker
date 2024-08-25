import 'package:dartz/dartz.dart';
import 'package:ship_tracker/core/failure/failure.dart';
import 'package:ship_tracker/features/auth/domain/entities/user_entity.dart';
import 'package:ship_tracker/features/auth/domain/repositories/auth_repositories.dart';

class LoginUseCase {
  final AuthRepositories authRepo;

  LoginUseCase({required this.authRepo});

  Future<Either<Failure, UserEntity>> call(String email, String password) async => await authRepo.login(email, password);
}
