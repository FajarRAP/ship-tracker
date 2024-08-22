import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ship_tracker/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ship_tracker/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:ship_tracker/features/auth/domain/usecases/login_use_case.dart';
import 'package:ship_tracker/features/tracker/controller/tracker_controller.dart';
import 'package:ship_tracker/features/tracker/presentation/tracker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'https://dutnjreyxgcqtddzawhf.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR1dG5qcmV5eGdjcXRkZHphd2hmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQzMTE2MjMsImV4cCI6MjAzOTg4NzYyM30.miGcqb2VOM7Il4GI2uuooJ2XX7X-DFi3IacPdRB9R5U');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRemote =
        AuthRemoteDatasourceImpl(supabase: Supabase.instance.client);
    final authRepo = AuthRepositoriesImpl(authRemote: authRemote);
    final _trackerController = Get.put(
      TrackerController(
        loginUseCase: LoginUseCase(authRepo: authRepo),
      ),
    );
    return GetMaterialApp(
      title: 'Ship Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TrackerPage(),
    );
  }
}
