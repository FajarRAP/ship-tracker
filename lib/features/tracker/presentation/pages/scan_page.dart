import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../widgets/insert_data_alert_dialog.dart';
import '../widgets/stage_layout.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StageLayout(
      appBarTitle: 'Pindai Resi',
      stageId: scanStage,
      onTap: () async {
        final String? receipt = await context.push(barcodeScannerRoute);

        if (context.mounted && receipt != null) {
          insertDialog(context, _formKey, _nameController, receipt, scanStage);
        } 
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
