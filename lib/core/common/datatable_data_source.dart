import 'package:flutter/material.dart';

import '../../features/tracker/domain/entities/ship_entity.dart';

class DataSource extends DataTableSource {
  final int row;
  final List<ShipEntity> ships;

  DataSource({
    required this.row,
    required this.ships,
  });

  @override
  DataRow? getRow(int index) {
    for (int i = 0; i < ships.length; i++) {
      if (index == i) {
        return DataRow(cells: <DataCell>[
          DataCell(Text(ships[i].receipt)),
          DataCell(Text(ships[i].stage)),
          DataCell(Text(ships[i].name)),
        ]);
      }
    }
    return null;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => row;

  @override
  int get selectedRowCount => 0;
}
