import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> register(String email, String password);
  Future<AuthResponse> login(String email, String password);
  Future<UserResponse> updateUser(Map<String, dynamic> metadata);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabase;

  AuthRemoteDataSourceImpl({required this.supabase});
  @override
  Future<AuthResponse> login(String email, String password) async =>
      await supabase.auth.signInWithPassword(email: email, password: password);

  @override
  Future<AuthResponse> register(String email, String password) async =>
      await supabase.auth.signUp(email: email, password: password);

  @override
  Future<UserResponse> updateUser(Map<String, dynamic> metadata) async =>
      await supabase.auth.updateUser(UserAttributes(data: metadata));

  @override
  Future<void> logout() async => await supabase.auth.signOut();
}
