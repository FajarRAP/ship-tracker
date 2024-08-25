import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ship_tracker/core/common/constants.dart';
import 'package:ship_tracker/features/auth/presentation/cubit/auth_cubit.dart'
    as c;
import 'package:ship_tracker/service_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrackerPage extends StatelessWidget {
  const TrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<c.AuthCubit>();

    return BlocListener<c.AuthCubit, c.AuthState>(
      listener: (context, state) {
        if (state is c.AuthSignedOut) {
          context.go(loginRoute);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ship Tracker'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  context.push(scanReceiptRoute);
                },
                child: const Text('Scan'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var res = await context.push('/barcode-scanner');
                  if (res is String) {
                    print('isi barcode : $res');
                  }
                },
                child: const Text('Check'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var res = await context.push('/barcode-scanner');
                  if (res is String) {
                    print('isi barcode : $res');
                  }
                },
                child: const Text('Pack'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var res = await context.push('/barcode-scanner');
                  if (res is String) {
                    print('isi barcode : $res');
                  }
                },
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
