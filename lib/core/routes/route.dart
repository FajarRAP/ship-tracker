import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:ship_tracker/core/common/scaffold_with_bottom_navigation_bar.dart';
import 'package:ship_tracker/features/auth/presentation/pages/get_password_reset_token_page.dart';
import 'package:ship_tracker/features/auth/presentation/pages/reset_password_page.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/tracker/presentation/cubit/ship_cubit.dart';
import '../../features/tracker/presentation/pages/check_page.dart';
import '../../features/tracker/presentation/pages/pack_page.dart';
import '../../features/tracker/presentation/pages/report_page.dart';
import '../../features/tracker/presentation/pages/return_page.dart';
import '../../features/tracker/presentation/pages/scan_page.dart';
import '../../features/tracker/presentation/pages/send_page.dart';
import '../../features/tracker/presentation/pages/tracker_page.dart';
import '../../features/tracker/presentation/pages/upload_page.dart';
import '../../features/tracker/presentation/widgets/open_camera.dart';
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

final _rootNavigatorkey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();
final _profileNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorkey,
  initialLocation: getIt.get<SupabaseClient>().auth.currentSession == null
      ? loginRoute
      : trackerRoute,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ScaffoldWithBottomNavigationBar(child: navigationShell),
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: trackerRoute,
              builder: (context, state) => const TrackerPage(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'scan',
                  builder: (context, state) => const ScanPage(),
                ),
                GoRoute(
                  path: 'check',
                  builder: (context, state) => const CheckPage(),
                ),
                GoRoute(
                  path: 'pack',
                  builder: (context, state) => const PackPage(),
                ),
                GoRoute(
                  path: 'send',
                  builder: (context, state) => const SendPage(),
                ),
                GoRoute(
                  path: 'return',
                  builder: (context, state) => const ReturnPage(),
                ),
                GoRoute(
                  path: 'report',
                  builder: (context, state) => const ReportPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: profileRoute,
              builder: (context, state) => const ProfilePage(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'register',
                  builder: (context, state) => const RegisterPage(),
                  // pageBuilder: (context, state) => CustomTransitionPage(
                  //     key: state.pageKey,
                  //     child: const RegisterPage(),
                  //     transitionsBuilder: transitionsBuilder),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: loginRoute,
      pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginPage(),
          transitionsBuilder: transitionsBuilder),
    ),
    GoRoute(
      path: getTokenResetPasswordRoute,
      pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const GetPasswordResetTokenPage(),
          transitionsBuilder: transitionsBuilder),
    ),
    GoRoute(
      path: resetPasswordRoute,
      pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ResetPasswordPage(),
          transitionsBuilder: transitionsBuilder),
    ),
    GoRoute(
      path: barcodeScannerRoute,
      pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SimpleBarcodeScannerPage(),
          transitionsBuilder: transitionsBuilder),
    ),
    // GoRoute(
    //   path: cameraRoute,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //       key: state.pageKey,
    //       child: TakePictureScreen(camera: getIt.get<ShipCubit>().camera),
    //       transitionsBuilder: transitionsBuilder),
    // ),
    // GoRoute(
    //   path: displayPictureRoute,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //       key: state.pageKey,
    //       child: const DisplayPictureScreen(),
    //       transitionsBuilder: transitionsBuilder),
    // )
  ],
);
