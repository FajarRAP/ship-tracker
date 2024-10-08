import 'package:flutter/material.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/on_tap_scan.dart';
import '../widgets/stage_layout.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StageLayout(
      appBarTitle: 'Scan Resi',
      stageId: scanStage,
      onTap: () async => await onTapScan(context, scanStage),
    );
  }
}
