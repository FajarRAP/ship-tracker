part of 'ship_cubit.dart';

@immutable
sealed class ShipState {}

final class ShipInitial extends ShipState {}

class GetShip extends ShipState {}

class InsertShip extends ShipState {}

class ShipLoading extends GetShip {}

class ShipLoaded extends GetShip {
  final List<ShipEntity> ships;

  ShipLoaded(this.ships);
}

class ShipError extends GetShip {
  final String message;

  ShipError(this.message);
}

class InsertShipLoading extends InsertShip {}

class InsertShipFinished extends InsertShip {
  final String message;

  InsertShipFinished(this.message);
}

class InsertShipError extends InsertShip {
  final String message;

  InsertShipError(this.message);
}

class ReportLoading extends ShipState {}

class ReportLoaded extends ShipState {}

class AllReport extends ReportLoaded {
  final List<String> reports;

  AllReport(this.reports);
}

class CreateReport extends ReportLoaded {
  final String message;

  CreateReport(this.message);
}

class ReportError extends ShipState {
  final String message;

  ReportError(this.message);
}
