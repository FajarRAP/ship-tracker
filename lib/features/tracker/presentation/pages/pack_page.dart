import 'package:flutter/material.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/on_tap_scan.dart';
import '../widgets/stage_layout.dart';

class PackPage extends StatelessWidget {
  const PackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StageLayout(
      appBarTitle: 'Scan Packing',
      stageId: packStage,
      onTap: () async => await onTapScan(context, packStage),
    );
  }
}
