import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../../../../core/exceptions/receipt_exception.dart';
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

  @override
  Future<Either<Failure, String>> createReport() async {
    try {
      final datas = await shipRemote.getAllShips();
      final List<ShipModel> ships =
          datas.map((e) => ShipModel.fromJson(e)).toList();
      final scans = ships.where((e) => e.stage == 'Scan').toList();
      final checks = ships.where((e) => e.stage == 'Check').toList();
      final packs = ships.where((e) => e.stage == 'Pack').toList();
      final sends = ships.where((e) => e.stage == 'Send').toList();

      final Workbook workbook = Workbook(4);
      final sheet1 = workbook.worksheets[0];
      final sheet2 = workbook.worksheets[1];
      final sheet3 = workbook.worksheets[2];
      final sheet4 = workbook.worksheets[3];

      sheet1.name = 'Scan';
      sheet2.name = 'Check';
      sheet3.name = 'Pack';
      sheet4.name = 'Send';

      sheetLoop(sheet1, scans);
      sheetLoop(sheet2, checks);
      sheetLoop(sheet3, packs);
      sheetLoop(sheet4, sends);

      final bytes = workbook.saveSync();
      workbook.dispose();

      final directory = await getExternalStorageDirectory();
      final path = directory?.path;
      File file = File('$path/Output.xlsx');
      await file.writeAsBytes(bytes);

      return const Right('Berhasil Membuat Laporan');
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}

void sheetLoop(Worksheet sheet, List<ShipEntity> datas) {
  for (int i = 0; i < datas.length; i++) {
    for (int j = 0; j < 3; j++) {
      sheet.getRangeByIndex(i + 1, j + 1).setText(datas[i].propertyToIndex(j));
    }
  }
}
