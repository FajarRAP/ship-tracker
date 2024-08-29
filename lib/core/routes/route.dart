import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/tracker/presentation/pages/check_page.dart';
import '../../features/tracker/presentation/pages/pack_page.dart';
import '../../features/tracker/presentation/pages/report_page.dart';
import '../../features/tracker/presentation/pages/scan_page.dart';
import '../../features/tracker/presentation/pages/send_page.dart';
import '../../features/tracker/presentation/pages/tracker_page.dart';
import '../../service_container.dart';
import '../common/constants.dart';

FadeTransition transition(Animation<double> animation, Widget child) =>
    FadeTransition(
      opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
      child: child,
    );

Widget transitionsBuilder(BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) =>
    transition(animation, child);

final router = GoRouter(
  initialLocation: getIt.get<SupabaseClient>().auth.currentSession == null
      ? loginRoute
      : trackerRoute,
  routes: [
    GoRoute(
        path: loginRoute,
        pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const LoginPage(),
            transitionsBuilder: transitionsBuilder)),
    GoRoute(
        path: registerRoute,
        pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const RegisterPage(),
            transitionsBuilder: transitionsBuilder)),
    GoRoute(
        path: trackerRoute,
        pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const TrackerPage(),
            transitionsBuilder: transitionsBuilder)),
    GoRoute(
        path: barcodeScannerRoute,
        pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SimpleBarcodeScannerPage(),
            transitionsBuilder: transitionsBuilder)),
    GoRoute(
        path: scanReceiptRoute,
        pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ScanPage(),
            transitionsBuilder: transitionsBuilder)),
    GoRoute(
        path: checkReceiptRoute,
        pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const CheckPage(),
            transitionsBuilder: transitionsBuilder)),
    GoRoute(
        path: packReceiptRoute,
        pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const PackPage(),
            transitionsBuilder: transitionsBuilder)),
    GoRoute(
        path: sendReceiptRoute,
        pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SendPage(),
            transitionsBuilder: transitionsBuilder)),
    GoRoute(
        path: reportRoute,
        pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ReportPage(),
            transitionsBuilder: transitionsBuilder)),
  ],
);
