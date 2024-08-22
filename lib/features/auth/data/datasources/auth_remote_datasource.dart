import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDatasource {
  Future<AuthResponse> register(String email, String password);
  Future<AuthResponse> login(String password);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final SupabaseClient supabase;

  AuthRemoteDatasourceImpl({required this.supabase});
  @override
  Future<AuthResponse> login(String password) async {
    final AuthResponse res =
        await supabase.auth.signInWithPassword(password: password);

    return res;
  }

  @override
  Future<AuthResponse> register(String email, String password) async {
    final AuthResponse res = await supabase.auth.signUp(password: password);

    return res;
  }
}
