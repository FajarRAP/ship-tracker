import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/common/constants.dart';

abstract class ShipRemoteDataSource {
  Future<Map<String, dynamic>> getShip(String receiptNumber);
  Future<List<Map<String, dynamic>>> getShips(int stageId);
  Future<List<Map<String, dynamic>>> getAllShips();
  Future<void> insertShip(String? currentUserId, String receiptNumber,
      String name, int stageId, int shipId);
  Future<String> uploadImage(String path, File file);
  String getImageUrl(String path);
}

class ShipRemoteDataSourceImpl extends ShipRemoteDataSource {
  final SupabaseClient supabase;

  ShipRemoteDataSourceImpl({required this.supabase});

  @override
  Future<Map<String, dynamic>> getShip(String receiptNumber) async =>
      (await supabase
              .from('ships')
              .select('id, receipt_number, stage_id(id, name)')
              .eq('receipt_number', receiptNumber))
          .first;

  @override
  Future<List<Map<String, dynamic>>> getShips(int stageId) async {
    return await supabase
        .from('ships_detail')
        .select(
            'name, receipt_number:ship_id(receipt_number, user_id), stage_name:stage_id(name), created_at')
        .eq('stage_id', stageId);
  }

  @override
  Future<void> insertShip(String? currentUserId, String receiptNumber,
      String name, int stageId, int shipId) async {
    if (stageId == scanStage) {
      await supabase.from('ships').insert({
        'user_id': currentUserId,
        'receipt_number': receiptNumber,
        'stage_id': stageId,
      });

      // await supabase.from('ships_detail').insert({
      //   'name': name,
      //   'stage_id': stageId,
      //   'ship_id': datas.first['id'],
      // });
      await supabase.from('ships_detail').insert({
        'name': name,
        'stage_id': stageId,
        'ship_id': shipId,
      });
    } else {
      // final datas = await supabase
      //     .from('ships')
      //     .select('id, receipt_number, stage_id(id, name)')
      //     .eq('receipt_number', receiptNumber);

      // final String remoteStageName =
      //     datas.first['stage_id']['name'].toString().toLowerCase();

      // if (datas.first['stage_id']['id'] == stageId) {
      //   throw ReceiptException(
      //       message: 'Nomor resi sudah di $remoteStageName');
      // }

      // if (datas.first['stage_id']['id'] > stageId) {
      //   throw ReceiptException(
      //       message: 'Ga bisa mundur, udah nyampe $remoteStageName');
      // }

      // if (datas.first['stage_id']['id'] < stageId - 1) {
      //   throw ReceiptException(
      //       message:
      //           'Jangan loncat, resi ini baru sampai tahap $remoteStageName');
      // }

      // await supabase.from('ships_detail').insert({
      //   'name': name,
      //   'stage_id': stageId,
      //   'ship_id': datas.first['id'],
      // });

      // await supabase
      //     .from('ships')
      //     .update({'stage_id': stageId}).eq('id', datas.first['id']);

      await supabase.from('ships_detail').insert({
        'name': name,
        'stage_id': stageId,
        'ship_id': shipId,
      });

      await supabase
          .from('ships')
          .update({'stage_id': stageId}).eq('id', shipId);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllShips() async {
    return await supabase.from('ships_detail').select(
        'name, receipt_number:ship_id(receipt_number), stage_name:stage_id(name), created_at');
  }

  @override
  String getImageUrl(String path) =>
      supabase.storage.from('receipt_images').getPublicUrl(path);

  @override
  Future<String> uploadImage(String path, File file) async =>
      await supabase.storage.from('receipt_images').upload(path, file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true));
}
