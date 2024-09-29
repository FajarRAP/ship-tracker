import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ship_tracker/service_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../widgets/home_menu_card.dart';

class TrackerPage extends StatelessWidget {
  const TrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSignedOut) {
          snackbar(context, state.message);
          context.go(loginRoute);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ship Tracker'),
        ),
        body: Center(
          child: _buildTrackerPage(
            context.read<AuthCubit>().user?.userMetadata?['role'],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackerPage(int? role) {
    switch (role) {
      case 1:
        return const HomeMenuCard(
          title: 'Scan Resi',
          route: scanReceiptRoute,
          color: Colors.blue,
          size: 200,
        );
      case 2:
        return const HomeMenuCard(
          title: 'Scan Checking',
          route: checkReceiptRoute,
          color: Colors.red,
          size: 200,
        );
      case 3:
        return const HomeMenuCard(
          title: 'Scan Packing',
          route: packReceiptRoute,
          color: Colors.green,
          size: 200,
        );
      case 4:
        return const HomeMenuCard(
          title: 'Scan Kirim',
          route: sendReceiptRoute,
          color: Colors.orange,
          size: 200,
        );
      case 5:
        return const HomeMenuCard(
          title: 'Scan Return',
          route: returnReceiptRoute,
          color: Colors.purple,
          size: 200,
        );
      default:
        return _buildAdminPage();
    }
  }

  Widget _buildAdminPage() {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.all(16),
      children: const <Widget>[
        HomeMenuCard(
          title: 'Scan Resi',
          route: scanReceiptRoute,
          color: Colors.blue,
        ),
        HomeMenuCard(
          title: 'Scan Ambil Resi',
          route: pickUpReceiptRoute,
          color: Colors.brown,
        ),
        HomeMenuCard(
          title: 'Scan Checker',
          route: checkReceiptRoute,
          color: Colors.red,
        ),
        HomeMenuCard(
          title: 'Scan Packing',
          route: packReceiptRoute,
          color: Colors.green,
        ),
        HomeMenuCard(
          title: 'Scan Kirim',
          route: sendReceiptRoute,
          color: Colors.orange,
        ),
        HomeMenuCard(
          title: 'Scan Return',
          route: returnReceiptRoute,
          color: Colors.purple,
        ),
        HomeMenuCard(
          title: 'Laporan',
          route: reportRoute,
          color: Colors.teal,
          icon: Icons.line_axis_rounded,
        ),
        // ElevatedButton(
        //   onPressed: () async {
        //     final res = await getIt.get<sp.SupabaseClient>().auth.signUp(
        //       password: '072489tk',
        //       email: 'diandi.adm2@gmail.com',
        //       data: {'is_admin': true},
        //     );
        //     print(res.user);
        //   },
        //   child: const Text('REG'),
        // ),
      ],
    );
  }
}
