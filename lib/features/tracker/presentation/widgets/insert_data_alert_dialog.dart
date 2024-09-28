import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/ship_cubit.dart';

Future<void> insertDialog(
  BuildContext context,
  String receipt,
  int stageId,
) =>
    showDialog(
      context: context,
      builder: (context) {
        final audioPlayer = AudioPlayer();
        final textTheme = Theme.of(context).textTheme;
        final String name =
            context.read<AuthCubit>().user?.userMetadata?['name'] ??
                'Tidak Diketahui';

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Berhasil Scan!',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nomor Resi:',
                style: textTheme.bodyMedium,
              ),
              Text(
                receipt,
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Nama Pemindai:',
                style: textTheme.bodyMedium,
              ),
              Text(
                name,
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async => await context
                  .read<ShipCubit>()
                  .insertShip(receipt, name, stageId),
              child: BlocConsumer<ShipCubit, ShipState>(
                buildWhen: (previous, current) => current is InsertShip,
                listener: (context, state) async {
                  if (state is InsertShipFinished) {
                    context.pop();
                    context.read<ShipCubit>().getShips(stageId);
                    flushbar(context, state.message);
                    await audioPlayer.play(AssetSource(successSound));
                  }
                  if (state is InsertShipError) {
                    if (!context.mounted) return;

                    flushbar(context, state.message);

                    switch (state.statusCode) {
                      case 400:
                        await audioPlayer.play(AssetSource(skipSound));
                        break;
                      case 401:
                      case 23505:
                        await audioPlayer.play(AssetSource(repeatSound));
                        break;
                    }
                  }
                },
                builder: (context, state) {
                  if (state is InsertShipLoading) {
                    return const CircularProgressIndicator();
                  }
                  return const Text(
                    'Simpan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );

    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text('Nomor Resi : $receipt'),
    //     content: Text(
    //       'Nama Pemindai : ${context.read<AuthCubit>().user?.userMetadata?['name']}',
    //       style: Theme.of(context).textTheme.bodyLarge,
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () async {
    //           if (formKey.currentState!.validate()) {
    //             await context
    //                 .read<ShipCubit>()
    //                 .insertShip(receipt, controller.text, stageId);
    //           }
    //         },
    //         child: BlocConsumer<ShipCubit, ShipState>(
    //           buildWhen: (previous, current) => current is InsertShip,
    //           listener: (context, state) {
    //             if (state is InsertShipFinished) {
    //               context.pop();
    //               context.read<ShipCubit>().getShips(stageId);
    //               flushbar(context, state.message);
    //             }
    //             if (state is InsertShipError) {
    //               flushbar(context, state.message);
    //             }
    //           },
    //           builder: (context, state) {
    //             if (state is InsertShipLoading) {
    //               return const CircularProgressIndicator();
    //             }
    //             return const Text('Simpan');
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // );
