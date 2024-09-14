import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> register(String email, String password);
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> verifyOTP(String email, String token);
  Future<UserResponse> updateUser(UserAttributes userAttr);
  Future<void> sendPasswordResetToken(String email);
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
  Future<AuthResponse> verifyOTP(String email, String token) async =>
      await supabase.auth
          .verifyOTP(token: token, email: email, type: OtpType.recovery);

  @override
  Future<UserResponse> updateUser(UserAttributes userAttr) async =>
      await supabase.auth.updateUser(userAttr);

  @override
  Future<void> sendPasswordResetToken(String email) async =>
      await supabase.auth.resetPasswordForEmail(email);

  @override
  Future<void> logout() async => await supabase.auth.signOut();
}
