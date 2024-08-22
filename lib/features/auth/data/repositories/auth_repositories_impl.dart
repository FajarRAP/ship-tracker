import 'package:ship_tracker/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ship_tracker/features/auth/domain/repositories/auth_repositories.dart';

class AuthRepositoriesImpl implements AuthRepositories {
  final AuthRemoteDatasource authRemote;

  AuthRepositoriesImpl({required this.authRemote});

  @override
  Future<void> login() async {
    try {
      
    } catch (e) {
      
    }
  }

  @override
  Future<void> logout() async {
    print('ini adalah logout');
  }

  @override
  Future<void> register() async {
    print('ini adalah register');
  }
}
