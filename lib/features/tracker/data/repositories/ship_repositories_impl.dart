import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ship_tracker/core/common/constants.dart';
import 'package:ship_tracker/service_container.dart';
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
      final ships = (await shipRemote.getAllShips())
          .map((e) => ShipModel.fromJson(e))
          .toList();

      final receipts = (await shipRemote.getUniqueReceiptNumber())
          .map((e) => e['receipt_number'] as String)
          .toList();

      final workbook = Workbook(5);
      final sheet1 = workbook.worksheets[0];
      final sheet2 = workbook.worksheets[1];
      final sheet3 = workbook.worksheets[2];
      final sheet4 = workbook.worksheets[3];
      final sheet5 = workbook.worksheets[4];

      sheet1.name = 'All';
      sheet2.name = 'Scan';
      sheet3.name = 'Check';
      sheet4.name = 'Pack';
      sheet5.name = 'Send';

      sheet1.getRangeByIndex(1, 1).setText('No');
      sheet1.getRangeByIndex(1, 2).setText('Nomor Resi');
      sheet1.getRangeByIndex(1, 3).setText('Scan Resi');
      sheet1.getRangeByIndex(1, 4).setText('Check Resi');
      sheet1.getRangeByIndex(1, 5).setText('Packing');
      sheet1.getRangeByIndex(1, 6).setText('Kirim');
      sheet1.getRangeByIndex(1, 7).setText('Tanggal');

      for (int i = 0; i < receipts.length; i++) {
        final temp = ships.where((e) => e.receipt == receipts[i]).toList();
        final names = temp.map((e) => e.name).toList();

        switch (names.length) {
          case 0:
            names.addAll(['-', '-', '-', '-']);
            break;
          case 1:
            names.addAll(['-', '-', '-']);
            break;
          case 2:
            names.addAll(['-', '-']);
            break;
          case 3:
            names.addAll(['-']);
            break;
        }

        List<String> data = [
          '${i + 1}',
          receipts[i],
          ...names,
          temp.last.createdAt.toIso8601String()
        ];

        for (int j = 0; j < data.length; j++) {
          sheet1.getRangeByIndex(i + 2, j + 1).setText(data[j]);
        }
      }

      sheet2.getRangeByIndex(1, 1).setText('No');
      sheet2.getRangeByIndex(1, 2).setText('Nomor Resi');
      sheet2.getRangeByIndex(1, 3).setText('Scan Resi');
      sheet2.getRangeByIndex(1, 4).setText('Tanggal');
      sheet2.getRangeByIndex(1, 5).setText('Jam');

      final filtered = await getIt
          .get<SupabaseClient>()
          .from('ships_detail')
          .select(
              'receipt_number:ship_id(receipt_number), name, created_at, stage_name:stage_id(name)')
          .eq('stage_id', scanStage);
      final scans = filtered.map((e) => ShipModel.fromJson(e)).toList();

      for (int i = 0; i < scans.length; i++) {
        final datas = [
          '${i + 1}',
          scans[i].receipt,
          scans[i].name,
          scans[i].createdAt.toIso8601String(),
          scans[i].createdAt.toIso8601String()
        ];
        for (int j = 0; j < 5; j++) {
          sheet2.getRangeByIndex(i + 2, j + 1).setText(datas[j]);
        }
      }

      final bytes = workbook.saveSync();
      workbook.dispose();

      final directory = await getExternalStorageDirectory();
      final path = directory?.path;
      File file = File('$path/Output.xlsx');
      await file.writeAsBytes(bytes);

      return const Right('Berhasil Membuat Laporan');
    } catch (e) {
      print(e.toString());
      return Left(Failure(message: e.toString()));
    }
  }
}

// void sheetLoop(Worksheet sheet, List<ShipEntity> datas) {
//   for (int i = 0; i < datas.length; i++) {
//     for (int j = 0; j < 3; j++) {
//       sheet.getRangeByIndex(i + 1, j + 1).setText(datas[i].propertyToIndex(j));
//     }
//   }
// }
