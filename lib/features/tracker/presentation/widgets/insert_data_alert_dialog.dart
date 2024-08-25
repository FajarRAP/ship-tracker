import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ship_tracker/features/tracker/presentation/cubit/ship_cubit.dart';

Future<void> insertDialog(
  BuildContext context,
  GlobalKey<FormState> formKey,
  TextEditingController nameController,
  String receipt,
  int stageId,
) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nomor Resi : $receipt'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Nama',
            ),
            validator: (value) => value!.isEmpty ? 'Harap Isi' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await context
                    .read<ShipCubit>()
                    .insertShip(receipt, nameController.text, stageId);
              }
            },
            child: BlocConsumer<ShipCubit, ShipState>(
              buildWhen: (previous, current) => current is InsertShip,
              listener: (context, state) {
                if (state is InsertShipFinished) {
                  context.pop();
                  context.read<ShipCubit>().getShips(stageId);
                }
                if (state is InsertShipError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
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
