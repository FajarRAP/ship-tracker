import 'package:dartz/dartz.dart';
import 'package:ship_tracker/core/failure/failure.dart';
import 'package:ship_tracker/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ship_tracker/features/auth/data/models/user_model.dart';
import 'package:ship_tracker/features/auth/domain/entities/user_entity.dart';
import 'package:ship_tracker/features/auth/domain/repositories/auth_repositories.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      String email, String password) async {
    try {
      final res = await authRemote.register(email, password);
      return Right(UserModel.fromUser(res.user!));
    } on AuthException catch (ae) {
      print(ae.toString());
      return Left(Failure(message: ae.message));
    } catch (e) {
      print(e.toString());
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<void> logout() async => await authRemote.logout();
}
