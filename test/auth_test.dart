import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabase extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

void main() {
  late SupabaseClient mockSupabase;
  late GoTrueClient mockGoTrueClient;

  setUp(() {
    mockSupabase = MockSupabase();
    mockGoTrueClient = MockGoTrueClient();
    when(() => mockSupabase.auth).thenReturn(mockGoTrueClient);
  });

  group('Auth Login - ', () {
    test('login with wrong credentials', () async {
      when(
        () => mockGoTrueClient.signInWithPassword(
          email: 'email',
          password: 'password',
        ),
      ).thenThrow(const AuthException('message'));

      try {
        await mockSupabase.auth
            .signInWithPassword(email: 'email', password: 'password');
      } on AuthException catch (e) {
        expect(e, isA<AuthException>());
        expect(e.message, 'message');
      }
    });

    test('login with valid credentials but email not confirmed', () async {
      const message = 'Email not confirmed';
      when(
        () => mockGoTrueClient.signInWithPassword(
            email: 'email@gmail.com', password: 'password'),
      ).thenThrow(
        const AuthException(message, statusCode: '400'),
      );

      try {
        await mockSupabase.auth
            .signInWithPassword(email: 'email@gmail.com', password: 'password');
      } on AuthException catch (e) {
        expect(e.message, message);
      }
    });

    test('login with valid credentials', () async {
      when(
        () => mockGoTrueClient.signInWithPassword(
          email: 'fajar',
          password: 'fajar',
        ),
      ).thenAnswer((invocation) async => AuthResponse());

      final res = await mockSupabase.auth
          .signInWithPassword(password: 'fajar', email: 'fajar');

      expect(res, isA<AuthResponse>());
    });
  });
}
