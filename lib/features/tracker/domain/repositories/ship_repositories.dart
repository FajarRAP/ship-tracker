import 'package:dartz/dartz.dart';
import 'package:ship_tracker/core/failure/failure.dart';
import 'package:ship_tracker/features/tracker/domain/entities/ship_entity.dart';

abstract class ShipRepositories {
  Future<Either<Failure, List<ShipEntity>>> getShips(int stageId);
  Future<Either<Failure, String>> insertShip(String receiptNumber, String name, int stageId);
}