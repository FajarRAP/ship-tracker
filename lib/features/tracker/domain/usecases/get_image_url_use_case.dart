import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../repositories/ship_repositories.dart';

class GetImageUrlUseCase {
  final ShipRepositories shipRepo;

  GetImageUrlUseCase({required this.shipRepo});

  Either<Failure, String> call(String path) => shipRepo.getImageUrl(path);
}
