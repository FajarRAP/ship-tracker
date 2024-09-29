import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ship_tracker/core/common/snackbar.dart';
import 'package:ship_tracker/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ship_tracker/features/tracker/domain/entities/ship_entity.dart';
import 'package:ship_tracker/features/tracker/presentation/widgets/expandable_fab.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/courier_identifier.dart';
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
        title: Text(widget.appBarTitle),
      ),
      body: Column(
        children: [
          Container(
            color: theme.colorScheme.surface,
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
          BlocConsumer<ShipCubit, ShipState>(
            bloc: shipCubit..getShips(widget.stageId),
            buildWhen: (previous, current) => current is GetShip,
            listener: (context, state) {
              if (state is DeleteShipSuccess) {
                shipCubit.getShips(widget.stageId);
                flushbar(context, state.message);
              }
            },
            builder: (context, state) {
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
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                courierIdentifier(state.ships[index].receipt),
                                style: textTheme.titleLarge,
                              ),
                              Text(
                                DateFormat('d-MM-y')
                                    .format(state.ships[index].syncWithWIB),
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          subtitle: Text(
                            state.ships[index].receipt,
                            style: textTheme.titleMedium,
                          ),
                          trailing: _buildDeleteButton(state.ships[index]),
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
                return Expanded(
                  child: Center(
                    child: Text(state.message),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      floatingActionButton:
          // ExpandableFab(
          //   distance: 1,
          //   children: [
          //     IconButton(
          //       onPressed: () {},
          //       icon: const Icon(Icons.document_scanner_rounded),
          //     ),
          //     IconButton(
          //       onPressed: () {},
          //       icon: const Icon(Icons.barcode_reader),
          //     ),
          //   ],
          // ),
          FloatingActionButton(
        onPressed: widget.onTap,
        child: const Icon(Icons.document_scanner_rounded),
      ),
    );
  }

  Widget _buildDeleteButton(ShipEntity ship) {
    final bool isAdmin =
        context.read<AuthCubit>().user?.userMetadata?['is_admin'] == true;
    final shipCubit = context.read<ShipCubit>();

    if (!isAdmin) return const SizedBox();

    return GestureDetector(
      onTap: () async {
        print(ship.id);
        print(ship.userId);
        print('Hapus Resi ${ship.receipt}');
        await shipCubit.deleteShip(ship.id);
      },
      child: const Icon(Icons.delete),
    );
  }
}
