import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/ship_cubit.dart';

class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Gambar Resi'),
      ),
      body: Column(
        children: [
          Image.file(File(context.read<ShipCubit>().picturePath)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }
}
