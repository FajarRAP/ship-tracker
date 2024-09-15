import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../cubit/ship_cubit.dart';

class DetailShipPage extends StatelessWidget {
  const DetailShipPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shipCubit = context.read<ShipCubit>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Detail Resi'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<ShipCubit, ShipState>(
                bloc: shipCubit..getImageUrl(),
                buildWhen: (previous, current) => current is ReceiptImageState,
                builder: (context, state) {
                  if (state is ImageLoaded) {
                    return Image.network(
                      state.path,
                      scale: 2,
                      errorBuilder: (context, error, stackTrace) =>
                          const ImageNotFound(),
                    );
                  }
                  return const ImageNotFound();
                },
              ),
              ElevatedButton(
                onPressed: () => context.push(cameraRoute),
                child: const Text('PHOTO'),
              ),
              const SizedBox(height: 12),
              Text(
                'NANTI JANGAN LUPA NAMA EKSPEDISINYA',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(shipCubit.ship.name),
              Text(shipCubit.ship.receipt),
              Text(shipCubit.ship.stage),
              Text('${shipCubit.ship.createdAt}'),
            ],
          ),
        ),
      ),
    );
  }
}

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
