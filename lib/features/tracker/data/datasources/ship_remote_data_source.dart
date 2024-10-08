import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/common/constants.dart';

abstract class ShipRemoteDataSource {
  Future<List<Map<String, dynamic>>> getShips(String receiptNumber);
  Future<List<Map<String, dynamic>>> getShipsByStageId(int stageId);
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
  Future<List<Map<String, dynamic>>> getShips(String receiptNumber) async =>
      await supabase
          .from('ships')
          .select('id, receipt_number, stage_id(id, name)')
          .eq('receipt_number', receiptNumber);

  @override
  Future<List<Map<String, dynamic>>> getShipsByStageId(int stageId) async {
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
      final data = await supabase.from('ships').insert({
        'user_id': currentUserId,
        'receipt_number': receiptNumber,
        'stage_id': stageId,
      }).select();

      await supabase.from('ships_detail').insert({
        'name': name,
        'stage_id': stageId,
        'ship_id': data.first['id'],
      });
    } else {
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
        'name, receipt_number:ship_id(receipt_number, user_id), stage_name:stage_id(name), created_at');
  }

  @override
  String getImageUrl(String path) {
    return supabase.storage.from('receipt_images').getPublicUrl(path);
  }

  @override
  Future<String> uploadImage(String path, File file) async {
    return await supabase.storage.from('receipt_images').upload(path, file,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: true));
  }
}
