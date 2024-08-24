import 'package:ship_tracker/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ship_tracker/features/auth/data/models/user_model.dart';
import 'package:ship_tracker/features/auth/domain/entities/user_entity.dart';
import 'package:ship_tracker/features/auth/domain/repositories/auth_repositories.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoriesImpl implements AuthRepositories {
  final AuthRemoteDataSource authRemote;

  AuthRepositoriesImpl({required this.authRemote});

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final res = await authRemote.login(email, password);
      return UserModel.fromUser(res.user!);
    } on AuthException catch (ae) {
      print(ae.toString());
      rethrow;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserEntity> register(String email, String password) async {
    try {
      final res = await authRemote.register(email, password);
      return UserModel.fromUser(res.user!);
    } on AuthException catch (ae) {
      print(ae.toString());
      rethrow;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logout() async => await authRemote.logout();
}
