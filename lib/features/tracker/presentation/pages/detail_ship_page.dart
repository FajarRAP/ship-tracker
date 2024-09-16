import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/constants.dart';
import '../cubit/ship_cubit.dart';

class DetailShipPage extends StatelessWidget {
  const DetailShipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DariChatGPT();
    // return const DariClaude();
  }
}

class DariClaude extends StatelessWidget {
  const DariClaude({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final shipCubit = context.read<ShipCubit>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Detail Pengiriman'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<ShipCubit, ShipState>(
                bloc: shipCubit..getImageUrl(),
                buildWhen: (previous, current) => current is ReceiptImageState,
                builder: (context, state) {
                  return Column(
                    children: [
                      Container(
                        height: 400,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: state is ImageLoaded
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  state.path,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.image_not_supported,
                                          size: 50),
                                ),
                              )
                            : const Center(child: Icon(Icons.image, size: 50)),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => context.push(cameraRoute),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Ambil Foto'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Informasi Pengiriman',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  _buildInfoRow('Ekspedisi', shipCubit.ship.name),
                  _buildInfoRow('No. Resi', shipCubit.ship.receipt),
                  _buildInfoRow('Status', shipCubit.ship.stage),
                  _buildInfoRow('Tanggal', '${shipCubit.ship.createdAt}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class DariChatGPT extends StatelessWidget {
  const DariChatGPT({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final shipCubit = context.read<ShipCubit>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Detail Resi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ShipCubit, ShipState>(
              bloc: shipCubit..getImageUrl(),
              buildWhen: (previous, current) => current is ReceiptImageState,
              builder: (context, state) {
                if (state is ImageLoaded) {
                  return Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        state.path,
                        scale: 2,
                        errorBuilder: (context, error, stackTrace) =>
                            const ImageNotFound(),
                      ),
                    ),
                  );
                }
                return const ImageNotFound();
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => context.push(cameraRoute),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Upload Resi'),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Informasi Resi',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            InfoItem(
              label: 'Di Scan Oleh',
              value: shipCubit.ship.name,
            ),
            const SizedBox(height: 8),
            InfoItem(
              label: 'Nomor Resi',
              value: shipCubit.ship.receipt,
            ),
            const SizedBox(height: 8),
            InfoItem(
              label: 'Status',
              value: shipCubit.ship.stage,
            ),
            const SizedBox(height: 8),
            InfoItem(
              label: 'Tanggal Scan',
              value: DateFormat('dd-MM-y, HH:m:s')
                  .format(shipCubit.ship.createdAt),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const InfoItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        Text(
          value,
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
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
