import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../entities/user_entity.dart';

abstract class AuthRepositories {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> register(
      String email, String password, int role);
  Future<Either<Failure, UserEntity>> updateUser(Map<String, dynamic> metadata);
  Future<Either<Failure, UserEntity>> resetPassword(
      String token, String email, String password);
  Future<Either<Failure, String>> sendPasswordResetToken(String email);
  Future<Either<Failure, String>> logout();
}
