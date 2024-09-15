import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/snackbar.dart';
import '../cubit/ship_cubit.dart';

class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shipCubit = context.read<ShipCubit>();
    final file = File(shipCubit.picturePath);
    final toPath = '${shipCubit.ship.receipt}-${shipCubit.ship.stage}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Gambar Resi'),
      ),
      body: Column(
        children: [
          Image.file(file),
          const SizedBox(height: 24),
          BlocConsumer<ShipCubit, ShipState>(
            buildWhen: (previous, current) => current is UploadImage,
            listener: (context, state) {
              if (state is ImageUploaded) {
                flushbar(context, 'Berhasil Upload Gambar');
              }
              if (state is UploadImageError) {
                flushbar(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is ImageUploading) {
                return const CircularProgressIndicator();
              }
              return ElevatedButton(
                onPressed: () async =>
                    await shipCubit.uploadImage(toPath, file),
                child: const Text('Upload'),
              );
            },
          ),
        ],
      ),
    );
  }
}
