import 'package:dartz/dartz.dart';
import 'package:ship_tracker/core/failure/failure.dart';
import 'package:ship_tracker/features/tracker/domain/entities/ship_entity.dart';
import 'package:ship_tracker/features/tracker/domain/repositories/ship_repositories.dart';

class GetShipsUseCase {
  final ShipRepositories shipRepo;

  GetShipsUseCase({required this.shipRepo});

  Future<Either<Failure, List<ShipEntity>>> call(int stageId) async =>
      await shipRepo.getShips(stageId);
}
