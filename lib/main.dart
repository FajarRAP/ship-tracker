import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/routes/route.dart';
import 'core/themes/theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/tracker/presentation/cubit/ship_cubit.dart';
import 'service_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.get('supa_url'),
    anonKey: dotenv.get('supa_anonkey'),
  );
  setup(camera: cameras.first);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt.get<AuthCubit>()),
        BlocProvider(create: (context) => getIt.get<ShipCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Ship Tracker',
        theme: theme,
        routerConfig: router,
      ),
    );
  }
}
