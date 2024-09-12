import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ship_tracker/core/common/my_elevated_button.dart';
import 'package:ship_tracker/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ship_tracker/service_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profil'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.grey[600],
                ),
                child: Center(
                  child: Text(
                    (authCubit.user?.userMetadata?['name'] as String)[0],
                    style:
                        textTheme.displayLarge?.copyWith(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                authCubit.user?.userMetadata?['name'],
                style: textTheme.headlineMedium,
              ),
              const SizedBox(height: 72),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      blurRadius: 24,
                      spreadRadius: 0,
                      offset: const Offset(0, 8),
                      color: Colors.black.withOpacity(.12),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                child: Row(
                  children: [
                    Icon(
                      Icons.email_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: textTheme.titleMedium,
                        ),
                        Text(
                          authCubit.user?.userMetadata?['email'],
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              MyElevatedButton(
                icon: Icons.exit_to_app_rounded,
                onPressed: () async => authCubit.logout(),
                label: Text(
                  'Logout',
                  style: textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
