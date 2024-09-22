import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ship_tracker/core/common/snackbar.dart';

import '../../../../core/common/constants.dart';
import '../cubit/ship_cubit.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shipCubit = context.read<ShipCubit>();

    return BlocListener<ShipCubit, ShipState>(
      listener: (context, state) {
        if (state is CreateReport) {
          flushbar(context, state.message);
          shipCubit.getAllSpreadsheetFiles();
        }
        if (state is ReportError) {
          flushbar(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => <PopupMenuItem>[
                PopupMenuItem(
                  onTap: () async => await shipCubit.createReport(),
                  child: const Text('Buat Laporan'),
                ),
              ],
            ),
          ],
          automaticallyImplyLeading: false,
          title: const Text('Laporan'),
        ),
        body: BlocBuilder<ShipCubit, ShipState>(
          bloc: shipCubit..getAllSpreadsheetFiles(),
          builder: (context, state) {
            if (state is ReportLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AllReport) {
              return RefreshIndicator(
                displacement: 10,
                onRefresh: shipCubit.getAllSpreadsheetFiles,
                child: ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: const EdgeInsets.only(left: 16),
                    leading: Image.asset(spreadsheetIcon),
                    title: Text(shipCubit
                        .shortFilename[state.reports.length - index - 1]),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => <PopupMenuItem>[
                        PopupMenuItem(
                          onTap: () => OpenFilex.open(
                              state.reports[state.reports.length - index - 1]),
                          child: const Text('Buka'),
                        ),
                        PopupMenuItem(
                          onTap: () async => await Share.shareXFiles([
                            XFile(
                                state.reports[state.reports.length - index - 1])
                          ]),
                          child: const Text('Bagikan'),
                        ),
                      ],
                    ),
                  ),
                  itemCount: state.reports.length,
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
