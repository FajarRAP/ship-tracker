class ShipEntity {
  final String receipt;
  final String name;
  final String stage;

  ShipEntity({
    required this.receipt,
    required this.name,
    required this.stage,
  });

  String propertyToIndex(int index) => index == 0
      ? receipt
      : index == 1
          ? name
          : stage;
}
