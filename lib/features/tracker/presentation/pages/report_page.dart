import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ship_tracker/core/common/constants.dart';
import 'package:ship_tracker/features/tracker/domain/entities/ship_entity.dart';
import 'package:ship_tracker/features/tracker/presentation/cubit/ship_cubit.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shipCubit = context.read<ShipCubit>();

    return BlocListener<ShipCubit, ShipState>(
      listener: (context, state) {
        if (state is CreateReportLoaded) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => <PopupMenuItem>[
                PopupMenuItem(
                  onTap: () async {
                    await shipCubit.createReport();
                    // List<ShipEntity> datas = [];
                    // final result = await context
                    //     .read<ShipCubit>()
                    //     .getShipsUseCase(scanStage);
                    // result.fold((l) => print(l.message), (r) => datas = r);

                    // Single Sheet
                    // final Workbook workbook = Workbook();
                    // final Worksheet sheet = workbook.worksheets[0];
                    // sheet.getRangeByName('A1').setText('Excel Pertama');
                    // final bytes = workbook.saveSync();
                    // workbook.dispose();

                    // Multiple Sheet
                    // final Workbook workbook = Workbook(4);
                    // final sheet1 = workbook.worksheets[0];
                    // final sheet2 = workbook.worksheets[1];
                    // final sheet3 = workbook.worksheets[2];
                    // final sheet4 = workbook.worksheets[3];
                    // sheet1.name = 'Scan';
                    // sheet2.name = 'Check';
                    // sheet3.name = 'Pack';
                    // sheet4.name = 'Send';
                    // for (int i = 0; i < datas.length; i++) {
                    //   for (int j = 0; j < 3; j++) {
                    //     sheet1
                    //         .getRangeByIndex(i + 1, j + 1)
                    //         .setText(datas[i].propertyToIndex(j));
                    //   }
                    // }

                    // final bytes = workbook.saveSync();
                    // workbook.dispose();

                    // final directory = await getExternalStorageDirectory();
                    // final path = directory?.path;
                    // File file = File('$path/Output.xlsx');
                    // await file.writeAsBytes(bytes);

                    // if (context.mounted) {

                    // }
                  },
                  child: const Text('Buat Laporan'),
                ),
              ],
            ),
          ],
          automaticallyImplyLeading: false,
          title: const Text('Laporan'),
        ),
        body: BlocBuilder<ShipCubit, ShipState>(
          builder: (context, state) {
            if (state is CreateReportLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 16),
                  title: const Text('File Pertama'),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => <PopupMenuItem>[
                      PopupMenuItem(
                        onTap: () async {
                          final directory = await getExternalStorageDirectory();
                          final path = directory?.path;
                          OpenFilex.open('$path/Output.xlsx');
                        },
                        child: const Text('Buka'),
                      ),
                      PopupMenuItem(
                        onTap: () {},
                        child: const Text('Bagikan'),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
