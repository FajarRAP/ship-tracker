import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/my_elevated_button.dart';
import '../../../../core/common/snackbar.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/profile_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final String? email = authCubit.user?.userMetadata?['email'];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
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
                    ((authCubit.user?.userMetadata?['name'] ?? email!)
                            as String)[0]
                        .toUpperCase(),
                    style:
                        textTheme.displayLarge?.copyWith(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return Text(
                    authCubit.user?.userMetadata?['name'] ?? email!,
                    style: textTheme.headlineMedium,
                  );
                },
              ),
              const SizedBox(height: 72),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return ProfileCard(
                    title: 'Nama',
                    body: authCubit.user?.userMetadata?['name'] ??
                        'Nama Belum Diisi',
                    icon: Icons.person,
                    child: IconButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await authCubit.updateUser(
                                        {'name': _controller.text.trim()});
                                  }
                                },
                                child: BlocConsumer<AuthCubit, AuthState>(
                                  listener: (context, state) {
                                    if (state is UserUpdated) {
                                      context.pop();
                                      flushbar(context, 'Berhasil Ubah Nama');
                                    }
                                    if (state is AuthError) {
                                      flushbar(context, state.message);
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is UpdatingUser) {
                                      return const CircularProgressIndicator();
                                    }
                                    return const Text('Selesai');
                                  },
                                ),
                              ),
                            ],
                            content: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: _controller,
                                decoration: const InputDecoration(
                                  hintText: 'Nama',
                                ),
                                validator: validator,
                              ),
                            ),
                            title: const Text('Silakan Isi'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.mode_edit_outline_rounded),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              ProfileCard(
                title: 'Email',
                body: email!,
                icon: Icons.email_rounded,
              ),
              const SizedBox(height: 4),
              if (authCubit.user?.userMetadata?['is_admin'] == true)
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => context.push(registerRoute),
                    child: RichText(
                      text: TextSpan(
                        text: 'Buat Akun Untuk Pengguna Baru? ',
                        style: textTheme.bodyMedium,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Klik Di Sini',
                            style: textTheme.bodyMedium
                                ?.copyWith(color: theme.colorScheme.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              MyElevatedButton(
                icon: Icons.exit_to_app_rounded,
                onPressed: () async => authCubit.logout(),
                label: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthError) {
                      flushbar(context, state.message);
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const CircularProgressIndicator(
                          color: Colors.white);
                    }
                    return Text(
                      'Logout',
                      style:
                          textTheme.titleLarge?.copyWith(color: Colors.white),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validator(String? value) =>
      value!.trim().isEmpty ? 'Harap Isi' : null;
}
