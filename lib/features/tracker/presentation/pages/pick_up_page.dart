import 'package:flutter/material.dart';
import 'package:ship_tracker/core/common/constants.dart';
import 'package:ship_tracker/core/helpers/on_tap_scan.dart';
import 'package:ship_tracker/features/tracker/presentation/widgets/stage_layout.dart';

class PickUpPage extends StatelessWidget {
  const PickUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StageLayout(
      appBarTitle: 'Scan Ambil Barang',
      stageId: pickUpStage,
      onTap: () async => onTapScan(context, pickUpStage),
    );
  }
}
