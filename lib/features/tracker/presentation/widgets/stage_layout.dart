import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(appBarTitle),
      ),
      body: BlocBuilder<ShipCubit, ShipState>(
        bloc: shipCubit..getShips(stageId),
        buildWhen: (previous, current) => current is GetShip,
        builder: (context, state) {
          if (state is ShipLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ShipLoaded) {
            return ListTileTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: Colors.green,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) => ListTile(
                  contentPadding: const EdgeInsets.only(left: 16),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nama Ekspedisi',
                        style: textTheme.titleLarge,
                      ),
                      Text(
                        state.ships[index].formattedDate,
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  subtitle: Text(
                    state.ships[index].receipt,
                    style: textTheme.titleMedium,
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.delete),
                  ),
                ),
                itemCount: state.ships.length,
              ),
            );
          }
          if (state is ShipEmpty) {
            return Center(
              child: Text('Belum Ada Data', style: textTheme.titleLarge),
            );
          }
          if (state is ShipError) {
            return Text(state.message);
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onTap,
        child: const Icon(Icons.document_scanner_rounded),
      ),
    );
  }
}
