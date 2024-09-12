import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ship_tracker/features/tracker/presentation/widgets/home_menu_card.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class TrackerPage extends StatelessWidget {
  const TrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSignedOut) {
          snackbar(context, 'Berhasil Logout');
          context.go(loginRoute);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ship Tracker'),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 10,
          padding: const EdgeInsets.all(16),
          children: const <Widget>[
            HomeMenuCard(
                title: 'Scan Resi',
                route: scanReceiptRoute,
                color: Colors.blue),
            HomeMenuCard(
                title: 'Scan Checking',
                route: checkReceiptRoute,
                color: Colors.red),
            HomeMenuCard(
                title: 'Scan Packing',
                route: packReceiptRoute,
                color: Colors.green),
            HomeMenuCard(
                title: 'Scan Kirim',
                route: sendReceiptRoute,
                color: Colors.orange),
            HomeMenuCard(
                title: 'Scan Return',
                route: returnReceiptRoute,
                color: Colors.purple),
            HomeMenuCard(
                title: 'Laporan',
                route: reportRoute,
                color: Colors.teal,
                icon: Icons.line_axis_rounded),
          ],
        ),
        // body: Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       ElevatedButton(
        //         onPressed: () => context.push(cameraRoute),
        //         child: const Text('Photo'),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
