import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../repositories/ship_repositories.dart';

class InsertShipUseCase {
  final ShipRepositories shipRepo;

  InsertShipUseCase({required this.shipRepo});

  Future<Either<Failure, String>> call(
          String receiptNumber, String name, int stageId) async =>
      await shipRepo.insertShip(receiptNumber, name, stageId);
}
