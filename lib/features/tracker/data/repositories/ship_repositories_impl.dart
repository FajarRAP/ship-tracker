import 'package:dartz/dartz.dart';
import 'package:ship_tracker/core/failure/failure.dart';
import 'package:ship_tracker/features/tracker/data/datasources/ship_remote_data_source.dart';
import 'package:ship_tracker/features/tracker/data/models/ship_model.dart';
import 'package:ship_tracker/features/tracker/domain/entities/ship_entity.dart';
import 'package:ship_tracker/features/tracker/domain/repositories/ship_repositories.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
