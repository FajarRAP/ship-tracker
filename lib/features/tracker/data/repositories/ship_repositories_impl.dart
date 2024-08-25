import 'package:dartz/dartz.dart';
import 'package:ship_tracker/core/exceptions/receipt_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entities/ship_entity.dart';
import '../../domain/repositories/ship_repositories.dart';
import '../datasources/ship_remote_data_source.dart';
import '../models/ship_model.dart';

class ShipRepositoriesImpl extends ShipRepositories {
  final ShipRemoteDataSource shipRemote;

  ShipRepositoriesImpl({required this.shipRemote});

  @override
  Future<Either<Failure, List<ShipEntity>>> getShips(int stageId) async {
    try {
      final datas = await shipRemote.getShips(stageId);
      return Right(datas.map((e) => ShipModel.fromJson(e)).toList());
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> insertShip(
      String receiptNumber, String name, int stageId) async {
    try {
      await shipRemote.insertShip(receiptNumber, name, stageId);
      return const Right('Berhasil Menyimpan');
    } on PostgrestException catch (pe) {
      switch (pe.code) {
        case '23505':
          return Left(Failure(message: 'Nomor resi sudah pernah di scan'));
        default:
          return Left(Failure(message: pe.toString()));
      }
    } on ReceiptException catch (re) {
      return Left(Failure(message: re.message));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
