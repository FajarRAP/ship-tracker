import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../cubit/ship_cubit.dart';

class StageLayout extends StatefulWidget {
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
  State<StageLayout> createState() => _StageLayoutState();
}

class _StageLayoutState extends State<StageLayout> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shipCubit = context.read<ShipCubit>();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.appBarTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Cari Resi',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: shipCubit.filterShips,
            ),
          ),
          BlocBuilder<ShipCubit, ShipState>(
            bloc: shipCubit..getShips(widget.stageId),
            buildWhen: (previous, current) => current is GetShip,
            builder: (context, state) {
              print(state);
              if (state is ShipLoading) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (state is ShipLoaded) {
                return ListTileTheme(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Colors.green,
                  child: Expanded(
                    child: RefreshIndicator(
                      displacement: 12,
                      onRefresh: () async => shipCubit.getShips(widget.stageId),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) => ListTile(
                          onTap: () {
                            shipCubit.ship = state.ships[index];
                            context.push(detailReceiptRoute);
                          },
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
                    ),
                  ),
                );
              }
              if (state is ShipEmpty) {
                return Expanded(
                  child: Center(
                    child: Text('Belum Ada Data', style: textTheme.titleLarge),
                  ),
                );
              }
              if (state is ShipError) {
                return Text(state.message);
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onTap,
        child: const Icon(Icons.document_scanner_rounded),
      ),
    );
  }
}
