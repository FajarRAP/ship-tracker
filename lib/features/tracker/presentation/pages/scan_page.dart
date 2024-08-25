import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ship_tracker/core/routes/route.dart';
import 'package:ship_tracker/service_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/common/constants.dart';
import '../../domain/entities/ship_entity.dart';
import '../cubit/ship_cubit.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final shipCubit = context.read<ShipCubit>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Scan Resi'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Scan'),
                onTap: () async {
                  String? receipt = await context.push(barcodeScannerRoute);
                  if (context.mounted && receipt != null) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Nomor Resi : $receipt'),
                        content: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              hintText: 'Nama',
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Harap Isi' : null,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await shipCubit.insertShip(
                                    receipt, _nameController.text, scanStage);
                              }
                            },
                            child: BlocConsumer<ShipCubit, ShipState>(
                              buildWhen: (previous, current) =>
                                  current is InsertShip,
                              listener: (context, state) {
                                if (state is InsertShipFinished) {
                                  context.pop();
                                  shipCubit.getShips(scanStage);
                                }
                                if (state is InsertShipError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.message)));
                                }
                              },
                              builder: (context, state) {
                                if (state is InsertShipLoading) {
                                  return const CircularProgressIndicator();
                                }
                                return const Text('Simpan');
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<ShipCubit, ShipState>(
        bloc: shipCubit..getShips(scanStage),
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
