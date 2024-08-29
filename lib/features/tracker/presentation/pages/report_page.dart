import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';

import '../cubit/ship_cubit.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shipCubit = context.read<ShipCubit>();

    return BlocListener<ShipCubit, ShipState>(
      listener: (context, state) {
        if (state is CreateReport) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is ReportError) {
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
                    title: Text(state.reports[index]),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => <PopupMenuItem>[
                        PopupMenuItem(
                          onTap: () => OpenFilex.open(state.reports[index]),
                          child: const Text('Buka'),
                        ),
                        PopupMenuItem(
                          onTap: () {},
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
