import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../widgets/insert_data_alert_dialog.dart';
import '../widgets/stage_layout.dart';

class PackPage extends StatefulWidget {
  const PackPage({super.key});

  @override
  State<PackPage> createState() => _PackPageState();
}

class _PackPageState extends State<PackPage> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return StageLayout(
      appBarTitle: 'Pack Resi',
      stageId: packStage,
      onTap: () async {
        final String? receipt = await context.push(barcodeScannerRoute);

        if (context.mounted && receipt != null) {
          insertDialog(context, _formKey, _nameController, receipt, packStage);
        }
      },
    );
  }
}
