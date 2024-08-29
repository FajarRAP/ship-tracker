import 'package:intl/intl.dart';

class ShipEntity {
  final String receipt;
  final String name;
  final String stage;
  final DateTime createdAt;

  ShipEntity({
    required this.receipt,
    required this.name,
    required this.stage,
    required this.createdAt,
  });

  String get formattedDate => DateFormat('d-M-y H:mm:ss').format(createdAt);
}
