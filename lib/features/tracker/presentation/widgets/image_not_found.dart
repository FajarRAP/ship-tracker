import 'package:flutter/material.dart';

class ImageNotFound extends StatelessWidget {
  const ImageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.all(8),
      width: double.infinity,
      height: 300,
      child: Center(
        child: Text(
          'Belum Ada Gambar',
          style: textTheme.bodyLarge,
        ),
      ),
    );
  }
}
