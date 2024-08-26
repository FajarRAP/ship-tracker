import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/exceptions/receipt_exception.dart';

abstract class ShipRemoteDataSource {
  Future<List<Map<String, dynamic>>> getShips(int stageId);
  Future<List<Map<String, dynamic>>> getAllShips();
  Future<List<Map<String, dynamic>>> getUniqueReceiptNumber();
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
      if (stageId == scanStage) {
        final datas = await supabase.from('ships').insert({
          'receipt_number': receiptNumber,
          'stage_id': stageId,
        }).select();

        await supabase.from('ships_detail').insert({
          'name': name,
          'stage_id': stageId,
          'ship_id': datas.first['id'],
        });
      } else {
        final datas = await supabase
            .from('ships')
            .select('id, receipt_number, stage_id(id, name)')
            .eq('receipt_number', receiptNumber);
        final String remoteStageName = datas.first['stage_id']['name'];

        if (datas.first['stage_id']['id'] == stageId) {
          throw ReceiptException(message: 'No resi sudah di $remoteStageName}');
        }

        if (datas.first['stage_id']['id'] > stageId) {
          throw ReceiptException(
              message: 'Ga bisa mundur, udah nyampe $remoteStageName');
        }

        if (datas.first['stage_id']['id'] < stageId - 1) {
          throw ReceiptException(
              message:
                  'Jangan loncat, resi ini baru sampai tahap $remoteStageName}');
        }

        await supabase.from('ships_detail').insert({
          'name': name,
          'stage_id': stageId,
          'ship_id': datas.first['id'],
        });

        await supabase
            .from('ships')
            .update({'stage_id': stageId}).eq('id', datas.first['id']);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllShips() async {
    return supabase.from('ships_detail').select(
        'name, receipt_number:ship_id(receipt_number), stage_name:stage_id(name), created_at');
  }

  @override
  Future<List<Map<String, dynamic>>> getUniqueReceiptNumber() async {
    return supabase.from('ships').select('receipt_number');
  }
}
