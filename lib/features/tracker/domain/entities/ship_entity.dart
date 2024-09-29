import 'package:intl/intl.dart';

class ShipEntity {
  final String receipt;
  final String name;
  final String stage;
  final String userId;
  final DateTime createdAt;

  ShipEntity({
    required this.receipt,
    required this.name,
    required this.stage,
    required this.userId,
    required this.createdAt,
  });

  String get formattedDate => DateFormat('dd-MM-y HH:mm:ss')
      .format(createdAt.add(const Duration(hours: 6)));
}
