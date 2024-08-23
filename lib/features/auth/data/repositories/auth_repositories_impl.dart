import 'package:ship_tracker/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ship_tracker/features/auth/domain/repositories/auth_repositories.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoriesImpl implements AuthRepositories {
  final AuthRemoteDatasource authRemote;

  AuthRepositoriesImpl({required this.authRemote});

  @override
  Future<void> login(String email, String password) async {
    try {
      final res = await authRemote.login(email, password);
      print(res.user);
    } on AuthException catch (ae) {
      print(ae.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> register(String email, String password) async {
    try {
      final res = await authRemote.register(email, password);
      print(res.user);
    } on AuthException catch (ae) {
      print(ae.toString());
    } catch (e) {
      print(e.toString());
    }
  }
}
