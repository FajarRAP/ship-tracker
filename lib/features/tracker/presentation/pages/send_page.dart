import 'package:flutter/material.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/on_tap_scan.dart';
import '../widgets/stage_layout.dart';

class SendPage extends StatelessWidget {
  const SendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StageLayout(
      appBarTitle: 'Scan Kirim',
      stageId: sendStage,
      onTap: () async => await onTapScan(context, sendStage),
    );
  }
}
