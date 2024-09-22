import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/tracker/presentation/widgets/insert_data_alert_dialog.dart';
import '../common/constants.dart';
import '../common/snackbar.dart';

Future<void> onTapScan(BuildContext context, int stageId) async {
  final String? name = context.read<AuthCubit>().user?.userMetadata?['name'];
  
  if (name == null) {
    flushbar(context, 'Nama belum diisi, silakan isi di bagian profile');
    return;
  }

  final String receipt = await context.push(barcodeScannerRoute) ?? '-1';

  if (!context.mounted || receipt == '-1') return;

  insertDialog(context, receipt, stageId);
}
