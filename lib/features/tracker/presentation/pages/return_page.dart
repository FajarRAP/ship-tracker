import 'package:flutter/material.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/on_tap_scan.dart';
import '../widgets/stage_layout.dart';

class ReturnPage extends StatelessWidget {
  const ReturnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StageLayout(
      appBarTitle: 'Scan Return',
      stageId: returnStage,
      onTap: () async => await onTapScan(context, returnStage),
    );
  }
}
