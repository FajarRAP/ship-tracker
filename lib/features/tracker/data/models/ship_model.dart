import 'package:ship_tracker/features/tracker/domain/entities/ship_entity.dart';

class ShipModel extends ShipEntity {
  ShipModel({
    required super.receipt,
    required super.name,
    required super.stage,
    required super.createdAt,
  });

  factory ShipModel.fromJson(Map<String, dynamic> json) => ShipModel(
        receipt: json['receipt_number']['receipt_number'],
        name: json['name'],
        stage: json['stage_name']['name'],
        createdAt: DateTime.parse(json['created_at']),
      );

  @override
  // String toString() => '$receipt - $name - $stage - $createdAt';
  String toString() => receipt;
}
