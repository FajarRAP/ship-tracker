import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/tracker/presentation/widgets/insert_data_alert_dialog.dart';
import '../common/snackbar.dart';

Future<void> onTapScan(BuildContext context, int stageId) async {
  final String? name = context.read<AuthCubit>().user?.userMetadata?['name'];

  if (name == null) {
    flushbar(context, 'Nama belum diisi, silakan isi di bagian profile');
    return;
  }

  final receipt = await BarcodeScanner.scan();

  if (!context.mounted || receipt.rawContent.isEmpty) return;

  insertDialog(context, receipt.rawContent, stageId);
}
