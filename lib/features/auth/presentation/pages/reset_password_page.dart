import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ship_tracker/core/common/constants.dart';
import 'package:ship_tracker/core/common/scaffold_with_bottom_navigation_bar.dart';
import 'package:ship_tracker/core/common/snackbar.dart';
import 'package:ship_tracker/service_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Reset Password'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // SupaResetPassword();
            print('KLIK RESET PW');
            // SupaResetPassword
            // getIt
            //     .get<SupabaseClient>()
            //     .auth
            //     .resetPasswordForEmail('fajary781@gmail.com');
            try {
              final recovery = await getIt.get<SupabaseClient>().auth.verifyOTP(
                    email: 'fajary781@gmail.com',
                    token: '041111',
                    type: OtpType.recovery,
                  );
              print(recovery);
              await getIt
                  .get<SupabaseClient>()
                  .auth
                  .updateUser(UserAttributes(password: '12345678'));

              if (!context.mounted) return;
              context.go(loginRoute);
              flushbar(
                  context, 'Berhasil reset password, silakan login kembali');
            } catch (e) {
              print(e.toString());
            }
          },
          child: const Text('RESET PW'),
        ),
      ),
    );
  }
}
