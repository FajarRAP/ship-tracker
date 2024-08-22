import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDatasource {
  Future<AuthResponse> register(String email, String password);
  Future<AuthResponse> login(String email, String password);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final SupabaseClient supabase;

  AuthRemoteDatasourceImpl({required this.supabase});
  @override
  Future<AuthResponse> login(String email, String password) async =>
      await supabase.auth.signInWithPassword(email: email, password: password);

  @override
  Future<AuthResponse> register(String email, String password) async =>
      await supabase.auth.signUp(email: email, password: password);
}
