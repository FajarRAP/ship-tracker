import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ShipRemoteDataSource {
  Future<List<Map<String, dynamic>>> getShips(int stageId);
  Future<void> insertShip(String receiptNumber, String name, int stageId);
}

class ShipRemoteDataSourceImpl extends ShipRemoteDataSource {
  final SupabaseClient supabase;

  ShipRemoteDataSourceImpl({required this.supabase});
  @override
  Future<List<Map<String, dynamic>>> getShips(int stageId) async {
    return await supabase
        .from('ships_detail')
        .select(
            'name, receipt_number:ship_id(receipt_number), stage_name:stage_id(name)')
        .eq('stage_id', stageId);
  }

  @override
  Future<void> insertShip(
      String receiptNumber, String name, int stageId) async {
    try {
      final datas = await supabase.from('ships').insert({
        'receipt_number': receiptNumber,
        'stage_id': stageId,
      }).select();

      await supabase.from('ships_detail').insert({
        'name': name,
        'stage_id': stageId,
        'ship_id': datas.first['id'],
      });
    } catch (e) {
      rethrow;
    }
  }
}
