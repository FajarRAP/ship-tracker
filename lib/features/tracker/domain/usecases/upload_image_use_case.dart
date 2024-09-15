import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../repositories/ship_repositories.dart';

class UploadImageUseCase {
  final ShipRepositories shipRepo;

  UploadImageUseCase({required this.shipRepo});

  Future<Either<Failure, String>> call(String toPath, File file) async =>
      await shipRepo.uploadImage(toPath, file);
}
