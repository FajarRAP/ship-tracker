import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../cubit/ship_cubit.dart';

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
