import '../../domain/entities/ship_entity.dart';

class ShipModel extends ShipEntity {
  ShipModel({
    required super.receipt,
    required super.name,
    required super.stage,
    required super.userId,
    required super.createdAt,
  });

  factory ShipModel.fromJson(Map<String, dynamic> json) => ShipModel(
        receipt: json['receipt_number']['receipt_number'],
        name: json['name'],
        stage: json['stage_name']['name'],
        userId: json['receipt_number']['user_id'],
        createdAt: DateTime.parse(json['created_at']),
      );
}
