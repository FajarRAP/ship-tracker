import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/datatable_data_source.dart';
import '../cubit/ship_cubit.dart';

class StageLayout extends StatelessWidget {
  const StageLayout({
    super.key,
    required this.appBarTitle,
    required this.stageId,
    required this.onTap,
  });

  final String appBarTitle;
  final int stageId;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    final shipCubit = context.read<ShipCubit>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(appBarTitle),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: onTap,
                child: const Text('Scan'),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<ShipCubit, ShipState>(
        bloc: shipCubit..getShips(stageId),
        buildWhen: (previous, current) => current is GetShip,
        builder: (context, state) {
          if (state is ShipLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ShipLoaded) {
            return SingleChildScrollView(
              child: PaginatedDataTable(
                columns: const <DataColumn>[
                  DataColumn(label: Text('Nomor Resi')),
                  DataColumn(label: Text('Tahapan')),
                  DataColumn(label: Text('Nama')),
                ],
                source: DataSource(
                  row: state.ships.length,
                  ships: state.ships,
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
