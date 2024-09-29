import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/courier_identifier.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/ship_cubit.dart';
import '../widgets/detail_ship_info_item.dart';
import '../widgets/image_not_found.dart';

class DetailShipPage extends StatelessWidget {
  const DetailShipPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shipCubit = context.read<ShipCubit>();
    final textTheme = Theme.of(context).textTheme;
    final String? currentUserId = context.read<AuthCubit>().user?.id;

    return Scaffold(
      appBar: AppBar(
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
            if (shipCubit.ship.userId == currentUserId)
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
              style: textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
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
              label: 'Nama Ekspedisi',
              value: courierIdentifier(shipCubit.ship.receipt),
            ),
            const SizedBox(height: 8),
            InfoItem(
              label: 'Status',
              value: shipCubit.ship.stage,
            ),
            const SizedBox(height: 8),
            InfoItem(
              label: 'Tanggal Scan',
              value: shipCubit.ship.formattedDate,
            ),
          ],
        ),
      ),
    );
  }
}
