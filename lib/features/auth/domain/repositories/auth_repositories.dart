import 'package:ship_tracker/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepositories {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String email, String password);
  Future<void> logout();
}
