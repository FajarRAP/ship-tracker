import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/tracker/controller/tracker_controller.dart';
import 'features/tracker/presentation/tracker.dart';
import 'service_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
      url: dotenv.env['supa_url']!, anonKey: dotenv.env['supa_anonkey']!);
  setup(supabase: Supabase.instance.client);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _trackerController = Get.put(getIt.get<TrackerController>());

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
