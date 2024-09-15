import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ship_tracker/service_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../../../../core/exceptions/receipt_exception.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/ship_entity.dart';
import '../../domain/repositories/ship_repositories.dart';
import '../datasources/ship_local_data_source.dart';
import '../datasources/ship_remote_data_source.dart';
import '../models/ship_model.dart';

class ShipRepositoriesImpl extends ShipRepositories {
  final ShipRemoteDataSource shipRemote;
  final ShipLocalDataSource shipLocal;

  ShipRepositoriesImpl({
    required this.shipRemote,
    required this.shipLocal,
  });

  @override
  Future<Either<Failure, List<ShipEntity>>> getShips(int stageId) async {
    try {
      final currentUserId = getIt.get<SupabaseClient>().auth.currentUser?.id;
      final datas = await shipRemote.getShips(stageId);

      return Right(datas
          .where((e) => e['receipt_number']['user_id'] == currentUserId)
          .map((e) => ShipModel.fromJson(e))
          .toList());
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> insertShip(
      String receiptNumber, String name, int stageId) async {
    try {
      final currentUserId = getIt.get<SupabaseClient>().auth.currentUser?.id;
      await shipRemote.insertShip(currentUserId, receiptNumber, name, stageId);

      return const Right('Berhasil Menyimpan');
    } on PostgrestException catch (pe) {
      switch (pe.code) {
        case '23505':
          return Left(Failure(message: 'Nomor resi sudah di scan'));
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

      generateSheetsData(
        isFirstSheet: true,
        sheet: sheet1,
        datas: ships,
        title: ['Scan Resi', 'Check Resi', 'Packing', 'Kirim'],
      );
      generateSheetsData(
        sheet: sheet2,
        datas: ships,
        title: ['Scan Resi'],
        stageName: 'Scan',
      );
      generateSheetsData(
        sheet: sheet3,
        datas: ships,
        title: ['Check Resi'],
        stageName: 'Check',
      );
      generateSheetsData(
        sheet: sheet4,
        datas: ships,
        title: ['Packing'],
        stageName: 'Pack',
      );
      generateSheetsData(
        sheet: sheet5,
        datas: ships,
        title: ['Kirim'],
        stageName: 'Send',
      );

      final bytes = workbook.saveSync();
      workbook.dispose();

      final directory = await getExternalStorageDirectory();
      final path = directory?.path;
      File file = File(
          '$path/report_${DateFormat('d-M-y_H:mm:s').format(DateTime.now())}.xlsx');
      await file.writeAsBytes(bytes, flush: true);

      return const Right('Berhasil Membuat Laporan');
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAllSpreadsheetFiles() async {
    try {
      final directory = (await getExternalStorageDirectory())!;
      final files = await shipLocal.getAllFiles(directory);

      return Right(files.map((e) => e.path).toList());
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Either<Failure, String> getImageUrl(String path) {
    try {
      final imgPath = shipRemote.getImageUrl(path);

      return Right(imgPath);
    } catch (e) {
      print(e.toString());
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(String toPath, File file) async {
    try {
      final fullPath = await shipRemote.uploadImage(toPath, file);
      print(fullPath);

      return Right(fullPath);
    } catch (e) {
      print(e.toString());
      return Left(Failure(message: e.toString()));
    }
  }
}

void generateSheetsData({
  bool isFirstSheet = false,
  required Worksheet sheet,
  required List<ShipEntity> datas,
  required List<String> title,
  String? stageName,
}) {
  if (isFirstSheet) {
    final receipts = datas.map((e) => e.receipt).toSet().toList();

    sheet.getRangeByIndex(1, 1).setText('No');
    sheet.getRangeByIndex(1, 2).setText('Nomor Resi');
    sheet.getRangeByIndex(1, 3).setText(title[0]);
    sheet.getRangeByIndex(1, 4).setText(title[1]);
    sheet.getRangeByIndex(1, 5).setText(title[2]);
    sheet.getRangeByIndex(1, 6).setText(title[3]);
    sheet.getRangeByIndex(1, 7).setText('Tanggal');

    for (int i = 0; i < receipts.length; i++) {
      final temp = datas.where((e) => e.receipt == receipts[i]).toList();
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
        default:
          break;
      }

      List<String> data = [
        '${i + 1}',
        receipts[i],
        ...names,
        DateFormat('d-M-y').format(temp.last.createdAt)
      ];

      for (int j = 0; j < data.length; j++) {
        sheet.getRangeByIndex(i + 2, j + 1).setText(data[j]);
      }
    }
  } else {
    final filtered = datas.where((e) => e.stage == stageName).toList();

    sheet.getRangeByIndex(1, 1).setText('No');
    sheet.getRangeByIndex(1, 2).setText('Nomor Resi');
    sheet.getRangeByIndex(1, 3).setText(title.first);
    sheet.getRangeByIndex(1, 4).setText('Tanggal');
    sheet.getRangeByIndex(1, 5).setText('Jam');

    for (int i = 0; i < filtered.length; i++) {
      final ready = [
        '${i + 1}',
        filtered[i].receipt,
        filtered[i].name,
        DateFormat('d-M-y').format(filtered[i].createdAt),
        DateFormat.Hms().format(filtered[i].createdAt)
      ];

      for (int j = 0; j < 5; j++) {
        sheet.getRangeByIndex(i + 2, j + 1).setText(ready[j]);
      }
    }
  }
}
