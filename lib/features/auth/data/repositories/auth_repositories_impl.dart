import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repositories.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoriesImpl implements AuthRepositories {
  final AuthRemoteDataSource authRemote;

  AuthRepositoriesImpl({required this.authRemote});

  @override
  Future<Either<Failure, UserEntity>> login(
      String email, String password) async {
    try {
      final res = await authRemote.login(email, password);
      return Right(UserModel.fromUser(res.user!));
    } on AuthException catch (ae) {
      print(ae.toString());
      switch (ae.statusCode) {
        case '400':
          return Left(Failure(message: 'Email/Password Salah'));
        default:
          return Left(Failure(message: ae.message));
      }
    } catch (e) {
      print(e.toString());
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
      String email, String password, int role) async {
    try {
      final res = await authRemote.register(email, password, role);
      return Right(UserModel.fromUser(res.user!));
    } on AuthException catch (ae) {
      print(ae.toString());
      switch (ae.code) {
        case 'user_already_exists':
          return Left(Failure(message: 'Email telah digunakan'));
        case 'weak_password':
          return Left(Failure(message: 'Password minimal 6 karakter'));
        default:
          return Left(Failure(message: ae.message));
      }
    } catch (e) {
      print(e.toString());
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(
      Map<String, dynamic> metadata) async {
    try {
      final response =
          await authRemote.updateUser(UserAttributes(data: metadata));
      print(response);
      return Right(UserModel.fromUser(response.user!));
    } catch (e) {
      print(e.toString());
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> resetPassword(
      String token, String email, String password) async {
    try {
      // Dibalik layar langsung login
      final attempt = await authRemote.verifyOTP(email, token);
      final response =
          await authRemote.updateUser(UserAttributes(password: password));
      print(attempt);
      print(response);
      return Right(UserModel.fromUser(response.user!));
    } catch (e) {
      print(e.toString());
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<void> sendPasswordResetToken(String email) async =>
      await authRemote.sendPasswordResetToken(email);

  @override
  Future<void> logout() async => await authRemote.logout();
}
