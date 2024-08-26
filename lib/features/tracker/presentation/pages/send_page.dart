import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../widgets/insert_data_alert_dialog.dart';
import '../widgets/stage_layout.dart';

class SendPage extends StatefulWidget {
  const SendPage({super.key});

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StageLayout(
      appBarTitle: 'Kirim Resi',
      stageId: sendStage,
      onTap: () async {
        final String? receipt = await context.push(barcodeScannerRoute);

        if (context.mounted && receipt != null) {
          insertDialog(context, _formKey, _nameController, receipt, sendStage);
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
