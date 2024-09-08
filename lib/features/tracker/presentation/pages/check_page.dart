import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../widgets/insert_data_alert_dialog.dart';
import '../widgets/stage_layout.dart';

class CheckPage extends StatefulWidget {
  const CheckPage({super.key});

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StageLayout(
      appBarTitle: 'Cek Resi',
      stageId: checkStage,
      onTap: () async {
        final String receipt = await context.push(barcodeScannerRoute) ?? '-1';

        if (context.mounted && receipt != '-1') {
          insertDialog(context, _formKey, _controller, receipt, checkStage);
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
