import 'package:flutter/material.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/on_tap_scan.dart';
import '../widgets/stage_layout.dart';

class CheckPage extends StatelessWidget {
  const CheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StageLayout(
      appBarTitle: 'Scan Checking',
      stageId: checkStage,
      onTap: () async => await onTapScan(context, checkStage),
    );
  }
}
