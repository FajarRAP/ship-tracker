import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ship_tracker/features/tracker/domain/entities/ship_entity.dart';
import 'package:ship_tracker/features/tracker/domain/usecases/get_ships_use_case.dart';
import 'package:ship_tracker/features/tracker/domain/usecases/insert_ship_use_case.dart';

part 'ship_state.dart';

class ShipCubit extends Cubit<ShipState> {
  ShipCubit({
    required this.getShipsUseCase,
    required this.insertShipUseCase,
  }) : super(ShipInitial());

  final GetShipsUseCase getShipsUseCase;
  final InsertShipUseCase insertShipUseCase;

  Future<void> getShips(int stageId) async {
    emit(ShipLoading());
    final result = await getShipsUseCase(stageId);

    result.fold(
      (l) => emit(ShipError(l.message)),
      (r) => emit(ShipLoaded(r)),
    );
  }

  Future<void> insertShip(
      String receiptNumber, String name, int stageId) async {
    emit(InsertShipLoading());

    final result = await insertShipUseCase(receiptNumber, name, stageId);

    result.fold(
      (l) => emit(InsertShipError(l.message)),
      (r) => emit(InsertShipFinished(r)),
    );
  }
}
