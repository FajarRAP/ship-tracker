import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../repositories/ship_repositories.dart';

class GetAllSpreadsheetFilesUseCase {
  final ShipRepositories shipRepo;

  GetAllSpreadsheetFilesUseCase({required this.shipRepo});

  Future<Either<Failure, List<String>>> call() async =>
      await shipRepo.getAllSpreadsheetFiles();
}
