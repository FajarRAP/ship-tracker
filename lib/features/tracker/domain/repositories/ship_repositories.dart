import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../entities/ship_entity.dart';

abstract class ShipRepositories {
  Future<Either<Failure, List<ShipEntity>>> getShips(int stageId);
  Future<Either<Failure, String>> insertShip(String receiptNumber, String name, int stageId);
  Future<Either<Failure, String>> createReport();
  Future<Either<Failure, List<String>>> getAllSpreadsheetFiles();
}