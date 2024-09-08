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
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StageLayout(
      appBarTitle: 'Bungkus Resi',
      stageId: packStage,
      onTap: () async {
        final String receipt = await context.push(barcodeScannerRoute) ?? '-1';

        if (context.mounted && receipt != '-1') {
          insertDialog(context, _formKey, _controller, receipt, packStage);
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
